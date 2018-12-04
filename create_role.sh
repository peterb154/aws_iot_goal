#!/usr/bin/env bash
ROLE_NAME=Greengrass_ServiceRole
set -e

if [ `aws iam list-roles | jq '.Roles|.[]|.RoleName' | grep -c $ROLE_NAME` -lt 1 ]; then
    echo "Creating role $ROLE_NAME"
    aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document '{ 
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "greengrass.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }'
else
    echo "Role: $ROLE_NAME already exists"
fi
ROLE_ARN=`aws iam get-role --role-name $ROLE_NAME | jq .Role.Arn | sed s/\"//g`
echo "ROLE_ARN: $ROLE_ARN"
echo "Attaching AWSGreengrassResourceAccessRolePolicy policy to $ROLE_NAME"
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSGreengrassResourceAccessRolePolicy
echo "Associating greengrass service role: $ROLE_NAME to account"
aws greengrass associate-service-role-to-account --role-arn $ROLE_ARN
