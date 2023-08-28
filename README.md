## data-lake-challenge

Este é um projeto de Data lake para o [Bootcamp Engenharia de Dados AWS](https://howedu.com.br/cohort/engenharia-de-dados) da How Education.

O projeto foi dividido em duas etapas. A primeira contempla os seguintes passos:
1. Gerar dados fictícios sobre algum assunto de interesse e realizar a ingestão em um data lake hospedado no S3. Nesse ponto devem ser observados os layers e partições dos dados.
2. Configurar um crawler do Glue para catalogar os dados em tabelas.
3. Realizar 3 consultas nas tabelas criadas.

Já a segunda etapa contempla os passos a seguir:
1. Criar um script pyspark para processar os dados da camada `raw` para a camada `stage`.
2. Criar um script pyspark para processar os dados da camada `stage` para a camada `curated`.
3. Realizar 3 consultas nas tabelas curadas.
