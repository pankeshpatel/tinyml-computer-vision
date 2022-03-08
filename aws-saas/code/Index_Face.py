'''
            -----------------------------------------------------------------------------------------------------
                This python Script is used to index known faces for Smart Doorbell usecase 
                Indexed faces will be recognized when they are at your doorstep 
            -----------------------------------------------------------------------------------------------------
'''

# importing necessary libraries and modules
import boto3
import AWS_Constants


# Assigning AWS Credentials for using Cloud services
your_region_name =  AWS_Constants.your_region_name
your_aws_access_key_id = AWS_Constants.your_aws_access_key_id
your_aws_secret_access_key = AWS_Constants.your_aws_secret_access_key
collectionId =  'addFace' # Collection Name

# Initializing AWS Rekognition Client 
rek_client = boto3.client("rekognition", region_name = your_region_name, aws_access_key_id = your_aws_access_key_id,aws_secret_access_key = your_aws_secret_access_key)
                
# Initializing AWS S3 Client 
s3_client = boto3.client('s3', region_name = your_region_name , aws_access_key_id = your_aws_access_key_id,
                aws_secret_access_key = your_aws_secret_access_key)
                
bucket = 'rpidemo' #S3 bucket name
all_objects = s3_client.list_objects(Bucket = bucket)
print("All obj:", all_objects)

''' delete existing collection if it exists '''
list_response=rek_client.list_collections(MaxResults=2)
print("\n\nAll collections:", list_response)

if collectionId in list_response['CollectionIds']:
    rek_client.delete_collection(CollectionId=collectionId)

''' create a new collection '''
rek_client.create_collection(CollectionId=collectionId)

'''
    add all images in current bucket to the collections
    use folder names as the labels
'''
for content in all_objects['Contents']:
    #image1 = content['Key']
    #print("Image1:", image1)
    print("Content[key]", content['Key'])
    collection_name,collection_image = content['Key'].split('/')
    print("Collection name:",collection_name)
    print("Collection_image:", collection_image)
    if collection_image:
        label = collection_name
        print('Indexing: ',label)
        print("Content key:", content['Key'])
        print("Content type:",type(content['Key']))
        image = content['Key']
        print("Image:", image)
        index_response=rek_client.index_faces(CollectionId=collectionId,
                                Image={'S3Object':{'Bucket':bucket,'Name':image}},
                                ExternalImageId=label,
                                MaxFaces=1,
                                QualityFilter="AUTO",
                                DetectionAttributes=['DEFAULT'])
        print('FaceId: ',index_response['FaceRecords'][0]['Face']['FaceId'])