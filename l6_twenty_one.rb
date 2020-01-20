DEALER = 'dealer'
PLAYER = 'player'
CARD_TYPES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
CARD_SUITES = [] #fix

# methods
def prompt(string)
  puts "=> #{string}"
end

def join_and(arr)
  if arr.size == 2
    arr.join(' and ')
  else
    arr[0..-2].join(', ') + ", and #{arr[-1]}"
  end
end

def deal_card(dck, hnd)
  hnd << dck.delete_at(rand(dck.length))
end

def hand_value(hnd) 
  ace_count = hnd.select {|card| card == 'Ace'}.size
  face_card_value = hnd.select {|card| (card.is_a? String) && card != 'Ace'}.size * 10
  reg_card_value = hnd.select{ |card| card.is_a? Integer}.inject(:+)
  reg_card_value = 0 if reg_card_value.nil?
  total = reg_card_value + face_card_value + ace_count
  
  if total < 12 && ace_count > 0
    total += 10
  end

  total
end

def bust?(hnd_val)
  hnd_val > 21
end

def chicken_dinner?(hnd_val)
  hnd_val == 21
end

def hand_value_outcome(hnd_val)
  prompt "Chicken dinner!" if chicken_dinner?(hnd_val)
  prompt "Bust!" if bust?(hnd_val)
end

def display_hand(hnd, per, priv = 'hiden')
  prompt "You have : #{join_and(hnd)}"if per == 'player'

  if per == 'dealer' && priv == 'hiden'
    prompt "Dealer has: #{hnd[0]} and unknown card"
  elsif per == 'dealer' && priv == 'reveal'
    prompt "Dealer has: #{join_and(hnd)}"
  end
end

def display_hand_value(hnd_val, per)
  prompt "You current hand value is #{hnd_val}" if per == 'player'
  prompt "The dealer's current hand value is #{hnd_val}" if per == 'dealer'
end
# methods end

# Game proper
loop do

  deck = CARD_TYPES * 4 #fix
  player_hand = []
  dealer_hand = []

  system 'clear'
  prompt "Welcome to the Black Jack Table"
  prompt "Type y when ready!"
  loop do
    answer = gets.chomp
    break if answer.start_with?('y')
    prompt "Type y to begin"
  end

  2.times do
    deal_card(deck, dealer_hand)
    deal_card(deck, player_hand)
  end

  system 'clear'
  display_hand(dealer_hand, DEALER)
  display_hand(player_hand, PLAYER)
  display_hand_value(hand_value(player_hand), PLAYER)
  hand_value_outcome(hand_value(player_hand))
  sleep 1
  break if bust?(hand_value(player_hand)) || chicken_dinner?(hand_value(player_hand))

  loop do
    prompt "Do you want to hit or stay? (h/s)"
    answer = gets.chomp
    if answer.start_with?('s')
      break
    else
      system 'clear'
      deal_card(deck, player_hand)
      display_hand(dealer_hand, DEALER)
      display_hand(player_hand, PLAYER)
      display_hand_value(hand_value(player_hand), PLAYER)
      hand_value_outcome(hand_value(player_hand))
      break sleep 1 if bust?(hand_value(player_hand)) || chicken_dinner?(hand_value(player_hand))
    end
  end

  if bust?(hand_value(player_hand))
    prompt "Dealer wins"
    prompt 'Play again? (y/n)'
    answer = gets.chomp.downcase
    if !answer.start_with?('y') && !answer.start_with?('n')
      loop do
        prompt "Please Type either y or n"
        answer = gets.chomp.downcase
        break if answer.start_with?('y')
      end
    end
    break if answer.start_with?('n')
    next if answer.start_with?('y')
  end
    

  system 'clear'
  prompt "Dealer's turn to play"
  display_hand(dealer_hand, DEALER, 'reveal')
  display_hand_value(hand_value(dealer_hand), DEALER)
  if hand_value(dealer_hand) < 17
    loop do 
      prompt 'Delear hits'
      deal_card(deck, dealer_hand)
      sleep 0.9
      display_hand(dealer_hand, DEALER, 'reveal')
      display_hand_value(hand_value(dealer_hand), DEALER)
      hand_value_outcome(hand_value(dealer_hand))
      break sleep 1 if bust?(hand_value(dealer_hand)) || hand_value(dealer_hand) >= 17
    end
  end

  if bust?(hand_value(dealer_hand))
    prompt "You win!"
    prompt 'Play again? (y/n)'
    answer = gets.chomp.downcase
    if !answer.start_with?('y') && !answer.start_with?('n')
      loop do
        prompt "Please Type either y or n"
        answer = gets.chomp.downcase
        break if answer.start_with?('y')
      end
    end
    break if answer.start_with?('n')
    next if answer.start_with?('y')
  end

  system 'clear'
  display_hand(dealer_hand, DEALER, 'reveal')
  display_hand_value(hand_value(dealer_hand), DEALER)
  display_hand(player_hand, PLAYER)
  display_hand_value(hand_value(player_hand), PLAYER)
  prompt "Comparing your scores..."
  sleep 2
  prompt hand_value(player_hand) > hand_value(dealer_hand)? 
  "You win! Congratulations" : "Dealer wins, better luck next time"

  prompt 'Play again? (y/n)'
  answer = gets.chomp.downcase
  if !answer.start_with?('y') && !answer.start_with?('n')
    loop do
      prompt "Please Type either y or n"
      answer = gets.chomp.downcase
      break if answer.start_with?('y')
    end
  end
  break if answer.start_with?('n')
      
end

#Game proper end

=begin
Game_flow
1. Deal two cards to the player and the dealer
  - one card of the dealer will be seen
  - you can view both your cards
2. You can decide to hit or stay
  - if you stay your turn is over
  - if you hit you will be dealt an additional card
    - if your cards summed face value exceeds 21 you bust
    - you may continue hitting so long as you don't exceed 21
3. the dealer will no reveal their 2nd card 
  - if the value is 17 or more the dealer's turn is over
  - if the value is less than 16 the dealer must hit until thier total is 17 or above
  - if in the process of reaching 17 or higher the dealer busts, the player wins if the player did not bust
4. if neither the player or dealer has busted, compare who has highest face value summed cards 
   and declare them the winner
*5. shuffle the deck
6. ask if the player would like to play again 

Pseudo code
1. Define method deal card which accepts dck and hnd as its parameters
    - randomly select a card from the dck and place it in hnd
2. 
=end