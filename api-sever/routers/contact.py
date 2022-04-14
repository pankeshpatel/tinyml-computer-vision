from fastapi import APIRouter
from variables import *
from schemas.users import UserUpdateDetail


contact_router = APIRouter()

@contact_router.get("/ping_contact", tags=["ping"])
def contact_hello():
  return {"hello from contact router"}


'''
API - 11 : /edit-contact //Sample got problem
'''
@contact_router.post("/edit-contact", tags=["contact"])
async def edit_contact(request: dict):
    previous_name = request['previous_name']
    fullname = request['fullname']
    p_name1 = previous_name.split()
    p_name = ''
    name1 = fullname.split()
    name = ''
    for i in p_name1:
        p_name = p_name + i
    for i in name1:
        name = name + i
    p_email = request['emailId']
    p_phone = request['phone']
    p_group = request['group']
    face = request['face']
    response = ddb_table.get_item(Key={'fullname': previous_name})
    #face = request['face']
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
        obj = s3_resource.Object(S3_BUCKET_NAME,file_name)
        obj.put(Body=base64.b64decode(res))
    res_code = response['ResponseMetadata']['HTTPStatusCode']
    return {
        "Status":res_code,
        "Message" : "User details updated successfully "
    }
   

'''
API - 4 : /update-details - change/update group (i.e. friend, family, visitor)
'''   
@contact_router.post("/update-details", tags=["contact"])
async def update_details(request: UserUpdateDetail):
  fullname = request.fullname
  updated_group = request.group
  
  
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
  response_code = int(response_code)
  response = ddb_table.get_item(Key={'fullname': fullname})
  
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
   
   
# '''
# API - 3 : /get-data-on-group
# '''
@contact_router.post("/get-data-on-group", tags=["contact"])
async def get_data_on_group(request: dict):
    group = request['group']
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
        image = S3_FACE_URL + name +'.jpeg'
        print(image)
        response['Items'][i]['img'] = image
    response_code = response['ResponseMetadata']['HTTPStatusCode']
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