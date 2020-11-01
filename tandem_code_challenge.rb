#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'tty-prompt'

json = File.read('Apprentice_TandemFor400_Data.json')
question_bank = JSON.parse(json)

puts "Welcome to Tandem Trivia! Please enter your name below to begin:"
name = gets.chomp
system("clear")

def play_again?
  loop do
    print "Would you like to play again? Y/N "
    again = gets.chomp.capitalize

    case (again)
    when 'N'
      return false
    when 'Y'
      return true
    else
      puts "Please input y or n to continue or close the program."
    end
  end
end

begin
  question_count = 0
  score = 0
  num = question_bank.length - 1
  no_dup_questions = (0..num).to_a.shuffle

  prompt = TTY::Prompt.new

  while question_count < 10
    i = no_dup_questions.pop
    j = 0
    rand_answer = []
    while j < question_bank[i]["incorrect"].length
      rand_answer << question_bank[i]["incorrect"][j]
      j += 1
    end
    rand_answer << question_bank[i]["correct"]
    rand_answer = rand_answer.shuffle
      answer = prompt.select(question_bank[i]["question"]) do |menu|
        for item in rand_answer
          menu.choice item
        end
      end

      if answer == question_bank[i]["correct"]
        puts "Congratulations, #{question_bank[i]["correct"]} is the correct answer!"
        question_count += 1
        score += 1
      else
        puts "Unfortunately #{question_bank[i]["correct"]} is the correct answer."
        question_count += 1
      end
    sleep(0.75)
    system("clear")
  end

  if score < 7
    puts "Your score was #{score}. It looks like you need some work..."
  elsif score >= 7 && score <= 8
    puts "Good job, your score was #{score}. You could still use some work though."
  else
    puts "Congratulations #{name}! You scored #{score}! You are ready to take on the office and become a trivia champion!"
  end
end while play_again?