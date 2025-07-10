# 📊 API Benchmarks COVID-19

Esta API tem como finalidade prover comparações entre dados de COVID-19 entre estados brasileiros, com base no período da pandemia. 

Ela é construída com **Ruby on Rails** e utiliza **MongoDB** como banco de dados. Os dados são obtidos da API pública do [Brasil.IO](https://brasil.io/dataset/covid19/caso/) e organizados para consumo via frontend (Next.js/React) ou ferramentas como o Power BI.

---

## 🔗 Frontend
O frontend da aplicação pode ser acessado aqui:  
➡️ [Benchmark_Client (Next.js)](https://github.com/RazielZanini/Benchmark_Client)

---

## 📅 Período de dados disponível
Os dados fornecidos cobrem o período de **08/03/2020 a 27/03/2022**.

---

## ⚙️ Tecnologias utilizadas

- **Ruby on Rails**
- **MongoDB (Mongoid)**
- **API Brasil.IO** (dados COVID-19)
- **Docker (opcional)**

---

## 🧠 Como funciona

### Estrutura do banco de dados
Utilizamos um banco de dados **não relacional** (MongoDB) com duas coleções principais:

- **Benchmarkings:** Armazena os dados fornecidos pelos usuários (estados e datas).
- **Resultados:** Armazena os dados processados vindos da API externa, organizados por período e estado.

### Fluxo da aplicação
1. O usuário faz uma requisição `POST` para a rota `/benchmarkings`.
2. A aplicação verifica se já existe um benchmarking com os mesmos parâmetros.
   - Se existir, retorna os dados previamente salvos.
   - Se não existir, cria um novo benchmarking e aciona o service `CovidDataFetchService`.
3. O service `CovidDataFetchService`:
   - Consulta a API externa para cada estado fornecido.
   - Filtra os dados conforme o intervalo de datas.
   - Calcula os dados comparativos (casos, mortes, população).
   - Salva os dados agregados na coleção `Resultados`.

---

## 📊 Power BI

A aplicação oferece uma rota dedicada para consulta via Power BI.  `/resultados/:estado_1/:estado_2/:data_inicio/:data_fim`
Os dados são organizados e tratados por uma função auxiliar `tratar_dados`, que calcula inclusive a taxa de letalidade.

---

## 🚀 Como rodar o projeto
  - Adicionar as variáveis de ambiente de acordo com o env.example
  - rodar o comando bundle install
  - abrir o servidor com o comando rails s
  - Pode rodar também via docker com o comando docker compose up --build

### Pré-requisitos
- Ruby (>= 3.2)
- MongoDB local ou Mongo Atlas
- Bundler

### 1. Clonando o projeto

```bash
git clone https://github.com/RazielZanini/BenchMark_Planisa_Server.git
cd BenchMark_Planisa_Server
