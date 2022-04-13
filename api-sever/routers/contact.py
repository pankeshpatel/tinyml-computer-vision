from fastapi import APIRouter


contact_router = APIRouter()

@contact_router.get("/ping_contact")
def contact_hello():
  return {"hello from contact router"}




'''
API - 11 : /edit-contact //Sample got problem
'''
# @contact_router.post("/edit-contact")
# def edit_contact(event: dict):
#     return {"edit contact api"}
#     response = edit_contact_helper(event)
#     return response
   

'''
API - 4 : /update-details - change/update group (i.e. friend, family, visitor)
'''   
# @contact_router.post("/update-details")
# def update_details(event: dict):
#     response = update_details_helper(event)
#     return response
   
   
# '''
# API - 3 : /get-data-on-group
# '''
# @router.post("/get-data-on-group")
# def get_data_on_group(event: dict):
#     response = get_data_on_group_helper(event)
#     return response