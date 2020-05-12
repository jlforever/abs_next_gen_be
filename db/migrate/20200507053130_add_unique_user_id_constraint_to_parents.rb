class AddUniqueUserIdConstraintToParents < ActiveRecord::Migration[5.2]
  def up
    remove_index :parents, name: 'index_parents_on_user_id'
    add_index :parents, :user_id, unique: true
  end

  def down
    remove_index :parents, name: 'index_parents_on_user_id'
    add_index :parents, :user_id
  end
end
