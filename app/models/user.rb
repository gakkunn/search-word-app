class User < ApplicationRecord
  has_many :blocks, dependent: :destroy
  before_save :set_dummy_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable

  validates :name, presence: true,
                  uniqueness: { case_sensitive: false },
                  length: { maximum: 50 } 
  validates :password, 
            presence: true,
            length: { in: 6..150 },
            confirmation: true

  private
    def set_dummy_email
      self.email = generate_unique_email
    end

    def generate_unique_email
      loop do
        random_email = "#{SecureRandom.hex(4)}@dummy.com"
        break random_email unless User.exists?(email: random_email)
      end
    end
end
