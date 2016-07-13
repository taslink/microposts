class User < ActiveRecord::Base
  
  #データの保存前にメールアドレスのアルファベットを小文字に
  before_save { self.email = self.email.downcase }
  
  #nameは空でなく、また、最大50文字
  validates :name, presence: true, length: { maximum: 50 }
  
  #メールアドレスの正規表現パターンを定義
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  #emailは空でなく、255文字以内で、VALID_EMAIL_REGEXのパターンに一致し、他と異なる
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  # 自己紹介は255文字以下
  validates :profile , length: { maximum: 255 } 
  # 所在地は255文字以下
  validates :location , length: { maximum: 255 } 
  
end
