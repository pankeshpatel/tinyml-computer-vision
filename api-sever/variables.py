import boto3
from boto3.dynamodb.conditions import Key, Attr
from dotenv import load_dotenv
import os

load_dotenv()


# # AWS Credentials
REGION_NAME=os.getenv("REGION_NAME")
ACCESS_KEY_ID=os.getenv("ACCESS_KEY_ID")
SECRET_ACCESS_KEY=os.getenv("SECRET_ACCESS_KEY")

# S3
AWS_S3_SERVICE=os.getenv("AWS_S3_SERVICE")
S3_BUCKET_NAME=os.getenv("S3_BUCKET_NAME")
S3_FACE_URL=os.getenv("S3_FACE_URL")
S3_VIDEO_URL=os.getenv("S3_VIDEO_URL")

#DynamoDB
AWS_DYN_DATABASE=os.getenv("AWS_DYN_DATABASE")
AWS_DB_TABLE1=os.getenv("AWS_DB_TABLE1")
AWS_DB_TABLE2=os.getenv("AWS_DB_TABLE2")

#Rekognition
AWS_RECK_SERVICE=os.getenv("AWS_RECK_SERVICE")
AWS_RECK_COLLECTION_ID=os.getenv("AWS_RECK_COLLECTION_ID")

#SNS SNS Service
AWS_SNS_SERVICE=os.getenv("AWS_SNS_SERVICE")


#dynamodb instance using boto3
dynamodb_resource = boto3.resource(AWS_DYN_DATABASE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)
dynamodb_client = boto3.client(AWS_DYN_DATABASE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)

# dynamoDB Table Name 
ddb_table = dynamodb_resource.Table(AWS_DB_TABLE1) 

# S3 client using Boto3
s3 = boto3.client(AWS_S3_SERVICE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)
s3_resource = boto3.resource(AWS_S3_SERVICE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)

<<<<<<< Updated upstream
# Rekognition Client for add face
rekog_client = boto3.client(AWS_RECK_SERVICE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)
=======
    # Rekognition Client for add face
    rekog_client = boto3.client(AWS_RECK_SERVICE, region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)

    sns_client = boto3.client(AWS_SNS_SERVICE,  region_name = REGION_NAME, aws_access_key_id = ACCESS_KEY_ID, aws_secret_access_key = SECRET_ACCESS_KEY)
except:
    print("Error connectings")
    raise HTTPException(status_code=404, detail="Can't connect")
>>>>>>> Stashed changes
