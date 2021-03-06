class RegistrationCreator
  class CreationError < StandardError; end

  def self.create!(parent_user, course_id, accept_release_form,
                   family_member1, family_member2 = nil,
                   family_member3 = nil, charge_amount = nil)
    new(parent_user,
      course_id,
      accept_release_form,
      family_member1,
      family_member2,
      family_member3,
      charge_amount
    ).create!
  end

  def initialize(parent_user, course_id, accept_release_form,
                 family_member1, family_member2 = nil,
                 family_member3 = nil, charge_amount = nil)
    @course_id = course_id
    @parent_user = parent_user
    @accept_release_form = accept_release_form
    @family_member1 = family_member1
    @family_member2 = family_member2
    @family_member3 = family_member3
    @charge_amount = charge_amount
  end

  def create!
    begin
      raise 'The class you\'re attempting to register has reached its size limit' if reached_class_capacity?
      raise 'You cannot register without a family member' unless family_member1_exists?
      raise 'You are attempting to register with an invalid 2nd family member' unless family_member2_exists_and_valid?
      raise 'You are attempting to register with an invalid 3rd family member' unless family_member3_exists_and_valid?
      raise 'Not all of the specified family members are from the same family' unless family_members_together?
      raise "Specified total charge amount #{charge_amount} is incorrect" if charge_amount.present? && total_due_not_matched_with_expected_pay?

      Registration.create!(registration_create_params)
    rescue => exception
      if exception.to_s.match(/uniq_klass_primary_family_membe/)
        raise CreationError.new('You cannot have your kid(s) register the same class more than once')
      else
        raise CreationError.new(exception.to_s)
      end
    end
  end

  private

  attr_reader :parent_user,
    :course_id,
    :accept_release_form,
    :family_member1,
    :family_member2,
    :family_member3,
    :charge_amount

  def reached_class_capacity?
    course.capacity_reached?
  end

  def total_due_not_matched_with_expected_pay?
    charge_amount.to_f != calculated_total_due_specification!.total
  end

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
      subtotal: calculated_total_due_specification!.course_subtotal,
      total_due: calculated_total_due_specification!.total,
      handling_fee: calculated_total_due_specification!.handling_fee,
      total_due_by: due_date,
      status: 'pending'
    }
  end

  def calculated_total_due_specification!
    @calculated_total_due_specification ||= begin
      OpenStruct.new(
        CourseFeeCalculator.calculate!(
          course,
          family_member1,
          family_member2,
          family_member3
        )
      )
    end
  end

  def course
    @course ||= Klass.reg_effective.find(course_id) 
  end

  def due_date
    Time.zone.now + 2.days 
  end
end
