require_relative "blackjack"
DECK = Deck.new
class Player
  attr_accessor :hand, :staying

  def initialize
    @hand = Hand.new
    2.times do
      @hand.cards << DECK.deal_card
    end
    @staying = false
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
    @staying = true
  end
end

class Dealer < Player

  def initialize
    super
  end

  def show_hand(game_over = false)
    puts "Dealer's hand:"
    @hand.cards.each do |card|
      unless card == @hand.cards.first
        puts "#{card.name} of #{card.suite}"
      end
    end
    if game_over
      puts "#{hand.total_value}"
    else
      puts "#{hand.total_value - hand.cards[0].value}"
    end
  end

  def evaluate_hand
    if blackjack?
      puts "Blackjack! Dealer wins!"
      true
    elsif bust?
      puts "Dealer busts, you win."
      false
    end

    def get_action
      if @hand.total_value < 17
        hit
      elsif @hand.total_value < 21
        stay
      end
    end
  end

  def hit
    new_card = DECK.deal_card
    puts "Dealer got the #{new_card.name} of #{new_card.suite}"
    @hand.cards << new_card
  end
end

class Game
  attr_accessor :player, :dealer, :game_over, :winner
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @game_over = false
    @winner = nil
    judge_game
  end

  def play
    puts "Dealing you in."
    until @game_over
      @player.show_hand
      @dealer.show_hand
      if @player.staying && @dealer.staying
        compare_hands
        @game_over = true
      elsif @player.staying
        @dealer.get_action
        judge_game
      else
        get_player_action
        judge_game
        @dealer.get_action
        judge_game
      end
    end
    @player.show_hand
    @dealer.show_hand(true)
    if @winner == @player
      puts "You win!"
    elsif @winner == @dealer
      puts "You lose! Better luck next time."
    else
      puts "Come back soon!"
    end
  end

  def get_player_action
    puts "hit, or stay, or quit?"
    player_action = gets.chomp!
    case player_action
      when "hit"
        @player.hit
      when "stay"
        @player.stay
      when "quit"
        @game_over = true
      else
        puts "I don't understand."
        get_player_action
    end
  end

  def judge_game
    if @player.blackjack? || @dealer.bust?
      @winner = @player
      @game_over = true
    elsif @player.bust? || @dealer.blackjack?
      @winner = @dealer
      @game_over = true
    end
  end

  def compare_hands
    if @player.hand.total_value > @dealer.hand.total_value
      @winner = @player
    elsif @player.hand.total_value <= @dealer.hand.total_value
      @winner = @dealer
    end
  end
end
