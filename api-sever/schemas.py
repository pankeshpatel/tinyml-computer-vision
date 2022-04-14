from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

class UserUpdateDetailRequest(BaseModel):
   fullname: str
   group: str
   

