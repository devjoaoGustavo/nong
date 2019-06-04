# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UseCases::NgoLookup do
  describe 'initialize' do
    it do
      ngo = Ngo.create!(
        name: 'Branch name',
        description: 'Branch description',
        image_url: 'https://image.url'
      )

      result = described_class.new(id: ngo.id)

      expect(result).to be_a UseCases::NgoLookup
      expect(result.args).to have_key :id
    end
  end

  describe '#call' do
    context 'when the ngo is found' do
      it do
        ngo = Ngo.create!(
          name: 'Branch name',
          description: 'Branch description',
          image_url: 'https://image.url'
        )

        instance = described_class.new(id: ngo.id)

        result = instance.call

        expect(result).to be_a Boundary::Ngo
        expect(result.id).to eq ngo.id
      end
    end

    context 'when the ngo is not found' do
      it do
        ngo_id = SecureRandom.uuid

        instance = described_class.new(id: ngo_id)

        expect { instance.call }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
