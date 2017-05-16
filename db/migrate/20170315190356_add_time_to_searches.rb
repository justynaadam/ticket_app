# frozen_string_literal: true

class AddTimeToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :time, :datetime
  end
end
