import boto3
from boto3.dynamodb.conditions import Key, Attr
from dotenv import load_dotenv
import os
import json
import base64
import datetime

load_dotenv()  # take environment variables from .env.
your_region_name = os.getenv("your_region_name")
your_aws_access_key_id = os.getenv("your_aws_access_key_id")
your_aws_secret_access_key = os.getenv("your_aws_secret_access_key")

'''dynamodb instance using boto3'''
dynamodb_resource = boto3.resource('dynamodb', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)
dynamodb_client = boto3.client('dynamodb', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)

'''S3 client using Boto3'''
s3 = boto3.client('s3', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)
s3_resource = boto3.resource('s3', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)

'''Rekognition Client for add face'''
rekog_client = boto3.client('rekognition', region_name = your_region_name, aws_access_key_id = your_aws_access_key_id, aws_secret_access_key = your_aws_secret_access_key)

''' DynamoDB Table Name '''
ddb_table = dynamodb_resource.Table("registration_details")

''' S3 bucket_name '''
bucket_name = "registered-faces"



''' API - 1 : Add user's "fullname", "phone", "group","emailId" & "Face" '''
def add_face_helper(event: dict):
    response = {}
    fullname = event['fullname']
    phone = event['phone']
    group = event['group']
    emailId = event['emailId']
    face = event['face']

    response['fullname'] = fullname
    response['phone'] = phone
    response['group'] = group
    response['emailId'] = emailId
    ddb_table.put_item(Item = response)
    print("fullname", fullname)
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    print("S3 name:",name)
    print("finalname for s3 folder: ",name)
    res = bytes(face, 'utf-8')
    image_64_decode = base64.decodebytes(res)
    file_name = name +'.jpeg'
    obj = s3_resource.Object(bucket_name,file_name)
    obj.put(Body=base64.b64decode(res),ACL = 'public-read')
    print("Done!!")
    collectionId = 'addFace'
    index_response = rekog_client.index_faces(CollectionId=collectionId,
                                Image={'S3Object':{'Bucket':bucket_name,'Name':file_name}},
                                ExternalImageId=name,
                                MaxFaces=1,
                                QualityFilter="AUTO",
                                DetectionAttributes=['ALL'])
    print("index_faces", index_response)
    return {
        'statusCode': 200,
        'body': response,
        'message': 'Data Stored Successfully!!!'
    }


''' API - 2 : /delete-face '''
def delete_face_helper(event: dict):
    fullname = event['fullname']
    print(fullname)
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    response = ddb_table.get_item(Key={'fullname': fullname})
    ddb_table.delete_item(
    Key={
        'fullname': fullname
    })
    obj = s3_resource.Object(bucket_name, name + '.jpeg').delete()
    response_code = response['ResponseMetadata']['HTTPStatusCode']
    print('Res Code:',response_code)
    response_code = int(response_code)
    if response_code == 200:
        res_msg = {
        'statusCode': response_code,
        'body': {
            'Response':'Data deleted successfully!!!'
            }
        }
    else:
        res_msg = {
            'message': 'Unable to Process Request'
        }
    return res_msg



''' API - 3 : /get-data-on-group '''
def get_data_on_group_helper(event: dict):
    group = event['group']
    response = ddb_table.scan(
        FilterExpression=Attr('group').eq(group)
    )
    print("raw_responce",response)
    for i in range(0,len(response['Items'])):
        print(response['Items'][i])
        fullname = response['Items'][i]['fullname']
        name1 = fullname.split()
        name = ''
        for j in name1:
            name = name + j
        print("name:" ,name)
        image = 'https://registered-faces.s3.amazonaws.com/' + name +'.jpeg'
        print(image)
        response['Items'][i]['img'] = image
    print("end_res",response)
    response_code = response['ResponseMetadata']['HTTPStatusCode']
    print('Res Code:',response_code)
    response_code = int(response_code)
    if response_code == 200:
        res_msg = {
        'statusCode': response_code,
        'body': {
            'Response':'Data Retrieved Successfully',
            'Data': response['Items']
            }
        }
    else:
        res_msg = {
            'message': 'Unable to process request!'
        }

    return res_msg



''' API - 4 : /update-details - change/update group (i.e. friend, family, visitor) '''
def update_details_helper(event: dict):
    fullname = event['fullname']
    updated_group = event['group']
    response = ddb_table.get_item(Key={'fullname': fullname})
    email = response['Item']['emailId']
    phone = response['Item']['phone']

    item = {}
    item['fullname'] = fullname
    item['phone'] = phone
    item['group'] = updated_group
    item['emailId'] = email
    ddb_table.put_item(Item = item)

    response_code = response['ResponseMetadata']['HTTPStatusCode']
    print('Res Code:',response_code)
    response_code = int(response_code)
    print ("After update \n")
    response = ddb_table.get_item(Key={'fullname': fullname})
    print (response['Item'])
    if response_code == 200:
        res_msg = {
        'statusCode': response_code,
        'body': {
            'Response':'Data Updated Successfully',
            'data': item
            }
        }
    else:
        res_msg={
            'message':'Unable to process request'
        }
    return res_msg


