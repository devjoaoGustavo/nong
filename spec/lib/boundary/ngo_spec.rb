# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boundary::Ngo do
  describe 'attributes' do
    it 'should respond to attributes methods' do
      result = described_class.new(
        id: nil,
        name: nil,
        description: nil,
        image_url: nil,
        branch: false,
        ngo_id: ''
      )

      expect(result).to respond_to :id
      expect(result).to respond_to :name
      expect(result).to respond_to :description
      expect(result).to respond_to :ngo_id
      expect(result).to respond_to :branch
    end
  end
end
