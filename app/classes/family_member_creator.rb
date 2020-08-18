class FamilyMemberCreator
  class CreationError < StandardError; end

  def self.create!(user, student_params)
    new(user, student_params).create!
  end

  def initialize(user, student_params)
    @user = user
    @student_params = student_params
  end

  def create!
    begin
      raise 'Unable to create a family member without a parent' unless parent.present?
      raise "The specified student with name: #{student_params[:first_name]} #{student_params[:last_name]} has already been added" if parent_associated_with_this_student?
      raise 'The student has to be between age 2 and 7' if student_age < 2 || student_age > 10

      ActiveRecord::Base.transaction do
        student = create_student!
        FamilyMember.create!(parent: parent, student: student)
      end
    rescue => exception
      raise CreationError.new(exception.to_s)
    end
  end

  private

  attr_reader :student_params, :user

  def parent
    @parent ||= user.parent
  end

  def create_student!
    Student.create!(
      first_name: student_params[:first_name],
      last_name: student_params[:last_name],
      nickname: student_params[:nickname],
      date_of_birth: student_params[:date_of_birth],
      age: student_age
    ) 
  end

  def parent_associated_with_this_student?
    parent.students.where(
      first_name: student_params[:first_name],
      last_name: student_params[:last_name]
    ).exists?
  end

  def student_age
    @student_age ||= begin
      base_age = ((Time.zone.now - Time.zone.parse(student_params[:date_of_birth])) / 1.year).floor
      base_age == 0 ? 1 : base_age
    end
  end
end
