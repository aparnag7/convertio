# frozen_string_literal: true

RSpec.describe Convertio do
  it "has a version number" do
    expect(Convertio::VERSION).not_to be nil
  end

  describe "#convert" do
    it "support miles to kilometers" do
      expect(described_class.convert(1, from: :mi, to: :km)).to be_within(0.001).of(1.60934)
    end

    it "supports kilometers to miles" do
      expect(described_class.convert(1, from: :km, to: :mi)).to be_within(0.001).of(0.621371)
    end

    it "throws NoUnitError for invalid types" do
      expect { described_class.convert(1, from: :l, to: :km) }.to raise_error(Convertio::NoUnitError)
    end

    it "throws TypeMismatchError for invalid conversions" do
      expect { described_class.convert(1, from: :lb, to: :km) }.to raise_error(Convertio::TypeMismatchError)
    end

    it "throws error if distance is negative" do
      expect do
        described_class.convert(-1, from: :mi, to: :km)
      end.to raise_error(StandardError, "Distance cannot be negative")
    end
  end
end
