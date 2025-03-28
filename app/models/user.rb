class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :attendances, dependent: :destroy
  has_many :shift_requests, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :modifications, dependent: :destroy
  has_many :absences, dependent: :destroy
  has_one_attached :profile_image
  validates :name, presence: { message: "名前は必須です" }
  validates :email, presence: { message: "メールアドレスは必須です" }
  validates :hourly_wage, presence: { message: "時給は必須です" }
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
