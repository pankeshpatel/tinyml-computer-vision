from fastapi import APIRouter, HTTPException, Depends,Response, status
from variables import *
from .auth import *
from schemas import SNSRegistrationRequest



sns_router = APIRouter()

@sns_router.post('/sns-registration', tags=["SNS"], status_code=200)
async def sns_registration(request:SNSRegistrationRequest):
    username = request.username
    token = request.token
    deviceID = request.deviceID
    authToken = request.authToken
    try:
        response = sns_client.create_platform_endpoint(
            PlatformApplicationArn='arn:aws:sns:us-west-2:363697981190:app/APNS_SANDBOX/ios-application',
            Token=token,
            CustomUserData=username,
        )

        endpoints = sns_client.list_endpoints_by_platform_application(
            PlatformApplicationArn='arn:aws:sns:us-west-2:363697981190:app/APNS_SANDBOX/ios-application',

        )

        mobile_arns = []
        for i in range(len(endpoints['Endpoints'])):
            print(endpoints['Endpoints'][i]['EndpointArn'])
            mobile_arns.append(endpoints['Endpoints'][i]['EndpointArn'])
        print("-----")

        for i in range(len(mobile_arns)):
            print("i:" + mobile_arns[i])
            sns_subscribe = sns_client.subscribe(
                TopicArn='arn:aws:sns:us-west-2:363697981190:ios-notification',
                Protocol='application',
                Endpoint= mobile_arns[i],
                ReturnSubscriptionArn=True
            )


        res_msg =  {
                'status_code': status.HTTP_200_OK,
                'message': 'Success!!!'
        }
        return res_msg
    except ClientError as e:
        print("Error: " + e.response['Error']['Message'])
        response = e.response['Error']['Message']
        return response
