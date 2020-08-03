class ExpertAvailabilitiesController < ApplicationController
  before_action :set_expert_availability, only: [:show, :edit, :update, :destroy]
  before_action :set_experts, only: [:new, :create, :edit, :update]
  skip_before_action :authenticate_user!, only: [:get_available_dates_by_expert, :get_expert_available_times_by_date]
  skip_load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:get_available_dates_by_expert, :get_expert_available_times_by_date]

  # GET /expert_availabilities
  # GET /expert_availabilities.json
  def index
    @q = ExpertAvailability.ransack(params[:q])
    @expert_availabilities = @q.result.includes(:expert).paginate(page: params[:page], per_page: 10).order(date: :desc)
  end

  # GET /expert_availabilities/1
  # GET /expert_availabilities/1.json
  def show
  end

  # GET /expert_availabilities/new
  def new
    @expert_availability = ExpertAvailability.new
  end

  # GET /expert_availabilities/1/edit
  def edit
  end

  # POST /expert_availabilities
  # POST /expert_availabilities.json
  def create
    failed = ExpertAvailability.validate(params)

    respond_to do |format|
      if failed.empty?
        flash[:warning] = ExpertAvailability.create(params)
        format.html { redirect_to expert_availabilities_url, notice: flash[:warning].empty? ? 'Disponibilidade(s) do especialista cadastrada(s)'
          : 'Disponibilidade(s) do especialista cadastrada(s), com exceção da(s) discriminada(s) abaixo:' }
      else
        flash[:error] = failed
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /expert_availabilities/1
  # PATCH/PUT /expert_availabilities/1.json
  def update
    respond_to do |format|
      if @expert_availability.update(expert_availability_params)
        format.html { redirect_to expert_availabilities_url, notice: 'Expert availability was successfully updated.' }
        format.json { render :show, status: :ok, location: @expert_availability }
      else
        format.html { render :edit }
        format.json { render json: @expert_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expert_availabilities/1
  # DELETE /expert_availabilities/1.json
  def destroy
    @expert_availability.destroy
    respond_to do |format|
      format.html { redirect_to expert_availabilities_url, notice: 'Expert availability was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_available_dates_by_expert
    render json: {
      dates: ExpertAvailability.get_available_dates_by_expert(params[:expert_id])
    }, status: :ok
  end

  def get_expert_available_times_by_date
    render json: {
      times: ExpertAvailability.get_expert_available_times_by_date(params[:date])
    }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert_availability
      @expert_availability = ExpertAvailability.find(params[:id])
    end

    def set_experts
      @experts = Expert.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expert_availability_params
      params.require(:expert_availability).permit(:expert_id, :shift, :date)
    end
end
