require 'spec_helper'
require 'vcr_helper'

module GemOfLegend
  describe Client do
    let (:client) { described_class.new(region: 'na') }

    context "without setting an api key" do
      it "raises error if LOL_API_Key isn't set" do
        stub_const('ENV', {})
        expect do
          described_class.new(region: 'na')
        end.to raise_error("Set LOL_API_KEY environment variable")
      end
    end

    context "setting regions and api_key" do
      it "is successfully instantiated with valid regions" do
        valid_regions = ["br", "eune", "euw", "kr", "lan", "las", "na", "oce", "ru", "tr", "pbe"]
        valid_regions.each do |region|
          expect do
            described_class.new(region: region)
          end.to_not raise_error
        end
      end

      it "throws an error if an invalid region is given" do
        expect do
          described_class.new(region: 'mars')
        end.to raise_error(GemOfLegend::InvalidRegion)
      end

      it "knows its region" do
        expect(client.region).to eq('na')
      end

      it "reads the API key from an environment variable" do
        allow(ENV).to receive(:fetch).with('LOL_API_KEY').and_return("My Key")
        client = described_class.new(region: 'na')
        expect(client.api_key).to eq('My Key')
      end
    end

    context "Champions" do
      it "returns all of the champions" do
        champions = nil
        VCR.use_cassette('champions') do
          champions = client.champions
        end
        expect(champions.first).to be_a Champion
      end

      it "finds a champion by id" do
        champion = nil
        VCR.use_cassette('champion') do
          champion = client.champion(id: 103)
        end
        expect(champion).to be_a Champion
      end

      it "returns an error when given a champion with an invalid" do
        champion = nil

        VCR.use_cassette('invalid_champion') do
          champion = client.champion(id: 90000)
        end
        actual = {"errors" => {"code" => "404", "status" => "Champion not found."}}
        expect(champion).to eql({"errors" => {"code" => "404", "status" => "Champion not found."}})
      end
    end
  end
end
