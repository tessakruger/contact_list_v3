require 'pg'
require_relative 'contact_2'

puts PG.inspect


# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList < ActiveRecord::Base

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  puts "Here is a list of available commands:"
  puts "new - Create a new contact"
  puts "list - List all contacts"
  puts "show - Show a contact"
  puts "search - Search contacts"
  puts "delete - Delete a contact"
  puts "sync - Sync CSV"

  user_choice = gets.chomp

  case user_choice
  when "new"
    puts "What is your Full Name?"
    name = gets.chomp
    puts "What is your email address?"
    email = gets.chomp
    Contact.save(name, email)

  when "list"
    puts Contact.all()

  when "show"
    puts "Please enter an ID number to find a contact:"
    id = gets.chomp.to_i
    puts Contact.find(id)

  when "search"
    puts "Please enter a first name, last name or email"
    term = gets.chomp.to_s
    puts Contact.search(term)

  when "delete"
    puts "Enter Contact ID"
    term = gets.chomp.to_i
    Contact.delete(term)

  when "sync"
    Contact.sync_csv
  end

end
