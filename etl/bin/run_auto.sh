#!/bin/bash

BASEDIR=/opt/pentaho/kettle/etl/logProcessing

cd $BASEDIR/kettle

KETTLE_JOB=$BASEDIR/etl/timestamped_log_manager/process_missing_logs_wrapper.kjb
LOG=/var/log/etl/auto_cron_hourly.log

#KETTLE_HOME=/opt/pentaho/kettle
JAVAMAXMEM=20000 ./kitchen.sh -file $KETTLE_JOB ${1+"$@"} 2>&1 > $LOG
