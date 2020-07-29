class Attendance < ApplicationRecord
  # attendanceモデルとuserモデルの関係→1:1の関係を示してる
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効(↓カスタムのバリデーション)
  # validate(sが付かない)→カスタムメソッドをバリデーションとして使う事ができる
  validate :finished_at_is_invalid_without_a_started_at

  # errorsメッセージに追加してる
  # 出勤時間がない、かつ退勤時間が存在する場合→trueとなり処理が実行される
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
end