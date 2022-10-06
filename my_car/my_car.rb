class MyCar
    attr_accessor :color
    attr_reader :year

    def initialize(year, color, model)
        @year = year
        @color = color
        @model = model
        @speed = 0
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