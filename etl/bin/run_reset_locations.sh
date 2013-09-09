#!/bin/bash
cd /opt/pentaho/kettle/kettle-4.3/
BASEDIR=/opt/pentaho/kettle/etl/logProcessing

KETTLE_JOB=$BASEDIR/etl/dimensions/reset_locations.kjb

KETTLE_HOME=$BASEDIR/prod_config JAVAMAXMEM=10000 ./kitchen.sh -level Basic -file $KETTLE_JOB
