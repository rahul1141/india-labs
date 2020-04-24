#!/bin/bash
STACK_NAME=indialabs-stack
REGION=us-east-2
CLI_PROFILE=india-labs-profile
EC2_INSTANCE_TYPE=t2.micro
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
EC2InstanceType=$EC2_INSTANCE_TYPE

if [ $? -eq 0 ]; then
aws cloudformation list-exports \
--profile $CLI_PROFILE \
--query "Exports[?Name=='InstanceEndpoint'].Value"
fi
