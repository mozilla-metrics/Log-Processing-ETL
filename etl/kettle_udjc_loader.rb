#!/usr/bin/ruby
# The contents of this file are subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

# TODO: detect unused connections

require 'optparse'
require 'rexml/document'
require 'tempfile'
include REXML

$replace_original_file = false
$extract_only = false
$backup_original_file = true
$java_base_dir = "./java"

options = OptionParser.new do |o|
    o.banner = "Usage: #{$0} [ options ] file1 [ file2 file3 ... ]"
    o.on('-o', '--overwrite', 'Causes the original file to be replaced with the fixed version.') { $replace_original_file = true }
    o.on('-e', '--extract', 'Use this option to pull the java code out of the XML.') { $extract_only = true }
    o.on('-j', '--java-base JAVADIR', 'Directory to search for java files. UDJCs should be located at <java base>/<transformation>/<step name>.java') { |arg| $java_base_dir = arg }
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
        base = File.basename(file)
        xmldoc = Document.new(File.new(file))
        xmldoc.context[:attribute_quote] = :quote
        xmldoc.elements.each("transformation/step"){ |step|
            type = step.elements["type"].text
            if type == "UserDefinedJavaClass"
                name = step.elements["name"].text
                puts "Found a UDJC:  Name: '#{name}', Type: '#{type}'"
                # get the source:
                source = step.elements["definitions/definition/class_source"].cdatas
                javadir = "#{$java_base_dir}/#{base}"
                javafile = "#{javadir}/#{name}.java"

                if $extract_only
                    puts "Creating it in '#{javafile}'"
                    Dir.mkdir(javadir) unless File.directory?(javadir)
                    File.open(javafile, "w") { |java|
                        java.print(source.join(''))
                    }
                else
                    puts "Looking for it in '#{javafile}'"
                    if File.file?(javafile)
                        puts "Found it! comparing with the doc."
                        #puts "here's #{source.size} sources: " + source.join('')
                        tmp = Tempfile.new('udjc_source')
                        tmp.print(source.join(''))
                        tmp.flush

                        diff_output = %x(diff "#{javafile}" "#{tmp.path}")
                        if diff_output.empty?
                            puts "Source for '#{name}' is unchanged.  Skipping."
                        else
                            puts "Diff of java file and udjc content:"
                            puts diff_output
                            #sleep(30)
                            puts "Do you want to replace the UDJC? [y|N]"
                            answer = $stdin.gets.strip
                            if answer =~ /^[yY]/
                                puts "Replacing..."
                                # TODO
                                newsource = IO.read(javafile)

                                step.delete_element("definitions/definition/class_source")
                                step.elements["definitions/definition"].add_element(Element.new("class_source"))
                                CData.new(newsource, true, step.elements["definitions/definition/class_source"])
                                updated = File.open("#{file}.udjc", "w")
                                #xmldoc.write(File.new("#{file}.udjc"))
                                xmldoc.write(updated)
                                updated.close

                                if $replace_original_file
                                    puts "Replacing '#{file}' with updated version"
                                    if $backup_original_file
                                        File.rename(file, "#{file}.orig")
                                    end
                                    File.rename("#{file}.udjc", file)
                                end
                            else
                                puts "Leaving UDJC alone."
                            end
                        end
                    else
                        puts "ERROR: No such file '#{javafile}'. Aborting."
                        puts "  Hint: you can use the '--extract' option to get the source out of the transformation."
                    end
                end
            end
        }
    else
        puts "Skipping '#{file}' since it's not a regular file."
    end
end

