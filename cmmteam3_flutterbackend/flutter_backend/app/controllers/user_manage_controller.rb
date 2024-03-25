class UserManageController < ApplicationController
  def update 
    m_users = MUser.find_by(id: params[:id])
    
    if m_users
      if m_users.member_status == false
       @m_us = MUser.where(id: params[:id]).update_all(member_status: true)
      else
       @m_us = MUser.where(id: params[:id]).update_all(member_status: false)
      end
      usermanage()
      render json: m_users, status: :ok
    else  
      render json: { error: 'User not found' }, status: :not_found
    end
  end

def usermanage
    @m_user = MUser.find_by(id: @current_user)
    @user_manages_activate = MUser.select("m_users.id,name,email,member_status,admin").joins("join t_user_workspaces on t_user_workspaces.id = m_users.id")
                                 .where("t_user_workspaces.id = m_users.id and admin <> 1 and member_status = 1 and t_user_workspaces.workspaceid = ?",@current_user)

    @user_manages_deactivate = MUser.select("m_users.id,name,email,member_status,admin").joins("join t_user_workspaces on t_user_workspaces.id = m_users.id")
                                   .where("t_user_workspaces.id = m_users.id and admin <> 1 and member_status = 0 and t_user_workspaces.workspaceid = ?",@current_user)

    @user_manages_admin = MUser.select("m_users.id,name,email,member_status,admin").joins("join t_user_workspaces on t_user_workspaces.id = m_users.id")
                            .where("t_user_workspaces.id = m_users.id and m_users.admin = 1 and t_user_workspaces.workspaceid = ?",@current_user)
    @m_userer = MUser.joins("INNER JOIN t_user_workspaces ON t_user_workspaces.userid = m_users.id
                            INNER JOIN m_workspaces ON m_workspaces.id = t_user_workspaces.workspaceid")
        .where("m_users.member_status = 0 OR m_users.member_status = 1  and m_workspaces.id = ?", @current_workspace)

    retrievehome
  end
end





