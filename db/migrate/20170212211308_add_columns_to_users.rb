# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :location, :string
    add_column :users, :phone, :integer
  end
end
