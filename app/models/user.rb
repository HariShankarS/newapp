class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :comments, through: :posts
  acts_as_voter
  validates :name, { presence: true, uniqueness: true }
  validate :name_alphanumeric

  def name_alphanumeric
  	if (name.length - name.gsub(/[^0-9a-z]/i, '').length) != 0 
  	  errors.add(:name, "Only Alphanumeric Characters allowed")
  	end
  end
  act_as_mentionee

end
