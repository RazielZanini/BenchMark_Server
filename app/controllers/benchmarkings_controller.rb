class BenchmarkingsController < ApplicationController
  before_action :set_benchmarking, only: %i[ show update destroy ]

  # GET /benchmarkings
  def index
    @benchmarkings = Benchmarking.all

    render json: @benchmarkings
  end

  # GET /benchmarkings/1
  def show
    render json: @benchmarking
  end

  # POST /benchmarkings
  def create
    benchmarking_params = benchmarking_params()

    # Checa se já existe um tetse benchmark com estes mesmos dados antes de prosseguir
    benchmarking_existente = Benchmarking.find_by(
      estado_1: benchmarking_params[:estado_1],
      estado_2: benchmarking_params[:estado_2],
      data_inicio: benchmarking_params[:data_inicio],
      data_fim: benchmarking_params[:data_fim]
    )

    if benchmarking_existente&.resultados&.where(periodo: "#{benchmarking_params[:data_inicio]} a #{benchmarking_params[:data_fim]}")&.exists?
      render json: { message: "Já existe um benchmarking com esses dados", benchmarking: benchmarking_existente }, status: :ok
      return
    end

    @benchmarking = Benchmarking.new(benchmarking_params)

    if @benchmarking.save
      CovidDataFetchService.fetch_and_save(@benchmarking)
      render json: @benchmarking, status: :created, location: @benchmarking
    else
      render json: @benchmarking.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /benchmarkings/1
  def update
    if @benchmarking.update(benchmarking_params)
      render json: @benchmarking
    else
      render json: @benchmarking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /benchmarkings/1
  def destroy
    @benchmarking.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benchmarking
      @benchmarking = Benchmarking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def benchmarking_params
      params.require(:benchmarking).permit(:nome, :estado_1, :estado_2, :data_inicio, :data_fim)
    end
end
