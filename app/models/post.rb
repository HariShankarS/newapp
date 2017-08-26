class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  acts_as_votable
  validates_presence_of :user_id, :message
  act_as_mentioner
end
