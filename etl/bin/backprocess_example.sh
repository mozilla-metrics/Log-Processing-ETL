# The contents of this file are subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

# Example command to run a backprocess:
JAVAMAXMEM=10000 ./kitchen.sh -file /etl/timestamped_log_manager/backprocess.kjb \
    -param:SITE_CONDITION="= 'vamo' AND server = 'nslog1'" \
    -param:SITE_TRANSFORMATION=/etl/amo/parse_and_load_amo_versioncheck_only.ktr 2012-02-27-13 2012-02-27-13
