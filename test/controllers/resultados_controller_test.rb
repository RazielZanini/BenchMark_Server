require "test_helper"

class ResultadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resultado = resultados(:one)
  end

  test "should get index" do
    get resultados_url, as: :json
    assert_response :success
  end

  test "should create resultado" do
    assert_difference("Resultado.count") do
      post resultados_url, params: { resultado: { benchmark_id: @resultado.benchmark_id, casos_confirmados: @resultado.casos_confirmados, data: @resultado.data, mortes: @resultado.mortes, pais: @resultado.pais, populacao: @resultado.populacao } }, as: :json
    end

    assert_response :created
  end

  test "should show resultado" do
    get resultado_url(@resultado), as: :json
    assert_response :success
  end

  test "should update resultado" do
    patch resultado_url(@resultado), params: { resultado: { benchmark_id: @resultado.benchmark_id, casos_confirmados: @resultado.casos_confirmados, data: @resultado.data, mortes: @resultado.mortes, pais: @resultado.pais, populacao: @resultado.populacao } }, as: :json
    assert_response :success
  end

  test "should destroy resultado" do
    assert_difference("Resultado.count", -1) do
      delete resultado_url(@resultado), as: :json
    end

    assert_response :no_content
  end
end
