require 'spec_helper'

describe "users/new.html.erb" do

  context 'renders a mock user' do
    before(:each) do
      assign(:user, stub_model(User,
        :first_name => "",
        :last_name => "",
        :email => "",
        :roles => "",
        :username => "",
        :encrypted_password => "",
        :password_salt => "",
        :deactivated => false
      ).as_new_record)
      render
    end

    it "renders all the input elements of the user form" do
      rendered.should have_xpath("//form[@action=\"#{users_path}\"][@method=\"post\"]")
      rendered.should have_xpath('//input[@id="user_first_name"][@name="user[first_name]"][@value=""]')
      rendered.should have_xpath('//input[@id="user_last_name"][@name="user[last_name]"][@value=""]')
      rendered.should have_xpath('//input[@id="user_email"][@name="user[email]"][@value=""]')
      # rendered.should have_xpath('//form//input[@id="user_roles"][@name="user[roles]"][@value=""]')
      rendered.should have_xpath('//form//input[@id="user_username"][@name="user[username]"][@value=""]')
      # rendered.should have_xpath('//form//input[@id="user_encrypted_password"][@name="user[encrypted_password]"][@value=""]')
      # rendered.should have_xpath('//form//input[@id="user_password_salt"][@name="user[password_salt]"][@value=""]')
      rendered.should have_xpath('//*[@id="user_deactivated"]', :text => "#{I18n.translate('view_text.false')}")
    end

    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('users.new.header'))
    end
    
    it 'shows label and values using layout css' do
      rendered.should have_xpath('//div[1][@class="field"]/label[@for="user_first_name"]')
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="value"]/input[@id="user_first_name"]')
    end

   end
   
end
