# frozen_string_literal: true

# Defines the database migration for creating ngos table
class CreateNgos < ActiveRecord::Migration[5.2]
  def change
    create_table :ngos, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.references :ngo, type: :uuid, index: true
      t.boolean :branch

      t.timestamps
    end
  end
end
