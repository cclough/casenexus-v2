class Post < ActiveRecord::Base
  attr_accessible :user, :content, :channel_id

  belongs_to :user
  # belongs_to :channel

  def content_trunc
    content.truncate(17, separator: ' ')
  end

end
