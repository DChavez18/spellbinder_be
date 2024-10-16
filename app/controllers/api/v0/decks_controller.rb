class Api::V0::DecksController < ApplicationController
  before_action :logged_in?
    before_action :set_deck, only: [:show, :update, :destroy]

  def create
    user = User.find_by(id: session[:user_id])

    deck = user.decks.build(deck_params)
    if deck.save
      render json: deck, status: :created
    else
      render json: deck.errors, status: :unprocessable_entity
    end
  end

  def update
    if @deck.update(deck_params)
      render json: @deck, status: :ok
    else
      render json: { error: "Invalid" }, status: 302
    end
  end

  def destroy
    # deck = Deck.find(params[:id])
    @deck.destroy
    head :no_content
  end

  def index
    user = User.find_by(id: session[:user_id])
    decks = User.user_decks(user.id)
    render json: decks, status: :ok, content_type: 'application/json'
  end

  def show
    # begin
      # deck = Deck.find(params[:id])
      user = User.find_by(id: session[:user_id])
      deck = Deck.find_by(id: params[:id])
      show_deck = user.user_show_deck(user.id, deck.id)
      render json: show_deck, status: :ok, content_type: 'application/json'
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Deck not found"}, status: :not_found, content_type: 'application/json'
    # end
  end

  def add_card
    # begin
      deck = Deck.find(params[:deck_id])
      facade = DeckFacade.new(deck)

      facade.add_card(params[:list], params[:card])
      render json: deck, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Deck not found" }, status: :not_found
    # end
  end

  # def remove_card
  #   begin
  #     deck = Deck.find(params[:deck_id])
  #     deck.remove_card(params[:list], params[:card])
  #     deck.save
  #     render json: deck, status: :ok
  #   rescue ActiveRecord::RecordNotFound
  #     render json: { error: "Deck not found" }, status: :not_found
  #   end
  # end

  # def remove_card
  #   deck = Deck.find_by(id: params[:deck_id])
  #   if deck.cards[params[:list]].first.flatten.any? { |hash| hash['name'] == params[:card] }
  #     deck.remove_card(params[:list], params[:card])
  #     deck.save
  #     render json: deck, status: :ok
  #   else
  #     render json: { error: "Deck/card not found" }, status: :not_found
  #   end
  # end

  def remove_card
    deck = Deck.find_by(id: params[:deck_id])
    if deck
      if deck. cards && deck.cards[params[:list]]
        if deck.cards[params[:list]].first.flatten.any? { |hash| hash['name'] == params[:card] }
          deck.remove_card(params[:list], params[:card])
          deck.save
          render json: deck, status: :ok
        else
          render json: { error: "Deck/card/list not found" }, status: :not_found
        end
      else
        render json: { error: "Deck/card/list not found" }, status: :not_found
      end
    else
      render json: { error: "Deck/card/list not found" }, status: :not_found
    end
  end

  private

  def set_deck
    # begin
    @deck = Deck.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Deck not found" }, status: :not_found
    # end
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
  # def index
  #   facade = DeckFacade.new
  #   decks = facade.receive_decks
  #   render json: DeckSerializer.new(decks)
  # end
end