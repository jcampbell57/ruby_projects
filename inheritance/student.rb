class Student
	def initialize(name, grade)
		@name = name
			@grade = grade
	end

	def better_grade_than?(stu2)
		if grade > stu2.grade
				puts "Well done!"
		else
			puts "Put in more effort!"
		end
	end

	protected 

	def grade 
    @grade
	end
end 

joe = Student.new("Joe", 92)
bob = Student.new("Bob", 86)

joe.better_grade_than?(bob)
bob.better_grade_than?(joe)
