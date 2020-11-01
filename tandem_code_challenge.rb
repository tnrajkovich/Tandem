#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'tty-prompt'

# First, the question bank is created by parsing the json file.
json = File.read('Apprentice_TandemFor400_Data.json')
question_bank = JSON.parse(json)

#The contestant can enter their name for a custom congratulations at the end if they perform well.
puts "Welcome to Tandem Trivia! Please enter your name below to begin:"
name = gets.chomp
system("clear")

#This loop sets up for a response later that will allow the user to keep playing or exit the application after completion of a full round.
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
  #Question count is used to keep track of our loop below, not allowing it to exceed 10 questions.
  question_count = 0
  #The score resets to 0 at the beginning of each round
  score = 0
  num = question_bank.length - 1
  #The no_dup_questions variable is to ensure we get a random, non-repeating series of questions in each round of the game.
  no_dup_questions = (0..num).to_a.shuffle

  prompt = TTY::Prompt.new

  while question_count < 10
    # i is the index that is pulled from our random question number array for reference in the loop below
    i = no_dup_questions.pop
    # j is the index for the incorrect answers array for each question
    j = 0
    # rand_answer is an array that ensures we don't get the same order of answers for the questions (if you play multiple rounds, they will likely come out in a different order to keep it interesting)
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
    sleep(0.75) #This was a decision made to clear the question after some time allowed for the user to see if they got the answer correct before clearing the terminal screen.
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