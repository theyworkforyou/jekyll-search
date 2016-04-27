:warning: This gem is currently under heavy development and is not ready to be used in production.

# Jekyll::Search

Make it easy to search across collections on your Jekyll site.

## Installation

Add this to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-search', git: 'https://github.com/theyworkforyou/jekyll-search.git', branch: 'master'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-search

## Usage

### Prerequisites

First you'll need to make sure that you have jQuery and jQuery-UI already installed on the page as this plugin depends on those. 

### Liquid tags

Once you've got the prerequisites installed and on the page you'll need to add the following tag in the `<head>` tag of your site:

```liquid
{% jekyll_search_assets %}
```

Then add the following tag wherever you want the search box to appear:

```liquid
{% jekyll_search_box %}
```

## Configuration

By default this plugin will index the `posts` collection. If you want it to index other collections you'll need to add a section to your `_config.yml`:

```yaml
collections_to_search:
  - people
  - organizations
  - areas
  - posts
```

This will then include the documents from all of those collections in the search.

Sometimes you will have alternative names for things that will refer to the same thing. For example if you have a `person` document that has the `title` "James", you might also want to search for "Jim" and have it return the same document. You can configure other fields to be indexed by adding a ruby file into your site's `_plugins` directory containing something like this:

```ruby
Jekyll::Search::AlternativeSpellings.register :people do |person|
  person.data['other_names'].map { |on| on['name'] }
end
```

The `Jekyll::Search::Hooks.register` method takes a symbol which is the name of a collection and a block. The block is then passed each document for that collection and the block is expected to return an array of alternative spellings for this document.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/jekyll-search.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
