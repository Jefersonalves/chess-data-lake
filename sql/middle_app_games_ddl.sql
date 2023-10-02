CREATE EXTERNAL TABLE `games`(
  `black` string, 
  `black_elo` int, 
  `black_rating_diff` int, 
  `eco` string, 
  `event` string, 
  `moves` array<string>, 
  `opening` string, 
  `result` string, 
  `site` string, 
  `termination` string, 
  `time_control` string, 
  `white` string, 
  `white_elo` int, 
  `white_rating_diff` int, 
  `extracted_at` date, 
  `utc_datetime` timestamp, 
  `time_format` string)
PARTITIONED BY ( 
  `utc_month` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://chess-data-lake-middle/app/games/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='middle_crawler', 
  'averageRecordSize'='65', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='29', 
  'partition_filtering.enabled'='true', 
  'recordCount'='8270', 
  'sizeKey'='540496', 
  'typeOfData'='file')