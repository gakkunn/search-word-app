class User < ApplicationRecord
  has_many :blocks, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 } 
end
