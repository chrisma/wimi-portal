require 'rails_helper'

describe 'working hours chart' do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @project = FactoryGirl.create(:project, title: 'Working Hours Project')
    @hiwi1 = FactoryGirl.create(:user)
    @hiwi2 = FactoryGirl.create(:user)
    @project.users << @hiwi1
    @project.users << @hiwi2
  end

  it 'shows the working hours chart to the chair representative' do
    representative_user = FactoryGirl.create(:user)
    representative = FactoryGirl.create(:chair_representative, user: representative_user, chair: @chair)
    login_as representative_user

    visit projects_path
    expect(page).to have_css('div#hiwiWorkingHoursChart')
  end

  it 'does not show the working hours chart to a hiwi' do
    login_as @hiwi1
    visit projects_path
    expect(page).to_not have_css('div#hiwiWorkingHoursChart')
  end
end
