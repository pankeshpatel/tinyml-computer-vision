from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers.contact import contact_router
from routers.event import event_router
from routers.face import face_router
from routers.video import video_router



app = FastAPI()

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

@app.get("/ping_main")
def hello_world():
  return {"main server is running"}
 
 
app.include_router(contact_router)
app.include_router(event_router)
app.include_router(face_router)
app.include_router(video_router)
 
 
 
