class Initiation
  attr_accessor :name

  def initialize
    print "Hello sir or ma'am, what is your name? "
    @name = gets.chomp.capitalize
    puts "Thanks for playing, #{@name}."
  end

  def place_bet
    initial_purse = 100
    print "Please pace a bet between 1-100 to receive your cards :"
    bet = gets.chomp.to_i
    @purse = initial_purse - bet
  end
end


class Deck
  attr_accessor :shuffled_deck
  def iso_cards
    deck = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack(10)", "Queen(10)", "King(10)", "Ace(1 or 11)"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    @shuffled_deck = (deck.product(suits)*5).shuffle
  end
end


class Hand
  # attr_accessor :first_card, :second_card, :player_hand

  def initialize (shuffled_deck)
    @deck = shuffled_deck
  end

  def hand
    @player_hand = []
    @dealer_hand = []

    2.times do
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end

    @first_card = @player_hand[0]
    @second_card = @player_hand[1]
    @dealers_first_card = @dealer_hand[0]
    @dealers_second_card = @dealer_hand[1]

    puts "First Card = #{@first_card[0]} of #{@first_card[1]}"
    puts "Second Card =  #{@second_card[0]} of #{@second_card[1]}"
    puts "The Dealer's card that's showing is a(n) #{@dealers_first_card[0]} of #{@dealers_first_card[1]}"
  end

  def player_action
    print "Select 'H' to hit or 'S' to stand :"
    decision = gets.chomp.upcase

    if decision == "H"
      @player_hand << @deck.pop
      third_card = @player_hand[2]
      puts "Third Card = #{third_card[0]} of #{third_card[1]}"
      puts "Your card value is :#{calculate_total(@player_hand)}"
    elsif decision == "S"
      puts "You have decided to stand. Your current total is : #{calculate_total(@player_hand)}"
    end

    if calculate_total(@player_hand) == 21
      puts "Congratulations, you have blackjack!"
    elsif calculate_total(@player_hand) > 21
      puts "You have busted. You lose."
      puts "Dealer's total: #{calculate_total(@dealer_hand)}"
      exit
    elsif decision !="S"
      print "Select 'H' to hit or 'S' to stand :"
      decision_two = gets.chomp.upcase
      if decision_two == "H"
        @player_hand << @deck.pop
        fourth_card = @player_hand[3]
        puts "Fourth Card = #{fourth_card[0]} of #{fourth_card[1]}"
        puts "Your card value is : #{calculate_total(@player_hand)}"
        if calculate_total(@player_hand) > 21
          puts "You have busted. You lose"
          puts "Dealer's total: #{calculate_total(@dealer_hand)}"
          exit
        end
        if calculate_total(@player_hand) < 21
          print "Select 'H' to hit or 'S' to stand :"
          decision_three = gets.chomp.upcase
          if decision_three == "H"
            @player_hand << @deck.pop
            fifth_card = @player_hand[4]
            puts "Fifth Card = #{fifth_card[0]} of #{fifth_card[1]}"
            puts "Your card value is : #{calculate_total(@player_hand)}"
            if calculate_total(@player_hand) > 21
              puts "You have busted. You lose."
              puts "Dealer's total: #{calculate_total(@dealer_hand)}"
              exit
            end
          end
        end
      elsif decision_two == "S"
        puts "You have decided to stand. Your current total is #{calculate_total(@player_hand)}"
      end
    end
  end


  def dealer_action

    player_total = calculate_total(@player_hand)

    if calculate_total(@dealer_hand) < 17
      @dealer_hand << @deck.pop
      @new_total = calculate_total(@dealer_hand)
    elsif
      calculate_total(@dealer_hand) >= 17
      @new_total = calculate_total(@dealer_hand)
    end

    if @new_total > player_total
      puts "Dealer's total: #{@new_total}"
      puts "You lose!"
    elsif
      @new_total < player_total
      puts "Dealer's total: #{@new_total}"
      puts "Congratulations, you win!"
    elsif
      @new_total == player_total
      puts "Dealer's total: #{@new_total}"
      puts "You lose, tie goes to the house!"
    end
  end

  def calculate_total (hand)
    total = 0

    #Give face cards a value
    hand.collect {|ind| ind[0]}.each do |element|
      if element == "Jack(10)" || element == "Queen(10)" || element == "King(10)"
        total = total + 10
      elsif element == "Ace(1 or 11)"
        total = total + 11
      else
        total = total + element
      end
    end

    #Defines when an Ace = 1 or when an Ace = 11
    hand.collect {|ind| ind[0]}.each do |element|
      if total > 21 && element == "Ace(1 or 11)"
        total = total - 10
      end
      return total
    end
  end

  def continue
    print "New game (y/n)?"
    new_game = gets.chomp.downcase
    if new_game == 'y'
      shuffled_deck = Deck.new.iso_cards
      hand_obj = Hand.new(shuffled_deck)
      hand_obj.hand
      hand_obj.player_action
      hand_obj.dealer_action
      self.continue
    end
    puts "Bon Voyage"
    exit
  end
end

class Run_Game
  initial = Initiation.new
  initial.place_bet
  shuffled_deck = Deck.new.iso_cards
  hand_obj = Hand.new(shuffled_deck)
  hand_obj.hand
  hand_obj.player_action
  hand_obj.dealer_action
  hand_obj.continue
end


Run_Game.new
