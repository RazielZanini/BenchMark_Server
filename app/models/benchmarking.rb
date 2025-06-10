class Benchmarking
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :pais_1, type: String
  field :pais_2, type: String
  field :data_inicio, type: Date
  field :data_fim, type: Date
end
