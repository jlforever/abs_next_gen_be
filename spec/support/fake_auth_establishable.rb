module FakeAuthEstablishable
  def establish_session!(user, establish_time)
  	Timecop.freeze(establish_time) do
  		session = JWTSessions::Session.new(payload: { user_id: user.id }, refresh_by_access_allowed: true)
  		data = session.login.slice(:access, :access_expires_at).with_indifferent_access
  	
  		OpenStruct.new(access: data[:access], access_expires_at: data[:access_expires_at])
  	end
  end
end
