module RolesHelper
  def new_role_link
    link_to 'New Role', new_role_path, { :title => 'Create a new role' }
  end
  
  def show_role_link(role)
    link_to role.name, role_path(role.code),
      { :title => role.name }
  end
  
  def edit_role_link(role)
    link_to 'Edit Role', edit_role_path(role.code),
      { :title => "Edit #{role.name}" }
  end
end
