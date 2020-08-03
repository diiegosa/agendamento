class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_novo_sga_services, only: [:new, :create, :edit, :update]
  skip_before_action :authenticate_user!, only: [:get_all_that_have_service_point]
  skip_load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: [:get_all_that_have_service_point]

  # GET /services
  # GET /services.json
  def index
    @q = Service.ransack(params[:q])
    @services = @q.result.includes(:novo_sga_service)
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to services_url, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        abort @service.errors.inspect
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to services_url, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_all_that_have_service_point
    render json: {
      services:  Service.get_all_that_have_service_point
    }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    def set_novo_sga_services
      @novo_sga_services = Service.get_all_to_new_or_edit(params.include?(:id) ? params[:id] : nil)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:document, :fa_icon, :novo_sga_service_id)
    end
end
