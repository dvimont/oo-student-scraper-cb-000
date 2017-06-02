class Student

  # Class methods and attributes
  @@all = Array.new

  def self.create_from_collection(students_array)
    students_array.each{|student_hash| Student.new(student_hash)}
  end

  def self.all()
    return @@all
  end

  # Instance methods and attributes
  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog,
                :profile_quote, :bio, :profile_url

  def initialize(student_hash)
    student_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

end
