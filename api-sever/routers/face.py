from fastapi import APIRouter
from aws_helper_func import *


face_router = APIRouter()

@face_router.get("/ping_face")
def face_hello():
  return {"hello from face face_router"}


# # API 1
@face_router.post('/add-face')
def add_face(event: dict):
    response = add_face_helper(event)
    return response


# API 2
@face_router.post("/delete-face")
def delete_face(event: dict):
   response = delete_face_helper(event)
   return response
   

# API 9  
@face_router.post("/get-face-details")
def get_face_details(event: dict):
    response = get_face_details_helper(event)
    return response





