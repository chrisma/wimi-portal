require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    assign(:projects, [
      FactoryGirl.create(:project),
      FactoryGirl.create(:project)
    ])
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  it 'renders a list of projects' do
    render
  end

  it 'does not show private projects that I do not belong to' do
    chair = FactoryGirl.create(:chair)
    chair2 = FactoryGirl.create(:chair)
    @user.update(chair: chair)
    not_my_project = FactoryGirl.create(:project, title: 'I should not see this project', public: false, chair: chair2)

    visit projects_path

    expect(page).to_not have_content(not_my_project.title)
  end

  it 'shows private projects that I do not belong to if I am representative of the chair' do
    chair = FactoryGirl.create(:chair)
    @user.update(chair: chair)
    FactoryGirl.create(:wimi, user: @user, representative: true)
    not_my_project = FactoryGirl.create(:project, title: 'I should not see this project', public: false, chair: chair)

    visit projects_path

    expect(page).to have_content(not_my_project.title)
  end

  it 'shows private projects that I belong to' do
    chair = FactoryGirl.create(:chair)
    @user.update(chair: chair)
    my_project = FactoryGirl.create(:project, title: 'I should see this project', public: false, chair: chair)
    my_project.users << @user

    visit projects_path

    expect(page).to have_content(my_project.title)
  end

  it 'shows all details about a project' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project, chair: chair)
    project.users << @user

    project.update(status: true)
    project.update(public: true)

    visit projects_path

    expect(page).to have_content(project.title)
    expect(page).to have_content(l(project.created_at))
    expect(page).to have_content(chair.name)

    expect(page).to have_content(I18n.t('projects.index.public'))
    expect(page).to have_content(I18n.t('projects.index.status_true'))

    project.update(status: false)
    project.update(public: false)
    visit projects_path

    expect(page).to have_content(I18n.t('projects.index.status_false'))
    expect(page).to have_content(I18n.t('projects.index.private'))
  end

  it 'denies the superadmin the the list of projects' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit projects_path
    expect(current_path).to eq(dashboard_path)
  end
end
