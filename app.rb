require 'rubygems'
require 'sinatra'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	
	barbers.each do |barber|
		if !is_barber_exists? db, barber

			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

before do
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	@barbers = db.execute 'select * from Barbers'
end

configure do
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "username" TEXT,
      "phone" TEXT,
      "datestamp" TEXT,
      "barber" TEXT,
      "color" TEXT
    )'
  db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT
      )'
  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Joker'] 

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

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end


db =  SQLite3::Database.new 'barbershop.db'
db.execute 'insert into Users (username, phone, datestamp, barber, color)
 
values (?, ?, ?, ?, ?)',[@username, @phone, @datetime, @barber, @color]

	erb "<h2>Спасибо, вы записались</h2>"

end


get '/contacts' do
  erb :contacts
end

get '/showusers' do
  db =  SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  @results = db.execute 'select * from Users order by id desc'
  
  erb :showusers
end

