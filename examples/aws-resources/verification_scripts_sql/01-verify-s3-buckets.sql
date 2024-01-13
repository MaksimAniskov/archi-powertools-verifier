SELECT "Error! Model contains bucket that does not exist:", e.Name
FROM elements e
WHERE e.Specialization="AWS::S3::Bucket" AND NOT EXISTS (SELECT * FROM aws_s3_buckets b WHERE b.Name=e.Name);

SELECT "Error! S3 bucket not represented in model:", b.Name
FROM aws_s3_buckets b
WHERE NOT EXISTS (SELECT * FROM elements e WHERE e.Specialization="AWS::S3::Bucket" AND b.Name=e.Name);
