def prompt(message)
  puts("=> #{message}")
end

def valid_number?(number)
  number != 0
end

def operation_to_message(op)
  case op
  when '1'
    'adding'
  when '2'
    'subtracting'
  when '3'
    'multiplying'
  when '4'
    'dividing'
  end
end

prompt('Welcome to calculator! Enter you name: ')

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt('Make sure to use a valid name.')
  else
    break
  end
end

prompt("Hello, #{name}")

loop do # main looop
  user_num1 = ''
  loop do
    prompt('Please input the first number: ')
    user_num1 = gets.chomp.to_i

    if valid_number?(user_num1)
      break
    else
      prompt('That is not a valid number')
    end
  end

  user_num2 = ''
  loop do
    prompt('Please input the second number: ')
    user_num2 = gets.chomp.to_i
    if valid_number?(user_num2)
      break
    else
      prompt('That is not a valid number')
    end
  end

  operator_prompt = <<-MSG
  What operation would you like to perform
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG

  prompt(operator_prompt)
  user_operator = ''
  loop do
    user_operator = gets.chomp
    if %w(1 2 3 4).include?(user_operator)
      break
    else
      prompt('Must choose 1, 2, 3, or 4')
    end
  end

  user_nums = "#{user_num1} by #{user_num2}..."
  prompt("#{operation_to_message(user_operator)} " + user_nums)

  result =
    case user_operator
    when '1'
      user_num1 + user_num2
    when '2'
      user_num1 - user_num2
    when '3'
      user_num1 * user_num2
    when '4'
      user_num1.to_f / user_num2.to_f
    end

  prompt("The result is #{result}")

  prompt('Do you want to perform another calculation? (Y to calculate again)')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thank you for using the calculator')
