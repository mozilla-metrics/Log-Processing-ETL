#!/bin/bash
BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle

## Date range to backprocess:
START_DATE=2012-06-30-16
END_DATE=2012-07-01-16
LOG_FILE=backprocess$END_DATE.log

## Log level:
LEVEL=Basic

BACK_JOB=$BASEDIR/etl/timestamped_log_manager/backprocess.kjb

LOGDIR=/var/log/etl

## Examples:
KETTLE_HOME=/opt/pentaho/kettle JAVAMAXMEM=10000 ./kitchen.sh -level $LEVEL -file $BACK_JOB -param:SITE_CONDITION="IN ('amo', 'vamo')" -param:ACTIVE_CONDITION="IS NOT NULL" -param:SITE_TRANSFORMATION="$BASEDIR/etl/amo/parse_and_load_amo.ktr" $START_DATE $END_DATE > $LOGDIR/$LOG_FILE
#KETTLE_HOME=/opt/pentaho/kettle JAVAMAXMEM=10000 ./kitchen.sh -level $LEVEL -file $BACK_JOB -param:SITE_CONDITION="IN ('dmo')" -param:ACTIVE_CONDITION="IS NOT NULL" -param:SITE_TRANSFORMATION="$BASEDIR/etl/downloads/parse_and_load_download_requests.ktr" $START_DATE $END_DATE > $LOGDIR/$LOG_FILE
#KETTLE_HOME=/opt/pentaho/kettle JAVAMAXMEM=10000 ./kitchen.sh -level $LEVEL -file $BACK_JOB -param:SITE_CONDITION="IN ('aus')" -param:ACTIVE_CONDITION="IS NOT NULL" -param:SITE_TRANSFORMATION="$BASEDIR/etl/aus/parse_and_load_aus_requests.ktr" $START_DATE $END_DATE > $LOGDIR/$LOG_FILE
