require_relative "blackjack"
DECK = Deck.new
class Player
  attr_accessor :hand

  def initialize
    @hand = Hand.new
    2.times do
      @hand.cards << DECK.deal_card
    end
    evaluate_hand
  end

  def evaluate_hand
    if blackjack?
      puts "Blackjack! You win!"
      true
    elsif bust?
      puts "Bust, you lose."
      false
    end
  end

  def show_hand
    puts "Your hand:"
    @hand.cards.each do |card|
      puts "#{card.name} of #{card.suite}"
    end
    puts "#{hand.total_value}"
  end

  def blackjack?
    @hand.total_value == 21 ? true : false
  end

  def bust?
    @hand.total_value > 21 ? true : false
  end

  def hit
    new_card = DECK.deal_card
    puts "You got the #{new_card.name} of #{new_card.suite}"
    @hand.cards << new_card
  end

  def stay
    @hand.total_value
  end
end

class Dealer < Player

  def initialize
    super
  end

  def show_hand
    puts "Dealer's hand:"
    @hand.cards.each do |card|
      puts "#{card.name} of #{card.suite}"
    end
    puts "#{hand.total_value}"
  end

  def evaluate_hand
    if blackjack?
      puts "Blackjack! Dealer wins!"
      true
    elsif bust?
      puts "Dealer busts, you win."
      false
    end
  end
end

class Game
  attr_accessor :player, :dealer, :game_over
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    if @player.evaluate_hand || @dealer.evaluate_hand
      @game_over = true
    else
      @game_over = false
    end
  end

  def play
    puts "Dealing you in."
    until @game_over
      @player.show_hand
      @dealer.show_hand
      puts "hit, or stay, or quit?"
      player_action = gets.chomp!
      case player_action
      when "hit"
        @player.hit
        judge_hand(@player)
      when "stay"
        @player.stay
      when "quit"
        @game_over = true
      else
        puts "I don't understand"
        player_action = gets.chomp!
      end
    end
  end


  def judge_hand(player)
    if player.evaluate_hand == true || player.evaluate_hand == false
      @game_over = true
    end
  end
end