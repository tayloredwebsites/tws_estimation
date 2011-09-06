require 'spec_helper'

describe "users/show.html.erb" do


  context 'has the values of a user' do
    before(:each) do
      @user = assign(:user, stub_model(User,
        :first_name => "First Name",
        :last_name => "Last name",
        :email => "Email",
        :roles => "Roles",
        :username => "Username"
      ))
      render
    end

    it "renders attributes" do
      rendered.should have_xpath('//span[@class="label"]', :text => 'First Name')
      rendered.should have_xpath('//span[@class="label"]', :text => 'Last name')
      rendered.should have_xpath('//span[@class="label"]', :text => 'Email')
      rendered.should have_xpath('//span[@class="label"]', :text => 'Roles')
      rendered.should have_xpath('//span[@class="label"]', :text => 'Username')
    end

    it "should find the header tag content" do
      rendered.should have_xpath('//h4', :text => I18n.translate('users.show.header'))
    end
    
    it 'shows label and values using layout css' do
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="label"]', :text => 'First Name')
      rendered.should have_xpath('//div[1][@class="field"]/span[@class="value"]', :text => 'First Name')
    end

  end
  
end
