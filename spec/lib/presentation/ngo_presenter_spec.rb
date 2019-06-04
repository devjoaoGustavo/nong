# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Presentation::NgoPresenter, type: :presenters do
  let(:input) do
    Ngo.new(
      id: SecureRandom.uuid,
      name: 'NGO name',
      description: 'NGO description',
      image_url: 'https://image.url',
      branch: false,
      ngo_id: nil
    )
  end

  describe '#initialize' do
    context 'when the input args are correctly' do
      it do
        result = described_class.new(input)

        expect(result).to be_a Presentation::NgoPresenter
        expect(result.domain_ngo).to be_a Ngo
        expect(result.boundary_ngo).to be_nil
      end
    end
  end

  describe '#call' do
    context 'when the presentation succeed' do
      it do
        instance = described_class.new(input)

        result = instance.call

        expect(result).to be true
        expect(instance.boundary_ngo).to be_a Boundary::Ngo
        expect(instance.boundary_ngo).to be_parent
        expect(instance.boundary_ngo.id).to be_present
        expect(instance.boundary_ngo.name).to eq instance.domain_ngo.name
        expect(
          instance.boundary_ngo.image_url
        ).to eq instance.domain_ngo.image_url
        expect(
          instance.boundary_ngo.description
        ).to eq instance.domain_ngo.description
      end
    end
  end
end
