#!/bin/bash

BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle
LOG=/var/log/etl/dimensions_cron_nightly.log

#KETTLE_HOME=/opt/pentaho/kettle
./kitchen.sh -level Minimal -file $BASEDIR/etl/dimensions/product_version_management.kjb -param:mode=check ${1+"$@"} 2>&1 | tee -a $LOG | grep -C 1000 ERROR
