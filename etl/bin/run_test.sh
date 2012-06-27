#!/bin/bash

cd /opt/pentaho/kettle/kettle-4.3/
BASEDIR=/opt/pentaho/kettle/etl/logProcessing
KETTLE_HOME=$BASEDIR/testing JAVAMAXMEM=20000 ./kitchen.sh -level Basic -file /tmp/test_amo_trans.kjb ${1:?"datacenter"} ${2:?"site"} ${3:?"server"} ${4:?"timestamp"} ${5:?"filename"} 2>&1 > $BASEDIR/TEST_parse_and_load.log
