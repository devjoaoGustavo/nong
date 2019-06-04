# frozen_string_literal: true

module Boundary
  class Ngo
    # provides essential attributes in order to reference a Ngo
    class Head < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Types::Coercible::String.default(SecureRandom.uuid)
      attribute :name, Types::Strict::String.optional
    end
  end
end
