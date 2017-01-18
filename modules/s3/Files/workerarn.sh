#!/bin/bash
aws iam get-role --role-name ${worker-role} | jq ".Role.Arn" | tr -d '"'
