class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :set_services, only: [:index]
  skip_before_action :authenticate_user!, only: [:new, :create, :receipt, :search, :get_by_email, :send_information_by_email, :cancel]
  skip_load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:new, :create, :receipt, :search, :get_by_email, :send_information_by_email, :cancel]

  # GET /schedules
  # GET /schedules.json
  def index
    @attendance_queue_today_message = params[:attendance_queue_today_message] if(params.include?(:attendance_queue_today_message))
    @q = Schedule.ransack(params[:q])
    @schedules = @q.result.paginate(page: params[:page], per_page: 20).order(:date, :time)
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
    render layout: "home", template: "schedules/new"
  end

  def search
    render layout: "home", template: "schedules/search"
  end

  def get_by_email
    schedules = Schedule.get_by_email(params[:client_email])
    render json: {
      schedules: schedules
    }, status: :ok
  end

  def send_information_by_email
    message_return = Schedule.send_information_by_email(params[:schedule_id])
    render json: {
      message: message_return
    }, status: :ok
  end

  def cancel
    message_return = Schedule.cancel(params[:schedule_protocol], params[:schedule_id])
    render json: {
      message: message_return
    }, status: :ok
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.generate_object(schedule_params, params)
    respond_to do |format|
      if @schedule.save
        ReceiptMailer.schedule_email(@schedule).deliver
        return render pdf: "agendamento-cbmpe",
          template: "schedules/receipt.pdf.erb",
          margin: {left: 25, right: 25 },
          #disposition: 'attachment',
          footer: { center: "[page] of [topage]" }
      else
        format.html { render :new, layout: "home" }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def receipt
    respond_to do |format|
      format.html

      format.pdf {
        render pdf: "articles-list-report",
        margin: {left: 25, right: 25 },
        #disposition: 'attachment',
        footer: { center: "[page] of [topage]" }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def set_services
      @services = Service.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(
          :client_name,
          :client_cpf,
          :client_email,
          :client_email_confirmation,
          :client_cellphone_number,
          :property_sequential_or_protocol,
          :service_id,
          :service_point_id,
          :date,
          :time,
          :description
        )
    end
end
