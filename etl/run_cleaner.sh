find . -type f -not -path "*unused*" -a \( -name "*.ktr" -o -name "*.kjb" -o -name "*.xml" \) -exec ./kettle_xml_cleaner.rb -o -B {} \;
