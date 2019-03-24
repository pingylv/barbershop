#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { 	:username => 'Enter a name',
	 		:phone => 'Entera phone number',
	 		:datetime => 'Enter a date nad time'}
	hh.each do |key, value|
		if params[key] ==''
			@error = hh[key]
			return erb :visit
		end
	end

	@title = 'Thank you!'
	@message = "Dear #{@username}, #{@barber} will be waiing for you at #{@datetime}"
	
	f = File.open "./public/users.txt", "a"
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Barber: #{@barber}, Color: #{@color}!"
	f.close

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

