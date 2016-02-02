require_relative "blackjack"
deck = @Deck.new
class Player
  attr_reader :hand

  def initialize
    @hand = Hand.new
    2.times do
      @hand.cards << deck.deal_card
    end
    evaluate_hand
  end

  def evaluate_hand
    if blackjack?
  end

  def blackjack?
    if @hand.total_value == 21
      true
    end
  end

  def bust?
    if @hand.total_value > 21
      puts "#{hand.total_value}, you lose."
      return true
    end
  end

  def hit_me
    @hand.cards << deck.deal_card
  end
end

class Dealer
  attr_reader :hand

  def initialize
    @hand = Hand.new
  end
end