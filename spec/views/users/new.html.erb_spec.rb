require 'spec_helper'

describe "users/new.html.erb" do
  before(:each) do
    assign(:user, stub_model(User,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :roles => "MyString",
      :username => "MyString",
      :encrypted_password => "MyString",
      :password_salt => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_first_name", :name => "user[first_name]"
      assert_select "input#user_last_name", :name => "user[last_name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_roles", :name => "user[roles]"
      assert_select "input#user_username", :name => "user[username]"
      assert_select "input#user_encrypted_password", :name => "user[encrypted_password]"
      assert_select "input#user_password_salt", :name => "user[password_salt]"
    end
  end
end
