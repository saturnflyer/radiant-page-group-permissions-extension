require_dependency 'model_extensions'
require_dependency 'controller_extensions'

# Uncomment this if you reference any of your controllers in activate
begin
  require_dependency 'application_controller'
rescue MissingSourceFile
  require_dependency 'application'
end

class PageGroupPermissionsExtension < Radiant::Extension
  version "0.2"
  description "Allows you to organize your users into groups and apply group based edit permissions to the page heirarchy."
  url "http://matt.freels.name"
  
  define_routes do |map|
    if Group.table_exists?
      map.namespace :admin do |admin|
        admin.resources :groups
      end
      map.with_options(:controller => 'admin/groups') do |group|
        group.remove_admin_group 'admin/groups/:id/remove', :action => 'remove', :conditions => {:method => :get}
        group.add_member_admin_group 'admin/groups/:id/add_member', :action => 'add_member', :conditions => {:method => :post}
        group.remove_member_admin_group 'admin/groups/:group_id/remove_member/:id', :action => 'remove_member'
      end
    end
  end
  
  def activate
    if Group.table_exists?
      User.module_eval &UserModelExtensions
      Page.module_eval &PageModelExtensions
      Admin::PagesController.module_eval &PageControllerExtensions
      UserActionObserver.instance.send :add_observer!, Group
      
      # admin.tabs is deprecated with 0.9
      if Radiant::Version.to_s >= "0.9.0"
        add_tab "Settings" do
          add_item "Groups", "/admin/groups", :after => "Users", :visibility => [:admin]
        end
      else
        admin.tabs.add "Groups", "/admin/groups", :after => "Layouts", :visibility => [:admin]
      end
      admin.pages.index.add :node, "page_group_td", :before => "status_column"
      admin.pages.index.add :sitemap_head, "page_group_th", :before => "status_column_header"
      admin.pages.edit.add :parts_bottom, "page_group_form_part", :after => "edit_timestamp"
    end
  end
  
  def deactivate
  end
  
end