class RemoveUserIdFromSearches < ActiveRecord::Migration[5.0]
  def change
    remove_column :searches, :user_id, :integer
  end
end
