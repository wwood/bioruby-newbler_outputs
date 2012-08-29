# Position Consensus Quality_Score Depth Signal  StdDeviation
# >contig00001  1
# 1 C 64  6 2.04  0.60
# 2 C 20  6 2.04  0.60
# 3 G 64  6 1.96  0.55
# 4 G 20  6 1.96  0.55
class Bio::Newbler::AlignmentInfoFile
  # Iterate through each row, returning contig_name, columns (string then Array of strings)
  def self.foreach(filename)
    current_contig = nil
    
    CSV.foreach(filename, :headers => true, :col_sep => "\t") do |row|
      if matches = row[0].match(/^>(contig\d{5}\d*)/)
        current_contig = matches[1]
      else
        yield current_contig, row
      end
    end
  end
  
  # Return a hash of contig name to Contig objects with filled in coverage and length details
  def self.contig_hash(filename)
    log = Bio::Newbler.log
    
    hash = {}
    add_contig = lambda do |contig_name, total_count, length, coverage_profile|
      contig = Bio::Newbler::Contig.new
      contig.length = length
      contig.coverage = total_count.to_f/length
      contig.coverage_profile = coverage_profile
      hash[contig_name] = contig
      
      if hash.length % 1024 == 0
        log.info "Completed #{hash.length} contigs"
        $stderr.puts "Completed #{hash.length} contigs"
      end
    end
    
    count = 0
    total_length = 0
    last_contig = nil
    coverage_profile = []
    
    foreach(filename) do |contig, cols|
      last_contig = contig if last_contig.nil?
      
      if contig==last_contig
        coverage = cols[3].to_i
        
        count += coverage
        total_length += 1
        coverage_profile.push coverage
      else
        add_contig.call(last_contig, count, total_length, coverage_profile)
        count = 0
        total_length = 0
        coverage_profile = []
      end
      last_contig = contig
    end
    add_contig.call(last_contig, count, total_length, coverage_profile)
    
    return hash
  end
end