# frozen_string_literal: true

# Defines the database model for NGOs
class Ngo < ApplicationRecord
  validates :name, :description, :image_url, presence: true
  validates :ngo_id, presence: true, if: :branch
  scope :parent_ngos, -> { where(branch: false) }

  def parent
    self.class.find_by(id: ngo_id)
  end

  def branches
    self.class.where(ngo_id: id)
  end
end
