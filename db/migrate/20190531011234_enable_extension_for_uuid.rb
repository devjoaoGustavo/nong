# frozen_string_literal: true

# Defines the database migration in order to enable uuid extension
class EnableExtensionForUuid < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
