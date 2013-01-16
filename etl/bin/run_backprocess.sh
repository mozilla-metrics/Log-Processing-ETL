#!/bin/bash

USAGE="Usage: $0 <type> <start_date> <end_date>
Where
  type         The type of data you want to backprocess.  One of 'amo', 'dmo', or 'aus'.  Note that 'amo' also includes vamo.
  start_date   Beginning of the backprocess interval.  Format is YYYY-mm-dd-HH
  end_date     End of the backprocess interval.  Format is YYYY-mm-dd-HH
Example:
  $ $0 amo 2013-01-15-15 2013-01-17-04

The above would process amo (and vamo) logs between Jan 15th 2013 at 15:00 UTC and Jan 17th 2013 at 04:00.
"

BASEDIR=/opt/pentaho/kettle/etl/logProcessing
cd $BASEDIR/kettle

if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
   echo "Error: missing argument(s)"
   echo "$USAGE"
   exit -1
fi

START_DATE_CHECK=$(echo $2 | sed -r "s/[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}$//")
if [ ! -z "$START_DATE_CHECK" ]; then
   echo "Error: invalid start date '$2'.  Should be of the form YYYY-mm-dd-HH"
   echo "$USAGE"
   exit -1
fi
END_DATE_CHECK=$(echo $3 | sed -r "s/[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}$//")
if [ ! -z "$END_DATE_CHECK" ]; then
   echo "Error: invalid start date '$3'.  Should be of the form YYYY-mm-dd-HH"
   echo "$USAGE"
   exit -1
fi

COND="IN ('amo', 'vamo')"
TRANS=$BASEDIR/etl/amo/parse_and_load_amo.ktr

case $1 in
   amo)
      echo "Processing amo and vamo"
      # vars default to amo above.
      ;;
   dmo)
      echo "Processing dmo"
      COND="IN ('dmo')"
      TRANS=$BASEDIR/etl/downloads/parse_and_load_dmo.ktr
      ;;
   aus)
      echo "Processing aus"
      COND="IN ('aus')"
      TRANS=$BASEDIR/etl/aus/parse_and_load_aus.ktr
      ;;
   *)
      echo "Error: Unknown log type '$1'"
      echo "$USAGE"
      exit -1
      ;;
esac

## Date range to backprocess:
START_DATE=$2
END_DATE=$3
LOG_FILE=/var/log/etl/backprocess$END_DATE.log

## Log level:
LEVEL=Basic

BACK_JOB=$BASEDIR/etl/timestamped_log_manager/backprocess.kjb

KETTLE_HOME=/opt/pentaho/kettle JAVAMAXMEM=10000 ./kitchen.sh -level $LEVEL -file $BACK_JOB -param:SITE_CONDITION="$COND" -param:ACTIVE_CONDITION="IS NOT NULL" -param:SITE_TRANSFORMATION="$TRANS" $START_DATE $END_DATE > $LOG_FILE
