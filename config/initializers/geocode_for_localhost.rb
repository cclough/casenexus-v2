if Rails.env == 'development'
  class Rack::Request
    def ip
      '190.17.133.143'
    end
  end
end