#!/bin/bash
export DB_HOST=$1
export HANA_REVISION=$2
export DISK_ID=$3
#create attribute file

cat > json/demo_db_attributes.json << EOF
{
  "hana": {
      "major": { 
                 "version": "2"
               },
    "sid": "MV1",
    "instance": "00",
    "password": "Start1234",
    "revision": "$HANA_REVISION"
  },
  "saplvm": {
       "disk_id": "$DISK_ID"
  }
}
EOF
