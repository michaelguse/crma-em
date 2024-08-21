#!/bin/zsh

# defaults are set to DEV environment
# other environments are supported by providing inst and targetorg parameters to the script invocation
local inst="https://deloitte--aurora.sandbox.my.salesforce.com"
local targetorg="mguse@deloitte.com.gcrm.6335400.aurora"
local sfversion="61.0"
local source="src"
local positional=()
local debug="false"
local process="crma_extract"

local usage=(
    "crma_extract.sh [-h|--help] [-d|--debug] [-i|--inst <instance UR>] [-t|--targetorg <login email for targetorg>] [-v|--version <Salesforce API Version|default('61.0')>]"
)

opterr() { echo >&2 "optparsing_demo: Unknown option '$1'" }

while (( $# )); do
    case $1 in
        --)                 shift; positional+=("${@[@]}"); break  ;;
        -h|--help)          printf "%s\n" $usage && return         ;;
        -d|--debug)         debug="true"                           ;;
        -i|--inst)          shift; inst=$1                         ;;
        -t|--targetorg)     shift; targetorg=$1                    ;;
        -*)                 opterr $1 && return 2                  ;;
        *)                  positional+=("${@[@]}"); break         ;;
    esac
    shift
done

# Extract sandbox name from URL
### Grab text after "--" string
source=${inst#*--} 
### Split string by "." and take first value
source=${source[(ws:.:)1]} 

# List process execution info 
echo "\Process Info"
echo "----------------------------------------------------------------"
echo "Output folder:      /${process}/"
echo "Instance URL:       ${inst}"
echo "Target Org:         ${targetorg}"
echo "Salesforce Version: v${sfversion}"
echo "Source:             ${source}"
echo '\nPress any key to continue...'; read -k1 -s
echo


# Make sure directory exists to place outputs from script
DIR="./${process}/"
if [ ! -d "$DIR" ] ; then
  ### Take action if $DIR does not exist ###
  echo "Creating output directory ${DIR}...\n"
  mkdir ${process}
fi

# Get Access Token from SF CLI environment
#sf org display --target-org mguse@deloitte.com.gcrm.6335400.aurora > crma_org.info
sf org display --target-org ${targetorg} > crma_org.info
token=`grep "Access Token" crma_org.info | cut -w -f 4`
rm crma_org.info

printf "\nExtracting CRMA Dashboard Info ... "

curl -s ${inst}/services/data/v${sfversion}/wave/dashboards \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o ${DIR}${source}_dashboards.json \

jq '.dashboards[]|{Id: .id, Label: .label, Name: .name, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' ${DIR}${source}_dashboards.json > ${DIR}${source}_dashboard_list.json  

tmp=`grep '\"Id\":' ${DIR}${source}_dashboard_list.json|wc -l|cut -w -f 2`
printf "${tmp} entries.\n"

printf "Extracting CRMA Dataset Info   ... "

curl -s ${inst}/services/data/v${sfversion}/wave/datasets \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o ${DIR}${source}_datasets.json \

jq '.datasets[]|{Id: .id, Name: .name, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' ${DIR}${source}_datasets.json > ${DIR}${source}_dataset_list.json

tmp=`grep '\"Id\":' ${DIR}${source}_dataset_list.json|wc -l|cut -w -f 2`
printf "${tmp} entries.\n"

printf "Extracting CRMA Lenses Info    ... "

curl -s ${inst}/services/data/v${sfversion}/wave/lenses \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $token" \
    -o ${DIR}${source}_lenses.json \

jq '.lenses[]|{Id: .id, Label: .label, Name: .name, CreatedDate: .createdDate, LastModDate: .lastModifiedDate}' ${DIR}${source}_lenses.json > ${DIR}${source}_lenses_list.json

tmp=`grep '\"Id\":' ${DIR}${source}_lenses_list.json|wc -l|cut -w -f 2`
printf "${tmp} entries.\n"

printf "\nDone!\n"
