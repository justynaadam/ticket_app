class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.text :title
      t.text :content
      t.decimal :price, :precision => 8, :scale => 2 
      t.string :ticket_type
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tickets, [:user_id, :created_at]
  end
end
