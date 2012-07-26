require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tempfile'

describe "BioNewblerOutputs" do
  it "should parse a coverage file" do
    test = "Position        Consensus       Quality Score   Depth   Signal  StdDeviation
    >contig00001    1
    1       A       64      13      5.91    0.46
    2       A       64      13      5.91    0.46
    3       A       64      13      5.91    0.46
    4       A       64      13      5.91    0.46
    5       A       64      13      5.91    0.46
    6       A       51      13      5.91    0.46
    7       T       64      13      0.98    0.08
    8       C       64      13      0.96    0.09
    9       A       64      13      0.89    0.15
    10      T       64      13      1.02    0.09
    11      C       64      14      2.95    0.40
    12      C       64      14      2.95    0.40
    13      C       64      14      2.95    0.40
    14      A       64      14      2.90    0.19
    >contig00002    1
    1       T       64      16      0.97    0.04
    2       G       64      16      1.01    0.05
    3       C       64      16      0.96    0.04
    4       G       64      16      2.94    0.27
    5       G       64      16      2.94    0.27
    6       G       64      16      2.94    0.27".split("\n").collect{|s| s.strip.gsub(/\s+/,"\t")}.join("\n")
    
    Tempfile.open('a') do |tempfile|
      tempfile.puts test
      tempfile.close
      
      hash = Bio::Newbler::AlignmentInfoFile.contig_hash(tempfile.path)
      hash.length.should eq(2)
      hash.to_a[0][0].should eq('contig00001')
      hash.to_a[1][0].should eq('contig00002')
      
      hash.to_a[0][1].coverage.should eq(13.285714285714286)
      hash.to_a[1][1].coverage.should eq(16.0)
    end
  end
  
  it 'test ok on realish data' do
    file = File.join(File.dirname(__FILE__),'data','500.test.454AlignmentInfo.tsv')
    hash = Bio::Newbler::AlignmentInfoFile.contig_hash(file)
    hash.length.should eq(42)
  end
  
  it 'contig_hash should compute median coverage properly' do
    contig = Bio::Newbler::Contig.new
    expect {contig.median_coverage}.to raise_error
    
    contig.coverage_profile = [1,2,3]
    contig.median_coverage.should eq(2.0)
    
    contig.coverage_profile = [1,2,3,4]
    contig.median_coverage.should eq(2.5)
  end
  
  it 'should contig_hash median on realish data' do
    file = File.join(File.dirname(__FILE__),'data','500.test.454AlignmentInfo.tsv')
    hash = Bio::Newbler::AlignmentInfoFile.contig_hash(file)
    hash['contig00001'].median_coverage.should eq(13.0)
    hash['contig00012'].median_coverage.should eq(10.0)
  end
  
end
