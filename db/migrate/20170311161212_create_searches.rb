# frozen_string_literal: true

class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :keywords
      t.integer :category_id
      t.float :minimum_price
      t.float :maximum_price
      t.string :location_keywords

      t.timestamps
    end
  end
end
