class ChannelsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  validates_uniqueness_of :channel_id, :scope => :user_id
end
