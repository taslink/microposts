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
  
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
                                    
  has_many :follower_users, through: :follower_relationships, source: :follower

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
end
