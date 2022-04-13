from fastapi import APIRouter
from aws_helper_func import *
from variables import *



video_router = APIRouter()

@video_router.get("/ping_video")
def video_hello():
  return {"hello from video router"}


@video_router.get("/get-all-video-details")
def get_all_video_details():    
    response = get_all_video_details_helper()
    return response
   
   