#!/bin/bash
# The contents of this file are subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

find . -type f -not -path "*unused*" -a \( -name "*.ktr" -o -name "*.kjb" -o -name "*.xml" \) -exec ./kettle_xml_cleaner.rb -o -B {} \;
