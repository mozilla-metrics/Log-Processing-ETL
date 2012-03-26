#!/usr/bin/ruby
# The contents of this file are subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

# TODO: detect unused connections

require 'optparse'

def remap(line, map, label)
    tag = line[/<[^\/>]*>/]
    replacement = map[tag]
    if !replacement.nil?
        puts "replacing #{label} #{tag} with '#{replacement}'"
        line.sub!(/>[^<]*</, ">#{replacement}<")
    end
end

in_slaveservers = false
in_connection = false
in_extended_description = false
desc_contains_license = false
has_port = false
skip_lines = 0

in_mysql_connection = false
remap_mysql = {
    "<server>"   => '${METRICS_MYSQL_HOST}',
    "<database>" => '${METRICS_MYSQL_NAME}',
    "<port>"     => '${METRICS_MYSQL_PORT}',
    "<username>" => '${METRICS_MYSQL_USER}',
    "<password>" => '${METRICS_MYSQL_PASS}',
}

in_vertica_connection = false
remap_vertica = {
    "<database>" => '${VERTICA_DB}',
    "<port>"     => '${VERTICA_PORT}',
    "<username>" => '${VERTICA_USER}',
    "<password>" => '${VERTICA_PASS}',
}

# TODO: remap_socorro_dev

in_amo_master_connection = false
remap_amo_master = {
    "<server>"   => '${AMO_MASTER_HOST}',
    "<database>" => '${AMO_MASTER_DATABASE}',
    "<port>"     => '${AMO_MASTER_PORT}',
    "<username>" => '${AMO_MASTER_USER}',
    "<password>" => '${AMO_MASTER_PASS}',
}

# TODO: probably don't need this one.
in_lucid_connection = false
remap_lucid = {
    "<server>"   => '${LUCID_HOST}',
    "<database>" => '${LUCID_DATABASE}',
    "<port>"     => '${LUCID_PORT}',
    "<username>" => '${LUCID_USER}',
    "<password>" => '${LUCID_PASS}',
}

LICENSE_BLURB_L1 = 'The contents of this file are subject to the terms of the Mozilla Public'
LICENSE_BLURB_L2 = 'License, v. 2.0. If a copy of the MPL was not distributed with this file,'
LICENSE_BLURB_L3 = 'You can obtain one at http://mozilla.org/MPL/2.0/.'
LICENSE_BLURB = [LICENSE_BLURB_L1, LICENSE_BLURB_L2, LICENSE_BLURB_L3].join("\n")

$replace_original_file = false
$backup_original_file = true

options = OptionParser.new do |o|
    o.banner = "Usage: #{$0} [ options ] file1 [ file2 file3 ... ]"
    o.on('-o', '--overwrite', 'Causes the original file to be replaced with the fixed version.') { $replace_original_file = true }
    o.on('-B', '--no-backup', "Do not backup the original files - make sure you're using version control!") { $backup_original_file = false }
    o.on_tail('-h', '--help', "Show this message") { puts o; exit }
    o.parse!
end

if ARGV.size == 0
    puts options
    abort
end

ARGV.each do |file|
    # skip directories
    if File.file?(file)
        puts "Processing '#{file}'..."
        fixed = File.open("#{file}.fixed", "w")
        linenum = 0
        File.open(file).each_line { |line|
            linenum += 1

            if in_connection and line =~ /^\s*<port>[^>]+<\/port>\s*$/
                has_port = true;
            end

            if line.include?('FIXME')
                puts "WARN: #{file}:#{linenum}:  Found an unfixed FIXME: #{line}"
            end

            if linenum == 2 and line != "<!-- #{LICENSE_BLURB_L1}\n"
                fixed.print "<!-- #{LICENSE_BLURB_L1}\n"
                fixed.print "   - #{LICENSE_BLURB_L2}\n"
                fixed.print "   - #{LICENSE_BLURB_L3}  -->\n"
            elsif line =~ /^\s*<extended_description\/>\s*$/
                indent = line[/^\s*/]
                fixed.print "#{indent}<extended_description>\n"
                fixed.print LICENSE_BLURB
                fixed.print "\n#{indent}</extended_description>\n"
                skip_lines += 1 unless skip_lines > 0
            elsif line =~ /^\s*<extended_description>\s*$/
                in_extended_description = true
            elsif line =~ /^\s*<\/extended_description>\s*$/
                in_extended_description = false
                if !desc_contains_license
                    fixed.print "\n" + LICENSE_BLURB + "\n"
                end
            elsif in_extended_description and line.include?(LICENSE_BLURB_L1)
                desc_contains_license = true
            elsif line =~ /^\s*<slaveservers>\s*$/
                in_slaveservers = true
            elsif line =~ /^\s*<\/slaveservers>\s*$/
                in_slaveservers = false
            elsif line =~ /^\s*<connection>\s*$/
                in_connection = true
            elsif line =~ /^\s*<\/connection>\s*$/
                in_connection = false
                in_mysql_connection = false
                in_vertica_connection = false
                in_amo_master_connection = false
                in_lucid_connection = false
                has_port = false
            elsif in_connection and line =~ /^\s*<name>metrics mysql<\/name>\s*$/
                in_mysql_connection = true
            elsif in_connection and line =~ /^\s*<name>amo master<\/name>\s*$/
                in_amo_master_connection = true
            elsif in_connection and line =~ /^\s*<name>lucid<\/name>\s*$/
                in_lucid_connection = true
            elsif in_connection and has_port and line =~ /^\s*<attribute><code>PORT_NUMBER<\/code><attribute>[0-9]+<\/attribute><\/attribute>\s*$/
                skip_lines += 1 unless skip_lines > 0
            elsif in_mysql_connection
                remap(line, remap_mysql, 'mysql')
            elsif in_connection and line =~ /^\s*<type>VERTICA<\/type>\s*$/
                in_vertica_connection = true
            elsif in_vertica_connection
                remap(line, remap_vertica, 'vertica')
            elsif in_amo_master_connection
                remap(line, remap_amo_master, 'amo master')
            elsif in_lucid_connection
                remap(line, remap_lucid, 'lucid')
            elsif in_connection and line =~ /<username>/ and !line.include?('${')
                puts "WARN: #{file}:#{linenum}:  bare username: #{line}"
            elsif in_connection and line =~ /<password>/ and !line.include?('${')
                puts "WARN: #{file}:#{linenum}:  bare password: #{line}"
            elsif in_slaveservers
                skip_lines += 1
            end
    
            #puts "#{linenum} #{skip_lines} #{line}"
    
            if skip_lines > 0
                skip_lines -= 1
            else
                fixed.print line
            end
        }
    
        puts "Finished processing '#{file}'"
    
        if $replace_original_file
            puts "Replacing '#{file}' with fixed version"
            if $backup_original_file
                File.rename(file, "#{file}.orig")
            end
            File.rename("#{file}.fixed", file)
        end
    else
        puts "Skipping '#{file}' since it's not a regular file."
    end
end

