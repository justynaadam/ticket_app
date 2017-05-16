# frozen_string_literal: true

class AddColumnToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :in_content, :boolean, default: false
  end
end
