import pyspark.sql.functions as F

from spark_session_builder import create_spark_session


spark = create_spark_session()

SOURCE_TABLE = "s3a://chess-data-lake-opening/games-app/"
df = spark.read.option("mode", "PERMISSIVE").json(SOURCE_TABLE)

# df.printSchema()
# root
#  |-- black: string (nullable = true)
#  |-- black_elo: long (nullable = true)
#  |-- black_rating_diff: long (nullable = true)
#  |-- eco: string (nullable = true)
#  |-- event: string (nullable = true)
#  |-- moves: string (nullable = true)
#  |-- opening: string (nullable = true)
#  |-- result: string (nullable = true)
#  |-- site: string (nullable = true)
#  |-- termination: string (nullable = true)
#  |-- time_control: string (nullable = true)
#  |-- utc_date: string (nullable = true)
#  |-- utc_time: string (nullable = true)
#  |-- white: string (nullable = true)
#  |-- white_elo: long (nullable = true)
#  |-- white_rating_diff: long (nullable = true)
#  |-- extracted_at: date (nullable = true)

df = (
    df.withColumn("white_elo", F.col("white_elo").cast("int"))
    .withColumn("black_elo", F.col("black_elo").cast("int"))
    .withColumn("white_rating_diff", F.col("white_rating_diff").cast("int"))
    .withColumn("black_rating_diff", F.col("black_rating_diff").cast("int"))
)

# Transform moves string like "1. e4 c5" to an array like ["e4", "c5"]
df = df.withColumn("moves", F.expr(r"regexp_extract_all(moves, '[A-Za-z]+[0-9]+', 0)"))


df = (
    df.withColumn(
        "utc_datetime", F.concat(F.col("utc_date"), F.lit(" "), F.col("utc_time"))
    )
    .withColumn(
        "utc_datetime", F.to_timestamp(F.col("utc_datetime"), "yyyy.MM.dd HH:mm:ss")
    )
    .withColumn(
        "utc_month", F.to_date(F.date_format(F.col("utc_datetime"), "yyyy-MM-01"))
    )
    .drop("utc_date")
    .drop("utc_time")
)

df = df.withColumn(
    "result",
    F.when(F.col("result") == "1-0", "white")
    .when(F.col("result") == "0-1", "black")
    .otherwise(F.lit("draw")),
)

# Extract the time format of the game, the values can be bullet, blitz or classical
df = df.withColumn("time_format", F.lower(F.split("event", r" ")[1]))

df = df.withColumn(
    "utc_month", F.to_date(F.date_format(F.col("utc_datetime"), "yyyy-MM-01"))
)

# df.printSchema()
# root
#  |-- black: string (nullable = true)
#  |-- black_elo: integer (nullable = true)
#  |-- black_rating_diff: integer (nullable = true)
#  |-- eco: string (nullable = true)
#  |-- event: string (nullable = true)
#  |-- moves: array (nullable = true)
#  |    |-- element: string (containsNull = true)
#  |-- opening: string (nullable = true)
#  |-- result: string (nullable = false)
#  |-- site: string (nullable = true)
#  |-- termination: string (nullable = true)
#  |-- time_control: string (nullable = true)
#  |-- white: string (nullable = true)
#  |-- white_elo: integer (nullable = true)
#  |-- white_rating_diff: integer (nullable = true)
#  |-- extracted_at: date (nullable = true)
#  |-- utc_datetime: timestamp (nullable = true)
#  |-- time_format: string (nullable = true)
#  |-- utc_month: date (nullable = true)

DESTINATION_TABLE = "s3a://chess-data-lake-middle/games-app/games/"
df.write.partitionBy("utc_month").mode("overwrite").parquet(DESTINATION_TABLE)
