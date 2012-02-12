module ApplicationHelper

  def cur_user_full_name
    @user_session.current_user_full_name
  end
  
  def cur_user_id
    @user_session.current_user_id
  end
  
  def cur_user
    #Rails.logger.debug("* ApplicationHelper - cur_user - session: #{@user_session.inspect.to_s}")
    #Rails.logger.debug("* ApplicationHelper - cur_user - cur_user: #{@user_session.current_user.inspect.to_s}")
    @user_session.current_user
  end
  
  def clear_session
    session[:current_user_id] = nil
    @user_session = UserSession.new (session)
  end
    
  def get_session_info
    @user_session.get_session_info
  end
      
  def cur_system
    Rails.logger.debug("* ApplicationHelper.cur_system - @systemc:#{@systemc}")
    @systemc
  end
  
  def session_info(key)
    @user_session.info(key.to_sym)
  end
  
  def show_deactivated?
    Rails.logger.debug("* ApplicationHelper.show_deactivated? info(show_deactivated):#{@user_session.info(:show_deactivated).inspect}")
    @user_session.info(:show_deactivated) == DB_TRUE
  end
  def dont_show_deactivated
    @user_session.set_info(:show_deactivated, DB_FALSE)
    Rails.logger.debug("* ApplicationHelper.dont_show_deactivated info(show_deactivated):#{@user_session.info(:show_deactivated).inspect}")
  end
  def show_deactivated
    @user_session.set_info(:show_deactivated, DB_TRUE)
    Rails.logger.debug("* ApplicationHelper.show_deactivated info(show_deactivated):#{@user_session.info(:show_deactivated).inspect}")
  end
  
end
