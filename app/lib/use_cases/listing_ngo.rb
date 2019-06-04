# frozen_string_literal: true

module UseCases
  # provides an interface for listing NGOs using a given presenter
  class ListingNgo
    attr_reader :presenter_class

    def initialize(presenter_class = Presentation::NgoPresenter)
      @presenter_class = presenter_class
    end

    def call
      Ngo
        .parent_ngos
        .map(&method(:present))
    end

    private

    def present(domain_ngo)
      presenter_class
        .new(domain_ngo)
        .tap(&:call)
        .then(&:boundary_ngo)
    end
  end
end
