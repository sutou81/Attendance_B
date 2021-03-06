class User < ApplicationRecord
  # attendanceモデルとの関係性1人のユーザーに対して、attendanceのレコードは多→1：多の関係性を示すもの
  # ↑の理由から複数形(attendances)
  has_many :attendances, dependent: :destroy
  # 「remember_token」という仮想の属性を作成します。
  # has_secure_passwordでは自動的にpasswordカラムを仮想属性として扱えるようにする→
  # →機能がありましたが、今回はそのような機能はありません。それが、attr_accessor :remember_token
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true  
  # inオプションを指定:「2文字以上かつ30文字以下」という検証を追加することができます。
  # allow_blank: true→空文字""の場合バリデーションをスルー
  # 上記の続き:存在性の検証を入れていないことから、空の状態で送信し、2文字上の検証に引っかからないようにするために追加
  validates :department, length: {in: 2..30}, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  # allow_nil:これでは新規作成の時もパスワードのバリデーションがスルーされてしまうのでは？
  # has_secure_passwordがオブジェクト生成時に存在性を検証するようになっています。
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 勤怠7章参照:session[:user_id]で一時的にログイン状態を保持できるようになった
  # 今度はcookiesを使って永続的にログイン状態を保持させる
  # だだ問題がある、このまま使うと悪用される危険がある
  # 防止策が下記の2つのメソッド→cookieを(User.new_tokenで作った)ランダムな文字列にハッシュ化(規則性がある文字列(パスワード)に置き換える)
  # 置き換えるのが　User.digest(string)
  # ダイジェストとして保存するための準備が整った→注意：
  # →永続セッションの為にハッシュ化したトークンをデータベースに記憶させるのは 下記のrememberメソッド
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # has_secure_passwordでは自動的にpasswordカラムを仮想属性として扱えるようにする
  # 機能がありましたが、今回はそのような機能はありません。
  # そのためattr_accessorを使って、user.remember_tokenメソッドを使えるよう実装します。
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  # update_attributeはsがない為、こちらはバリデーションを素通りさせます
  # update_attribute(属性名, 属性の値)→1つの属性のみ更新保存可
  # remember_digest属性(カラム)に、User.digest(remember_token)の値(ハッシュ化した値)を入れて更新→上記のメソッドを使用
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致すればtrueを返す
  # has_secure_passwordのauthenticateの役割を持つようなメソッドのトークン版を作っておきましょう
  # authenticateメソッド 下記説明あり
  # このメソッドは引数に渡された文字列（パスワードを指します）をハッシュ化した値と、データベースにある
  # password_digestの値を比較して一致した場合には対象のユーザーオブジェクトを返し、
  # 値が一致しなかった場合はfalseを返します→これを使いログインの認証を行う
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。永続的セッションを終了させる
  # 具体的には、ユーザーオブジェクトが持つremember_digestをnilで更新します
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # 検索メソッド→あいまい検索か全てのユーザー一覧か
  def self.search(search)
    if search
      User.where(['name LIKE ?', "%#{search}%"]) 
    else
      User.all
    end
  end
end
