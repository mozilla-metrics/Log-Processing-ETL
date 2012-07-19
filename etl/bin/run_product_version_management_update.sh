#!/bin/bash

BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle
LOG=/var/log/etl/run_product_version_management$(date +%Y%m%d).log

#KETTLE_HOME=/opt/pentaho/kettle
./kitchen.sh -level Minimal -file $BASEDIR/etl/dimensions/product_version_management.kjb -param:mode=update ${1+"$@"} 2>&1 | tee -a $LOG | grep -C 1000 ERROR
