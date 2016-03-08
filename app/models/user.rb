class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, foreign_key: :user_id, dependent: :destroy
  has_many :posts
  after_initialize :set_default_role, if:  :new_record?

  def set_default_role
    self.role ||= "user"
  end
end
