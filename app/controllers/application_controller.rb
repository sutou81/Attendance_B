class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # %w{日 月 火 水 木 金 土}はRubyのリテラル表記と呼ばれるものです。
  # ["日", "月", "火", "水", "木", "金", "土"]の配列と同じように使えます。
  # $変数名 →グローバル変数 グローバル変数は極端に言うとプログラムのどこからでも呼び出すことのできる変数で
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day] 
  end
end