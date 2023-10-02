CREATE EXTERNAL TABLE `rank`(
  `player` string, 
  `current_elo` int, 
  `percent_rank` double)
PARTITIONED BY ( 
  `time_format` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://chess-data-lake-final/players/rank/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='final_crawler', 
  'averageRecordSize'='22', 
  'classification'='parquet', 
  'compressionType'='none', 
  'objectCount'='4', 
  'partition_filtering.enabled'='true', 
  'recordCount'='14804', 
  'sizeKey'='208502', 
  'typeOfData'='file')