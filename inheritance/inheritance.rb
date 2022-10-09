# MODULES
module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

# CLASSES
class Animal
    include Walkable

    def speak
        "Hello!"
    end
end

class Fish < Animal
    include Swimmable
end

module Mammal
    class GoodDog < Animal
        include Swimmable
        include Climbable

        DOG_YEARS = 7

        attr_accessor :name, :age

        def initialize(n, a)
            self.name = n
            self.age = a
        end

        def speak
            super + " from #{self.name} in the GoodDog class"
        end

        def public_disclosure
            "#{self.name} in human years is #{human_years}"
        end

        private

        def human_years
            age * DOG_YEARS
        end
    end

    class Cat < Animal
    end

    def self.some_out_of_place_method(num)
        num ** 2
    end
end

sparky = Mammal::GoodDog.new("Sparky", 2)
neemo  = Fish.new
paws = Mammal::Cat.new

puts sparky.speak
puts paws.speak

puts sparky.swim
puts neemo.swim
# puts paws.swim  
    # => NoMethodError: undefined method `swim' for #<Cat:0x007fc453152308>

value = Mammal.some_out_of_place_method(4)
puts value
value = Mammal::some_out_of_place_method(3)
puts value

puts sparky.public_disclosure

puts "---GoodDog method lookup---"
puts Mammal::GoodDog.ancestors

class Person
    def initialize(age)
      @age = age
    end
  
    def older?(other_person)
      age > other_person.age
    end
  
    protected
  
    attr_reader :age
end
  
  malory = Person.new(64)
  sterling = Person.new(42)
  
puts malory.older?(sterling)  # => true
puts sterling.older?(malory)  # => false
  
#   malory.age
    # => NoMethodError: protected method `age' called for #<Person: @age=64>