class SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    @login = resource
    render template: '/static_pages/home'
  end
end
