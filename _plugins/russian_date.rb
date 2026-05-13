# frozen_string_literal: true

require "date"

module RussianDate
  MONTHS = {
    1 => "января",
    2 => "февраля",
    3 => "марта",
    4 => "апреля",
    5 => "мая",
    6 => "июня",
    7 => "июля",
    8 => "августа",
    9 => "сентября",
    10 => "октября",
    11 => "ноября",
    12 => "декабря"
  }.freeze

  def ru_date(input)
    date = parse_date(input)
    return input if date.nil?

    "#{date.day} #{MONTHS.fetch(date.month)} #{date.year}"
  end

  private

  def parse_date(input)
    return input.to_date if input.respond_to?(:to_date)

    Date.parse(input.to_s)
  rescue ArgumentError
    nil
  end
end

Liquid::Template.register_filter(RussianDate)

