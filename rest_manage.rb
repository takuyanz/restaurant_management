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
		ask
	end

	def ask
		puts "\n What would you like to do?"
		puts " 1. New Customers"
		puts " 2. Display Situation"

		num = gets.chomp
		
		case num 
		when "1"
			puts " How many customers?"
			num_cus = gets.chomp.to_i

			find_out_seats(num_cus)
		when "2"
			display_situation
		end
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
			if table.length >= num_cus then 
				if enough_seats(table, num_cus)					
					n = 0
					table.each do |i|
						inform_seats_available if n == num_cus
						@table_now[i] = "X"
						n += 1
					end
				else
					inform_no_seats
				end
			end
		end
		inform_no_seats		
	end
	
	def enough_seats(table, num_cus)
		total = 0
		
		table.each do |t|
			if @table_now[t] == " "
				total += 1
			end
		end

		if total >= num_cus
			return true
		else
			return false
		end
	end

	def inform_seats_available
		puts "Take Customers to ???"
		ask
	end
	
	def inform_no_seats
		puts "Sorry no seats avaiable"
		ask
	end

	def display_situation
		
		puts "-------------------"
		puts ""
		puts "Table 1(3 people): #{@table_now[:a1]}#{@table_now[:a2]}#{@table_now[:a3]}"
		puts "Table 2(3 people): #{@table_now[:b1]}#{@table_now[:b2]}#{@table_now[:b3]}"
		puts "Table 3(3 people): #{@table_now[:c1]}#{@table_now[:c2]}#{@table_now[:c3]}"
		puts "Table 4(4 people): #{@table_now[:d1]}#{@table_now[:d2]}#{@table_now[:d3]}#{@table_now[:d4]}"
		puts "Table 5(2 people): #{@table_now[:e1]}#{@table_now[:e2]}"
		puts ""
		puts "-------------------"	
	
		ask
	end
end

#execute!
Restaurant.new
