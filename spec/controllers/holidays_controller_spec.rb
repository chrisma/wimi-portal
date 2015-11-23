require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe HolidaysController, type: :controller do
  before(:each) do
    login_with create ( :user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Holiday. As you add validations to Holiday, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    #skip('Add a hash of attributes valid for your model')
    {start: Date.today, end: Date.today+1, user_id: 1}
  }

  let(:invalid_attributes) {
    #skip('Add a hash of attributes invalid for your model')
    {start: Date.today-1, end: Date.today, user_id: 1}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # HolidaysController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all holidays as @holidays' do
      holiday = Holiday.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:holidays)).to eq([holiday])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested holiday as @holiday' do
      holiday = Holiday.create! valid_attributes
      get :show, {id: holiday.to_param}, valid_session
      expect(assigns(:holiday)).to eq(holiday)
    end
  end

  describe 'GET #new' do
    it 'assigns a new holiday as @holiday' do
      get :new, {}, valid_session
      expect(assigns(:holiday)).to be_a_new(Holiday)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested holiday as @holiday' do
      holiday = Holiday.create! valid_attributes
      get :edit, {id: holiday.to_param}, valid_session
      expect(assigns(:holiday)).to eq(holiday)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Holiday' do
        expect {
          post :create, {holiday: valid_attributes}, valid_session
        }.to change(Holiday, :count).by(1)
      end

      it 'assigns a newly created holiday as @holiday' do
        post :create, {holiday: valid_attributes}, valid_session
        expect(assigns(:holiday)).to be_a(Holiday)
        expect(assigns(:holiday)).to be_persisted
      end

      it 'redirects to the created holiday' do
        post :create, {holiday: valid_attributes}, valid_session
        expect(response).to redirect_to(Holiday.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved holiday as @holiday' do
        post :create, {holiday: invalid_attributes}, valid_session
        expect(assigns(:holiday)).to be_a_new(Holiday)
      end

      it "re-renders the 'new' template" do
        post :create, {holiday: invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested holiday' do
        holiday = Holiday.create! valid_attributes
        put :update, {id: holiday.to_param, holiday: new_attributes}, valid_session
        holiday.reload
        #skip('Add assertions for updated state')
        expect(holiday.status).to eq('Active')
      end

      it 'assigns the requested holiday as @holiday' do
        holiday = Holiday.create! valid_attributes
        put :update, {id: holiday.to_param, holiday: valid_attributes}, valid_session
        expect(assigns(:holiday)).to eq(holiday)
      end

      it 'redirects to the holiday' do
        holiday = Holiday.create! valid_attributes
        put :update, {id: holiday.to_param, holiday: valid_attributes}, valid_session
        expect(response).to redirect_to(holiday)
      end
    end

    context 'with invalid params' do
      it 'assigns the holiday as @holiday' do
        holiday = Holiday.create! valid_attributes
        put :update, {id: holiday.to_param, holiday: invalid_attributes}, valid_session
        expect(assigns(:holiday)).to eq(holiday)
      end

      it "re-renders the 'edit' template" do
        holiday = Holiday.create! valid_attributes
        put :update, {id: holiday.to_param, holiday: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested holiday' do
      holiday = Holiday.create! valid_attributes
      expect {
        delete :destroy, {id: holiday.to_param}, valid_session
      }.to change(Holiday, :count).by(-1)
    end

    it 'redirects to the holidays list' do
      holiday = Holiday.create! valid_attributes
      delete :destroy, {id: holiday.to_param}, valid_session
      expect(response).to redirect_to(holidays_url)
    end
  end
end
