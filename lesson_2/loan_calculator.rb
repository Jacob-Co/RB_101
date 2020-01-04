def valid_number?(num)
  num.to_f != 0 || num.start_with?('0')
end

puts "Welcome the loan calculator!"
puts "Let me help you calcualte your monthly payment!"

loop do
  puts "> What is your loan amount?"

  loan_amount = ''
  loop do
    loan_amount = gets.chomp
    if valid_number?(loan_amount)
      break
    else puts "> Please input a valid number"
    end
  end

  puts "> What is your Annual Percentage Rate? Please include % at the end!"

  annual_percentage_rate = ''
  loop do
    annual_percentage_rate = gets.chomp
    if annual_percentage_rate[-1] == '%' &&
       valid_number?(annual_percentage_rate)
      annual_percentage_rate.delete!('%')
      break
    else
      puts "> Please input a valid number with a % at the end"
    end
  end

  monthly_interest_rate = annual_percentage_rate.to_f / 12 / 100

  puts "> What is your loan duration in months?"

  loan_duration_months = ''
  loop do
    loan_duration_months = gets.chomp
    if valid_number?(loan_duration_months)
      break
    else
      puts "> Please input a valid number"
    end
  end

  puts "  With a loan amount of: #{loan_amount}"
  puts "  and an annual percentage rate of: #{annual_percentage_rate}"
  puts "  and a loan duration of: #{loan_duration_months} months"
  puts "Your monthly payment is... "

  monthly_payment = loan_amount.to_f *
                    (monthly_interest_rate / (1 -
                    (1 + monthly_interest_rate)**(-loan_duration_months.to_f)))

  puts monthly_payment

  puts '> Do you want to do another calculation?'
  puts '> Y for more'
  repeat = gets.chomp
  break puts 'Thank you' if repeat.downcase != 'y'
end
