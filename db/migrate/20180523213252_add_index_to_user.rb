class AddIndexToUser < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :token, unique: true
  end
end
