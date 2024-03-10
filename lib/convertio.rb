# frozen_string_literal: true

require_relative "convertio/version"

# Convert value to different units
module Convertio
  class Error < StandardError; end
  ABBREVIATIONS = {
    'km': "kilometers",
    'mi': "miles"
  }.freeze
  KILOMETERS_PER_MILE = 1.60934
  def self.convert(value, from:, to:)
    case [from, to]
    when %i[mi km]
      value * KILOMETERS_PER_MILE
    when %i[km mi]
      value / KILOMETERS_PER_MILE
    else
      raise Error, "Unsupported conversion: #{ABBREVIATIONS[from]} to #{ABBREVIATIONS[to]}"
    end
  end
end
