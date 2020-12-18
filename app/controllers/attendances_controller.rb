class AttendancesController < ApplicationController

	UPDATE_ERROR_MESSAGE = "勤怠登録に失敗しました。やり直してください。"
	
	def update
		@user = User.find(params[:user_id])
		@attendance = Attendance.find(params[:id])
		
		if @attendance.started_at.nil?
			if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
				flash[:info] = "おはようございます。出社時間を登録しました。"
			else
				flash[:danger] = UPDATE_ERROR_MESSAGE
			end
		elsif @attendance.finished_at.nil?
			if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
				flash[:info] = "お疲れ様でした。退社時間を登録しました。"
			else
				flash[:danger] = UPDATE_ERROR_MESSAGE
			end
		end
		redirect_to @user
	end
end
