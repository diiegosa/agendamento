class NovoSgaController < ApplicationController
    skip_before_action :authenticate_user!, only: [:attendance_queue_today]
    skip_load_and_authorize_resource
    skip_before_action :verify_authenticity_token, only: [:attendance_queue_today]

    def attendance_queue_today
        redirect_to schedules_url(attendance_queue_today_message: NovoSga::Attendance.queue_today)
    end
end
