'''
            -----------------------------------------------------------------------------------------------------
                        This is the Main Python Program where the execution takes place.
            It requires AWS_Constants.py, AWS_Rekognition.py, Capture_Video.py python files to be in same folder.
            Before Running, Update your AWS - Cloud Credentials in AWS_Constants.py file
            -----------------------------------------------------------------------------------------------------
'''
import concurrent.futures
import boto3
import _pickle as cPickle
import time
import json

#Importing Modules
from Capture_Video import *
from AWS_Rekognition import *
import AWS_Constants

print("Beginning of Execution")
print("Initializing AWS Services")

# Assigning AWS Credentials for using Cloud services
# Step 1: Provide AWS Credentials
your_region_name =  AWS_Constants.your_region_name
your_aws_access_key_id = AWS_Constants.your_aws_access_key_id
your_aws_secret_access_key = AWS_Constants.your_aws_secret_access_key

# Initialize AWS Cloud Services - AWS S3, AWS DynamoDB, AWS SNS

# Initializing S3 - Storage Configuration
s3_client = boto3.client('s3', region_name = your_region_name , aws_access_key_id = your_aws_access_key_id,
                    aws_secret_access_key = your_aws_secret_access_key)

s3_bucket = "rpidemo" #S3 Bucket Name to store frames and video clip
s3_key_frames_root = "frames/" #S3 bucket folder name

# Initializing AWS DynamoDB Data Store
dynamodb = boto3.resource('dynamodb', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)
ddb_table = dynamodb.Table("edge_db") # DynamoDB Table Name

# Initializing AWS SNS - Simple Notification Service
sns = boto3.client("sns",region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)

# Kinesis Client
#kinesis_client = boto3.client("kinesis", region_name = your_region_name, aws_access_key_id = your_aws_access_key_id,
                #aws_secret_access_key = your_aws_secret_access_key)
collectionId = 'addFace' #Used for Face Rekognition Only ( Create new Collection Using Index-Faces.py )
kinesis_data_stream_name = "edge_stream" # Enter Your Kinesis Data Stream Name....Create One if not created


labels_on_watch_list_set = [] # Detected labels stored here

# Attributes of dynamoDb
name = ''
notification_type = ''
notification_message = ''
notification_title = ''


# Frame Package --> The dictionary which is to be inserted in the dynamoDB
frame_package ={'frame_id': frame_id,
                'approx_capture_timestamp' : int(now_ts_utc),
                'rekog_labels' : labels_on_watch_list_set,
                's3_bucket':s3_bucket,
                'notification': name + " was spotted at your door.",
                'notification_type': str(notification_type),
                'notification_title' : name + " spotted",
                's3_video_bucket' : 'video',
                's3_key' : s3_key_frames_root +frame_id + '.jpg',
                's3_video_key' :frame_id + '.mp4',
                'external_image_id' : name
                }



def Upload_to_aws(l):
    '''
        Function - Upload_to_aws(l)
        - This will take the output of running AWS_Rekonigiton.py code and based on the object found in
          the frames, it will generate the frame_package and uploads it to DynamoDB Data store
        - Also generates a notification for iOS Application
    '''
    # Collecting Results after running all the function present in AWS_Rekognition.py
    detected_person, notification_type_face = l[0]
    labels_on_watch_list_set, rekog_response = l[1]
    detected_animal, notification_type_animal = l[2]
    detected_violence, notification_type_gun = l[3]

    detected_package, notification_type_package = l[4]
    detected_logo, notification_type_logo = l[5]
    detected_vehicle, notification_type_vehicle = l[7]

    final_notification_type = []
    final_name = []
    final_name.append(detected_person)
    final_name.append(detected_animal)
    final_name.append(detected_violence)
    final_name.append(detected_package)
    final_name.append(detected_logo)
    final_name.append(detected_vehicle)

    #Removing Empty Entries
    for i in range(len(final_name)):
        try:
            final_name.remove('')
        except ValueError:
            pass
    print("Final Name:", final_name)

    name = ''
    notification_type = ''
    notification_message = ''
    notification_title = ''

    #Formating the output in readable format
    if len(final_name) == 0:
        name += 'Nothing'
    elif len(final_name) == 1:
        name += final_name[0]
    elif len(final_name) == 2:
        name += final_name[0] + 'with ' + final_name[1]
    elif len(final_name) == 3:
        name += final_name[0] + 'with ' + final_name[1] + 'and ' + final_name[2]

    #Editing the display output for DyanmoDb Table
    if notification_type_gun == 'suspicious':
        notification_type = 'suspicious'
        notification_message = 'An unusual activity may have been spotted at your front Door. You should review immediately.'
        notification_title = 'Suspicious spotted'
    elif notification_type_face == 'unknown':
        notification_type = 'unknown'
        notification_message = 'An unknown was spotted at your door.'
        notification_title = 'Unknown spotted'
    elif notification_type_face == 'known':
        notification_type = 'known'
        notification_message = detected_person + ' was spotted at your door.'
        notification_title = ' Known spotted'

    elif notification_type_animal == 'animal':
        notification_type = 'animal'
        notification_message = 'An animal was spotted at your front door.'
        notification_title = 'Animal spotted'

    elif notification_type_package == 'Package':
        notification_type = 'Package'
        notification_message = 'A package was delivered at your front door.'
        notification_title = 'Package spotted'

    elif notification_type_logo == 'Logo':
        notification_type = 'Logo'
        notification_message = 'A ' +  detected_logo +' package/van was spotted at your front door.'
        notification_title = 'Logo spotted'

    elif notification_type_vehicle == 'Vehicle':
        notification_type = 'Vehicle'
        notification_message = 'A Vehicle was spotted at your front door.'
        notification_title = 'Vehicle spotted'

    # Changing the values of the dictionary
    frame_package['rekog_labels'] = labels_on_watch_list_set
    frame_package['notification'] = notification_message
    frame_package['notification_type'] = notification_type
    frame_package['notification_title'] = notification_title
    frame_package['external_image_id'] = name


    '''
            ---------------------------------------------------------------------------------------
            This portion is for Pushing a Notificaton to iOS Application - Will be updated Soon!!!!
            ---------------------------------------------------------------------------------------
    #if frame_package['notification_type'] = 'unknown'
    sns_title = frame_package['notification']
    sns_name = ''
    sns_image = ''
    if frame_package['notification_type'] == 'unknown':
        sns_name = 'Unknown Face'
    elif frame_package['notification_type'] == 'known':
        sns_name = frame_package['notification_type']
        s3_name = frame_package['external_image_id']
        sns_image = 'https://registered-faces.s3.amazonaws.com/' + s3_name +'.jpeg'
    else:
        sns_name = frame_package['notification_type']

    push = {"aps":{"alert":{ "title": sns_title},
                    "name": sns_name,
                    "s3_key": sns_image
                    }}
    msg4 = {
        "APNS_SANDBOX" : json.dumps(push),
        "default": "Enter default message here"
    }
    publish = sns.publish(
        TopicArn='arn:aws:sns:us-east-1:714655694284:ios-notification',
        MessageStructure='json',
        Message=json.dumps(msg4)
    )
    print("Published",publish['ResponseMetadata']['HTTPStatusCode'])
    '''
    print("Final Output of Whole Program")
    print("##############################")
    print(frame_package)

    frame_package['img_bytes'] = l[6]

    #frame_package_json = json.dumps(frame_package)
    #Encoding the data and putting it on the kinesis stream
    '''response = kinesis_client.put_record(
                    StreamName= kinesis_data_stream_name,
                    Data=cPickle.dumps(frame_package),
                    #Data=frame_package_json,
                    PartitionKey="partitionkey"
                )'''

    ddb_table.put_item(Item = frame_package)
    print("Successfully inserted in DynamoDB")


