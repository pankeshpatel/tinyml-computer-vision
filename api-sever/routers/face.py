from fastapi import APIRouter
from variables import *


face_router = APIRouter()

@face_router.get("/ping_face")
def face_hello():
  return {"hello from face face_router"}

# API - 1 : Add user's "fullname", "phone", "group","emailId" & "Face" '''
@face_router.post('/add-face')
def add_face(request: dict):
    response = {}
    fullname = request['fullname']
    phone = request['phone']
    group = request['group']
    emailId = request['emailId']
    face = request['face']

    response['fullname'] = fullname
    response['phone'] = phone
    response['group'] = group
    response['emailId'] = emailId
    ddb_table.put_item(Item = response)
    #print("fullname", fullname)
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    res = bytes(face, 'utf-8')
    image_64_decode = base64.decodebytes(res)
    file_name = name +'.jpeg'
    obj = s3_resource.Object(S3_BUCKET_NAME,file_name)
    obj.put(Body=base64.b64decode(res),ACL = 'public-read')
    #collectionId = 'addFace'
    index_response = rekog_client.index_faces(
                          CollectionId=AWS_RECK_COLLECTION_ID,
                          Image={'S3Object':{'Bucket':S3_BUCKET_NAME,'Name':file_name}},
                          ExternalImageId=name,
                          MaxFaces=1,
                          QualityFilter="AUTO",
                          DetectionAttributes=['ALL']
                          )
    return {
        'statusCode': 200,
        'body': response,
        'message': 'Data Stored Successfully!!!'
    }
   


''' API - 2 : /delete-face '''
@face_router.post("/delete-face")
def delete_face(request: dict):
    fullname = request['fullname']
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    response = ddb_table.get_item(Key={'fullname': fullname})
    ddb_table.delete_item(
    Key={
        'fullname': fullname
    })
    obj = s3_resource.Object(S3_BUCKET_NAME, name + '.jpeg').delete()
    response_code = response['ResponseMetadata']['HTTPStatusCode']
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
   

''' API - 9 : /get-face-details '''
@face_router.post("/get-face-details")
def get_face_details(request: dict):
    fullname = request['fullname']
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    response = ddb_table.get_item(Key={'fullname': fullname})
    #bucket_name = 'registered-faces'
    data = s3.get_object(Bucket=S3_BUCKET_NAME, Key=name +'.jpeg')
    contents = data['Body'].read()
    '''encoded_string = base64.b64encode(contents)
    print('type', type(encoded_string))
    enc = str(encoded_string)
    enclen = int(len(enc))
    print("enclen:",enclen)
    enc = enc[2:enclen-1] #to remove b' '''
    img = S3_FACE_URL + name +'.jpeg';
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





