class Post < ActiveRecord::Base
  attr_accessible :content, :channel_id

  belongs_to :user
  # belongs_to :channel
end
