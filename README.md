![Dropkiq_logo-dk](https://user-images.githubusercontent.com/69064/68704782-dd868e80-055a-11ea-952c-78bd9e9344d6.png)

# Dropkiq

**[Dropkiq](https://www.dropkiq.com/) simplifies the creation of Liquid expressions.** Quickly build your dynamic content with the simplest Liquid template editor.

* *Immediate Feedback:* No more guesswork. Know exactly how your expressions will evaluate in real time.
* *No More Typos:* To err is human. Identify mistakes as they happen and take corrective measures.
* *Visibility of Options:* Data at your fingertips. See what data is available without asking your development team.

Check it out at [https://www.dropkiq.com](https://www.dropkiq.com/)!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dropkiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dropkiq

## Usage

This Gem makes several assumptions about your Ruby on Rails application:

* Drop classes are expected to have the same name as the corresponding Rails model. For example, if you have an ActiveRecord model with name of `Person`, the drop class is expected to be called `PersonDrop` (Ruby on Rails applications using the legacy `liquid_methods` method with [PR #568](https://github.com/Shopify/liquid/pull/568) are also supported.)
* Drop class methods are expected to return the same data type as the corresponding Rails-model getter methods for relationships and columns.
* This Gem has not been tested with Rails models that have non-default primary key (other than `id`).

This Gem provides a rake command to generate a schema file that can be used to manage Fixtures on Dropkiq. Create the `db/dropkiq_schema.yaml` file by running the following command:


```
bundle exec rake dropkiq:schema
```


You should now have a `db/dropkiq_schema.yaml` file. This file describes all tables associated to Drop classes in your application, along with all methods avaialble to the Drop class. It is important that you **DO** allow this file to be checked in to version control so that you can maintain your Dropkiq schema over time as you add/remove/modify your Drop classes.

Notice that `type` has NOT been set on all methods. The Dropkiq Gem is only able to infer the method type for methods that correspond to a column or relationship on the ActiveRecord model. Please take a moment to manually add `type` values for all methods that were not able to be inferred. (Hint: Search the dropkiq_schema.yaml file for the word "CHANGEME" to see what needs manual attention.) Notice that if you run `bundle exec rake dropkiq:schema` again, your changes are saved!


#### Ruby on Rails Column to Dropkiq Data Type Mappings

| Ruby on Rails Column Type | Dropkiq Data Type |
| --- | --- |
| `string` | `ColumnTypes::String` |
| `integer` | `ColumnTypes::Numeric` |
| `boolean` | `ColumnTypes::Boolean` |
| `datetime` | `ColumnTypes::DateTime` |
| `date` | `ColumnTypes::DateTime` |
| `decimal` | `ColumnTypes::Numeric` |
| `float` | `ColumnTypes::Numeric` |
| `text` | `ColumnTypes::Text` |
| `time` | `ColumnTypes::DateTime` |
| `binary` | `ColumnTypes::Numeric` |

#### Ruby on Rails Associations to Dropkiq Data Type Mappings

| Ruby on Rails Association Type | Dropkiq Data Type |
| --- | --- |
| `belongs_to` | `ColumnTypes::HasOne` |
| `has_one` | `ColumnTypes::HasOne` |
| `has_many` | `ColumnTypes::HasMany` |
| `has_one through:` | `ColumnTypes::HasOne` |
| `has_many through:` | `ColumnTypes::HasMany` |
| `has_and_belongs_to_many` | `ColumnTypes::HasMany` |

**Please note:** You must also specify a `foreign_table_name` for any Association column in Dropkiq. These types can also be used for arbitrary methods within your Drop class that simply returns a single instance or array of instances of a Drop Class.

```ruby
class PersonDrop < Liquid::Drop
  # ...
end

class GroupDrop < Liquid::Drop
  def initialize(group)
    @group = group
  end

  # Use the ColumnTypes::HasOne column type and specify the foreign_table_name as "people"
  def owner
    owner_membership  = @group.memberships.find_by!(owner: true)
    PersonDrop.new(owner_membership.person)
  end

  # Use the ColumnTypes::HasMany column type and specify the foreign_table_name as "people"
  def managers
    @group.memberships.where(manager: true).map{|m| PersonDrop.new(m.person)}
  end
end
```


Dropkiq also provides a `ColumnTypes::YAML` Column Type if your Drop class model has any methods that simply return an Array or Hash, such as this example:

```ruby
class ProductDrop < Liquid::Drop
  def initialize(product)
    @product = product
  end

  # Use the ColumnTypes::YAML column type and serialize the Array as Yaml
  def possible_sku_numbers
    [12345, 67890, 45678, 12390]
  end

  # Use the ColumnTypes::YAML column type and serialize the Hash as Yaml
  def custom_data
    {
      description: "This is a book about bananas",
      price: 12.95
    }
  end
end
```

#### Dropkiq Method Classification

In the event that a liquid method is not an exact match to a column or association, the Dropkiq Ruby Gem will attempt to make a best guess about the data type of the method based on the name. The rules for matching are as follows:

| Method Name Ends With | Dropkiq Data Type |
| --- | --- |
| `_id` | `ColumnTypes::Numeric` |
| `_count` | `ColumnTypes::Numeric` |
| `?` | `ColumnTypes::Boolean` |
| `_present` | `ColumnTypes::Boolean` |
| `_changed` | `ColumnTypes::Boolean` |
| `description` | `ColumnTypes::Text` |
| `name` | `ColumnTypes::String` |
| `password` | `ColumnTypes::String` |
| `type` | `ColumnTypes::String` |
| `title` | `ColumnTypes::String` |
| `to_s` | `ColumnTypes::String` |
| `to_string` | `ColumnTypes::String` |
| `_url` | `ColumnTypes::String` |
| `_email` | `ColumnTypes::String` |
| `_partial` | `ColumnTypes::String` |
| `_email_address` | `ColumnTypes::String` |
| `_uuid` | `ColumnTypes::String` |

The Dropkiq Ruby Gem will also attempt to classify liquid methods by creating a sample instance of the Liquid Drop class to test. The liquid method will be called, and the value will attempt to be classified using the foollowing:

| Value Result | Dropkiq Data Type |
| --- | --- |
| `TrueClass` | `ColumnTypes::Boolean` |
| `FalseClass` | `ColumnTypes::Boolean` |
| `String` | `ColumnTypes::String` |
| `Symbol` | `ColumnTypes::String` |
| `Numeric` | `ColumnTypes::Numeric` |
| `Date` | `ColumnTypes::DateTime` |
| `Time` | `ColumnTypes::DateTime` |
| `DateTime` | `ColumnTypes::DateTime` |

Dropkiq will attempt to classify relationships in the event the method returns a single ActiveRecord object (`ColumnTypes::HasOne`), or a collection or ActiveRecord objects (`ColumnTypes::HasMany`).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dropkiq. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dropkiq project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dropkiq/blob/master/CODE_OF_CONDUCT.md).
