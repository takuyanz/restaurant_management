# coding: utf-8
require "color_text"

class Restaurant

	def initialize
		@tables = [
			[:a1, :a2, :a3],
			[:b1, :b2, :b3],
			[:c1, :c2, :c3],

			[:d1, :d2, :d3, :d4],
			[:e1, :e2]
		] 

		read_table
		welcome
	end

	def welcome
		puts "\n ----------------------------".neon
		puts " What would you like to do?".green
		puts ""
		show_options

		num = gets.chomp
			
		if (["1","2"]).include? num

			case num 
			when "1"
				puts "\n How many customers? Please type in a number".green
				print " "
				num_cus = gets.chomp.to_i

				find_out_seats(num_cus)
			when "2"
				display_situation
			end
		
		else 
			wrong_input
			show_options
		end
	end

	def wrong_input
		puts ""
		puts " Please select a number".red
		puts ""
	end

	def show_options
		puts " 1. New Customers"
    puts " 2. Display Situation"
		puts ""
		print " You are selecting: "
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
		puts "\n Take Customers to seats:"
		
		n = 1
		table.each do |t|	
			print "#{t} "	
			welcome if n == num_cus
			
			n += 1
		end
	end
	
	def inform_no_seats
		puts " Sorry no seats avaiable".red
		welcome
	end

	def display_situation
		
		puts " -------------------"
		puts ""
		puts " Table 1(3 people): #{@table_now[:a1]}#{@table_now[:a2]}#{@table_now[:a3]}"
		puts " Table 2(3 people): #{@table_now[:b1]}#{@table_now[:b2]}#{@table_now[:b3]}"
		puts " Table 3(3 people): #{@table_now[:c1]}#{@table_now[:c2]}#{@table_now[:c3]}"
		puts " Table 4(4 people): #{@table_now[:d1]}#{@table_now[:d2]}#{@table_now[:d3]}#{@table_now[:d4]}"
		puts " Table 5(2 people): #{@table_now[:e1]}#{@table_now[:e2]}"
		puts ""
		puts " -------------------"	
	
		welcome
	end
end

#execute!
Restaurant.new
