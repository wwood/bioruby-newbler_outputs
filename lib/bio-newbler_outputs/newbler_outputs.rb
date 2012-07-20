require 'csv'

module Bio
  class Newbler
    class Contig
      attr_accessor :length, :coverage
    end
    
    
    # Position Consensus Quality_Score Depth Signal  StdDeviation
    # >contig00001  1
    # 1 C 64  6 2.04  0.60
    # 2 C 20  6 2.04  0.60
    # 3 G 64  6 1.96  0.55
    # 4 G 20  6 1.96  0.55
    class AlignmentInfoFile
      # Iterate through each row, returning contig_name, columns (string then Array of strings)
      def self.foreach(filename)
        current_contig = nil
        
        CSV.foreach(filename, :headers => true, :col_sep => "\t") do |row|
          if matches = row[0].match(/^>(contig\d{5})$/)
            current_contig = matches[1]
          else
            yield current_contig, row
          end
        end
      end
      
      # Return a hash of contig name to Contig objects with filled in coverage and length details
      def self.contig_hash(filename)
        hash = {}
        add_contig = lambda do |contig_name, total_count, length|
          contig = Contig.new
          contig.length = length
          contig.coverage = total_count.to_f/length
          hash[contig_name] = contig
        end
        
        count = 0
        total_length = 0
        last_contig = nil
        foreach(filename) do |contig, cols|
          last_contig = contig if last_contig.nil?
          
          if contig==last_contig 
            count += cols[3].to_i
            total_length += 1
          else
            add_contig.call(last_contig, count, total_length)
            count = 0
            total_length = 0
          end
          last_contig = contig
        end
        add_contig.call(last_contig, count, total_length)
        
        return hash
      end
    end
  end
end