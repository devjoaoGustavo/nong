# frozen_string_literal: true

module UseCases
  # Implement the business rule to create a new NGO
  class NgoCreation
    attr_reader :parser, :boundary_ngo, :created_ngo, :errors

    def initialize(args = {})
      invalid_input unless args.class.in? [ActionController::Parameters, Hash]

      @parser = Parsing::NgoParser.new(normalize_args(args))
      @boundary_ngo = parser.boundary_ngo
    end

    def call
      new_ngo = parser.call

      if new_ngo.save
        Presentation::NgoPresenter
          .new(new_ngo)
          .then { |presenter| presenter.call && presenter }
          .then(&method(:assign_boundary_ngo))

        return true
      end

      @errors = new_ngo.errors

      false
    end

    private

    def invalid_input
      raise ArgumentError, 'Invalid args type! Hash expected'
    end

    def assign_boundary_ngo(presenter)
      return unless presenter

      @created_ngo = presenter.boundary_ngo
    end

    def normalize_args(args)
      {
        id: nil,
        name: nil,
        image_url: nil,
        description: nil,
        branch: false,
        ngo_id: ''
      }.merge(args)
    end
  end
end
