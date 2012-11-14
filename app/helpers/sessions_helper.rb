module SessionsHelper
  def sign_in(manager)
    cookies.permanent.signed[:remember_token] = [manager.id, manager.salt]
    self.current_manager = manager
  end

  def current_manager=(manager)
    @current_manager = manager
  end

  def current_manager
    @current_manager ||= manager_from_remember_token
  end

  def signed_in?
    !current_manager.nil?
  end

  private

    def manager_from_remember_token
      Manager.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
