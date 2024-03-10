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

    it "throws an error for invalid conversions" do
      expect { described_class.convert(1, from: :l, to: :km) }.to raise_error(Convertio::Error)
    end
  end
end
