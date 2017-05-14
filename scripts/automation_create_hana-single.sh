#!/usr/bin/env bash
# Make sure you source the openrc file before executing this script locally

# This script receives 2 parameters: instance ID and Hana type, creates the right hana automation and run it on the instance ID provided
export INSTANCE_ID=$1
export HANA_TYPE=$2
AUTOMATION_NAME=hana-single-auto
#AUTOMATION_REPO=https://github.wdf.sap.corp/cc-chef-cookbooks/hana.git
AUTOMATION_REPO=https://github.wdf.sap.corp/c5240533/hana.git
REPO_REVISION=master
BASE_RUNLIST="recipe[hana::install-"
#RUNLIST="recipe[hana::install-hana-single.rb]"
ATTRIB_FILE=json/demo_db_attributes.json

# create automation according to the hana version given in terraform
case "$HANA_TYPE" in
'hana-single') 
RUNLIST="recipe[sap-lvm::database-disk-sliced],""$BASE_RUNLIST""$HANA_TYPE"]
            echo $RUNLIST
            ;;
esac
echo "$(tput setaf 1)the run list is: $(tput setaf 6)$RUNLIST$(tput sgr 0)"

# authentication using lyra to get token
lyra authenticate 2>&1 | tee tmp/token_export.sh

# export OS_TOKEN 
source tmp/token_export.sh

#Get automation list
lyra automation list 2>&1 | tee tmp/automation_list.txt

# Check if automation is already created
AUTOMATION_ID=`awk -v auto_name=$AUTOMATION_NAME '$4==auto_name {print $2}' tmp/automation_list.txt`

# Create automation only if not created already
if [[ -z "$AUTOMATION_ID" ]]; then
  lyra automation create chef --name=$AUTOMATION_NAME --repository=$AUTOMATION_REPO \
    --runlist=$RUNLIST  --timeout=3000 \
    --attributes-from-file=$ATTRIB_FILE --repository-revision=$REPO_REVISION --timeout=36000 --log-level=debug  2>&1 | tee tmp/automation_created.txt
  AUTOMATION_ID=`awk '$2=="id" {print $4}' tmp/automation_created.txt`
fi


#Add tag to server
lyra node tag add --node-id $INSTANCE_ID tag:$HANA_TYPE

# Execute automation
lyra automation execute --automation-id $AUTOMATION_ID --selector='@identity="'$INSTANCE_ID'"' --watch 2>&1 | tee tmp/run_automation.txt

# Cleanup
#rm -f tmp/*.txt tmp/token_export.sh
