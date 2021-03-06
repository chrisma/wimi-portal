require 'rails_helper'
require 'spec_helper'

describe WorkDaysController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @project = FactoryGirl.create(:project)
  end

  let(:valid_attributes) {
    {date: Date.today, start_time: Time.now.middle_of_day, end_time: Time.now.middle_of_day + 2.hour, break: 10, attendance: '', notes: 'some note', user_id: @user.id, project_id: @project.id}
  }

  let(:invalid_attributes) {
    {date: Date.today, start_time: Time.now.middle_of_day, end_time: Time.now.middle_of_day + 2.hour, break: nil, attendance: '', notes: 'some note', user_id: @user.id}
  }

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns work_days for this month as @work_days' do
      work_day = WorkDay.create! valid_attributes
      get :index, {month: Date.today.month, year: Date.today.year, user_id: @user.id}, valid_session
      expect(assigns(:work_days)).to eq([work_day])
    end

    it 'shows work_days for month and project' do
      work_day = WorkDay.create! valid_attributes
      get :index, {month: Date.today.month, year: Date.today.year, user_id: @user.id, project_id: @project.id}, valid_session
      expect(assigns(:work_days)).to eq([work_day])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested work_day as @work_day' do
      work_day = WorkDay.create! valid_attributes
      get :show, {id: work_day.to_param}, valid_session
      expect(assigns(:work_day)).to eq(work_day)
    end
  end

  describe 'GET #new' do
    it 'assigns a new work_day as @work_day' do
      get :new, {}, valid_session
      expect(assigns(:work_day)).to be_a_new(WorkDay)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested work_day as @work_day' do
      work_day = WorkDay.create! valid_attributes
      get :edit, {id: work_day.to_param}, valid_session
      expect(assigns(:work_day)).to eq(work_day)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new WorkDay' do
        expect {
          post :create, {work_day: valid_attributes}, valid_session
        }.to change(WorkDay, :count).by(1)
      end

      it 'assigns a newly created work_day as @work_day' do
        post :create, {work_day: valid_attributes}, valid_session
        expect(assigns(:work_day)).to be_a(WorkDay)
        expect(assigns(:work_day)).to be_persisted
      end

      it 'redirects to the time_sheet for the work_days month and project' do
        post :create, {work_day: valid_attributes}, valid_session
        expect(response).to redirect_to(work_days_path(month: Date.today.month, year: Date.today.year, user_id: @user.id, project: @project.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved work_day as @work_day' do
        post :create, {work_day: invalid_attributes}, valid_session
        expect(assigns(:work_day)).to be_a_new(WorkDay)
      end

      it "re-renders the 'new' template" do
        post :create, {work_day: invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {date: Date.today, start_time: Time.now.middle_of_day - 1.hour, end_time: Time.now.middle_of_day + 2.hour, break: 20, attendance: '', notes: 'some note', user_id: @user.id}
      }

      it 'updates the requested work_day' do
        work_day = WorkDay.create! valid_attributes
        put :update, {id: work_day.to_param, work_day: new_attributes}, valid_session
        work_day.reload
        expect(work_day.start_time.hour).to equal((Time.now.middle_of_day - 1.hour).hour)
        expect(work_day.break).to equal(20)
      end

      it 'assigns the requested work_day as @work_day' do
        work_day = WorkDay.create! valid_attributes
        put :update, {id: work_day.to_param, work_day: valid_attributes}, valid_session
        expect(assigns(:work_day)).to eq(work_day)
      end

      it 'redirects to the time_sheet for the work_days month and project' do
        work_day = WorkDay.create! valid_attributes
        put :update, {id: work_day.to_param, work_day: valid_attributes}, valid_session
        expect(response).to redirect_to(work_days_path(month: Date.today.month, year: Date.today.year, user_id: @user.id, project: @project.id))
      end
    end

    context 'with invalid params' do
      it 'assigns the work_day as @work_day' do
        work_day = WorkDay.create! valid_attributes
        put :update, {id: work_day.to_param, work_day: invalid_attributes}, valid_session
        expect(assigns(:work_day)).to eq(work_day)
      end

      it "re-renders the 'edit' template" do
        work_day = WorkDay.create! valid_attributes
        put :update, {id: work_day.to_param, work_day: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested work_day' do
      work_day = WorkDay.create! valid_attributes
      expect {
        delete :destroy, {id: work_day.to_param}, valid_session
      }.to change(WorkDay, :count).by(-1)
    end

    it 'redirects to the work_days list for current month' do
      work_day = WorkDay.create! valid_attributes
      delete :destroy, {id: work_day.to_param}, valid_session
      expect(response).to redirect_to(work_days_path(month: work_day.date.month, year: work_day.date.year, project: @project.id, user_id: @user.id))
    end
  end
end
