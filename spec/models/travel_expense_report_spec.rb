require 'rails_helper'

RSpec.describe TravelExpenseReport, type: :model do
  before :each do
    @Report = FactoryGirl.create(:travel_expense_report, :user => FactoryGirl.create(:user))
  end

  context "with valid input" do
    it "creates a valid report" do
      expect(TravelExpenseReport.first).to eq(@Report)
    end
    it 'has access to name of the user' do
      expect(@Report.first_name).to eq(User.first.first_name)
      expect(@Report.last_name).to eq(User.first.last_name)
    end
    it 'has access to signature of the user' do
      expect(@Report.get_signature).to eq(User.first.signature)
    end
  end

  context "with invalid input" do
    it "rejects wrong dates" do
      expect(FactoryGirl.build(:travel_expense_report_wrong_dates).valid?).to be false
    end
    it "rejects negative advances" do
      expect(FactoryGirl.build(:travel_expense_report_negative_advance).valid?).to be false
    end
  end
end