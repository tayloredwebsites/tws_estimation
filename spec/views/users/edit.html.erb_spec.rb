require 'spec_helper'

describe "users/edit.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :roles => "MyString",
      :username => "MyString",
      :encrypted_password => "MyString",
      :password_salt => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_first_name", :name => "user[first_name]"
      assert_select "input#user_last_name", :name => "user[last_name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_roles", :name => "user[roles]"
      assert_select "input#user_username", :name => "user[username]"
      assert_select "input#user_encrypted_password", :name => "user[encrypted_password]"
      assert_select "input#user_password_salt", :name => "user[password_salt]"
    end
  end
  
  context 'integrated to layout' do
    it 'shows label and values using layout css'
  end
end
