require_relative '../setup'
require 'csv'

def commands(answer)
  case answer
  when "NEW" || "new"
    puts "To create a new contact, please enter the first name."
    first_name = gets.chomp
    puts "Please enter the last name."
    last_name = gets.chomp
    puts "Email address"
    email = gets.chomp

    new_contact = Contacts.create!(first_name: first_name,
                                   last_name: last_name,
                                   email: email,
                                   )
    puts "----------"
    puts "\n"
    puts "New profile for #{new_contact.first_name} #{new_contact.last_name} has been created"

  when "LIST"
    list = Contacts.all
    list.each do |contacts|
      puts "#{contacts.first_name} #{contacts.last_name}"
    end
  when "SHOW"
    puts "Enter an ID number to find a contact:"
    id = gets.chomp.to_i
    result = Contacts.find(id)
    puts "#{result.first_name} #{result.last_name}"
  when "SEARCH"
    input_matches = false
    puts "Please enter a first name, last name or email"
    input = gets.chomp.to_s
    result = Contacts.where(first_name: input)
    result.each do |find|
      puts "#{find.first_name} #{find.last_name}"
      end
  when "QUIT"
    abort
  end
end

prompt_user = false
puts "Here is a list of available commands:"
while prompt_user == false do
    puts "NEW - Create a new contact"
    puts "LIST - List all contacts"
    puts "SHOW - Show a contact"
    puts "SEARCH - Search contacts"
    puts "QUIT - To exit"
    answer = gets.chomp
    commands(answer)
    puts "\nPlease enter a valid command:"
  end