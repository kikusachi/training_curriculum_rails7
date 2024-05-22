class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index

    get_week

    @plan = Plan.new
  end

  # 予定の保存
  def create
    #planテーブルに情報を追加・保存する
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private
  # カレンダーの予定を追加するようのストロングパラメータ
  def plan_params
    #:calendars←コントローラーで受け取りたいキーを指す
    params.require(:plan).permit(:date, :plan)
  end

  #１週間分の日付を取得する関数
  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end


      # wdayメソッドを用いて取得した数値
      wday_num = (@todays_date + x).wday
      #「wday_numが7以上の場合」という条件式
      if wday_num >= 7
        wday_num = wday_num -7
      end

      #wdaysを使うと曜日が取り出せる・(@todays_date + x)で日にちをずらし目的の日数分取得
      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, :plans => today_plans, :wdays => wdays[wday_num]}

      @week_days.push(days)
    end

  end
end
