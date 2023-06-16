# Time::Duration

The `Time::Duration` library provides a structured and convenient way to work with durations of time in the Crystal programming language. It allows the creation of duration instances from various units of time such as seconds, minutes, hours, days, weeks, months, and years, and also supports duration operations like addition, subtraction, multiplication, and division.

This library is inspired by the [ActiveSupport::Duration](https://api.rubyonrails.org/classes/ActiveSupport/Duration.html) library from the Ruby on Rails framework.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     time_duration:
       github: mamantoha/time_duration
   ```

2. Run `shards install`

## Usage

```crystal
require "time_duration"
```

### Initialization

Initialize a duration from a float value representing seconds:

```crystal
duration = Time::Duration.new(3600.0) # Creates a duration of 1 hour.
```
You can also create durations directly from various units of time:

```crystal
hour = Time::Duration.hours(1)    # Creates a duration of 1 hour.
day = Time::Duration.days(1)      # Creates a duration of 1 day.
week = Time::Duration.weeks(1)    # Creates a duration of 1 week.
month = Time::Duration.months(1)  # Creates a duration of 1 month.
year = Time::Duration.years(1)    # Creates a duration of 1 year.
```

### Operations

The library supports standard mathematical operations for durations:

```crystal
total = day + hour      # Addition
difference = day - hour # Subtraction
doubled = day * 2       # Multiplication
halved = day / 2        # Division
```

You can also compare two durations:

```crystal
if day > hour
  puts "A day is longer than an hour."
end
```

### Conversion

You can convert a duration into various units of time:

```crystal
puts "In seconds: #{hour.in_seconds}"
puts "In minutes: #{hour.in_minutes}"
puts "In hours: #{hour.in_hours}"
puts "In days: #{day.in_days}"
puts "In weeks: #{week.in_weeks}"
puts "In months: #{month.in_months}"
puts "In years: #{year.in_years}"
```

### Time

Calculate a time in the past or future based on a duration:

```crystal
duration = Time::Duration.hours(1)

puts duration.ago   # prints the time 1 hour ago
puts duration.since # prints the time 1 hour in the future
```

You can also use it with a specific time:

```crystal
specific_time = Time.new(2023, 1, 1)

puts duration.ago(specific_time)   # prints the time 1 hour before the specific_time
puts duration.since(specific_time) # prints the time 1 hour after the specific_time
```
## Contributing

1. Fork it (<https://github.com/mamantoha/time_duration/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
