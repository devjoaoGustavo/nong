# frozen_string_literal: true

module Boundary
  # This class describe a boundary model in order
  # to avoid persistent model to be known outside the application
  class Ngo < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id, Types::Strict::String.optional
    attribute :name, Types::Strict::String.optional
    attribute :description, Types::Strict::String.optional
    attribute :image_url, Types::Strict::String.optional
    attribute :branch, Types::Bool.default(false)
    attribute :ngo_id, Types::Strict::String.default('')

    alias branch? branch

    def parent?
      !branch?
    end
  end
end
