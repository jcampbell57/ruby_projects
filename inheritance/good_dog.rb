class GoodDog
    attr_accessor :name, :height, :weight, :age

    DOG_YEARS = 7

    @@number_of_dogs = 0

    def initialize(n, h, w, a)
        @name = n
        @height = h
        @weight = w
        self.age  = a * DOG_YEARS

        @@number_of_dogs += 1
    end

    def speak
        "#{name} says arf!"
    end

    def change_info(n, h, w)
        self.name = n
        self.height = h
        self.weight = w
    end

    def info
        # "#{name} weighs #{weight} and is #{height} tall." 
        "#{self.name} weighs #{self.weight} and is #{self.height} tall."
    end

    def what_is_self
        self
    end

    def self.total_number_of_dogs
        @@number_of_dogs
    end
end
  
puts GoodDog.total_number_of_dogs 

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs', 2)
puts sparky.speak
puts sparky.name
puts sparky.age 
puts sparky.info
sparky.name = "Spartacus"
puts sparky.name  
sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info
p sparky.what_is_self

fido = GoodDog.new("Fido", '12 inches', '10 lbs', 4)
puts fido.speak 
puts fido.age 

puts GoodDog.total_number_of_dogs 