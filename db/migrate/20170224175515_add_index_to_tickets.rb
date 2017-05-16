# frozen_string_literal: true

class AddIndexToTickets < ActiveRecord::Migration[5.0]
  def change
    add_index :tickets, %i[user_id id]
  end
end
