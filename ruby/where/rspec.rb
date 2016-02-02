require "rspec"
require_relative "where"
include Where
describe Where do
  before(:all) do
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  describe "#where" do

    it "returns an array of results with an exact match" do
      expect(@fixtures.where(:name => "The Wolf")).to eq([@wolf])
    end

    it "returns an array of results with a partial match" do
      expect(@fixtures.where(:title => /^B.*/)).to eq([@charles, @glen])
    end

    it "returns an array of results where there are multiple exact matches" do
      expect(@fixtures.where(:rank => 4)).to eq([@boris, @wolf])
    end

    it "returns an array of results when passed multiple critera" do
      expect(@fixtures.where(:rank => 4, :quote => /get/)).to eq([@wolf])
    end

    it "returns an array of results when chained" do
      expect(@fixtures.where(:quote => /if/i).where(:rank => 3))
    end

  end
end