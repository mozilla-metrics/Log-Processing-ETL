#!/bin/bash

cd /opt/pentaho/kettle
./kitchen.sh -level Minimal -file /etl/dimensions/product_version_management.kjb -param:mode=check ${1+"$@"} 2>&1 | tee -a dimensions_cron_nightly.log | grep -C 1000 ERROR