''' API - 9 : /get-face-details '''
def get_face_details_helper(event: dict):
    fullname = event['fullname']
    name1 = fullname.split()
    print("Got username:", fullname)
    print("name1", name1)
    name = ''
    for i in name1:
        name = name + i
    print("name:", name)
    response = ddb_table.get_item(Key={'fullname': fullname})
    print(" DynamoDB response", response)
    bucket_name = 'registered-faces'
    data = s3.get_object(Bucket=bucket_name, Key=name +'.jpeg')
    contents = data['Body'].read()
    '''encoded_string = base64.b64encode(contents)
    print('type', type(encoded_string))
    enc = str(encoded_string)
    enclen = int(len(enc))
    print("enclen:",enclen)
    enc = enc[2:enclen-1] #to remove b' '''
    img = 'https://registered-faces.s3.amazonaws.com/' + name +'.jpeg';
    response_code = data['ResponseMetadata']['HTTPStatusCode']
    print('Res Code:',response_code)
    response_code = int(response_code)

    if response_code == 200:
        res_msg = {
        'statusCode': response_code,
        'Response':'Data Retrieved Successfully',
        'body': {
            'fullname':fullname,
            'emailId': response['Item']['emailId'],
            'group': response['Item']['group'],
            'phone': response['Item']['phone'],
            'img': img
            }
        }
    else:
        res_msg = {
            'message': 'Unable to process request!'
        }
    return res_msg




''' API - 10 : /get-event-details '''
def get_event_details_helper(event: dict):
    ddb_table = dynamodb_resource.Table("edge_db")
    fullname = event['fullname']
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    print(name)
    response = ddb_table.scan(
        FilterExpression=Attr('external_image_id').eq(name))
    data = {"notification": []}
    temp = data['notification']
    for i in range(len(response['Items'])):
        data1 = response['Items'][i]['notification']
        print(response['Items'][i]['notification'])
        timestamp =  response['Items'][i]['approx_capture_timestamp']
        time1 = datetime.datetime.fromtimestamp(int(timestamp))
        #time = time1.strftime("%m-%d-%Y  %H:%M %P")
        time = time1.strftime("%m-%d-%Y  %H:%M:%S")
        print("time:",time)
        #video = 'https://rpidemo.s3.amazonaws.com/video/'+response['Items'][i]['s3_video_key']
        y = {
            "title":data1,
            "time": time
        }
        temp.append(y)
    print(data)
    response_code = response['ResponseMetadata']['HTTPStatusCode']
    print('Res Code:',response_code)
    response_code = int(response_code)
    if response_code == 200:
        res_msg = {
        'statusCode': response_code,
        'Data': data
        }
    else:
        res_msg={
            'message':'Unable to process request'
        }

    return res_msg

''' API - 11 : /edit-contact //Sample got problem '''
def edit_contact_helper(event: dict):
    previous_name = event['previous_name']
    fullname = event['fullname']
    p_name1 = previous_name.split()
    p_name = ''
    name1 = fullname.split()
    name = ''
    for i in p_name1:
        p_name = p_name + i
    for i in name1:
        name = name + i
    print("p_name",p_name)
    print("new name",name)
    p_email = event['emailId']
    p_phone = event['phone']
    p_group = event['group']
    face = event['face']
    response = ddb_table.get_item(Key={'fullname': previous_name})
    print(response)
    #face = event['face']
    if (response['ResponseMetadata']['HTTPStatusCode'] == 200):
        ddb_table.delete_item(Key={'fullname': previous_name})
        item = {}
        item['fullname'] = fullname
        item['phone'] = p_phone
        item['group'] = p_group
        item['emailId'] = p_email
        ddb_table.put_item(Item = item)
        res = bytes(face, 'utf-8')
        image_64_decode = base64.decodebytes(res)
        file_name = name +'.jpeg'
        print(file_name)
        #Deleting S3 item
        del_item = s3.delete_object(Bucket=bucket_name, Key=p_name + '.jpeg')
        #s3.Object(bucket_name, file_name).delete()
        #inserting new Image
        obj = s3_resource.Object(bucket_name,file_name)
        obj.put(Body=base64.b64decode(res))
    print(previous_name + " | " + fullname + " | " + p_email + " | " + str(p_phone) + " | " + p_group)
    res_code = response['ResponseMetadata']['HTTPStatusCode']
    return {
        "Status":res_code,
        "Message" : "User details updated successfully "
    }



''' API - 12 : get-all-video-details '''
def get_all_video_details_helper():
    response = dynamodb_client.scan(TableName = 'edge_db',
                    AttributesToGet=['notification','approx_capture_timestamp','s3_video_key'])
    data = {"notification": []}
    temp = data['notification']
    for i in range(len(response['Items'])):
        data1 = response['Items'][i]['notification']['S']
        print(response['Items'][i]['notification']['S'])
        timestamp = response['Items'][i]['approx_capture_timestamp']['N']
        time = datetime.datetime.fromtimestamp(int(timestamp))
        time1 = time.strftime("%d, %b %Y :  %H:%M:%S")
        print(time1)
        url = 'https://rpidemo.s3.amazonaws.com/video/'
        video = response['Items'][i]['s3_video_key']['S']
        video = url + video
        y = {"title":data1,
            "time": time1,
            "video": video
        }
        temp.append(y)
        print(video)
    print(len(response['Items']))
    print(time.now().time())

    return {
        'statusCode': 200,
        'Data': data
    }
