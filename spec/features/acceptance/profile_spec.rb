require 'rails_helper'

include Warden::Test::Helpers

describe 'profile', type: feature do
  #self.use_transactional_fixtures = false #only necessary when using selenium with js:true
  before :each do
    @current_user = FactoryGirl.create(:user)
    login_as(@current_user, scope: :user)
  end

  it "shows only given details" do
    visit "/users/#{@current_user.id}/"
    expect(page).to have_content 'First Name'
    expect(page).to have_content 'Last Name'
    expect(page).to have_content 'Email'
    expect(page).to_not have_content 'Research Assistant'
    expect(page).to_not have_content 'Student Assistant'
    expect(page).to_not have_content 'Division'
    expect(page).to_not have_content 'Research Group'
    expect(page).to_not have_content 'Projects'
    expect(page).to_not have_content 'Street'
    expect(page).to_not have_content 'Residence'
    expect(page).to_not have_content 'Zip Code'
    expect(page).to_not have_content 'City'
    expect(page).to_not have_content 'Staff Number'
  end

  it "allows to add an personal address" do
    visit "/users/#{@current_user.id}/"
    click_on('Edit')
    fill_in('Street', :with => 'August-Bebel-Str. 89')
    fill_in('Zip Code', :with => '14482')
    fill_in('City', :with => 'Potsdam')
    click_on('Save')
    expect(page).to have_content 'Profile was successfully updated'
    expect(page).to have_content 'Street'
    expect(page).to have_content 'August-Bebel-Str. 89'
    expect(page).to have_content 'Zip Code'
    expect(page).to have_content '14482'
    expect(page).to have_content 'City'
    expect(page).to have_content 'Potsdam'
  end

  it "does not allow to change the research group" do
    visit "/users/#{@current_user.id}/edit"
    expect(page).to_not have_content 'Division'
    expect(page).to_not have_content 'Research Group'
  end
end

describe 'research assistant profile', type: feature do
  #self.use_transactional_fixtures = false #only necessary when using selenium with js:true
  before :each do
    chair = FactoryGirl.create(:chair)
    user = FactoryGirl.create(:user)

    representative = FactoryGirl.create(:user)
    FactoryGirl.create(:chair_representative, user_id: representative.id, chair_id: chair.id)

    @current_user = FactoryGirl.create(:chair_wimi, user_id: user.id, chair_id: chair.id).user
    login_as(@current_user, scope: :user)

    visit('/projects/new')
    fill_in('Title', :with => 'MyProject')
    click_on('Create Project')
  end

  it "shows status, chair and projects" do
    visit "/users/#{@current_user.id}/"
    expect(page).to have_content 'First Name'
    expect(page).to have_content 'Last Name'
    expect(page).to have_content 'Research Assistant'
    expect(page).to have_content 'Research Group'
    expect(page).to have_content 'TestChair'
    expect(page).to have_content 'Projects'
    expect(page).to have_content 'MyProject'
  end
end
