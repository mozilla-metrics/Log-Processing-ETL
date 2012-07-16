#!/bin/bash

cd /opt/pentaho/kettle/kettle-4.3/
BASEDIR=/opt/pentaho/kettle/etl/logProcessing
LOG=/var/log/etl/eod_cron.log
KETTLE_JOB=$BASEDIR/etl/timestamped_log_manager/eod_processing.kjb

#KETTLE_HOME=/opt/pentho/kettle/
JAVAMAXMEM=10000 ./kitchen.sh -file $KETTLE_JOB ${1+"$@"} 2>&1 > $LOG

