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
    begin
    @resultado = Resultado.find_by(benchmarking_id: params[:benchmarking_id])

    if @resultado
      render json: @resultado
    else
      render json: { error: "Resultado não encontrado para esse benchmarking" }, status: :not_found
    end
    rescue => e
    render json: { error: "Erro ao buscar resultado: #{e.message}" }, status: :internal_server_error
    end
  end

  # GET /resultados/:estado_1/:estado_2/:data_inicio/:data_fim
  def comparativo
  estado_1 = params[:estado_1].upcase
  estado_2 = params[:estado_2].upcase

  begin
    data_inicio = Date.parse(params[:data_inicio])
    data_fim = Date.parse(params[:data_fim])
  rescue ArgumentError
    return render json: { error: "Datas inválidas" }, status: :bad_request
  end

  benchmarking = Benchmarking.find_by(
    estado_1: estado_1,
    estado_2: estado_2,
    data_inicio: data_inicio,
    data_fim: data_fim
  )

  unless benchmarking
    return render json: { error: "Benchmarking não encontrado com esses parâmetros" }, status: :not_found
  end

  resultado = Resultado.find_by(benchmarking_id: benchmarking.id)

  unless resultado
    return render json: { error: "Resultado não encontrado para esse benchmarking" }, status: :not_found
  end

  dados_tratados = tratar_dados(resultado.dados)

  render json: {
    benchmarking: benchmarking.nome,
    periodo: resultado.periodo,
    comparativo: dados_tratados
  }
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

  def tratar_dados(dados)
    estado_1 = dados[0]
    estado_2 = dados[1]

    {
      estado_1["estado"] => {
        casos: estado_1["casos_confirmados"],
        mortes: estado_2["mortes"],
        letalidade: "#{calc_letalidade(estado_1)}%"
      },
      estado_2["estado"] => {
        casos: estado_2["casos_confirmados"],
        mortes: estado_2["mortes"],
        letalidade: "#{calc_letalidade(estado_2)}%"
      },
      diferencas: {
        casos: estado_1["casos_confirmados"] - estado_2["casos_confirmados"],
        mortes: estado_1["mortes"] - estado_2["mortes"]
      }
    }
  end

  def calc_letalidade(estado)
    return 0 if estado["casos_confirmados"].zero?
    ((estado["mortes"].to_f / estado["casos_confirmados"]) * 100).round(2)
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
