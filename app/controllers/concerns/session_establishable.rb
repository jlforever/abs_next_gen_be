module Concerns
  module SessionEstablishable
    def obtain_session_and_recognize_errors!
      if user_permitted_for_session_access?
        payload = { user_id: user.id }
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
        render json: session.login.slice(:access, :access_expires_at), status: :created
      else
        yield
      end
    end
  end
end
