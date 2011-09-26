require 'spec_helper'

describe "users/edit.html.erb" do

  context 'has a the input fields for a user' do
    before(:each) do
      @user = assign(:user, stub_model(User,
        :first_name => "MyString",
        :last_name => "MyString",
        :email => "MyString",
        :roles => "MyString",
        :username => "MyString",
        :encrypted_password => "MyString",
        :password_salt => "MyString",
        :deactivated => false
      ))
      render
    end

    it "renders all the input elements of the user form" do
      rendered.should have_xpath("//form[@action=\"#{user_path(@user)}\"][@class=\"edit_user\"][@method=\"post\"]")
      rendered.should have_xpath('//form//input[@id="user_first_name"][@name="user[first_name]"][@value="MyString"]')
      rendered.should have_xpath('//form//input[@id="user_last_name"][@name="user[last_name]"][@value="MyString"]')
      rendered.should have_xpath('//form//input[@id="user_email"][@name="user[email]"][@value="MyString"]')
      # rendered.should have_xpath('//form//input[@id="user_roles"][@name="user[roles]"][@value="MyString"]')
      rendered.should have_xpath('//form//input[@id="user_username"][@name="user[username]"][@value="MyString"]')
      # rendered.should have_xpath('//form//input[@id="user_encrypted_password"][@name="user[encrypted_password]"][@value="MyString"]')
      # rendered.should have_xpath('//form//input[@id="user_password_salt"][@name="user[password_salt]"][@value="MyString"]')
      rendered.should have_xpath('//*[@id="user_deactivated"]', :text => "#{I18n.translate('view_text.false')}")
      
    end

    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('users.edit.header'))
    end
    
    it 'shows label and values using layout css' do
      rendered.should have_xpath('//div[1][@class="field"]/label[@for="user_first_name"]')
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="value"]/input[@id="user_first_name"]')
    end

  end
  
end
