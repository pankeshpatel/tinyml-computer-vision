<<<<<<< Updated upstream
from fastapi import FastAPI
=======
from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.exceptions import RequestValidationError
>>>>>>> Stashed changes
from fastapi.middleware.cors import CORSMiddleware
from routers.index import *
from config.openapi import tags_metadata

<<<<<<< Updated upstream
=======
from schemas import User,UserInDB, Token, TokenData
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from typing import Optional
from datetime import datetime, timedelta



>>>>>>> Stashed changes
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


<<<<<<< Updated upstream
 
 
=======

app.include_router(auth_router)
>>>>>>> Stashed changes
app.include_router(contact_router)
app.include_router(event_router)
app.include_router(face_router)
app.include_router(video_router)
<<<<<<< Updated upstream
 
 
 
=======
app.include_router(sns_router)
>>>>>>> Stashed changes
