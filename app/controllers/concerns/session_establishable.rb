module Concerns
  module SessionEstablishable
    def obtain_session_and_recognize_errors!
      Rails.logger.info "hello I am in authentication now"
      if user_permitted_for_session_access?
        payload = { user_id: user.id }
        Rails.logger.info "intended to login email: #{user.email}"
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        Rails.logger.info "#{session}"
        render json: session.login.slice(:access, :access_expires_at), status: :created
      else
        yield
      end
    end
  end
end
