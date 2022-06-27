<<<<<<< Updated upstream
from fastapi import APIRouter
=======

from .auth import *
from fastapi import APIRouter, HTTPException, status, Response

>>>>>>> Stashed changes
from variables import *
import base64
from schemas import AddUserDetailsRequest, DeleteUserDetailsRequest, GetUserDetailsRequest


<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
face_router = APIRouter()

# API - 1 : Add user's "fullname", "phone", "group","emailId" & "Face" '''
<<<<<<< Updated upstream
@face_router.post('/add-face', tags=["face"])
async def add_face(request: AddUserDetailsRequest):

=======
@face_router.post('/add-face', tags=["face"], status_code=201)
async def add_face(request: AddUserDetailsRequest, res:Response = Depends(get_current_active_user)):
>>>>>>> Stashed changes
    fullname = request.fullname
    face = request.face
    phone = request.phone
    group = request.group
    emailId = request.emailId

    response = {}
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
<<<<<<< Updated upstream
    index_response = rekog_client.index_faces(
                          CollectionId=AWS_RECK_COLLECTION_ID,
                          Image={'S3Object':{'Bucket':S3_BUCKET_NAME,'Name':file_name}},
                          ExternalImageId=name,
                          MaxFaces=1,
                          QualityFilter="AUTO",
                          DetectionAttributes=['ALL']
                          )
    response_code = index_response['ResponseMetadata']['HTTPStatusCode']
    response_code = int(response_code)
    if response_code == 200:
        return {
            'statusCode': 200,
=======

    #rekog_client_response=rekog_client.create_collection(CollectionId=AWS_RECK_COLLECTION_ID)

    try:
        index_response = rekog_client.index_faces(
                              CollectionId=AWS_RECK_COLLECTION_ID,
                              Image={'S3Object':{'Bucket':S3_BUCKET_NAME,'Name':file_name}},
                              ExternalImageId=name,
                              MaxFaces=1,
                              QualityFilter="AUTO",
                              DetectionAttributes=['ALL']
                              )
    except ClientError as e:
         print(e.response['Error']['Message'])
         return e.response['Error']['Message']

    res_msg =  {
            'status_code': status.HTTP_201_CREATED,
>>>>>>> Stashed changes
            'body': response,
            'message': 'Data Stored Successfully!!!'
        }
    else:
        res_msg = {
            'message': 'Unable to Process Request'
        }



''' API - 2 : /delete-face '''
@face_router.post("/delete-face", tags=["face"])
<<<<<<< Updated upstream
async def delete_face(request: DeleteUserDetailsRequest):
=======
async def delete_face(request: DeleteUserDetailsRequest, res:Response = Depends(get_current_active_user)):
>>>>>>> Stashed changes
    fullname = request.fullname
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
<<<<<<< Updated upstream
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
@face_router.post("/get-face-details", tags=["face"])
async def get_face_details(request: GetUserDetailsRequest):
=======
    try:
        response = ddb_table.get_item(Key={'fullname': fullname})
        if "Item" in response.keys():
            ddb_table.delete_item(
            Key={
                'fullname': fullname
            })
            obj = s3_resource.Object(S3_BUCKET_NAME, name + '.jpeg').delete()

            res_msg = {
                'status_code': status.HTTP_200_OK,
                'body': {'Response':'Data deleted successfully!!!'
                        }
            }
            return res_msg
        else:
            #res.status_code = 404
            # return {"response_code": 400,
            #         "details": "Item not Found"}
            raise HTTPException(status_code=404, detail={"status_code": 404, "msg":"Item not found"})
    except ClientError as e:
         print(e.response['Error']['Message'])
         return e.response['Error']['Message']



''' API - 9 : /get-face-details '''
@face_router.post("/get-face-details", tags=["face"], status_code=200)
async def get_face_details(request: GetUserDetailsRequest , res:Response = Depends(get_current_active_user)):
>>>>>>> Stashed changes
    fullname = request.fullname
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
<<<<<<< Updated upstream
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
=======
    try:
        response = ddb_table.get_item(Key={'fullname': fullname})
        if "Item" in response.keys():
            #bucket_name = 'registered-faces'
            data = s3.get_object(Bucket=S3_BUCKET_NAME, Key=name +'.jpeg')
            contents = data['Body'].read()
            img = S3_FACE_URL + name +'.jpeg';
            response_code = data['ResponseMetadata']['HTTPStatusCode']
            res_msg = {
            'status_code': response_code,
            'Response':'Data Retrieved Successfully',
            'body': {
                'fullname':fullname,
                'emailId': response['Item']['emailId'],
                'group': response['Item']['group'],
                'phone': response['Item']['phone'],
                'img': img
                }
            }
            return res_msg
        else:
            #res.status_code = 404
            # return {"status_code": 400,
            #         "details": "Item not Found"}
            raise HTTPException(status_code=404, detail={"status_code": 404, "msg":"Item not found"})
    except ClientError as e:
         print(e.response['Error']['Message'])
         return e.response['Error']['Message']
    # except:
    #     raise HTTPException(status_code=404, detail="Item not found")
>>>>>>> Stashed changes
