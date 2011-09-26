require 'spec_helper'

describe "users/show.html.erb" do


  context 'has the values of a user' do
    before(:each) do
      @user = assign(:user, stub_model(User,
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :roles => "Roles",
        :username => "Username"
      ))
      render
    end

    it "renders attributes" do
      rendered.should match(/First Name/)
      rendered.should match(/Last Name/)
      rendered.should match(/Email/)
      rendered.should match(/Roles/)
      rendered.should match(/Username/)
      rendered.should have_selector('span', :text => 'Username')
    end

    it "should find the header tag content" do
      rendered.should have_selector('h4', :text => I18n.translate('users.show.header'))
    end
    
    it 'shows label and values using layout css' do
      rendered.should have_selector('div.field[1]/span.label')
      #rendered.should have_selector('div.field[1]/label')
      rendered.should have_selector('div.field[1]/span.value')
    end

  end
  
end
