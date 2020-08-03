class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:get_available_dates_by_service_point_and_service, :get_available_times_by_date, :get_service_points_and_experts_that_have_availability_by_service]
  skip_load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:get_available_dates_by_service_point_and_service, :get_available_times_by_date, :get_service_points_and_experts_that_have_availability_by_service]

  # GET /availabilities
  # GET /availabilities.json
  def index
    @q = Availability.ransack(params[:q])
    @availabilities = @q.result.includes(:service, :service_point).paginate(page: params[:page], per_page: 10).order(date: :desc)
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
  end

  # GET /availabilities/new
  def new
    @availability = Availability.new
  end

  # GET /availabilities/1/edit
  def edit
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    failed = Availability.validate(params)
    respond_to do |format|
      if failed.empty?
        flash[:warning] = Availability.create(params)
        format.html { redirect_to availabilities_url,
                      notice: flash[:warning].empty? ? 'Disponibilidade cadastrada' : 'Disponibilidade cadastrada, com exceção da(s) discriminada(s) abaixo:' }
      else
        flash[:error] = failed
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /availabilities/1
  # PATCH/PUT /availabilities/1.json
  def update
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to availabilities_url, notice: 'Availability was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: 'Availability was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_available_dates_by_service_point_and_service
    render json: {
      dates: Availability.get_available_dates_by_service_point_and_service(params[:service_point_id], params[:service_id])
    }, status: :ok
  end

  def get_available_times_by_date
    render json: {
      times: Availability.get_available_times_by_date(params[:date])
    }, status: :ok
  end

  def get_service_points_and_experts_that_have_availability_by_service
    render json: {
      service_points: ServicePoint.get_all_that_have_availability_by_service(params[:service_id]),
      experts: Expert.get_all_that_have_availability_by_service(params[:service_id])
    }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_availability
      @availability = Availability.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def availability_params
      params.require(:availability).permit(:service_point_id, :service_id, :date, :shift, :attendant_number)
    end
end
