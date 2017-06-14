#!/bin/bash
export TAG=$1
export HANA_REVISION=$2
export DISK_ID=$3
export REGION=$4
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
        "revision": "$HANA_REVISION",
        "region": "$REGION"
    },
    "saplvm": {
        "disk_id": "$DISK_ID"
    },
    "sapinst": {
        "region": "$REGION",
        "db_tag": "$TAG"
    }
}
EOF
