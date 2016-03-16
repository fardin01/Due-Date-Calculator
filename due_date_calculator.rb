require 'date'
require 'time'
require 'active_support/time'

class DueDateCalculator
	HOLIDAYS = [Date.new(2016,03,14), Date.new(2016,03,15)]

	def initialize(date, turnaround)
		@remaining_time = (date.change(hour: 17).to_time - date.to_time) / 3600
		@date = date
		@turnaround = turnaround
	end

	def calculate_due_date
		if @turnaround <= @remaining_time
			deadline = @date + @turnaround.hours
		else
			remaining_days = (@turnaround - @remaining_time) / 8
			remaining_hours = (@turnaround - @remaining_time) % 8

			for days in 0..remaining_days do
				@date = next_business_day(@date)
			end
			deadline = @date.change(hour: 9) + remaining_hours.hours
		end
	end

	def next_business_day(date)
	  date += 1
	  while (date.saturday?) || (date.sunday?) || HOLIDAYS.include?(date) do
	    date = date.next_day.change(hour: 9)
	  end   
	  date
	end
end

DueDateCalculator.new(DateTime.new(2016,3,16,9),9).calculate_due_date