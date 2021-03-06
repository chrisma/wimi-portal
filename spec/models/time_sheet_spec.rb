# == Schema Information
#
# Table name: time_sheets
#
#  id                    :integer          not null, primary key
#  month                 :integer
#  year                  :integer
#  salary                :integer
#  salary_is_per_month   :boolean
#  workload              :integer
#  workload_is_per_month :boolean
#  user_id               :integer
#  project_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  handed_in             :boolean          default(FALSE)
#  rejection_message     :text             default("")
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#  wimi_signed           :boolean          default(FALSE)
#  hand_in_date          :date
#

require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  before(:each) do
    @sheet = FactoryGirl.create(:time_sheet)
  end

  it 'sums up the right ammount of working hours' do
    time1 = Time.parse('10:00:00')
    time2 = Time.parse('11:00:00')
    time3 = Time.parse('12:00:00')
    first_day = FactoryGirl.create(:work_day, start_time: time1, end_time: time2, break: 0)
    second_day = FactoryGirl.create(:work_day, start_time: time2, end_time: time3, break: 0)

    expect(@sheet.sum_hours).to eq(2)
  end

  it 'returns nil for a TimeSheet without a Project' do
    expect(TimeSheet.time_sheet_for(@sheet.year, @sheet.month, nil, @sheet.user_id)).to eql(nil)
  end

  it 'returns a sheet for a TimeSheet' do
    expect(TimeSheet.time_sheet_for(@sheet.year, @sheet.month, @sheet.project_id, @sheet.user_id)).to eql(@sheet)
  end

  it 'creates a new sheet if no TimeSheet is found' do
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)

    expect(TimeSheet.time_sheet_for((Date.today. + 2.year).year, Date.today.month, @project, @user)).to eql((TimeSheet.where(year: (Date.today + 2.year).year, month: Date.today.month, project: @project, user: @user)).first)
  end
end
