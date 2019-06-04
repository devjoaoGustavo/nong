# frozen_string_literal: true

module Presentation
  # Provides a way to convert domain's NGO to boundary's NGO
  class NgoPresenter
    attr_reader :domain_ngo, :boundary_ngo

    def initialize(domain_ngo)
      return unless domain_ngo.is_a?(Ngo)

      @domain_ngo = domain_ngo
    end

    def call
      return false if domain_ngo.blank?

      @boundary_ngo = build_boundary_ngo

      true
    end

    private

    def build_boundary_ngo
      Boundary::Ngo.new(
        id: domain_ngo.id,
        name: domain_ngo.name,
        description: domain_ngo.description,
        image_url: domain_ngo.image_url,
        branch: domain_ngo.branch?,
        ngo_id: ngo_id
      )
    end

    def ngo_id
      domain_ngo.ngo_id || ''
    end
  end
end
