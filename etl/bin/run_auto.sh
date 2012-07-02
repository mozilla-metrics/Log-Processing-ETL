#!/bin/bash

cd /opt/pentaho/kettle/kettle-4.3/
BASEDIR=/opt/pentaho/kettle/etl/logProcessing
KETTLE_HOME=$BASEDIR/prod_config
KETTLE_JOB=$BASEDIR/etl/timestamped_log_manager/process_missing_logs_wrapper.kjb

KETTLE_HOME=$BASEDIR/prod_config JAVAMAXMEM=20000 ./kitchen.sh -file $KETTLE_JOB ${1+"$@"} 2>&1 > auto_cron_hourly.log
