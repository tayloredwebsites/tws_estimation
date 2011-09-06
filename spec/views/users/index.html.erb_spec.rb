require 'spec_helper'

describe "users/index.html.erb" do

  context 'has a table listing users' do
    before(:each) do
      assign(:users, [
        stub_model(User,
          :first_name => "First Name",
          :last_name => "Last Name",
          :email => "Email",
          :roles => "Roles",
          :username => "Username",
          :encrypted_password => "Encrypted Password",
          :password_salt => "Password Salt"
        ),
        stub_model(User,
          :first_name => "First Name",
          :last_name => "Last Name",
          :email => "Email",
          :roles => "Roles",
          :username => "Username",
          :encrypted_password => "Encrypted Password",
          :password_salt => "Password Salt"
        )
      ])
      render
    end

    it "renders a table of users" do
      rendered.should have_xpath('//table/tr/td', :text => 'First Name'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Last Name'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Email'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Roles'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Username'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Encrypted Password'.to_s, :count => 2)
      rendered.should have_xpath('//table/tr/td', :text => 'Password Salt'.to_s, :count => 2)
    end

    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('users.index.header'))
    end
    
    it "should show a styled table of users" do
      rendered.should have_xpath('//table[@cellspacing="0"]', :count => 1)
      rendered.should have_xpath('//table/tr[@class="odd"]', :count => 1)
      rendered.should have_xpath('//table/tr[@class="even"]', :count => 1)
    end

  end
  
end
