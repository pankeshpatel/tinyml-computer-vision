from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

class UserUpdateDetailIn(BaseModel):
   fullname: str
   group: str
   

