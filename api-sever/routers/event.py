from fastapi import APIRouter


event_router = APIRouter()

@event_router.get("/ping_event")
def event_hello():
  return {"hello from event router"}


# @router.post("/get-event-details")
# def get_event_details(event: dict):
#    return {"event api"}

    # response = get_event_details_helper(event)
    # return response