require 'spec_helper'

module GemOfLegend 
  describe Champion do
    context "remote champions" do
      class FakeClient
        def fetch(url)
          {"champions" => 
           [{"id"=>266, "active"=>true, "botEnabled"=>false, "freeToPlay"=>false, "botMmEnabled"=>false, "rankedPlayEnabled"=>true},
            {"id"=>103, "active"=>true, "botEnabled"=>false, "freeToPlay"=>false, "botMmEnabled"=>false, "rankedPlayEnabled"=>true},
            {"id"=>84, "active"=>true, "botEnabled"=>false, "freeToPlay"=>false, "botMmEnabled"=>false, "rankedPlayEnabled"=>true},
            {"id"=>12, "active"=>true, "botEnabled"=>true, "freeToPlay"=>false, "botMmEnabled"=>true, "rankedPlayEnabled"=>true},
            {"id"=>32, "active"=>true, "botEnabled"=>true, "freeToPlay"=>false, "botMmEnabled"=>true, "rankedPlayEnabled"=>true}]
          }
        end

        def endpoint
          "http://example.com"
        end

        def query_params
          "api_key=MY_KEY"
        end
      end

      it "returns a list of champions" do
        client = FakeClient.new
        champions = described_class.all(client: client)
        expect(champions.first).to be_a Champion
      end

      it "knows its full resource name" do
        client = FakeClient.new
        expect(described_class.resource_url(client: client)).to eq('http://example.com/champion?api_key=MY_KEY')
      end
    end

    context "wrapping individual champions" do
      it "converts properties to snake case" do
        data = {"id"=>103, "active"=>true, "botEnabled"=>false, "freeToPlay"=>false, "botMmEnabled"=>false, "rankedPlayEnabled"=>true}
        champion = Champion.new(data)
        expect(champion.id).to eq 103
        expect(champion.active).to be_truthy
        expect(champion.bot_enabled).to be_falsy
        expect(champion.free_to_play).to be_falsy
        expect(champion.bot_mm_enabled).to be_falsy
        expect(champion.ranked_play_enabled).to be_truthy
      end
    end
  end
end

