#!/bin/bash

cd /opt/pentaho/kettle/kettle
#./kitchen.sh -file /opt/pentaho/kettle/etl/logProcessing/run_on_carte.kjb -param:JOB=/etl/timestamped_log_manager/process_missing_logs_wrapper.kjb ${1+"$@"} 2>&1 > auto_cron_hourly.log
JAVAMAXMEM=20000 ./kitchen.sh -file /opt/pentaho/kettle/etl/logProcessing/etl/timestamped_log_manager/process_missing_logs_wrapper.kjb ${1+"$@"} 2>&1 > auto_cron_hourly.log

