from fastapi import FastAPI, status
from pydantic import BaseModel
from typing import Optional


'''------------Schemas for face.py------------'''
class AddUserDetailsRequest(BaseModel):
    fullname: str
    face: str
    phone: str
    group: str
    emailId: str

class DeleteUserDetailsRequest(BaseModel):
    fullname: str

class GetUserDetailsRequest(BaseModel):
    fullname: str

'''------------Schemas for contacts.py------------'''
class EditContactDetailsRequest(BaseModel):
    previous_name: str
    fullname: str
    face: str
    phone: str
    emailId: str

class UserUpdateDetailRequest(BaseModel):
    fullname: str
    group: str

class GetUserFromGroupRequest(BaseModel):
    group: str

'''------------Schemas for event.py------------'''
class GetEventDetailsRequest(BaseModel):
    fullname: str


'''---------Schema for USer -------'''
class User(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    disabled: Optional[bool] = None

class UserInDB(User):
    hashed_password: str

class Token(BaseModel):
    status_code: int
    access_token: str
    token_type: str
    message: str

class TokenData(BaseModel):
    username: Optional[str] = None



'''---------Schema for SNS -------'''
class SNSRegistrationRequest(BaseModel):
    username: str
    token: str
    deviceID: int
    authToken: str
