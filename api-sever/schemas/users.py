from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

class UserUpdateDetail(BaseModel):
   fullname: str
   group: str
   
