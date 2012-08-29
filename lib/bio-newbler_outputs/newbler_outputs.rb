require 'csv'

module Bio
  class Newbler
    def self.log
      Bio::Log::LoggerPlus['bio-newbler_outputs']
    end
    
    class Contig
      attr_accessor :length, :coverage, :coverage_profile
      
      # Compute the median coverage for this contig, based on the data
      # in @coverage_profile.
      def median_coverage
        if @coverage_profile.nil? or @coverage_profile.empty?
          raise "coverage_profile is empty, so cannot compute median"
        end
        
        sorted = @coverage_profile.sort
        if sorted.length % 2 == 1 #if odd
          return sorted[(sorted.length-1)/2].to_f
        else # else must be even
          middle = sorted.length/2
          return (sorted[middle]+sorted[middle-1]).to_f/2
        end
      end
    end
  end
end
