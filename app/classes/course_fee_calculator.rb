class CourseFeeCalculator
  class CalculationError < StandardError; end

  def self.calculate!(course, primary_family_member, secondary_family_member = nil, tertiary_family_member = nil)
    new(course, primary_family_member, secondary_family_member, tertiary_family_member).calculate!
  end

  def initialize(course, primary_family_member, secondary_family_member, tertiary_family_member)
    @course = course
    @primary_family_member = primary_family_member
    @secondary_family_member = secondary_family_member
    @tertiary_family_member = tertiary_family_member
  end

  def calculate!
    raise CalculationError.new('Unable to calculate course cost without a specified registering student') unless primary_family_member.present?

    member1_fee + member2_fee + member3_fee
  end

  private

  attr_reader :course,
    :primary_family_member,
    :secondary_family_member,
    :tertiary_family_member

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
    @member2_fee ||= secondary_family_member.present? ? (member1_fee * (course.one_sibling_same_class_discount_rate / 100.0))  : 0
  end

  def member3_fee
    @member3_fee ||= tertiary_family_member.present? ? (member1_fee * (course.two_siblings_same_class_discount_rate / 100.0)) : 0
  end
end
