# A struct to represent a time duration, providing utility methods and conversions
# to handle time values more conveniently.
#
# Example:
#
# ```
# duration = Time::Duration.minutes(90)
# puts duration.in_hours   # Outputs: 1.5
# puts duration.in_seconds # Outputs: 5400
#
# future_time = duration.since
# puts future_time # Outputs: [current_time + 90 minutes]
#
# past_time = duration.ago
# puts past_time # Outputs: [current_time - 90 minutes]
# ```
struct Time::Duration
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  SECONDS_PER_MINUTE =       60
  SECONDS_PER_HOUR   =     3600
  SECONDS_PER_DAY    =    86400
  SECONDS_PER_WEEK   =   604800
  SECONDS_PER_MONTH  =  2629746 # 1/12 of a gregorian year
  SECONDS_PER_YEAR   = 31556952 # length of a gregorian year (365.2425 days)

  include Comparable(self)

  getter value

  @general : NamedTuple(years: Int32, months: Int32, days: Int32, hours: Int32, minutes: Int32, seconds: Int32)?

  def initialize(@value : Float64)
  end

  def self.new(time_span : Time::Span)
    new(time_span.to_f)
  end

  def self.new(start_time : Time, end_time : Time)
    new(end_time - start_time)
  end

  def self.between(start_time : Time, end_time : Time)
    new(start_time, end_time)
  end

  # Returns a `Time::Duration` representing the given number of seconds.
  def self.seconds(value)
    new(value)
  end

  # Returns a `Time::Duration` representing the given number of minutes.
  def self.minutes(value)
    new(value * SECONDS_PER_MINUTE)
  end

  # Returns a `Time::Duration` representing the given number of hours.
  def self.hours(value)
    new(value * SECONDS_PER_HOUR)
  end

  # Returns a `Time::Duration` representing the given number of days.
  def self.days(value)
    new(value * SECONDS_PER_DAY)
  end

  # Returns a `Time::Duration` representing the given number of weeks.
  def self.weeks(value)
    new(value * SECONDS_PER_WEEK)
  end

  # Returns a `Time::Duration` representing the given number of months.
  def self.months(value)
    new(value * SECONDS_PER_MONTH)
  end

  # Returns a `Time::Duration` representing the given number of years.
  def self.years(value)
    new(value * SECONDS_PER_YEAR)
  end

  # Compare two `Time::Duration` instances based on their value.
  def <=>(other : self)
    @value <=> other.value
  end

  # Returns a new `Time::Duration` representing the sum of two durations.
  def +(other : self)
    Time::Duration.new(@value + other.value)
  end

  # Returns a new `Time::Duration` representing the difference between two durations.
  def -(other : self)
    Time::Duration.new(@value - other.value)
  end

  # Returns a new `Time::Duration` representing the original duration multiplied by a number.
  def *(other : Number)
    Time::Duration.new(@value * other)
  end

  # Returns a new `Time::Duration` representing the original duration divided by a number.
  def /(other : Number)
    Time::Duration.new(@value / other)
  end

  def in_seconds : Int32
    @value.to_i
  end

  def in_minutes : Float64
    in_seconds / SECONDS_PER_MINUTE
  end

  def in_hours : Float64
    in_seconds / SECONDS_PER_HOUR
  end

  def in_days : Float64
    in_seconds / SECONDS_PER_DAY
  end

  def in_weeks : Float64
    in_seconds / SECONDS_PER_WEEK
  end

  def in_months : Float64
    in_seconds / SECONDS_PER_MONTH
  end

  def in_years : Float64
    in_seconds / SECONDS_PER_YEAR
  end

  def in_general : NamedTuple(years: Int32, months: Int32, days: Int32, hours: Int32, minutes: Int32, seconds: Int32)
    @general ||= begin
      remainder = @value

      years, remainder = remainder.divmod(SECONDS_PER_YEAR)
      months, remainder = remainder.divmod(SECONDS_PER_MONTH)
      days, remainder = remainder.divmod(SECONDS_PER_DAY)
      hours, remainder = remainder.divmod(SECONDS_PER_HOUR)
      minutes, remainder = remainder.divmod(SECONDS_PER_MINUTE)
      seconds = remainder

      {years: years.to_i, months: months.to_i, days: days.to_i, hours: hours.to_i, minutes: minutes.to_i, seconds: seconds.to_i}
    end
  end

  def humanize(*, oxford_comma = false, include_minutes = true, include_seconds = false) : String
    parts = [] of String

    parts << "#{in_general[:years]} year#{'s' unless in_general[:years] == 1}" if in_general[:years] > 0
    parts << "#{in_general[:months]} month#{'s' unless in_general[:months] == 1}" if in_general[:months] > 0
    parts << "#{in_general[:days]} day#{'s' unless in_general[:days] == 1}" if in_general[:days] > 0
    parts << "#{in_general[:hours]} hour#{'s' unless in_general[:hours] == 1}" if in_general[:hours] > 0
    parts << "#{in_general[:minutes]} minute#{'s' unless in_general[:minutes] == 1}" if include_minutes && in_general[:minutes] > 0
    parts << "#{in_general[:seconds]} second#{'s' unless in_general[:seconds] == 1}" if include_seconds && in_general[:seconds] > 0

    if parts.size > 1
      last = parts.pop

      and_part = oxford_comma ? ", and" : " and"
      "#{parts.join(", ")}#{and_part} #{last}"
    else
      parts.join
    end
  end

  # Calculates a new `Time` that is as far in the past as this `Duration` represents.
  def ago(time = Time.local) : Time
    parts = seconds_and_nanoseconds
    time - Time::Span.new(seconds: parts[:seconds], nanoseconds: parts[:nanoseconds])
  end

  # Calculates a new `Time` that is as far in the future as this `Duration` represents.
  def since(time = Time.local) : Time
    parts = seconds_and_nanoseconds
    time + Time::Span.new(seconds: parts[:seconds], nanoseconds: parts[:nanoseconds])
  end

  # Splits the duration into whole seconds and nanoseconds.
  private def seconds_and_nanoseconds
    whole_seconds = @value.floor
    fractional_seconds = @value - whole_seconds
    nanoseconds = (fractional_seconds * 1_000_000_000).to_i

    {seconds: whole_seconds.to_i, nanoseconds: nanoseconds}
  end
end
