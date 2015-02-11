module GemOfLegend
  class InvalidRegion < StandardError; end
  class Client
    REGIONS = ["br", "eune", "euw", "kr", "lan", "las", "na", "oce", "ru", "tr", "pbe"]
    API_VERSION = "v1.2"
    URL_BASE = "api.pvp.net/api/lol"

    attr_reader :region, :api_key
    def initialize(region:)
      raise InvalidRegion unless REGIONS.include?(region)
      @api_key = ENV.fetch('LOL_API_KEY') { raise "Set LOL_API_KEY environment variable" }
      @region = region
    end

    def champions
      Champion.all(client: self)
    end

    def champion(id:)
      Champion.find(client: self, id: id)
    end

    def endpoint
      ["https://#{region}.#{URL_BASE}", region, API_VERSION].join("/")
    end

    def fetch(url)
      HTTParty.get(url)
    end

    def query_params
      "api_key=#{api_key}"
    end
  end
end
