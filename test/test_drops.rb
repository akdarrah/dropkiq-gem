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
