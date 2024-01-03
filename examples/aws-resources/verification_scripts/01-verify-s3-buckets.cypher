OPTIONAL MATCH (aws_s3_buckets:AWS_S3_Bucket)
OPTIONAL MATCH (model_s3_buckets:TechnologyService{specialization: "AWS::S3::Bucket"})

WITH
    collect(DISTINCT aws_s3_buckets.name) AS list1,
    collect(DISTINCT model_s3_buckets.name) AS list2
WITH
    [n IN list1 WHERE NOT n IN list2 | "S3 bucket not represented in model:  "+n] AS err_list1,
    [n IN list2 WHERE NOT n IN list1 | "Model contains bucket that does not exist:  "+n] AS err_list2
UNWIND err_list1+err_list2 AS errors
RETURN errors AS `Error!`