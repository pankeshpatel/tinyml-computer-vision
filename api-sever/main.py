from fastapi import FastAPI
from fastapi import Request
from fastapi.middleware.cors import CORSMiddleware

from aws_helper_func import *

'''Update list with the URL:port where the front end is running'''
origins = [
    "http://localhost:3000",
]

'''App object'''
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

''' Entry Point '''
@app.get("/")
def index():
    help()
    return {"name":"Shailesh Arya"}

# One with bitbuck has problem with image base 64
'''
API - 1 : Add user's "fullname", "phone", "group","emailId" & "Face"
'''
@app.post("/add-face")
def add_face(event: dict):
    response = add_face_helper(event)
    return response

'''
API - 2 : /delete-face
'''
@app.post("/delete-face")
def delete_face(event: dict):
    response = delete_face_helper(event)
    return response

'''
API - 3 : /get-data-on-group
'''
@app.post("/get-data-on-group")
def get_data_on_group(event: dict):
    response = get_data_on_group_helper(event)
    return response


'''
API - 4 : /update-details - change/update group (i.e. friend, family, visitor)
'''
@app.post("/update-details")
def update_details(event: dict):
    response = update_details_helper(event)
    return response


'''
API - 9 : /get-face-details
'''
@app.post("/get-face-details")
def get_face_details(event: dict):
    response = get_face_details_helper(event)
    return response

'''
API - 10 : /get-event-details
'''
@app.post("/get-event-details")
def get_event_details(event: dict):
    response = get_event_details_helper(event)
    return response


'''
API - 11 : /edit-contact //Sample got problem
'''
@app.post("/edit-contact")
def edit_contact(event: dict):
    response = edit_contact_helper(event)
    return response


'''
API - 12 : get-all-video-details
'''
@app.get("/get-all-video-details")
def get_all_video_details():
    response = get_all_video_details_helper()
    return response
