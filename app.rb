#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers =db.execute 'select * from barbers'
end

def barber_exists? db, name
	db.execute('select * from barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !barber_exists? db, barber
			db.execute 'insert into barbers (name) values (?)', [barber]
		end
	end
end

configure do 
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT)'
	db.execute 'CREATE TABLE IF NOT EXISTS "barbers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "name" TEXT)'

		seed_db db, ['Walter White','Jessie Pinkman', 'Gus Fring', 'Jeff']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end
get '/about' do
	erb :about
end
get '/visit' do
	erb :visit
end
get '/contacts' do
	erb :contacts
end
get '/showusers' do
	db = get_db
	@results = db.execute 'select * from users order by id desc'
	erb :showusers
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { 	:username => 'Enter a name',
	 		:phone => 'Enter a phone number',
	 		:datetime => 'Enter a date nad time'}
	hh.each do |key, value|
		if params[key] ==''
			@error = hh[key]
			return erb :visit
		end
	end

	db = get_db
	db.execute 'insert into users (username, phone, datestamp, barber, color) values (?,?,?,?,?)', [@username, @phone, @datetime, @barber, @color]
	
	@title = 'Thank you!'
	@message = "Dear #{@username}, #{@barber} will be waiting for you at #{@datetime}"

	erb :message

end

post '/contacts' do
	@email = params[:email]
	@msg = params[:msg]

	@title = 'Thank you!'
	@message = "The messege has been saved!"
	
	f = File.open "./public/contacts.txt", "a"
	f.write "E-mail: #{@email}, message: #{@msg}!"
	f.close

	erb :message
end