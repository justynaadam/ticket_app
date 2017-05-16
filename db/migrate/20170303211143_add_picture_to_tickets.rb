# frozen_string_literal: true

class AddPictureToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :picture, :string
  end
end
