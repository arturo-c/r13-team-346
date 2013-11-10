class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :authentications, :dependent => :delete
  has_and_belongs_to_many :games
  has_many :tweets
  has_many :comments
  has_many :notifications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :location, :type => String
  field :handle, :type => String
  field :image, :type => String
  field :url, :type => String
  field :twitter_id, :type => Integer
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ handle: 1 }, { unique: true, background: true })
  field :name, :type => String
  validates_presence_of :name
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  def apply_omniauth(omniauth)
    info = omniauth['info']
    self.handle = info['nickname'] if handle.blank?
    self.name = info['name']
    self.email = info['nickname'] + '@twitter.com'
    self.location = info['location']
    self.image = info['image']
    self.url = info['urls']['Twitter']
    self.twitter_id = omniauth['uid'].to_i
    apply_trusted_services(omniauth) if self.new_record?
  end

  def apply_trusted_services(omniauth)
    user_info = omniauth['info']
    self.password, self.password_confirmation = String::RandomString(16)
    self.confirmed_at, self.confirmation_sent_at = Time.now
  end
end
