class GroupDrop < Liquid::Drop
  def initialize(group)
    @group = group
  end

  def name
    @group["name"]
  end

  def owner
    PersonDrop.new(@group.owner)
  end

  def people
    @group.people.map{|p| PersonDrop.new(p)}
  end
end

class TagDrop < Liquid::Drop
  def initialize(tag)
    @tag = tag
  end

  def name
    @tag["name"]
  end

  def groups
    @tag.groups.map{|g| GroupDrop.new(g)}
  end
end

class PersonDrop < Liquid::Drop
  class Unknown
  end

  def initialize(person)
    @person = person
  end

  def to_s
    name
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

  def nil
  end

  def true
    true
  end

  def false
    true
  end

  def string
    ""
  end

  def symbol
    :symbol
  end

  def integer
    123
  end

  def float
    1.001
  end

  def datetime
    DateTime.now
  end

  def date
    Date.today
  end

  def time
    Time.now
  end

  def unknown
    PersonDrop::Unknown.new
  end

  def first_tag
    Tag.first
  end

  def all_tags
    Tag.all
  end
end
