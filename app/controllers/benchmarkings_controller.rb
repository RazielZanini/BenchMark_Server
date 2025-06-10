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
    @benchmarking = Benchmarking.new(benchmarking_params)

    if @benchmarking.save
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
      params.require(:benchmarking).permit(:nome, :pais_1, :pais_2, :data_inicio, :data_fim)
    end
end
