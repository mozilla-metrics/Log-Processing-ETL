#!/bin/bash

cd /opt/pentaho/kettle/kettle-4.3/
BASEDIR=/opt/pentaho/kettle/etl/logProcessing
JAVAMAXMEM=2000 ./pan.sh -level Minimal -file $BASEDIR/etl/timestamped_log_manager/audit_server_traffic.ktr
