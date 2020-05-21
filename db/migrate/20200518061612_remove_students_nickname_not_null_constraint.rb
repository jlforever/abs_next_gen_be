class RemoveStudentsNicknameNotNullConstraint < ActiveRecord::Migration[5.2]
  def up
    change_column_null(:students, :nickname, true)
  end

  def down
    # not a reversible migration
  end
end
