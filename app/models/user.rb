class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  ROLES = %w[
    user
    admin
    writer
    editor
  ].freeze
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, foreign_key: :user_id, dependent: :destroy
  has_many :posts

  validates :role, inclusion: { in: ROLES }

  after_initialize :set_default_role, if:  :new_record?

  def set_default_role
    self.role ||= "user"
  end
end
