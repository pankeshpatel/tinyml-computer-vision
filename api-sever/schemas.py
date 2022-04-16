from fastapi import FastAPI
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
