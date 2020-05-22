class FamilyMember < ApplicationRecord
  belongs_to :parent
  belongs_to :student

  validates :parent_id, :student_id, presence: true

  def as_serialized_hash
    {
      id: id,
      parent_id: parent_id,
      student: {
        id: student_id,
        first_name: student.first_name,
        last_name: student.last_name,
        nickname: student.nickname,
        date_of_birth: student.date_of_birth,
        age: student.age
      },
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
