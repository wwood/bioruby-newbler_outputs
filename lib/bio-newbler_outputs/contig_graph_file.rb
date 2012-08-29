# File parser for the 454ContigGraph.txt output from newbler.
#
#    1 contig00001 40963 29.1
#    2 contig00002 21  109.9
#    3 contig00003 24758 19.0
#    4 contig00004 8053  18.8
#    5 contig00005 28973 17.8
#    6 contig00006 28422 20.6
#    7 contig00007 1551  12.4
#    8 contig00008 15016 24.4
#    9 contig00009 44  40.9
#    10  contig00010 866 31.8
class Bio::Newbler::ContigGraphFile
  
  # Return a hash of contig name to Contig objects with filled in coverage and length details.
  #
  # Currently ignores other parts of the file e.g. edges (lines starting with C) and scaffolds (lines starting with S), and so on.
  def self.contig_hash(contig_graph_filename)
    log = Bio::Newbler.log
    
    state = 'read_contig_stats'
    contig_stats = {}

    File.open(contig_graph_filename).each_line do |line|
      if state == 'read_contig_stats'
        splits = line.strip.split("\t")
        if splits.length == 4
          contig = Bio::Newbler::Contig.new
          contig.length = splits[2].to_i
          contig.coverage = splits[3].to_f
          contig_stats[splits[1]] = contig
        elsif splits.length == 6
          state = 'scaffolds'
          unless splits[0] == 'C'
            raise "Unexpected line: #{splits.inspect}"
          end
          log.info "Cached stats on #{contig_stats.length} contigs"

        else
          raise "Unexpected number of fields (#{splits.length}) found in 454ContigGraph.txt file '#{contig_graph_filename}', in this line: #{line}"
        end
      end

      # if state == 'scaffolds'
        # if line.match(/^S/)
          # splits = line.split("\t")
          # raise unless splits.length == 4
          # total_length = splits[2]
          # #caculate coverage, not including gaps into the calculation
          # components = splits[3].split(';')
          # total_bases = 0
          # total_contiged_length = 0
          # components.each do |c|
            # cees = c.split(':')
            # raise unless cees.length == 2
            # if cees[0]!='gap'
              # contig = contig_stats[cees[0]]
              # if contig.nil?
                # raise "contig not found: #{cees[0]}"
              # end
            # total_contiged_length += contig.length
            # total_bases += contig.coverage*contig.length
            # end
          # end
          # puts [
            # splits[1],
            # total_length,
            # total_bases/total_contiged_length
          # ].join("\t")
        # end
    end
    
    return contig_stats
  end
end