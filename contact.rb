require 'byebug'
require 'csv'

class Contact

  attr_reader :id
  attr_accessor :name, :email

  def initialize(name, email, id=nil)
    @name = name
    @email = email
    @id = id
  end

  class << self

    def connection
      @@connection ||=PG.connect( dbname: 'contact_2' )
    end

    def all
      contacts = []
      results = connection.exec("SELECT id, name, email FROM contacts;")
      results.each do |row|
        contacts.push(row)
      end
      contacts
    end

    def save(name, email)
      connection.exec("INSERT INTO contacts (name, email) VALUES (\'#{name}\', \'#{email}\');")
      rows = connection.exec("SELECT * FROM contacts WHERE name = '#{name}' AND email = '#{email}'")
      rows = rows.values
      puts "\n New Contact Created: \t Id: #{rows[-1][0]} \t Name: #{rows[-1][1]} \t Email: #{rows[-1][2]} \n"
    end


    def find(id)
      puts "\n"
      rows = connection.exec("SELECT * FROM contacts WHERE id = #{id};")
      if rows.values != [] && (id != 0)
        puts "ID: #{rows[0]['id']} \t Name: #{rows[0]['name']} \t Email: #{rows[0]['email']}"
        return true
      else
        puts "Contact ID invalid."
        return false
      end
      puts "\n"
    end

    def search(term)
      term_found = false
      puts "\n"
      query = connection.exec("SELECT * FROM contacts;")
      query.each do |row|
        if row['name'].match(/.*#{term}.*/) || row['email'].match(/.*#{term}.*/)
          puts "ID: #{row['id']} \t Name: #{row['name']} \t Email: #{row['email']}"
          term_found = true
        end
      end
      puts "No matches in the database..." if term_found == false
      puts "\n"
    end

    def delete(id)
      if find(id)
        puts "\n"
        puts "Are you sure you want to delete this contact? (Y/N)"
        confirmation = gets.chomp
        if confirmation == "Y"
          connection.exec("DELETE FROM contacts WHERE id = #{id};")
          puts "Contact deleted..."
        end
        puts "\n"
      end
    end

    def sync_csv
      query = connection.exec("SELECT * FROM contacts;")
      CSV.open('contact_list.csv', 'wb') do |csv|
        query.each do |row|
          csv << [row['name'], row['email']]
        end
      end
      puts "contacts synced"
    end
  end
end

# def create(name, email)
#   contacts = []
#   results = connection.exec("INSERT INTO contacts(name, email) id, name, email FROM contacts;")
#   results.each do |row|
#     contact = Contact.new(
#       row['id'],
#       row['name'],
#     row['email'])
#     contacts.push(contact)
#   end
#   contacts
# end

#   def find(id)
#     i = 0
#     listing = ''
#     CSV.foreach("contacts.csv") do |line|
#       i += 1
#       if id == i
#         return line
#       end
#     end
#     if listing == ''
#       listing = "No user found."
#     end
#     listing
#   end

#   def search(term)
#     listing = ''
#     CSV.foreach("contacts.csv") do |row|
#       line = "#{row[0]}, (#{row[1]})"
#       if line.downcase.match (/.*#{term.downcase}.*/)
#         listing << "\n#{row[0]}, (#{row[1]})"
#       end
#     end
#     if listing == ''
#       listing = "No user found."
#     end
#     listing
#   end
