module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappigns[:user]
    sign_in(user)
  end
end
