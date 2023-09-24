import os

from pyspark.sql import SparkSession


def create_spark_session() -> SparkSession:
    spark = (
        SparkSession.builder.config(
            "spark.hadoop.fs.s3a.access.key", os.environ.get("AWS_ACCESS_KEY_ID")
        )
        .config(
            "spark.hadoop.fs.s3a.secret.key", os.environ.get("AWS_SECRET_ACCESS_KEY")
        )
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
        .config("spark.hadoop.fs.s3a.endpoint", "s3.sa-east-1.amazonaws.com")
        .config(
            "spark.hadoop.fs.s3a.aws.credentials.provider",
            "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider",
        )
        .config("spark.jars.packages", "com.amazonaws:aws-java-sdk:1.12.533")
        .config("spark.jars.packages", "org.apache.hadoop:hadoop-common:3.2.2")
        .config("spark.jars.packages", "org.apache.hadoop:hadoop-client:3.2.2")
        .config("spark.jars.packages", "org.apache.hadoop:hadoop-aws:3.2.2")
        .appName("app")
        .getOrCreate()
    )

    return spark
