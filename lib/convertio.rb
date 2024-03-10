# frozen_string_literal: true

require_relative "convertio/version"

# Convert value to different units
module Convertio
  class Error < StandardError; end

  # Raise error if unit is not found
  class NoUnitError < StandardError
    def initialize(units)
      error_message = units.map { |unit| "#{unit} is an invalid type" }.join(", ")
      super(error_message)
    end
  end

  # Raise error if type mismatch
  class TypeMismatchError < StandardError
    def initialize(from_unit, to_unit)
      error_message = "This conversion is not allowed: #{from_unit[:name]} is of type #{from_unit.fetch(:type)} but #{to_unit[:name]} is of type #{to_unit.fetch(:type)}" # rubocop:disable Layout/LineLength
      super(error_message)
    end
  end

  DISTANCE = :distance
  WEIGHT = :mass
  TEMPERATURE = :temperature
  PRESSURE = :pressure
  POWER = :power
  ENERGY = :energy
  ANGLE = :angle
  DATA = :data

  # Different units of distances: miles, kilometers, meters, feet, inches - smallest: inches
  # Different units of temperature: Celsius, Fahrenheit, Kelvin - smallest: Celsius
  # Different units of weight: gram, kilograms, pounds, ounces - smallest: ounces
  # Different units of pressure: pascal, atmosphere, mercury - smallest: pascal
  # Different units of power: watts, horsepower - smallest: watts
  # Different units of energy: calories, joules - smallest: joules
  # Different units of angle: radian, gradian, degree - smallest: radian
  # Different units of data: bits, byte, kilobyte, megabyte, gigabyte - smallest: bit
  # Pick the smallest unit in each type and convert the others to it.

  # Do conversions based on prefix - map kilo to 1000 automatically etc

  UNITS = {
    mi: {
      name: "miles",
      per_base: 63_360,
      type: DISTANCE
    },
    km: {
      name: "kilometers",
      per_base: 39_370.1,
      type: DISTANCE
    },
    m: {
      name: "meters",
      per_base: 39.3701,
      type: DISTANCE
    },
    ft: {
      name: "feet",
      per_base: 12,
      type: DISTANCE
    },
    in: {
      name: "inches",
      per_base: 1,
      type: DISTANCE
    },
    oz: {
      name: "ounces",
      per_base: 1,
      type: WEIGHT
    },
    kg: {
      name: "kilogram",
      per_base: 35.274,
      type: WEIGHT
    },
    lb: {
      name: "pounds",
      per_base: 16,
      type: WEIGHT
    }
  }.freeze

  def self.convert(value, from:, to:)
    Converter.new(value, from, to).convert
  end

  # This class validates input and performs conversion
  class Converter
    def initialize(value, from, to)
      @value = value
      @from = from
      @to = to
      @from_unit = UNITS[@from]
      @to_unit = UNITS[@to]
      validate!
    end

    def convert
      (@value * @from_unit[:per_base]) / @to_unit[:per_base].to_f
    end

    private

    def validate!
      validate_unit_presence!
      validate_unit_types!
      validate_value! if @from_unit[:type] == :distance
    end

    def validate_unit_presence!
      return unless @from_unit.nil? || @to_unit.nil?

      nil_units = []
      nil_units << @from if @from.nil?
      nil_units << @to if @to.nil?
      raise NoUnitError, nil_units
    end

    def validate_unit_types!
      return unless @from_unit.fetch(:type) != @to_unit.fetch(:type)

      raise TypeMismatchError.new(@from_unit, @to_unit)
    end

    def validate_value!
      return if @value.positive?

      raise StandardError, "Distance cannot be negative"
    end
  end
end
