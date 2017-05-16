# frozen_string_literal: true

class AddActivationToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :activation_digest, :string
    add_column :tickets, :activated, :boolean
    add_column :tickets, :activated_at, :datetime
  end
end
