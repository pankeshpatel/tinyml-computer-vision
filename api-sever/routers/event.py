<<<<<<< Updated upstream
from fastapi import APIRouter
=======
from fastapi import APIRouter,status, Response, Depends
>>>>>>> Stashed changes
from variables import *
import datetime
from .auth import *
from schemas import GetEventDetailsRequest


event_router = APIRouter()

<<<<<<< Updated upstream

#''' API - 10 : /get-event-details '''
@event_router.post("/get-event-details", tags=["event"])
async def get_event_details(request: GetEventDetailsRequest):
=======
''' API - 10 : /get-event-details '''
@event_router.post("/get-event-details", tags=["event"] )
async def get_event_details(request: GetEventDetailsRequest, res:Response = Depends(get_current_active_user)):
>>>>>>> Stashed changes
    ddb_table = dynamodb_resource.Table(AWS_DB_TABLE2)
    fullname = request.fullname
    name1 = fullname.split()
    name = ''
    for i in name1:
        name = name + i
    print(name)
<<<<<<< Updated upstream
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
            'statusCode': response_code,
            'message':'Unable to process request'
        }

    return res_msg
=======
    try:
        response = ddb_table.scan(
            FilterExpression=Attr('external_image_id').eq(name))
        print(response)
        if(response['Count'] == 0):
            #res.status_code = 404
            # return {"response_code": res.status_code,
            #         "details": "Item not Found"}
            raise HTTPException(status_code=404, detail={"status_code": 404, "msg":"Item not found"})
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
            res_msg = {
                'status_code': status.HTTP_200_OK,
                'Data': data
                }
            return res_msg
    except ClientError as e:
         print(e.response['Error']['Message'])
         return e.response['Error']['Message']
>>>>>>> Stashed changes
