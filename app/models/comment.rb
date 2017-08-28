class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  validates_presence_of :user_id, :post_id, :comment_text
  acts_as_votable
end
