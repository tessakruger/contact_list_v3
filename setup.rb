require 'pry'
require 'active_record'
require_relative 'lib/contacts'
require_relative 'commands/commands'
require 'rake'
require_relative 'rakefile'

# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contact_list',
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

puts 'Setting up Database (recreating tables) ...'

ActiveRecord::Schema.define do
  drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
  drop_table :phone_number if ActiveRecord::Base.connection.table_exists?(:phone_number)
  create_table :contacts do |table|
    table.column :first_name, :string
    table.column :last_name, :string
    table.column :email, :string
    table.timestamps null: false
  end
  create_table :phone_number do |phone|
    phone.references :contacts
    phone.column :phone, :integer
    phone.timestamps null: false
  end
end

puts 'Setup DONE'

def populate
  require 'faker'

  10.times do
    Contacts.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email
    )
  end
end

# rake
populate