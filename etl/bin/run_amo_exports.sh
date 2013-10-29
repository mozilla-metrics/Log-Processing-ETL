#!/bin/bash

BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle
LOG=/var/log/etl/eod_manual_amo_exports_`date '+%Y%m%d_%H%M%S'`.log
KETTLE_JOB=$BASEDIR/etl/timestamped_log_manager/run_amo_exports_only.kjb

export KETTLE_HOME=/opt/pentaho/kettle;
JAVAMAXMEM=10000 ./kitchen.sh -file $KETTLE_JOB ${1+"$@"} > $LOG 2>&1

KETTLE_EXIT=$?

if [ "$KETTLE_EXIT" -ne "0" ]; then
   echo "Error encountered during AMO exports. Kettle exit code was '$KETTLE_EXIT', but we expected '0'."
   cat $LOG
fi
