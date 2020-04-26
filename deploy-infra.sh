#!/bin/bash
STACK_NAME=indialabs-stack
REGION=us-east-2
CLI_PROFILE=india-labs-profile
EC2_INSTANCE_TYPE=t2.micro

AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile india-labs-profile \
--query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

# Generate a personal access token with repo and admin:repo_hook
# permissions from https://github.com/settings/tokens
GH_ACCESS_TOKEN=$(cat ~/.github/india-labs-access-token)
GH_OWNER=$(cat ~/.github/india-labs-owner)
GH_REPO=$(cat ~/.github/india-labs-repo)
GH_BRANCH=master
echo -e "\n\n=========== Deploying setup.yml ==========="

aws cloudformation deploy \
--region $REGION \
--profile $CLI_PROFILE \
--stack-name $STACK_NAME-setup \
--template-file setup.yml \
--no-fail-on-empty-changeset \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides \
  EC2InstanceType=$EC2_INSTANCE_TYPE \
  GitHubOwner=$GH_OWNER \
  GitHubRepo=$GH_REPO \
  GitHubBranch=$GH_BRANCH \
  GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
  CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
--region $REGION \
--profile $CLI_PROFILE \
--stack-name $STACK_NAME \
--template-file main.yml \
--no-fail-on-empty-changeset \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides \
  EC2InstanceType=$EC2_INSTANCE_TYPE \
  GitHubOwner=$GH_OWNER \
  GitHubRepo=$GH_REPO \
  GitHubBranch=$GH_BRANCH \
  GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
  CodePipelineBucket=$CODEPIPELINE_BUCKET

if [ $? -eq 0 ]; then
aws cloudformation list-exports \
--profile $CLI_PROFILE \
--query "Exports[?starts_with(Name,'InstanceEndpoint')].Value"
fi
