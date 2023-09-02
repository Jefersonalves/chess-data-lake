CREATE EXTERNAL TABLE `games_app`(
  `event` string COMMENT 'from deserializer', 
  `site` string COMMENT 'from deserializer', 
  `white` string COMMENT 'from deserializer', 
  `black` string COMMENT 'from deserializer', 
  `result` string COMMENT 'from deserializer', 
  `utc_date` string COMMENT 'from deserializer', 
  `utc_time` string COMMENT 'from deserializer', 
  `white_elo` int COMMENT 'from deserializer', 
  `black_elo` int COMMENT 'from deserializer', 
  `white_rating_diff` int COMMENT 'from deserializer', 
  `black_rating_diff` int COMMENT 'from deserializer', 
  `eco` string COMMENT 'from deserializer', 
  `opening` string COMMENT 'from deserializer', 
  `time_control` string COMMENT 'from deserializer', 
  `termination` string COMMENT 'from deserializer', 
  `moves` string COMMENT 'from deserializer')
PARTITIONED BY ( 
  `extracted_at` string)
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
WITH SERDEPROPERTIES ( 
  'paths'='black,black_elo,black_rating_diff,eco,event,moves,opening,result,site,termination,time_control,utc_date,utc_time,white,white_elo,white_rating_diff') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://chess-data-lake-opening/games-app/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='games-crawler', 
  'averageRecordSize'='400', 
  'classification'='json', 
  'compressionType'='none', 
  'objectCount'='4', 
  'partition_filtering.enabled'='true', 
  'recordCount'='2630', 
  'sizeKey'='1053466', 
  'typeOfData'='file')