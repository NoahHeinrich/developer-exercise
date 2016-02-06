require_relative "player_dealer"
require_relative "blackjack"

describe Card do
  before(:each) do
    @card = Card.new(:hearts, :ten, 10)
  end
  describe "#new" do
    it "is a card with a valid suite" do
      expect(@card.suite).to be :hearts
    end

    it "is a card with a valid name" do
      expect(@card.name).to be :ten
    end

    it "is a card with a valid value" do
      expect(@card.value).to eq 10
    end
  end
end

describe Deck do
  before(:each) do
    @deck = Deck.new
  end

  describe "#new" do
    it "is a deck of 52 cards" do
      expect(@deck.playable_cards.size).to eq 52
    end
  end

  describe "#deal_card" do
    it "removes a dealt card from the deck" do
      card = @deck.deal_card
      expect(@deck.playable_cards.include?(card)).to be false
    end
  end

  describe "#shuffle" do
    it "has 52 cards after shuffling" do
      @deck.shuffle
        expect(@deck.playable_cards.size).to eq 52
    end
  end
end

describe Hand do
  before(:each) do
    @hand = Hand.new
    @card1 = Card.new(:hearts, :ten, 10)
    @card2 = Card.new(:spades, :four, 4)
    @hand.cards << @card1
    @hand.cards << @card2
  end

  describe "#new" do
    it "has an array of cards" do
      expect(@hand.cards).to be_a Array
    end
  end

  describe "#total_value" do
    it "returns the total value of the hand" do
      expect(@hand.total_value).to eq 14
    end
  end

end

describe Player do
  before(:each) do
    @player = Player.new
  end

  describe "#new" do
    it "has a hand with 2 cards" do
      expect(@player.hand.cards.size).to eq 2
    end
    it "has a hand of Card objects" do
      expect(@player.hand.cards[0]).to be_a Card
    end
  end

  describe "#evaluate_hand" do
    it "returns blackjack if hand is 21" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      @player.hand.cards = [card1, card2]
      expect(@player.evaluate_hand).to be true
    end

    it "returns bust if hand exceeds 21" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ten, 10)
      card3 = Card.new(:spades, :five, 5)
      @player.hand.cards = [card1, card2, card3]
      expect(@player.evaluate_hand).to be false
    end
  end

  describe "#hit" do
    it "adds a card to the player's hand" do
      @player.hit
      expect(@player.hand.cards.size).to be 3
    end
  end
end

describe Dealer do
  before(:each) do
    @dealer = Dealer.new
  end

  describe "#get_action" do
    it "hits if card total is less than 17" do
      card1 = Card.new(:spades, :ten, 10)
      card2 = Card.new(:spades, :five, 5)
      expect(@dealer).to receive(:hit)
      @dealer.hand.cards = [card1, card2]
      @dealer.get_action
    end

    it "stays if card total is greater than or equal 17" do
      card1 = Card.new(:spades, :ten, 10)
      card2 = Card.new(:spades, :five, 7)
      expect(@dealer).to receive(:stay)
      @dealer.hand.cards = [card1, card2]
      @dealer.get_action
    end
  end

end

describe Game do
  before(:each) do
    @game = Game.new
  end

  describe "#new" do
    it "should be initialized with a player" do
      expect(@game.player).to be_a Player
    end

    it "should be initialized with a Dealer" do
      expect(@game.dealer).to be_a Dealer
    end
  end

  describe "#judge_game" do
    it "should set player as winner if player has blackjack" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      @game.player.hand.cards = [card1, card2]
      @game.judge_game
      expect(@game.winner).to be @game.player
    end

    it "should mark the game as over" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      @game.player.hand.cards = [card1, card2]
      @game.judge_game
      expect(@game.game_over).to be true
    end

    it "should set player as winner if dealer busts" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ten, 10)
      card3 = Card.new(:spades, :five, 5)
      @game.dealer.hand.cards = [card1, card2, card3]
      @game.judge_game
      expect(@game.winner).to be @game.player
    end

    it "should set dealer as winner if player busts" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ten, 10)
      card3 = Card.new(:spades, :five, 5)
      @game.player.hand.cards = [card1, card2, card3]
      @game.judge_game
      expect(@game.winner).to be @game.dealer
    end

    it "should set dealer as winner if dealer has blackjack" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      @game.dealer.hand.cards = [card1, card2]
      @game.judge_game
      expect(@game.winner).to be @game.dealer
    end
  end

  describe "#compare_hands" do
    it "should set player as winner if player
    s hand exceeds dealers" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      card3 = Card.new(:spades, :queen, 10)
      card4 = Card.new(:spades, :nine, 9)
      @game.player.hand.cards = [card1, card2]
      @game.dealer.hand.cards = [card3, card4]
      @game.compare_hands
      expect(@game.winner).to be @game.player
    end
    it "should set dealer as winner if dealer
    s hand exceeds players" do
      card1 = Card.new(:spades, :jack, 10)
      card2 = Card.new(:spades, :ace, 11)
      card3 = Card.new(:spades, :queen, 10)
      card4 = Card.new(:spades, :nine, 9)
      @game.dealer.hand.cards = [card1, card2]
      @game.player.hand.cards = [card3, card4]
      @game.compare_hands
      expect(@game.winner).to be @game.dealer
    end
  end
end