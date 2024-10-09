class MagicService

  def self.get_collections
    get_url("/v1/sets")
  end

  def self.get_collection_details(collection_id)
    get_url("/v1/sets/#{collection_id}")
  end

  def self.get_collection_cards(collection_code)
    get_url("/v1/cards?set=#{collection_code}")
  end

  def self.get_card_show(card_id)
    get_url("/v1/cards/#{card_id}")
  end

  def self.get_random_card
    get_url("/v1/cards?random=true&pageSize=1")
  end

  def self.get_card_search(card_name)
    get_url("/v1/cards?name=#{card_name}")
  end

  def self.get_url(url)
    response = conn.get(url)
     JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://api.magicthegathering.io" )
  end
end