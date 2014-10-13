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
			
		if (["1","2", "3", "4"]).include? num
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
			end
		else 
			wrong_input
			show_options
		end
	end
	
	def take_order
		puts "\n Type in an alphabet of the table (a,b,c,d,e)"
		print " "
		a = gets.chomp

		if ['a','b','c','d','e'].include? a 
			order = ""
			end_order = false

			while end_order == false do
				puts "\n Select numbers"
				puts " 1. Sushi"
				puts " 2. Curry"
				puts " 3. Karaage"
				puts " 4. Ramen"
				puts " 9. end"
			
				input = gets.chomp

				if input == "1"
					order = order + "Sushi "
				elsif input == "2"
					order = order + "Curry "
				elsif input == "3"
					order = order + "Karaage "
				elsif input == "4"
					order = order + "Ramen "
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
			('a'..'e').each do |table_alpha|
				order = 
					if @db[table_alpha] 
						@db[table_alpha]
					else 
						"No Order"
					end

				puts " Table #{table_alpha}: " + order.purple
			end
		end

		welcome
	end

	def show_options
		puts " 1. New Customers"
    puts " 2. Display Situation"
		puts " 3. Take Order"
		puts " 4. Show Orders"
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
			print "#{t} "	
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
