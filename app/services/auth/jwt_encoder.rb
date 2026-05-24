module Auth
  class JwtEncoder
    SECRET_KEY = Rails.application.credentials.secret_key_base

    def self.call(payload)
      JWT.encode(payload, SECRET_KEY)
    end
  end
end
