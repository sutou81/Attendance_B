class AttendancesController < ApplicationController
  
  def update
    # 更新対象のuserを特定(@user)し、更新対象の勤怠データを特定(@attendance)する
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = "勤怠登録に失敗しました。やり直してください。"
      end
    end
    redirect_to user_url(@user)
  end
end
