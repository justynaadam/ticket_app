class AddIndexToTickets < ActiveRecord::Migration[5.0]
  def change
    add_index :tickets, [:user_id, :id]
  end
end
