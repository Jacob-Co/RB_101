require 'pry'

PLAYERS = ['player', 'computer']
PLAYER_MARKER = 'P'
COMPUTER_MARKER = 'C'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[2, 5, 8], [1, 4, 7], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = num }
  new_board
end

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You: #{PLAYER_MARKER} Computer: #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts ""
end
# rubocop: enable Metrics/AbcSize

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == num }
end

def joinor(arr_selection, divider = ',', last_divider = 'or')
  if arr_selection == 0
    return ''
  elsif arr_selection.size == 1
    return arr_selection[0]
  elsif arr_selection.size == 2
    return arr_selection.join(" #{last_divider} ")
  else
    arr_selection.join("#{divider }").insert(-2, "#{last_divider} ")
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end

  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(brd, marker)
  WINNING_LINES.each do |line|
    at_risk_square = 0
    number_of_markers = 0
    line.each do |square|
      at_risk_square = square if brd[square].is_a? Integer
      number_of_markers += 1 if brd[square] == marker
    end
    return at_risk_square if number_of_markers == 2 && at_risk_square != 0
  end
  nil
end

def computer_places_piece!(brd)
  if find_at_risk_square(brd, COMPUTER_MARKER)
    square = find_at_risk_square(brd, COMPUTER_MARKER)
  elsif find_at_risk_square(brd, PLAYER_MARKER)
    square = find_at_risk_square(brd, PLAYER_MARKER)
  elsif brd[5] == 5
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    comparator_line = []
    line.each { |num| comparator_line << brd[num] }
    return 'player' if comparator_line == [PLAYER_MARKER, PLAYER_MARKER, PLAYER_MARKER]
    return 'computer' if comparator_line == [COMPUTER_MARKER, COMPUTER_MARKER,
                                  COMPUTER_MARKER]
  end

  nil
end

def update_score(winner, plyr_score, comp_score)
  if winner == 'player'
    plyr_score[0] += 1
  elsif winner == 'computer'
    comp_score[0] += 1
  end
end

def display_score(plyr_score, comp_score)
  prompt "The score is player: #{plyr_score}, computer: #{comp_score}"
end

# Start of Program

player_score = [0]
computer_score = [0]
number_of_games = [0]

loop do
  board = initialize_board
  first_to_play = PLAYERS.sample

  if number_of_games == [0]
    system 'clear'
    prompt "Welcome to Tic Tac Toe best of 5"
    prompt "You will be facing of against the computer"
    prompt "To register your move please type the corresponding number of the square you want to mark"
    prompt "The first move goes to the #{first_to_play}"
    loop do
      prompt "Press y to begin"
      answer = gets.chomp
      break if answer.start_with?('y')
    end
  end

  # game proper
  loop do
    display_board(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end
  # end of game proper

  display_board(board)

  if someone_won?(board) || board_full?(board)
    number_of_games[0] += 1
    update_score(detect_winner(board), player_score, computer_score)
    display_score(player_score, computer_score)

    prompt "You won this match" if detect_winner(board) == 'player'
    prompt "The computer won this match" if detect_winner(board) == 'computer'
    prompt "It's a tie" if board_full?(board)

    loop do
      prompt 'Press y for the next match'
      answer = gets.chomp
      break if answer.start_with?('y')
    end
  end

  if player_score == [5] || computer_score == [5]
    prompt "Congratulations you won!" if player_score == [5]
    prompt "The computer won. Better luck next time" if computer_score == [5]
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
  end
end

prompt 'Thank you for playing, bye!'


