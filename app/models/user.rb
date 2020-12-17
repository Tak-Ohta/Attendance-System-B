class User < ApplicationRecord
  has_many :attendances, dependent: :destroy #1対多の関係でattendancesと複数形にする
  
  # 「remember_token」という仮想属性を作成
  attr_accessor :remember_token
  before_save {self.email = email.downcase}
  
  validates :name, presence: true, length: {maximum: 50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 100},
                    format: { with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :department, length: {in: 2..30}, allow_blank: true
  validates :work_time, presence: true
  validates :basic_time, presence: true

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_cost
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # cookiesに保存されているremember_tokenがデータベースにあるremember_digestと一致すればtrueを返す
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了する
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
end
