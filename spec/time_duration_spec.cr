require "./spec_helper"

describe Time::Duration do
  it "calculates in_seconds correctly" do
    duration = Time::Duration.new(3600.0) # 1 hour
    duration.in_seconds.should eq 3600
  end

  it "calculates in_minutes correctly" do
    duration = Time::Duration.new(3600.0) # 1 hour
    duration.in_minutes.should eq 60.0
  end

  it "calculates in_hours correctly" do
    duration = Time::Duration.new(3600.0) # 1 hour
    duration.in_hours.should eq 1.0
  end

  it "calculates in_days correctly" do
    duration = Time::Duration.new(604_800.0) # 1 week
    duration.in_days.should eq 7.0
  end

  it "calculates in_weeks correctly" do
    duration = Time::Duration.new(604_800.0) # 1 week
    duration.in_weeks.should eq 1.0
  end

  it "calculates in_months correctly" do
    duration = Time::Duration.new(2_629_746.0) # 1 month
    duration.in_months.should eq 1.0
  end

  it "calculates in_years correctly" do
    duration = Time::Duration.new(31_556_952.0) # 1 year
    duration.in_years.should eq 1.0
  end

  it "calculates ago correctly" do
    duration = Time::Duration.new(3600.0)
    (Time.local - duration.ago).should be_close(Time::Span.new(seconds: 3600), Time::Span.new(seconds: 1))
  end

  it "calculates since correctly" do
    duration = Time::Duration.new(3600.0)
    (duration.since - Time.local).should be_close(Time::Span.new(seconds: 3600), Time::Span.new(seconds: 1))
  end

  it "calculates in_general correctly" do
    duration = Time::Duration.new(41_129_302.0) # 1 year, 3 months, 19 days, 11 hours, 31 minutes, and 52 seconds
    duration.in_general.should eq({years: 1, months: 3, days: 19, hours: 11, minutes: 31, seconds: 52})
  end

  it "humanizes duration correctly" do
    duration = Time::Duration.new(41_129_302.0) # 1 year, 3 months, 19 days, 11 hours, 31 minutes, and 52 seconds
    duration.humanize.should eq "1 year, 3 months, 19 days, 11 hours and 31 minutes"
  end

  it "humanizes duration with seconds correctly" do
    duration = Time::Duration.new(41_129_302.0) # 1 year, 3 months, 19 days, 11 hours, 31 minutes, and 52 seconds
    duration.humanize(include_seconds: true).should eq "1 year, 3 months, 19 days, 11 hours, 31 minutes and 52 seconds"
  end

  it "calculates seconds correctly" do
    duration = Time::Duration.seconds(3600)
    duration.value.should eq 3600.0
  end

  it "calculates minutes correctly" do
    duration = Time::Duration.minutes(60)
    duration.value.should eq 3600.0
  end

  it "calculates hours correctly" do
    duration = Time::Duration.hours(1)
    duration.value.should eq 3600.0
  end

  it "calculates days correctly" do
    duration = Time::Duration.days(1)
    duration.value.should eq 86_400.0
  end

  it "calculates weeks correctly" do
    duration = Time::Duration.weeks(1)
    duration.value.should eq 604_800.0
  end

  it "calculates months correctly" do
    duration = Time::Duration.months(1)
    duration.value.should eq 2_629_746.0
  end

  it "calculates years correctly" do
    duration = Time::Duration.years(1)
    duration.value.should eq 31_556_952.0
  end

  it "compares durations correctly" do
    duration1 = Time::Duration.seconds(60)
    duration2 = Time::Duration.minutes(1)
    duration3 = Time::Duration.hours(1)

    (duration1 == duration2).should be_true
    (duration1 < duration3).should be_true
    (duration3 > duration1).should be_true
  end
end
