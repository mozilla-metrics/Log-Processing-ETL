#!/bin/bash

BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle
JAVAMAXMEM=2000 ./pan.sh -level Minimal -file $BASEDIR/etl/timestamped_log_manager/audit_server_traffic.ktr $*
