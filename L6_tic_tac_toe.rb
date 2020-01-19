require 'pry'

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

def immediate_threat_line(brd, marker)
  WINNING_LINES.each do |line|
    threat_level = 0
    free_space = 0
    line.each do |space|
      threat_level += 1 if brd[space] == marker
      free_space += 1 if brd[space].is_a? Integer
      return line if threat_level == 2 && free_space == 1
    end
  end
  false
end

def resolve_immediate_threat(brd, threat_line)
  threat_line.each do |position|
    brd[position] = COMPUTER_MARKER if brd[position].is_a? Integer
  end
end

def computer_places_piece!(brd)
  if immediate_threat_line(brd, COMPUTER_MARKER)
    resolve_immediate_threat(brd, immediate_threat_line(brd, COMPUTER_MARKER))
  elsif immediate_threat_line(brd, PLAYER_MARKER)
    resolve_immediate_threat(brd, immediate_threat_line(brd, PLAYER_MARKER))
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
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

loop do
  board = initialize_board

  loop do
    display_board(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board)
    
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board) || board_full?(board)
    update_score(detect_winner(board), player_score, computer_score)
    display_score(player_score, computer_score)

    prompt "You won this match" if detect_winner(board) == 'player'
    prompt "The computer won this match" if detect_winner(board) == 'computer'
    prompt "It's a tie" if board_full?(board)

    loop do
      prompt 'Press y for the next match'
      answer = gets.chomp
      break if answer == 'y'
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