def upload_to_s3(local_file, bucket, s3_file):
    '''
        Function - upload_to_s3(local_file, bucket, s3_file)
        - This is used to upload the captured video to S3 bucket
    '''

    print("uploading to S3 Bucket")
    try:
        data = open(local_file, 'rb')
        s3_client.put_object(Key="video/"+frame_id+".mp4", Body=data, Bucket = bucket,ContentType = 'video/mp4')
        print("Upload succcessful")
        print("Clip Uploaded to S3 Bucket")
    except FileNotFoundError:
        print("Error in uploding the video")



# Step 2: Program Execution Starts here 
''' --------------------------------------
    Program Execution Starts Here
    # Parallel Exceution of Each Function
    --------------------------------------
'''

with concurrent.futures.ProcessPoolExecutor() as executor:

    ''' v0 - calls function capture_frames (present in Capture_Video.py) '''
    v0 = executor.submit(capture_frames)
    #After Image Capture wait till 20sec
    time.sleep(20)

    '''
        v1 - calls convert_to_bytearray() to convert the image to byte array format
        as it is required format for AWS - Rekognition library to work
    '''
    v1 = executor.submit(convert_to_bytearray)

    '''
        f1, f2, f3, f4, f5, f6, f7 - calls functions present in AWS_Rekognition.py simultaniously
        to detect object of interest in frame for all usecases
        use-cases -> Detect Face, Pet (Cat, Dog), Gun, NoteWorthy Vehicle(Ambulance, Firetruck) as Truck
                     Car, Packages/Couriers, Logo_Detection - USPS, FedEx, DHL, Amazon Prime
    '''
    flag = True
    while flag:
        if v1.done():
            flag = False
            f1=executor.submit(Face_detection,v1.result())
            f2=executor.submit(Label_detection,v1.result())
            f4=executor.submit(Gun_Detection,v1.result())
            f5=executor.submit(Package_Detection,v1.result())
            f6=executor.submit(Logo_Detection,v1.result())
    flag = True
    while flag:
        if f2.done():
            flag = False
            x,y = f2.result()
            f3=executor.submit(Animal_Detection,x,y)
            f7=executor.submit(Vehicle_Detection,x,y)

    '''
        After receiving resutls from All AWS_Rekognition funcions,
        f8 will collect the results and calls Upload_to_aws() for uploading results
    '''
    flag = True
    while flag:
        if f1.done() and f2.done() and f3.done() and f4.done() and f5.done() and f6.done() and f7.done():
            flag = False
            a = f1.result()
            b = f2.result()
            c = f3.result()
            d = f4.result()
            e = f5.result()
            f = f6.result()
            g = v1.result()
            h = f7.result()
            l = [a,b,c,d,e,f,g,h]
            print("Calling upload to AWS")
            f8=executor.submit(Upload_to_aws,l)

    ''' Calls video_making present in Capture_Video.py for stitching frames to video '''
    flag = True
    while flag:
        if v0.done():
            flag = False
            video = executor.submit(video_making)

    ''' Calls upload_to_s3 to uploading the video clip to S3 bucket '''
    flag = True
    while flag:
        if video.done():
            flag = False
            video_upload = executor.submit(upload_to_s3, 'output/videos/'+frame_id+'.mp4', s3_bucket, "video/")

#End of Code
