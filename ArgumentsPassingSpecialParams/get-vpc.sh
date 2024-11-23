# This script retrieves VPC IDs from a specified AWS region
#!/bin/bash

# Check if at least one argument is provided
if [ $# -gt 0 ]; then
    REGIONS=$@
    echo "Fetching VPC IDs for regions: $REGIONS"
    for REGION in $REGIONS; do
        aws ec2 describe-vpcs --region ${REGION} | jq ".Vpcs[].VpcId" -r
    done
else
    echo "You have provided $# arguments. Please provide at least one region."
    exit 1
fi