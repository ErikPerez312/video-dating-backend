class User < ApplicationRecord
  has_and_belongs_to_many :matches
  has_many :profile_images
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :age, presence: true
  validates :phone_number, presence: true, uniqueness: true

  # 1. Hash password before saving a User
  before_save :encrypt_password
  # 2. Generate a token for authentication before creating a User
  before_create :generate_token
  # 3. Adds a virtual password field, which we will use when creating a user
  attribute :password, :string


  def self.authenticate(phone_number, password)
    user = self.find_by_phone_number(phone_number)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # Generates a token for a user
  def generate_token
    token_gen = SecureRandom.hex
    self.token = token_gen
    token_gen
  end
end
