class Comment
  include Mongoid::Document

  field :comment, type: String
  field :date_time, type: DateTime

  belongs_to :game
  belongs_to :user

  validates_presence_of :comment
end