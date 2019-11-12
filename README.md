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

* Drop classes are expected to have the same name as the corresponding Rails model. For example, if you have an ActiveRecord model with name of `Person`, the drop class is expected to be called `PersonDrop`
* Drop class methods are expected to return the same data type as the corresponding Rails-model getter methods for relationships and columns.
* This Gem has not been tested with Rails models that have non-default primary key (other than `id`).

This Gem provides a rake command to generate a schema file that can be used to manage Fixtures on Dropkiq. Create the `db/dropkiq_schema.yaml` file by running the following command:

```
bundle exec rake dropkiq:schema
```

You should now have a `db/dropkiq_schema.yaml` file. This file describes all tables associated to Drop classes in your application, along with all methods avaialble to the Drop class. It is important that you **DO** allow this file to be checked in to version control so that you can maintain your Dropkiq schema over time as you add/remove/modify your Drop classes.

Notice that `type` has NOT been set on all methods. The Dropkiq Gem is only able to infer the method type for methods that correspond to a column or relationship on the ActiveRecord model. Please take a moment to manually add `type` values for all methods that were not able to be inferred. Notice that if you run `bundle exec rake dropkiq:schema` again, your changes are saved!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dropkiq. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dropkiq project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dropkiq/blob/master/CODE_OF_CONDUCT.md).
