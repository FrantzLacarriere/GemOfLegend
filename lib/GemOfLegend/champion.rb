require 'ostruct'
module GemOfLegend
  class Champion
    attr_reader :id,
      :active,
      :bot_enabled,
      :free_to_play,
      :bot_mm_enabled,
      :ranked_play_enabled

    RESOURCE = "champion"
    def self.all(client:)
      champions = client.fetch(resource_url(client:client))

      champions["champions"].map { |c| new(c)}
    end

    def self.find(client:, id:, &error_block)
      error_block ||= ->(){}
      champion = client.fetch(resource_url(client:client, id: id))
      if champion.code == 200
        new(champion)
      else
        error_block.call(champion)
        nil
      end
    end

    def self.resource_url(client:, id: nil)
      "#{client.endpoint}/#{resource_endpoint(id:id)}?#{client.query_params}"
    end

    def self.resource_endpoint(id:nil)
      id ? "#{RESOURCE}/#{id}" : "#{RESOURCE}"
    end

    def initialize(options={})
      @bot_mm_enabled = options.fetch("botMmEnabled")
      @id = options.fetch("id")
      @ranked_play_enabled = options.fetch("rankedPlayEnabled")
      @bot_enabled = options.fetch("botEnabled")
      @active = options.fetch("active")
      @free_to_play = options.fetch("freeToPlay")
    end
  end
end
