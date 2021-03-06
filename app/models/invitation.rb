# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sender_id  :integer
#

class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :sender, class_name: 'User'
end
