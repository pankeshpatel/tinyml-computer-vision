<<<<<<< Updated upstream
from fastapi import APIRouter
=======
from fastapi import APIRouter, HTTPException, Depends,Response, status
>>>>>>> Stashed changes
from variables import *
from .auth import *
import datetime


video_router = APIRouter()


# ''' API - 12 : get-all-video-details '''

@video_router.get("/get-all-video-details", tags=["video"])
<<<<<<< Updated upstream
async def get_all_video_details():
   response = dynamodb_client.scan(TableName = AWS_DB_TABLE2,
                   AttributesToGet=['notification','approx_capture_timestamp','s3_video_key'])
   data = {"notification": []}
   temp = data['notification']
   for i in range(len(response['Items'])):
       data1 = response['Items'][i]['notification']['S']
       timestamp = response['Items'][i]['approx_capture_timestamp']['N']
       time = datetime.datetime.fromtimestamp(int(timestamp))
       time1 = time.strftime("%d, %b %Y :  %H:%M:%S")
       url = S3_VIDEO_URL
       video = response['Items'][i]['s3_video_key']['S']
       video = url + video
       y = {
           "title":data1,
           "time": time1,
           "video": video
       }
       temp.append(y)


   return {
       'statusCode': 200,
       'Data': data
   }
=======
async def get_all_video_details(res:Response = Depends(get_current_active_user)):
    try:
        response = dynamodb_client.scan(TableName = AWS_DB_TABLE2,
                   AttributesToGet=['notification','approx_capture_timestamp','s3_video_key'])
        print(response['ResponseMetadata']['HTTPStatusCode'])
        data = {"status_code": status.HTTP_200_OK,
                "message": "Data retrieved successfully",
                "notification": []}
        temp = data['notification']
        for i in range(len(response['Items'])):
           data1 = response['Items'][i]['notification']['S']
           timestamp = response['Items'][i]['approx_capture_timestamp']['N']
           time = datetime.datetime.fromtimestamp(int(timestamp))
           time1 = time.strftime("%d, %b %Y :  %H:%M:%S")
           url = S3_VIDEO_URL
           video = response['Items'][i]['s3_video_key']['S']
           video = url + video
           y = {
               "title":data1,
               "time": time1,
               "video": video
           }
           temp.append(y)
        return data

    except ClientError as e:
        print("Error: " + e.response['Error']['Message'])
        response = e.response['Error']['Message']
        return response
    # except:
    #     raise HTTPException(status_code=404, detail="Table not found!!")




    # return {
    #    'statusCode': 200,
    #    'Data': data
    # }
>>>>>>> Stashed changes
