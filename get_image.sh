#!/bin/bash
echo $( openstack image list | grep sles-12 | awk '{print $4}' )

