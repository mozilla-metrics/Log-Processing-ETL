#!/bin/bash

cd /opt/pentaho/kettle/kettle
JAVAMAXMEM=10000 ./kitchen.sh -file /opt/pentaho/kettle/etl/logProcessing/etl/timestamped_log_manager/eod_processing.kjb ${1+"$@"} 2>&1 > eod_cron.log

