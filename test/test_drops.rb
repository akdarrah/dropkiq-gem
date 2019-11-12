class PersonDrop < Liquid::Drop
  def initialize(person)
    @person = person
  end

  def name
    @person["name"]
  end

  def age
    @person["age"]
  end

  def active
    @person["active"]
  end

  def created_at
    @person["created_at"]
  end

  def random_number
    rand(1..10)
  end
end
