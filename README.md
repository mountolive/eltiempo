# Eltiempo

The `eltiempo` wraps a client and a corresponding parser for retrieving weather data from [eltiempo](https://www.tiempo.com/api/)'s api

An example CLI is also provided. This can retrieve today's temperature, and current week's maximum and minimum average temperature.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eltiempo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eltiempo

It's neccessary a proper `eltiempo`'s API key to be able to retrieve data.
Both the CLI and the `gem` expect a `TIEMPO_API_KEY` environment variable to be set.

If you're using [dotenv](https://github.com/bkeepers/dotenv) in your project,
the gem will be able to pick up the variable from there also.


## Gem usage

```ruby
require 'eltiempo'

# Retrieving locations associated to division, from api
division = client.get_locations_from_division_id(division_id, division_name)
# Retrieving location by the passed name
location = division.get_location(city_name)
if !location
  puts 'Location passed was not found' 
  return
end
# Retrieves weather information from api
week_weather = client.get_weather_from_location_id(location.id)
# Prints today's temperature
puts week_weather.todays_temperature
puts week_weather.average_maximum_temperature
puts week_weather.average_minimum_temperature
```

## CLI

### CLI Installation

To install the cli in your system, after cloning this repository, run `bundle exec rake install`

### CLI Help

The help function for the `eltiempo` CLI prompts the following:

```
$ eltiempo --help


     The "eltiempo" cli retrieves the temperature of any city in Barcelona.
     It can prompt today's temperature, average minimum and/or average maximum
     weekly temperature, in Celsius degrees.
 
     FLAGS
     --today, -t    Will prompt today's temperature for the passed city.
     --av-max, -u  Will prompt average maximum temperature of the week for that city.
     --av-min, -d  Will prompt average minimum temperature of the week for that city.

     PARAMETER
        The Barcelona's city of which you want to retrieve its temperature

```

### CLI Usage

The `eltiempo` CLI is an example of the use of the `gem`. In any case, as mentioned, you need to have the `TIEMPO_API_KEY` env variable set in your system.

```
$ TIEMPO_API_KEY=yourkey eltiempo -d Gavà

Barcelona: Min temperature in Gavà for the week: 
              9.8 celsius

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests (this will create a coverage report in the `coverage` directory). 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

On local development, as already mentioned, you can use [dotenv](https://github.com/bkeepers/dotenv) to define the `TIEMPO_API_KEY` env variable, and it will be loaded on `require`. In that sense, the file `.env.template` serves as guideline: You can just rename it to `.env` and set the variable inside it to your API key and that's all.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mountolive/eltiempo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
