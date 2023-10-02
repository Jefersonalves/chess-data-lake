import pyspark.sql.functions as F
from pyspark.sql.window import Window

from spark_session_builder import create_spark_session

spark = create_spark_session()


SOURCE_TABLE = "s3a://chess-data-lake-middle/app/games/"
df = spark.read.parquet(SOURCE_TABLE)

white_players = df.select(
    F.col("white").alias("player"),
    F.col("white_elo").alias("player_elo"),
    F.col("time_format"),
    F.col("utc_datetime"),
)
black_players = df.select(
    F.col("black").alias("player"),
    F.col("black_elo").alias("player_elo"),
    F.col("time_format"),
    F.col("utc_datetime"),
)

players = white_players.union(black_players)
# players.count(), df.count()
# (16540, 8270)
players = players.sort(F.desc("utc_datetime"))

players = players.groupBy(["player", "time_format"]).agg(
    F.first(F.col("player_elo")).alias("current_elo")
)
player_window = Window.partitionBy("time_format").orderBy("current_elo")
players = players.withColumn(
    "percent_rank", F.round(F.percent_rank().over(player_window), 4)
)
# players.select(F.min(F.col("percent_rank")), F.max(F.col("percent_rank"))).show()
# +-----------------+-----------------+
# |min(percent_rank)|max(percent_rank)|
# +-----------------+-----------------+
# |              0.0|              1.0|
# +-----------------+-----------------+

DESTINATION_TABLE = "s3a://chess-data-lake-final/players/rank/"
players.write.partitionBy("time_format").mode("overwrite").parquet(DESTINATION_TABLE)
