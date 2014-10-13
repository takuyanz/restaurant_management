# coding: utf-8
require "color_text"
require "pstore"

class Restaurant

	def initialize
		@tables = [
			[:a1, :a2, :a3],
			[:b1, :b2, :b3],
			[:c1, :c2, :c3],

			[:d1, :d2, :d3, :d4],
			[:e1, :e2]
		] 
		
		@db = PStore.new("orders")
		@db.transaction do 
			("a".."e").each do |table|
				@db[table] = ""
			end

			@db["sushi"] = 600
			@db["curry"] = 1000
			@db["karaage"] = 300
			@db["ramen"] = 1200
		end

		read_table
		welcome
	end

	def welcome
		puts ""
		puts "\n ----------------------------".neon
		puts " What would you like to do?".green
		puts ""
		show_options

		num = gets.chomp
			
		if (["1","2", "3", "4", "5"]).include? num
			case num 
			when "1"
				puts "\n How many customers? Please type in a number. Type '99' to go back".green
				print " "
				num_cus = gets.chomp.to_i

				if num_cus == 99
					welcome
				else
					find_out_seats(num_cus)
				end
			when "2"
				display_situation
			when "3"
				take_order
			when "4"
				show_orders
			when "5"
				check
			end
		else 
			wrong_input
			show_options
		end
	end

	def check
		puts " Which table? (a,b,c,d,e)"
		puts " Table: "
		table = gets.chomp
			
		if ["a","b","c","d","e"].include? table
			totalprice = 0
				
			puts "\n Orders:"
			@db.transaction do
				@db[table].each do |menu|
					puts " #{menu}: #{@db[menu.downcase]} yen"
					totalprice = totalprice + @db[menu.downcase].to_i
				end
			end
			puts " Total Price: #{totalprice} yen"
				
			puts "\n Has it been paid? (y/n)".red
			yesno = gets.chomp

			if yesno == "y" 
				clean_table(table)
				puts "Thank you".yellow
				welcome
			else
				puts " Call the police, Customers ran away"
			end	
		else
			wrong_input
			check
		end
	end

	def clean_table(table_alpha)
		seats = @table_now.keys.select {|seat| seat.to_s.include? table_alpha}
		seats.each do |seat|
			@table_now[seat.to_sym] = ""
		end
	end

	def take_order
		puts "\n Type in an alphabet of the table (a,b,c,d,e)"
		print " "
		a = gets.chomp

		if ['a','b','c','d','e'].include? a 
			order = []
			end_order = false

			while end_order == false do
				puts "\n Select numbers"
				puts " 1. Sushi"
				puts " 2. Curry"
				puts " 3. Karaage"
				puts " 4. Ramen"
				puts " 9. end"
				puts " Order: "
				input = gets.chomp
				
				if input == "1"
					order << "Sushi"
				elsif input == "2"
					order << "Curry"
				elsif input == "3"
					order << "Karaage"
				elsif input == "4"
					order << "Ramen"
				elsif input == "9" 
					end_order = true
				end
			end
		else
			wrong_input
			take_order
		end

		@db.transaction do
			@db[a] = order
		end
		
		welcome
	end

	def show_orders
		
		@db.transaction do
			('a'..'e').each do |table|
			
				if @db[table].instance_of?(Array)
					print "\n Table #{table}:"
					@db[table].each do |menu|
						print " #{menu} ".purple
					end
				else 
					print "\n Table #{table}: "
					print "No Order"
				end
			end
		end

		welcome
	end

	def show_options
		puts " 1. New Customers"
    puts " 2. Display Situation"
		puts " 3. Take Order"
		puts " 4. Show Orders"
		puts " 5. Check"
		print "\n You are selecting: "
	end

	def read_table	
		@table_now = {
			a1:" ",a2:" ",a3:" ",
			b1:" ",b2:" ",b3:" ",
			c1:" ",c2:" ",c3:" ",
			d1:" ",d2:" ",d3:" ",d4:" ",
			e1:" ",e2:" "
		}
	end

	def find_out_seats(num_cus)
			
		@tables.each do |table|
			if table.length >= num_cus
				if enough_seats(table, num_cus)					
					n = 1
					table.each do |i|
						@table_now[i] = "X"
						inform_seats_available(table, num_cus) if n == num_cus
						n += 1
					end
				end
			end
		end
		inform_no_seats		
	end
	
	def enough_seats(table, num_cus)
		
		table.each do |t|
			if @table_now[t] == "X"
				return false
			end
		end
		return true
	end

	def inform_seats_available(table, num_cus)
		print "\n Take Customers to seats:"
		
		n = 1
		table.each do |t|	
			print "#{t} ".neon	
			welcome if n == num_cus
			
			n += 1
		end
	end
	
	def inform_no_seats
		puts "\n Sorry no seats avaiable".red
		welcome
	end

	def display_situation
		
		puts ""
		puts " = = = = = = = = = = = = = =".yellow
		puts ""
		puts " Table a(3 people): #{@table_now[:a1]}#{@table_now[:a2]}#{@table_now[:a3]}"
		puts " Table b(3 people): #{@table_now[:b1]}#{@table_now[:b2]}#{@table_now[:b3]}"
		puts " Table c(3 people): #{@table_now[:c1]}#{@table_now[:c2]}#{@table_now[:c3]}"
		puts " Table d(4 people): #{@table_now[:d1]}#{@table_now[:d2]}#{@table_now[:d3]}#{@table_now[:d4]}"
		puts " Table e(2 people): #{@table_now[:e1]}#{@table_now[:e2]}"
		puts ""
		puts " = = = = = = = = = = = = = =".yellow
	
		welcome
	end

	def wrong_input
		puts ""
		puts " Error: wrong input".red
		puts ""
	end

end

#execute!
Restaurant.new
