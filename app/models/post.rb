class Post < ActiveRecord::Base
  STATUS_TITLE = {
    "draft" => "Drafts",
    "pending" => "Waiting for review",
    "reviewed" => "Reviewed",
    "published" => "Published",
  }.freeze
  STATUSES = STATUS_TITLE.keys.freeze

  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  after_initialize :set_default_status, if:  :new_record?
  validates :status, inclusion: { in: STATUSES }

  scope :ordered, -> { order(created_at: :desc) }

  STATUSES.each do |status|
    scope status, -> { where(status: status) }
  end

  def author
    user.try(:email) || "Anonymous"
  end

  def set_default_status
    self.status ||= "draft"
  end
end
