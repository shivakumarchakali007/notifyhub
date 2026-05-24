module Auth
  class JwtDecoder
    SECRET_KEY = Rails.application.credentials.secret_key_base

    def self.call(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]

      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError
      nil
    end
  end
end
