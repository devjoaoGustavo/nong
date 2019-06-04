# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parsing::NgoParser, type: :parsers do
  describe 'call' do
    context 'when the input is correctly parsed' do
      it 'begin a branch' do
        ngo_id = SecureRandom.uuid
        input = {
          id: nil,
          name: 'Ngo name',
          description: 'Ngo description',
          image_url: 'https://image.com',
          branch: true,
          ngo_id: ngo_id
        }
        result = described_class.new(input).call

        expect(result).to be_a Ngo
        expect(result.name).to eq 'Ngo name'
        expect(result.description).to eq 'Ngo description'
        expect(result.image_url).to eq 'https://image.com'
        expect(result).to be_branch
        expect(result.ngo_id).to eq ngo_id
      end

      it 'being principal' do
        input = {
          id: nil,
          name: 'Ngo name',
          description: 'Ngo description',
          image_url: 'https://image.com',
          branch: false
        }
        result = described_class.new(input).call

        expect(result).to be_a Ngo
        expect(result.name).to eq 'Ngo name'
        expect(result.description).to eq 'Ngo description'
        expect(result.image_url).to eq 'https://image.com'
        expect(result).not_to be_branch
        expect(result.ngo_id).to be_blank
      end
    end

    context 'when there is some required attribute missing' do
      it 'id' do
        ngo_id = SecureRandom.uuid
        input = {
          name: 'Ngo name',
          description: 'Ngo description',
          image_url: 'https://image.com',
          branch: true,
          ngo_id: ngo_id
        }
        expect do
          described_class.new(input).call
        end.to raise_error(Dry::Struct::Error,
                           /:id is missing in Hash input/)
      end

      it 'name' do
        ngo_id = SecureRandom.uuid
        input = {
          id: SecureRandom.uuid,
          description: 'Ngo description',
          image_url: 'https://image.com',
          branch: true,
          ngo_id: ngo_id
        }
        expect do
          described_class.new(input).call
        end.to raise_error(Dry::Struct::Error,
                           /:name is missing in Hash input/)
      end

      it 'description' do
        ngo_id = SecureRandom.uuid
        input = {
          id: nil,
          name: 'Ngo name',
          image_url: 'https://image.com',
          branch: true,
          ngo_id: ngo_id
        }
        expect do
          described_class.new(input).call
        end.to raise_error(Dry::Struct::Error,
                           /:description is missing in Hash input/)
      end

      it 'image_url' do
        ngo_id = SecureRandom.uuid
        input = {
          id: nil,
          name: 'Ngo name',
          description: 'Ngo description',
          branch: true,
          ngo_id: ngo_id
        }
        expect do
          described_class.new(input).call
        end.to raise_error(Dry::Struct::Error,
                           /:image_url is missing in Hash input/)
      end
    end
  end
end
