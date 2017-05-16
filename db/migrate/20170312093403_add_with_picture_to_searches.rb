# frozen_string_literal: true

class AddWithPictureToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :with_picture, :boolean, default: false
  end
end
