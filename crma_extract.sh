#!/bin/zsh

# Get Access Token from SF CLI environment
sf org display --target-org mguse#@salesforce.demo > crma_org.info
token=`grep "Access Token" crma_org.info | cut -w -f 4`
rm crma_org.info

echo ""

printf "... extracting CRMA Dashboard Info\n"

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/dashboards \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o dashboards.json \

jq '.dashboards[]|{Id: .id, Label: .label, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' dashboards.json > dashboard_list.json  

printf "... extracting CRMA Dataset Info\n"

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/datasets \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o datasets.json \

jq '.datasets[]|{Id: .id, Name: .name, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' datasets.json > dataset_list.json

printf "... extracting CRMA Lenses Info\n"

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/lenses \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o lenses.json \

jq '.lenses[]|{Id: .id, Label: .label, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' lenses.json > lenses_list.json

printf "\nDone!\n"
