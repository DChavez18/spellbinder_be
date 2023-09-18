require 'rails_helper'

RSpec.describe "add card to deck" do 
  before :each do 
    @user = User.create!(username: 'Buff MagicKarp', email: 'level@gang', password: 'password')
    @deck = @user.decks.create!(name: 'Weak MagicKarp')
    @card = "Black Lotus"
    # @encoded_card_name = URI.encode_www_form_component(@card_name)
  end

  describe "POST /api/v0/decks/:id/add_card" do
    it '  adds a card to a deck' do
      allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: @user.id })
      post api_v0_deck_add_card_path(@deck.id), params: { list: 'main_board', card: @card}
      expect(response).to have_http_status(200)

      returned_card = JSON.parse(response.body, symbolize_names: true)

      expected_result = {
                          cards: {
                            main_board: [[
                              {
                                id: 1,
                                name: "Black Lotus",
                                set_name: "Unlimited Edition",
                                multiverseid: "600",
                                mana_cost: "{0}",
                                converted_mana_cost: 0.0,
                                colors: nil,
                                color_identity: nil,
                                type: "Artifact",
                                types: ["Artifact"],
                                subtypes: nil,
                                rarity: "Rare",
                                set: "2ED",
                                text: "{T}, Sacrifice Black Lotus: Add three mana of any one color.",
                                artist: "Christopher Rush",
                                number: "233",
                                power: nil,
                                toughness: nil,
                                image_url: "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=600&type=card",
                                rulings: nil
                              }
                            ]],
                            side_board: [],
                            maybe_board: []
                          },
                          name: "Weak MagicKarp"
                        }

      expect(returned_card[:cards][:main_board].count).to eq(1)
      expect(returned_card.slice(:cards, :name)).to eq(expected_result)
      expect(returned_card[:cards][:main_board].first.first[:name]).to eq(@card)
    end
  end
  describe "POST /api/v0/decks/:id/add_card" do
    context "when the user is not logged in" do
      it 'returns an error' do
        post api_v0_deck_add_card_path(@deck.id), params: { list: 'main_board', card: @card}
        
        expect(response).to have_http_status(302)
        # expect(error_message[:error]).to eq("You must be logged in or registered to create a deck.")
        # TODO revist this test
      end
    end

    context "when the deck does not exist" do
      it 'returns an error' do
        allow_any_instance_of(ApplicationController).to receive(:session).and_return({ user_id: @user.id })
        # require 'pry'; binding.pry
        post api_v0_deck_add_card_path(-1), params: { list: 'main_board', card: @card}
        
        expect(response).to have_http_status(:not_found)
        returned_response = JSON.parse(response.body, symbolize_names: true)
        expect(returned_response[:error]).to eq("Deck not found")
        # expect(response.body).to include('Deck not found')
      end
    end
  end
end