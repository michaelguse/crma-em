#!/bin/zsh

# Get Access Token from SF CLI environment
sf org display --target-org mguse#@salesforce.demo > crma_org.info
token=`grep "Access Token" crma_org.info | cut -w -f 4`
rm crma_org.info

printf "\nExtracting CRMA Dashboard Info ... "

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/dashboards \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o dashboards.json \

jq '.dashboards[]|{Id: .id, Label: .label, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' dashboards.json > dashboard_list.json  


tmp=`grep '\"Id\":' dashboard_list.json|wc -l|cut -w -f 2`
#printf `bc -e ${tmp}/6`
printf "${tmp} entries.\n"

printf "Extracting CRMA Dataset Info   ... "

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/datasets \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o datasets.json \

jq '.datasets[]|{Id: .id, Name: .name, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' datasets.json > dataset_list.json

tmp=`grep '\"Id\":' dataset_list.json|wc -l|cut -w -f 2`
#printf `bc -e ${tmp}/6`
printf "${tmp} entries.\n"

printf "Extracting CRMA Lenses Info    ... "

curl -s https://edo.my.salesforce.com/services/data/v58.0/wave/lenses \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o lenses.json \

jq '.lenses[]|{Id: .id, Label: .label, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' lenses.json > lenses_list.json

tmp=`grep '\"Id\":' lenses_list.json|wc -l|cut -w -f 2`
#printf `bc -e ${tmp}/6`
printf "${tmp} entries.\n"

printf "\nDone!\n"
