# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UseCases::NgoCreation, type: :use_cases do
  let(:input) do
    {
      name: 'NGO name',
      description: 'NGO description',
      image_url: 'http://www.cssantaluzia.org.br/uploads/geral2019_01_16/5-CentroSocialSantaLuzia_Internet_RGB_Horizontal.jpg'
    }
  end

  describe '#initialize' do
    context 'when the input is correctly' do
      it do
        result = described_class.new(input)

        expect(result).to be_a UseCases::NgoCreation
        expect(result.parser).to be_a Parsing::NgoParser
        expect(result.boundary_ngo).to be_a Boundary::Ngo
        expect(result.boundary_ngo).not_to be_branch
        expect(result.boundary_ngo.id).to be_nil
        expect(result.boundary_ngo.ngo_id).to be_blank
        expect(result.boundary_ngo.name).to eq input[:name]
        expect(result.boundary_ngo.description).to eq input[:description]
        expect(result.boundary_ngo.image_url).to eq input[:image_url]
        expect(result.created_ngo).to be_nil
      end
    end

    context 'when the iput is not a hash' do
      it do
        expect do
          described_class.new('')
        end.to raise_error(ArgumentError, /Hash expected/)
      end
    end
  end

  describe '#call' do
    context 'when the ngo is created correctly' do
      it do
        instance = described_class.new(input)

        result = instance.call

        expect(result).to be true
        expect(instance.created_ngo).to be_a Boundary::Ngo
        expect(instance.created_ngo).not_to be_branch
        expect(instance.created_ngo.id).to be_present
        expect(instance.created_ngo.ngo_id).to be_blank
        expect(instance.created_ngo.name).to eq input[:name]
        expect(instance.created_ngo.image_url).to eq input[:image_url]
        expect(instance.created_ngo.description).to eq input[:description]
      end
    end

    context 'when there is required attribute missing' do
      let(:input) do
        {
          name: '',
          description: 'NGO description',
          image_url: ''
        }
      end

      it do
        instance = described_class.new(input)
        result   = instance.call

        expect(result).to be false
        expect(instance.errors[:name]).to include "can't be blank"
        expect(instance.errors[:image_url]).to include "can't be blank"
      end
    end
  end
end
