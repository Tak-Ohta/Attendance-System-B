module UsersHelper
  # 勤怠基本情報（時間表示）を指定のフォーマットで返す
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
end
