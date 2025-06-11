class Resultado
  include Mongoid::Document
  include Mongoid::Timestamps
  field :periodo, type: String
  field :dados, type: Hash

  belongs_to :benchmarking, class_name: "Benchmarking", inverse_of: :resultados
end
