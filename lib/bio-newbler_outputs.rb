# Please require your code below, respecting the naming conventions in the
# bioruby directory tree.
#
# For example, say you have a plugin named bio-plugin, the only uncommented
# line in this file would be 
#
#   require 'bio/bio-plugin/plugin'
#
# In this file only require other files. Avoid other source code.

require 'bio-newbler_outputs/newbler_outputs.rb'
require 'bio-newbler_outputs/alignment_info_file'
require 'bio-newbler_outputs/contig_graph_file'

require 'bio-logger'
Bio::Log::LoggerPlus.new('bio-newbler_outputs')