class Person < ActiveRecord::Base
  include LiquidMethods
  has_and_belongs_to_many :tags

  liquid_methods :name

  belongs_to :group
  has_one :group_owner,
    through: :group,
    source: :owner
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_many :groups, through: :people
end

class Group < ActiveRecord::Base
  has_many :people
  has_one :owner, class_name: "Person"
end
