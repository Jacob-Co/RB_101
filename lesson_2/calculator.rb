require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def message(key, lang)
  MESSAGES[lang][key]
end

LANGUAGE = 'es'
def prompt(key, string = '')
  message = message(key, LANGUAGE)
  puts("=> #{message}#{string}")
end

def valid_number?(number)
  number.to_f != 0 || number.start_with?('0')
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

prompt('welcome')

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt('valid_name')
  else
    break
  end
end

prompt('greetings', name)

loop do # main looop
  user_num1 = ''
  loop do
    prompt('first_number')
    user_num1 = gets.chomp

    if valid_number?(user_num1)
      break
    else
      prompt('not_valid_number')
    end
  end

  user_num2 = ''
  loop do
    prompt('second_number')
    user_num2 = gets.chomp
    if valid_number?(user_num2)
      break
    else
      prompt('not_valid_number')
    end
  end

  prompt('operator_prompt')
  user_operator = ''
  loop do
    user_operator = gets.chomp
    if %w(1 2 3 4).include?(user_operator)
      break
    else
      prompt('op_error_choice')
    end
  end

  user_nums = "#{user_num1} by #{user_num2}..."
  puts "=> #{operation_to_message(user_operator)} #{user_nums}"

  result =
    case user_operator
    when '1'
      user_num1.to_f + user_num2.to_f
    when '2'
      user_num1.to_f - user_num2.to_f
    when '3'
      user_num1.to_f * user_num2.to_f
    when '4'
      user_num1.to_f / user_num2.to_f
    end

  prompt('result', result)

  prompt('use_again')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('thank_you')
