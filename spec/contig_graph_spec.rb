require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ContigGraphFile" do
  it "should parse a file" do
    file = File.join(File.dirname(__FILE__),'data','454ContigGraph.txt')
    hash = Bio::Newbler::ContigGraphFile.contig_hash(file)
    hash.length.should eq(10)
    
    hash.to_a[0][0].should eq('contig00001')
    hash.to_a[0][1].length.should eq(137)
    hash.to_a[0][1].coverage.should eq(6.3)
    
    hash.to_a[6][1].coverage.should eq(31.8)
  end
end