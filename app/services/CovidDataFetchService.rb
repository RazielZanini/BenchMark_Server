require "net/http"
require "json"
require "date"

class CovidDataFetchService
  API_URL = "https://brasil.io/api/v1/dataset/covid19/caso/data/"

  def self.fetch_and_save(benchmarking)
    periodo_str = "#{benchmarking.data_inicio} a #{benchmarking.data_fim}"

    return if benchmarking.resultados.where(periodo: periodo_str).exists?
    # Iniciando os parametros para as requisições
    estados = [ benchmarking.estado_1, benchmarking.estado_2 ]
    headers = { "Authorization" => ENV["API_KEY"] }
    dados_gerais = {}

    estados.each do |estado|
      resultados = []

      page = 1
      loop do
        uri = URI("#{API_URL}?state=#{estado}&page=#{page}&place_type=state")
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Get.new(uri)
          headers.each { |k, v| req[k] = v }
          http.request(req)
        end

        # Interrompe o loop caso a resposta seja diferente de 200
        break unless response.is_a?(Net::HTTPSuccess)

        body = JSON.parse(response.body)
        dados_filtrados = body["results"].select do |entrada|
          begin
            date = Date.parse(entrada["date"])
            date >= benchmarking.data_inicio && date <= benchmarking.data_fim
          rescue => e
            Rails.logger.error "Erro ao fazer parse da data: #{entrada["date"]} - #{e.message}"
            false
          end
        end
        resultados.concat(dados_filtrados)
        break unless body["next"]
        page += 1
      end

      ordenados = resultados.sort_by { |r| Date.parse(r["date"]) }
      next if ordenados.empty?
      inicio = ordenados.first
      fim = ordenados.last

      casos = fim["confirmed"] - inicio["confirmed"]
      mortes = fim["deaths"] - inicio["deaths"]
      populacao = fim["estimated_population"] || fim["estimated_population_2019"]

      dados_gerais[estado] = {
        "casos_confirmados" => casos,
        "mortes" => mortes,
        "populacao" => populacao
      }
    end
    benchmarking.resultados.create!(
        periodo: "#{benchmarking.data_inicio} a #{benchmarking.data_fim}",
        dados: dados_gerais
      )
  end
end
