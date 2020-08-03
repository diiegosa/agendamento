class ServicePointsController < ApplicationController
  before_action :set_service_point, only: [:show, :edit, :update, :destroy]
  before_action :set_novo_sga_service_points, only: [:new, :create, :edit, :update]

  # GET /service_points
  # GET /service_points.json
  def index
    @q = ServicePoint.ransack(params[:q])
    @service_points = @q.result(distinct: true)
  end

  # GET /service_points/1
  # GET /service_points/1.json
  def show
  end

  # GET /service_points/new
  def new
    @service_point = ServicePoint.new
  end

  # GET /service_points/1/edit
  def edit
  end

  # POST /service_points
  # POST /service_points.json
  def create
    @service_point = ServicePoint.new(service_point_params)

    respond_to do |format|
      if @service_point.save
        format.html { redirect_to service_points_url, notice: 'Service point was successfully created.' }
        format.json { render :show, status: :created, location: @service_point }
      else
        format.html { render :new }
        format.json { render json: @service_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_points/1
  # PATCH/PUT /service_points/1.json
  def update
    respond_to do |format|
      if @service_point.update(service_point_params)
        format.html { redirect_to service_points_url, notice: 'Service point was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_point }
      else
        format.html { render :edit }
        format.json { render json: @service_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_points/1
  # DELETE /service_points/1.json
  def destroy
    @service_point.destroy
    respond_to do |format|
      format.html { redirect_to service_points_url, notice: 'Service point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_all
    render json: {
      service_points: ServicePoint.all.map { |service_point| {id: service_point.id, name: service_point.name } }
    }, status: :ok
  end

  def get_services_without_expert
    render json: {
      services: ServicePoint.get_all_id_and_name_services_without_expert(params[:service_point_code]),
    }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_point
      @service_point = ServicePoint.find(params[:id])
    end

    def set_novo_sga_service_points
      @novo_sga_service_points = ServicePoint.get_all_to_new_or_edit(params.include?(:id) ? params[:id] : nil)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_point_params
      params.require(:service_point).permit(:novo_sga_service_point_id, :city, :neighborhood, :public_area, :cep, :number)
    end
end
