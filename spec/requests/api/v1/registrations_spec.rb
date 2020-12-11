require 'rails_helper'

describe Api::V1::RegistrationsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'emmee11133!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:parent2) { create(:parent, user: user2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days, reg_effective_from: Time.zone.now - 3.days, reg_effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 3.days, effective_until: Time.zone.now + 10.days, reg_effective_from: Time.zone.now + 3.days, reg_effective_until: Time.zone.now + 10.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:student2) { create(:student, first_name: 'Sammy', last_name: 'Duncan') }
  let!(:student3) { create(:student, first_name: 'Marshall', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:family_member2) { create(:family_member, parent: parent2, student: student2) }
  let!(:family_member3) { create(:family_member, parent: parent, student: student3) }
  let(:params) do
    {
      user_email: user.email,
      registration: {
        course_id: class1.id,
        accept_release_form: true,
        secondary_family_member_id: family_member1
      }
    }
  end

  let!(:charge_amount_request_params) do
    {
      user_email: user.email,
      charge_amount_request: {
        course_id: class1.id,
        primary_family_member_id: family_member1.id,
        secondary_family_member_id: family_member2.id
      }
    }
  end

  before do
    establish_valid_token!(user)
  end

  describe '#charge_amount' do
    it 'properly calculates the course fee for a given set of registering family members' do
      post '/api/v1/registrations/charge_amounts', params: charge_amount_request_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body).with_indifferent_access

      expect(body[:amount_specification][:course_subtotal]).to eq 6000
      expect(body[:amount_specification][:handling_fee]).to eq 0
      expect(body[:amount_specification][:total]).to eq 6000
    end
  end

  describe '#class_sessions' do
    let!(:registration_1) { create(:registration, klass: class1, primary_family_member: family_member1) }
    let!(:registration_2) { create(:registration, klass: class1, primary_family_member: family_member2) }
    let!(:class_sessions) do
      registration_1.klass.expected_session_dates.map do |specific_date|
        create(:class_session, registration: registration_1, effective_for: specific_date)
      end
    end

    it 'raises unauthorized error' do
      get "/api/v1/registrations/#{registration_2.id}/class_sessions", headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      expect(JSON.parse(response.body).with_indifferent_access[:errors][:registered_class_session_retrieval_error]).
        to match(/unable to retrieve registered class's sessions/)
    end

    it 'retrieves the registration specific class sessions' do
      get "/api/v1/registrations/#{registration_1.id}/class_sessions", headers: { 'Authorization' => "Bearer #{@token.access}" }
      body = JSON.parse(response.body).with_indifferent_access
      expect(body['class_sessions'].size).
        to eq class_sessions.size
      session1 = body['class_sessions'].first
      expect(ClassSession.find(session1['id']).registration).
        to eq registration_1
      expect(session1['individual_session_starts_at']).
        to eq registration_1.klass.individual_session_starts_at
    end

    it 'raises registration passed and cannot get class sessions' do
      registration_1.update(status: 'passed')
      get "/api/v1/registrations/#{registration_1.id}/class_sessions", headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      expect(JSON.parse(response.body).with_indifferent_access['errors']['registered_class_session_retrieval_error']).
        to eq 'Registration passed: unable to get class sessions for a passed registration'
    end
  end

  describe '#index' do
    let!(:registration_1) { create(:registration, klass: class1, primary_family_member: family_member1) }
    let!(:registration_2) { create(:registration, klass: class2, primary_family_member: family_member1, secondary_family_member_id: family_member3) }
    let!(:registration_3) { create(:registration, klass: class1, primary_family_member: family_member3, status: 'failed') }
    let!(:registration_4) { create(:registration, klass: class2, primary_family_member: family_member3, status: 'passed') }

    it 'retrieves the parent user\'s registration for the family members' do
      get '/api/v1/registrations', params: { user_email: user.email }, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 200
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:registrations].map { |r| r[:id] }).to match_array([registration_1.id, registration_2.id])
    end

    it 'raises unauthorized error' do
      get '/api/v1/registrations', params: { user_email: user2.email }, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 500
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:errors][:registrations_retrieval_error]).
        to eq "Unauthorized access: unable to retrieve registrations with email: #{user2.email}"
    end
  end

  describe '#create' do
    before do
      @fake_mailer = double('fake_mailer', deliver_now: nil)
      allow(RegistrationMailer).to receive(:registration_confirmation).and_return(@fake_mailer)
      allow(RegistrationMailer).to receive(:aba_admin_registration_notification).and_return(@fake_mailer)
    end

    context 'when class capacity has been reached' do
      let!(:students) do
        (0..19).to_a.map do |num|
          create(:student, first_name: "Sam_#{num}", last_name: 'Holch_#{num}')
        end
      end
      let!(:family_members) do
        students.map do |a_student|
          create(:family_member, parent: parent, student: a_student)
        end
      end
      let!(:paid_registrations) do
        family_members.each do |a_family_member|
          create(:registration, klass: class1, primary_family_member: a_family_member, status: 'paid')
        end
      end

      it 'prevents the registration from completing' do
        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        expect(JSON.parse(response.body).with_indifferent_access[:errors][:registration_creation_error]).
          to match(/attempting to register has reached its size limit/)
      end
    end

    context 'when first family members is missing' do
      it 'raises an error indicating no primary family member' do
        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        expect(JSON.parse(response.body).with_indifferent_access[:errors][:registration_creation_error]).
          to eq 'You cannot register without a family member'
      end
    end

    context 'when family members do not belong to the same family' do
      it 'raises an error indicating family member do not belong together' do
        params[:registration][:primary_family_member_id] = family_member1.id
        params[:registration][:secondary_family_member_id] = family_member2.id
        params[:registration][:tertiary_family_member_id] = family_member3.id

        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        expect(JSON.parse(response.body).with_indifferent_access[:errors][:registration_creation_error]).
          to eq 'Not all of the specified family members are from the same family'
      end
    end

    context 'when attempt to registered class is not effective' do
      it 'raises a class not found error' do
        params[:registration][:primary_family_member_id] = family_member1.id
        params[:registration][:secondary_family_member_id] = family_member3.id
        params[:registration][:course_id] = class2.id

        post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
        expect(response.status).to eq 500
        body = JSON.parse(response.body).with_indifferent_access
        expect(body[:errors][:registration_creation_error]).to match(/Couldn't find Klass/)
      end
    end

    it 'registers a course for a given set of family members' do
      params[:registration][:primary_family_member_id] = family_member1.id
      params[:registration][:secondary_family_member_id] = family_member3.id

      post '/api/v1/registrations', params: params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      expect(response.status).to eq 201
      body = JSON.parse(response.body).with_indifferent_access
      expect(body[:registration][:course][:id]).to eq params[:registration][:course_id]
      expect(body[:registration][:primary_family_member_id]).to eq family_member1.id
      expect(body[:registration][:secondary_family_member_id]).to eq family_member3.id
      expect(body[:registration][:total_due]).to eq 6000
      expect(body[:registration][:accept_release_form]).to be_truthy
      registration = Registration.last
      expect(RegistrationMailer).to have_received(:registration_confirmation).with(registration)
      expect(RegistrationMailer).to have_received(:aba_admin_registration_notification).with(registration)
    end
  end
end
