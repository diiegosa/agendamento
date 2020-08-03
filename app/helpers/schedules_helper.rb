module SchedulesHelper
    def show_status(status)
        ('<span class="label label-' + (status == NovoSga::Attendance::STATUS[:emit] ? 'success' : 'danger') + '">' + status + '</span>').html_safe
    end
end
