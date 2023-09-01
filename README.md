## data-lake-challenge

Este é um projeto de Data Lake para o [Bootcamp Engenharia de Dados AWS](https://howedu.com.br/cohort/engenharia-de-dados) da How Education.

O projeto possui duas etapas. A primeira deve satisfazer aos requisitos:
1. Gerar dados fictícios sobre algum assunto de interesse e realizar a ingestão dos dados em um Data Lake hospedado no AWS S3.
2. Configurar um crawler usando o AWS Glue para catalogar os dados em tabelas.
3. Realizar 3 consultas nas tabelas criadas através do AWS Athena.

## Proposta de Solução

A solução proposta consiste em um Data Lake para armazenar dados de xadrez.

Foram criados 3 buckets no S3. Os buckets foram organizados 
em 3 camadas e elas foram nomeadas como as fases de um jogo de xadrez:
1. `opening`: Camada de entrada dos dados, na qual os dados permanecem no formato original.
2. `middle`: Camada de dados processados e armazenados em formato parquet.
3. `final`: Camada de dados curados, na qual os dados são armazenados em formato parquet e particionados por casos de uso.

## Segunda Etapa

A Segunda etapa possui um conjunto de novos requisitos, a saber:
1. Criar um script pyspark para processar os dados da camada `raw` para a camada `stage`.
2. Criar um script pyspark para processar os dados da camada `stage` para a camada `curated`.
3. Realizar 3 consultas nas tabelas curadas.
