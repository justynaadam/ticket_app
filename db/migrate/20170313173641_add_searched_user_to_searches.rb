# frozen_string_literal: true

class AddSearchedUserToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :searched_user, :integer
  end
end
