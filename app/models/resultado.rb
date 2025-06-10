class Resultado
  include Mongoid::Document
  include Mongoid::Timestamps
  field :data, type: Date
  field :pais, type: String
  field :casos_confirmados, type: Integer
  field :mortes, type: Integer
  field :populacao, type: Integer
  belongs_to :benchmark
end
