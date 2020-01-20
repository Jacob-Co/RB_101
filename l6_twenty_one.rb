# methods
def prompt(string)
  puts "=> #{string}"
end

def deal_card(dck, hnd)
  hnd << dck.delete_at(rand(dck.length))
end

def hand_value(hnd) 
  ace_count = hnd.select {|card| card == 'ace'}.size
  face_card_value = hnd.select {|card| (card.is_a? String) && card != 'ace'}.size * 10
  reg_card_value = hnd.select{ |card| card.is_a? Integer}.inject(:+)
  total = reg_card_value + face_card_value + ace_count
  
  if total < 12 && ace_count > 0
    total += 10
  end

  total
end

def bust?(hnd_val)
  hnd_val > 21
end

# methods end

card_types = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'jack', 'queen', 'king', 'ace']
special_face_values = {'jack' => 10, 'queen' => 10, 'king' => 10, 'ace' => [1, 11]}
deck = card_types * 4
player_hand = []
dealer_hand = []

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