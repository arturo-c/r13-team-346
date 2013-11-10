class Notification
  include Mongoid::Document

  field :message, type: String
  field :game_admin_id, type: Integer
  field :notifier_image, type: String
  field :notifier_handle, type: String
  field :notifier_game, type: String
  field :notifier_date_time, type: DateTime
  field :flag_read, type: Boolean

end