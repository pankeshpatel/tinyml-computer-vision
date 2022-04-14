from fastapi import APIRouter
from variables import *

event_router = APIRouter()

# @event_router.get("/ping_event" , tags=["ping"])
# def event_hello():
#   return {"hello from event router"}


#''' API - 10 : /get-event-details '''

@event_router.post("/get-event-details", tags=["event"])
async def get_event_details(request: dict):
    ddb_table = dynamodb_resource.Table(AWS_DB_TABLE2)
    fullname = request['fullname']
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
    response_code = response['ResponseMetadata']['HTTPStatusCode']
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