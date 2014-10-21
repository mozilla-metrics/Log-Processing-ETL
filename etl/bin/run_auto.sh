#!/bin/bash
export JAVAMAXMEM='20g -Xms6000'
cd /opt/pentaho/kettle/etl/logProcessing/kettle


/opt/pentaho/kettle/etl/weblogs/kettle_wrapper.sh \
 -j "logProcessingEtl" \
 -l "Log Processing ETL" \
 -w 1500 \
 -c "./kitchen.sh -norep -file /opt/pentaho/kettle/etl/logProcessing/etl/timestamped_log_manager/process_missing_logs.kjb -level Basic ${1+"$@"}"

