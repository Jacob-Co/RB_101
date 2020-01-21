# start of variables
CARD_TYPES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
CARD_SUITES = [' of Clover', ' of Spades', ' of Hearts' , ' of Diamond']
PLAYER = 'player'
DEALER = 'dealer'
# end of varialbe

# start of method
#start of acc methods
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

def dealing_cards
  puts
  print '=> Dealing cards.'
  4.times do
    sleep 0.35
    print '.'
  end
  puts
  puts
end

def loading
  puts
  print '=> .'
  4.times do
    sleep 0.35
    print '.'
  end
  puts
  puts
end

def output_ready_q
  prompt "Type y when ready!"
  loop do
    answer = gets.chomp.downcase
    break if answer.start_with?('y')
    prompt "Type y to begin"
  end
end

def play_again_q
  prompt "Play again? ('y'/'n')"
  loop do
    answer = gets.chomp
    return 'yes' if answer.start_with?('y')
    return 'no' if answer.start_with?('n')
    prompt "Please type either 'y' for yes or 'n' for no"
  end
end
# end of acc methods

# start of main methods
def deal_card(dck, hand_names, hand_values)
  card = dck.delete_at(rand(dck.size))
  hand_names.prepend(card.values[0])
  hand_values.prepend(card.keys[0])
end

def starting_deal(dck, hand_names1, hand_names2, hand_values1, hand_values2)
  2.times do
  deal_card(dck, hand_names1, hand_values1)
  deal_card(dck, hand_names2, hand_values2)
  end
end

def display_hand(hand_names, hand_owner, priv = 'hidden')
  prompt "You have : #{join_and(hand_names)}"if hand_owner == 'player'

  if hand_owner == 'dealer' && priv == 'hidden'
    prompt "Dealer has: #{hand_names[0]} and \"Unknown Card\""
  elsif hand_owner == 'dealer' && priv == 'reveal'
    prompt "Dealer has: #{join_and(hand_names)}"
  end
end

def total_hand_value(hand_values)
  ace_count = hand_values.count('Ace')
  
  face_sum = hand_values.select { |card| (card.is_a? String) && card != 'Ace'}.size * 10
  
  reg_card_sum = hand_values.select{ |card| card.is_a? Integer}.inject(:+)
  reg_card_sum = 0 unless hand_values.any? Integer
  
  total = face_sum + reg_card_sum + ace_count

  total += 10 if total <= 11 && ace_count > 0

  total
end

def bust?(total_sum)
  total_sum > 21
end

def chicken_dinner?(total_sum)
  total_sum == 21
end
  

def show_table(hand_names1, hand_owner1, hand_names2, hand_owner2, priv)
  display_hand(hand_names1, hand_owner1)
  puts
  display_hand(hand_names2, hand_owner2, priv)
  puts
end

def player_hit_or_stay(hand_names1, hand_values1, hand_owner1, dck)
  prompt "Type 'h' to hit"
  prompt "Type 's' to stay"
  loop do
    answer = gets.chomp.downcase
    if answer != 'h' && answer != 's'
      #loading
      prompt "Type either 'h' or 's'"
    elsif answer == 's'
      break
    elsif answer == 'h'
      dealing_cards
      deal_card(dck, hand_names1, hand_values1)
      prompt "You received: #{hand_names1[0]} "
      display_hand(hand_names1, hand_owner1)
      total_sum = total_hand_value(hand_values1)
      loading
      break prompt 'You busted!' if bust?(total_sum)
      break prompt 'Winner, winner, chicken dinner!' if chicken_dinner?(total_sum)
      prompt "Hit again or stay? ('h'/'s')"
    end
  end
end

