module Towable
    def can_tow?(pounds)
        pounds < 2000
    end
end

class Vehicle
    attr_accessor :color
    attr_reader :year, :model

    @@number_of_vehicles = 0

    def self.total_number_of_vehicles
        puts "This program has created #{@@number_of_vehicles} vehicles"
    end

    def self.gas_milage(gallons, miles)
        puts "#{miles / gallons} miles per gallon."
    end

    def initialize(year, color, model)
        @year = year
        @color = color
        @model = model
        @speed = 0
        @@number_of_vehicles += 1
    end

    def speed_up(amount)
        @speed += amount
        puts "You accelerate by #{amount} mph."
    end
    
    def slow_down(amount)
        @speed -= amount
        puts "You decelerate by #{amount} mph."
    end

    def current_speed
        puts "You are currently going #{@speed} mph."
    end

    def shut_off
        @speed = 0
        puts "You have parked the vehicle."
    end

    def spray_paint(color)
        self.color = color
        puts "Your #{color} paint job looks great!"
    end

    def age
        "Your #{self.model} is #{years_old} year(s) old."
    end

    private 

    def years_old
        Time.now.year - self.year
    end
end

class MyCar < Vehicle
    NUMBER_OF_DOORS = 4

    def to_s
        "My car is a #{color} #{year} #{model}."
    end
end

class MyTruck < Vehicle
    include Towable

    NUMBER_OF_DOORS = 2

    def to_s
        "My truck is a #{color} #{year} #{model}."
    end
end

WRX = MyCar.new(2021, "silver", "WRX")
WRX.speed_up(25)
WRX.current_speed
WRX.speed_up(40)
WRX.current_speed
WRX.slow_down(40)
WRX.current_speed
WRX.slow_down(25)
WRX.current_speed
WRX.shut_off
WRX.current_speed

puts WRX.color
# WRX.color = "Silver"
WRX.spray_paint("Silver")
puts WRX.color
puts WRX.year

MyCar.gas_milage(16, 350)

puts WRX
puts WRX.age
 
puts "---MyCar method lookup---"
puts MyCar.ancestors
puts "---MyTruck method lookup---"
puts MyTruck.ancestors
puts "---Vehicle method lookup---"
puts Vehicle.ancestors