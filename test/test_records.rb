module TestRecords
  def setup_records
    person = Person.create!({
      name: "John Doe",
      active: true,
      notes: "A banana is an edible fruit – botanically a berry – produced by several kinds of large herbaceous flowering plants in the genus Musa. In some countries, bananas used for cooking may be called \"plantains\", distinguishing them from dessert bananas. Wikipedia",
      age: 34,
      birthdate: (Date.today - 20.years),
      net_worth: 155.55,
      height_in_miles: 0.012,
      favorite_time_of_day: Time.now,
      woke_up_at: Time.now.beginning_of_day,
      age_in_binary: 1101
    })

    group = Group.create!(name: "Chiquita Banana", owner: person)
    group.people << person

    banana_tag = Tag.create!({name: "Banana"})
    orange_tag = Tag.create!({name: "Orange"})

    person.tags << banana_tag
    person.tags << orange_tag
  end
end