def dealer_turn(hand_names, hand_owner, hand_values, total_sum, dck)
  total_sum_d = total_sum

  if total_sum_d < 17
    prompt "The dealer's hand is below 17"
    loop do
      dealing_cards
      deal_card(dck, hand_names, hand_values)
      total_sum_d = total_hand_value(hand_values)
      display_hand(hand_names, hand_owner, 'reveal')
      loading
      if total_sum_d >= 17
        break prompt 'The dealer busted' if bust?(total_sum_d)
        break prompt 'The dealer stays'
      end
      prompt "The dealer's hand is still below 17"
    end
  end
  # prompt 'The dealer stays' unless bust?(hand_values)
end

def compare_scores(total_sum_p, total_sum_d)
  if total_sum_p < 22 && total_sum_d < 22
    if total_sum_p > total_sum_d
      return 'player' 
    elsif total_sum_p < total_sum_d
      return 'dealer'
    else total_sum_p == total_sum_d
      'tie'
    end
  end
end

def display_winner(total_sum_p, total_sum_d)
  results = compare_scores(total_sum_p, total_sum_d)
  if bust?(total_sum_p) || results == 'dealer'
    prompt "The dealer wins, better luck next time"
  elsif bust?(total_sum_d) || results == 'player'
    prompt "Congratulations you won!"
  elsif results == 'tie'
    prompt "It's a tie!"
  end
end

def set_deck(dck)
  CARD_SUITES.each do |suite|
    CARD_TYPES.each do |card|
      dck << {card => "\"" + card.to_s + suite + "\""} if card.is_a? Integer
      dck << {card => "\"" +card + suite + "\""} if card.is_a? String
    end
  end
end

#end of main methods
#end of methods

#start of program
system 'clear'
  prompt "Welcome to the Black Jack Table"

loop do
  player_hand_values = []
  player_hand_names = []
  dealer_hand_values = []
  dealer_hand_names = []
  player_total_hand_value = 0
  dealer_total_hand_value = 0
  deck = []
  set_deck(deck)

  output_ready_q

  starting_deal(deck, player_hand_names, dealer_hand_names, 
               player_hand_values, dealer_hand_values)
  player_total_hand_value = total_hand_value(player_hand_values)
  dealer_total_hand_value = total_hand_value(dealer_hand_values)

  dealing_cards
  display_hand(player_hand_names, PLAYER)
  dealing_cards
  display_hand(dealer_hand_names, DEALER)
  loading

  if chicken_dinner?(player_total_hand_value)
    prompt "How lucky, you got a Chicken Dinner on your starting hand!"
    loading
  else
    prompt "Time for your turn"
    output_ready_q

    system 'clear'
    show_table(player_hand_names, PLAYER, dealer_hand_names, DEALER, 'hidden')
    player_hit_or_stay(player_hand_names, player_hand_values, PLAYER, deck)
    player_total_hand_value = total_hand_value(player_hand_values)
  end

  unless bust?(player_total_hand_value)
    prompt "Time for the dealer's turn"
    output_ready_q
  
    system 'clear'
    show_table(player_hand_names, PLAYER, dealer_hand_names, DEALER, 'hidden')
    loading
    dealer_turn(dealer_hand_names, DEALER, dealer_hand_values, dealer_total_hand_value, deck)
    dealer_total_hand_value = total_hand_value(dealer_hand_values)

    loading
    prompt "Time to determine the winner!"
    output_ready_q
  end

  loading
  system 'clear'
  prompt "Calculating the results now"

  unless bust?(player_total_hand_value) || bust?(dealer_total_hand_value)
    loading
    display_hand(player_hand_names, PLAYER)
    display_hand(dealer_hand_names, DEALER, 'reveal')
  end

  loading

  if bust?(player_total_hand_value)
    prompt 'You busted'
  elsif bust?(dealer_total_hand_value)
    prompt 'The dealer busted'
  end

  display_winner(player_total_hand_value, dealer_total_hand_value)

  loading
  break if play_again_q == 'no'
  prompt "Setting up"
  loading
  system 'clear'
end

prompt "Thank you for playing and come again!"
