class AddAssociateTeachingSessionReferenceToClassSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :class_sessions, :associate_teaching_session_id, :bigint
    add_index :class_sessions, :associate_teaching_session_id
    add_foreign_key :class_sessions, :teaching_sessions, column: 'associate_teaching_session_id'
  end
end
