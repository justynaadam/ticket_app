class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :text
      t.references :main, index: true
      t.timestamps
    end
  end
end
