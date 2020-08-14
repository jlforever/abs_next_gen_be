class RegistrationCreator
  class CreationError < StandardError; end

  def self.create!(parent_user, course_id, accept_release_form, family_member1, family_member2 = nil, family_member3 = nil)
    new(parent_user, course_id, accept_release_form, family_member1, family_member2, family_member3).create!
  end

  def initialize(parent_user, course_id, accept_release_form, family_member1, family_member2 = nil, family_member3 = nil)
    @course_id = course_id
    @parent_user = parent_user
    @accept_release_form = accept_release_form
    @family_member1 = family_member1
    @family_member2 = family_member2
    @family_member3 = family_member3
  end

  def create!
    begin
      raise 'You cannot register without a family member' unless family_member1_exists?
      raise 'You are attempting to register with an invalid 2nd family member' unless family_member2_exists_and_valid?
      raise 'You are attempting to register with an invalid 3rd family member' unless family_member3_exists_and_valid?
      raise 'Not all of the specified family members are from the same family' unless family_members_together?

      registration = Registration.create!(registration_create_params)
      RegistrationMailer.registration_confirmation(registration).deliver_now
      RegistrationMailer.aba_admin_registration_notification(registration).deliver_now
      registration
    rescue => exception
      if exception.to_s.match(/uniq_klass_primary_family_membe/)
        raise CreationError.new('You cannot have your kid(s) register the same class more than once')
      else
        raise CreationError.new(exception.to_s)
      end
    end
  end

  private

  attr_reader :parent_user, :course_id, :accept_release_form, :family_member1, :family_member2, :family_member3

  def family_member1_exists?
    family_member1.present?
  end

  def family_member2_exists_and_valid?
    family_member2.blank? || family_member1.present? 
  end

  def family_member3_exists_and_valid?
    family_member3.blank? || family_member1.present?
  end

  def family_members_together?
    unique_user_ids = [
      family_member1.parent.user_id,
      family_member2&.parent&.user_id,
      family_member3&.parent&.user_id
    ].compact.uniq

    unique_user_ids.size == 1 && unique_user_ids.first == parent_user.id
  end

  def registration_create_params
    {
      klass_id: course.id,
      accept_release_form: accept_release_form,
      primary_family_member_id: family_member1.id,
      secondary_family_member_id: family_member2&.id,
      tertiary_family_member_id: family_member3&.id,
      total_due: calculated_total_due,
      total_due_by: due_date,
      status: 'pending'
    } 
  end

  def calculated_total_due
    member1_fee + member2_fee + member3_fee
  end

  def per_student_cost
    course.per_session_student_cost 
  end

  def outstanding_sessions_size
    course.remaining_session_dates_from_reference_date(Time.zone.now).size
  end

  def member1_fee
    @member1_fee ||= per_student_cost * outstanding_sessions_size
  end

  def member2_fee
    @member2_fee ||= family_member2.present? ? (member1_fee * (course.one_sibling_same_class_discount_rate / 100.0))  : 0
  end

  def member3_fee
    @member3_fee ||= family_member3.present? ? (member1_fee * (course.two_siblings_same_class_discount_rate / 100.0)) : 0
  end

  def course
    @course ||= Klass.reg_effective.find(course_id) 
  end

  def due_date
    Time.zone.now + 5.days 
  end
end
