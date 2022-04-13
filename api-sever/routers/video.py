from fastapi import APIRouter


video_router = APIRouter()

@video_router.get("/ping_video")
def video_hello():
  return {"hello from video router"}


# @router.get("/get-all-video-details")
# def get_all_video_details():
#     return {"get all video detail"}

#     # response = get_all_video_details_helper()
#     # return response
   
   