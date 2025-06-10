require "test_helper"

class BenchmarkingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @benchmarking = benchmarkings(:one)
  end

  test "should get index" do
    get benchmarkings_url, as: :json
    assert_response :success
  end

  test "should create benchmarking" do
    assert_difference("Benchmarking.count") do
      post benchmarkings_url, params: { benchmarking: { data_fim: @benchmarking.data_fim, data_inicio: @benchmarking.data_inicio, nome: @benchmarking.nome, pais_1: @benchmarking.pais_1, pais_2: @benchmarking.pais_2 } }, as: :json
    end

    assert_response :created
  end

  test "should show benchmarking" do
    get benchmarking_url(@benchmarking), as: :json
    assert_response :success
  end

  test "should update benchmarking" do
    patch benchmarking_url(@benchmarking), params: { benchmarking: { data_fim: @benchmarking.data_fim, data_inicio: @benchmarking.data_inicio, nome: @benchmarking.nome, pais_1: @benchmarking.pais_1, pais_2: @benchmarking.pais_2 } }, as: :json
    assert_response :success
  end

  test "should destroy benchmarking" do
    assert_difference("Benchmarking.count", -1) do
      delete benchmarking_url(@benchmarking), as: :json
    end

    assert_response :no_content
  end
end
