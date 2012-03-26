# Example command to run a backprocess:
JAVAMAXMEM=10000 ./kitchen.sh -file /etl/timestamped_log_manager/backprocess.kjb \
    -param:SITE_CONDITION="= 'vamo' AND server = 'nslog1'" \
    -param:SITE_TRANSFORMATION=/etl/amo/parse_and_load_amo_versioncheck_only.ktr 2012-02-27-13 2012-02-27-13
