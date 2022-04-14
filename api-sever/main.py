from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers.index import *
from config.openapi import tags_metadata

app = FastAPI(
   title = "Edge AI APIs",
   description = "REST API Server",
   version = "0.0.1",
   openapi_tags = tags_metadata
)

# Update list with the URL:port where the front end is running
origins = [
    "http://localhost:3000",
]

# App object
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# @app.get("/ping_main", tags=["ping"])
# def hello_world():
#   return {"main server is running"}
 
 
app.include_router(contact_router)
app.include_router(event_router)
app.include_router(face_router)
app.include_router(video_router)
 
 
 
