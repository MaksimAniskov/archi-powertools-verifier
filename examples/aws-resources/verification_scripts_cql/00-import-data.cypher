LOAD CSV FROM "file:///additional_data/aws-s3-buckets.csv" AS line
MERGE (:AWS_S3_Bucket{name:line[0]})
RETURN count(*) AS `Imported items from aws-s3-buckets.csv:`;
