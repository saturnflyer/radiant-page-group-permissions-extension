require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::GroupsController do
  dataset :users
  
  before do
    @group_1 = Group.create!(:name => 'Z Group 1')
    @group_2 = Group.create!(:name => 'Group 1')
    @group_3 = Group.create!(:name => 'Group 2')
    @groups = [@group_2, @group_3, @group_1]
    login_as :admin
  end
  
  describe "index with GET request" do
    it "should order Groups by name" do
      get :index
      assigns(:groups).should == @groups
    end
  end

end
