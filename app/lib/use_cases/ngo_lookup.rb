# frozen_string_literal: true

module UseCases
  # provide a generic interface for find a NGO by given params
  class NgoLookup
    attr_reader :args

    def initialize(args = {})
      @args = args
    end

    def call
      Ngo
        .find_by!(args)
        .then(&method(:present))
    end

    private

    def present(domain_ngo)
      Presentation::NgoPresenter
        .new(domain_ngo)
        .tap(&:call)
        .then(&:boundary_ngo)
    end
  end
end
