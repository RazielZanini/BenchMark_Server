class ResultadosController < ApplicationController
  before_action :set_resultado, only: %i[ show update destroy ]

  # GET /resultados
  def index
    @resultados = Resultado.all

    render json: @resultados
  end

  # GET /resultados/1
  def show
    render json: @resultado
  end

  # GET /resultados/by_benchmark/1
  def show_by_benchmark
    @resultado = Resultado.find_by(benchmarking_id: params[:benchmarking_id])

    if @resultado
      render json: @resultado
    else
      render json: { error: "Resultado não encontrado para esse benchmarking" }, status: :not_found
    end
  end

  # POST /resultados
  def create
    @resultado = Resultado.new(resultado_params)

    if @resultado.save
      render json: @resultado, status: :created, location: @resultado
    else
      render json: @resultado.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resultados/1
  def update
    if @resultado.update(resultado_params)
      render json: @resultado
    else
      render json: @resultado.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resultados/1
  def destroy
    @resultado.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resultado
      @resultado = Resultado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resultado_params
      params.require(:resultado).permit(:benchmark_id, :periodo, :dados)
    end
end
