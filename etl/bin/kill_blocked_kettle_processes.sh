#!/bin/bash

# ============================================================================
# Find Kettle process that don't produce any log output (stalled processes)  #
# ============================================================================

# Debug settings:
DEBUG=false
# How long (minutes) can a process run without log activity:
STALL_TIME_THRESHOLD=100

KETTLE_PROCESSES=`ps -ef | grep kettle-core.jar | grep -v grep | awk '{print $2}'`
for KETTLE_PID in $KETTLE_PROCESSES ; do
	$DEBUG found kettle pid = $KETTLE_PID
	KETTLE_LOG_FILES=`ls -l /proc/$KETTLE_PID/fd | egrep '.log$' | cut -d '>'  -f 2`
	$DEBUG Logfiles for $KETTLE_PID: $KETTLE_LOG_FILES
	# log files changed less than $STALL_TIME_THRESHOLD minutes ago:
	OLD_LOG_FILES=`find $KETTLE_LOG_FILES -cmin -$STALL_TIME_THRESHOLD`
	if [ -z "$OLD_LOG_FILES" ]; then
		echo "========================================================================================================"
		echo "Found a Kettle process (PID=$KETTLE_PID) without logs activity for at lest $STALL_TIME_THRESHOLD minutes."
		KETTLE_PPID=`ps -f -p $KETTLE_PID | awk '!/PPID/ {print $3}'`
		echo "Parent (PID=$KETTLE_PPID) process tree:"
		pstree -A -a -l $KETTLE_PPID | uniq 
		echo -n Killing -9 process $KETTLE_PID
		kill -9 $KETTLE_PID
		echo "  Done."
		echo "========================================================================================================"
		echo
	fi
done




