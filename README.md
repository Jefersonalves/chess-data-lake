## data-lake-challenge

Este é um projeto de Data Lake usando os serviçoes da [AWS](https://aws.amazon.com/) para o [Bootcamp Engenharia de Dados AWS](https://howedu.com.br/cohort/engenharia-de-dados) da How Education.

O projeto deve satisfazer aos requisitos:
1. Gerar dados fictícios sobre algum assunto de interesse e realizar a ingestão dos dados em um Data Lake hospedado no [S3](https://aws.amazon.com/pt/s3/).
2. Configurar um crawler usando o [Glue](https://aws.amazon.com/pt/glue/) para catalogar os dados em tabelas.
3. Realizar 3 consultas nas tabelas criadas através do [Athena](https://aws.amazon.com/pt/athena/).

## Proposta de Solução

A solução proposta consiste em um Data Lake para armazenar dados de xadrez.

Foram criados 3 buckets no S3. Os buckets foram organizados 
em 3 camadas e elas foram nomeadas como as fases de um jogo de xadrez:
1. `opening`: Camada de entrada dos dados, na qual os dados permanecem no formato original.
2. `middle`: Camada de dados processados e armazenados em formato parquet.
3. `final`: Camada de dados curados, na qual os dados são armazenados em formato parquet e particionados por casos de uso.

### 1. Dados fictícios

Foi desenvolvido um pacote Python para gerar dados fictícios de partidas de xadrez e armazená-los em um bucket do S3. O pacote está disponível no repositório [https://github.com/Jefersonalves/chess-data-ingestion](https://github.com/Jefersonalves/chess-data-ingestion).

O pacote gera arquivos JSON como o exemplo a seguir:

```json
{
    "event": "Rated Blitz game",
    "site": "https://www.chess.com",
    "white": "hdias",
    "black": "slima",
    "result": "1-0",
    "utc_date": "2022.11.23",
    "utc_time": "06:54:54",
    "white_elo": 2629,
    "black_elo": 2532,
    "white_rating_diff": 89,
    "black_rating_diff": 38,
    "eco": "E60",
    "opening": "Kings Indian Defense",
    "time_control": "300+0",
    "termination": "Normal",
    "moves": "1. d4 Nf6 2. c4 g6 3. Nc3 Bg7"
}
```

O pacote foi usado para gerar os dados e realizar a ingestão na camada `opening` simulando um aplicativo de jogos de xadrez nomeado `game-app`.

### 2. Configuração do Crawler

O crawler do Glue foi confirgurado para catalogar a camada `opening` como uma database e os dados do `game-app` como uma tabela. A imagem abaixo exibe o crawler criado.

![Crawler](images/crawler.png)

A instrução DDL para criação da tabela está disponível no arquivo [queries/ddl.sql](queries/ddl.sql).

### 3. Consultas no Athena

Uma vez que a tabela estava catalogada, foi possível realizar consultas através do Athena.
As consultas realizadas abordaram diferentes casos de uso.

A primeira consulta ([queries/1.sql](queries/1.sql)) retorna o número de partidas por data de extração.
![query1](images/query_1.png)

A segunda ([queries/2.sql](queries/2.sql)) calcula a taxa de vitória das aberturas para os jogadores de brancas e negras.
![query2](images/query_2.png)

A terceira ([queries/3.sql](queries/3.sql)) busca identificar quais são os primeiros movimentos mais comuns para ambos os jogadores.
![query3](images/query_3.png)
