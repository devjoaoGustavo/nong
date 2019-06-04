# frozen_string_literal: true

module Parsing
  # Provides an interface to convert external data into a NGO domain model
  class NgoParser
    attr_reader :boundary_ngo

    def initialize(args)
      @boundary_ngo = Boundary::Ngo.new(args)
    end

    def call
      Ngo.new(
        id: boundary_ngo.id,
        name: boundary_ngo.name,
        description: boundary_ngo.description,
        image_url: boundary_ngo.image_url,
        branch: boundary_ngo.branch,
        ngo_id: boundary_ngo.ngo_id
      )
    end
  end
end
