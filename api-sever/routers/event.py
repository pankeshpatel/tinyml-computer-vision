from fastapi import APIRouter
from aws_helper_func import *



event_router = APIRouter()

@event_router.get("/ping_event")
def event_hello():
  return {"hello from event router"}


@event_router.post("/get-event-details")
def get_event_details(event: dict):
    response = get_event_details_helper(event)
    return response