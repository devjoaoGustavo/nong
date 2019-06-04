# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UseCases::ListingNgo do
  describe 'initialize' do
    it do
      result = described_class.new

      expect(result).to be_a UseCases::ListingNgo
      expect(result.presenter_class).to eq Presentation::NgoPresenter
    end
  end

  describe 'call' do
    it do
      ngo = Ngo.create(
        'name' => 'ONU',
        'description' => 'ONU description',
        'image_url' => 'http://image.url',
        'branch' => '0'
      )

      instance = described_class.new

      result = instance.call

      expect(result).to be_an Array
      expect(result.first).to be_a Boundary::Ngo
      expect(result.first.id).to eq ngo.id
    end
  end
end
