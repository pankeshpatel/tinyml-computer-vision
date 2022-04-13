from fastapi import APIRouter



face_router = APIRouter()

@face_router.get("/ping_face")
def face_hello():
  return {"hello from face router"}


# # API 1
# @router.post('/add-face')
# def add_face(event: dict):
#     response = add_face_helper(event)
#     return response


# # API 2
# @router.post("/delete-face")
# def delete_face(event: dict):
#    return {"delete face"}

#     # response = delete_face_helper(event)
#     # return response
   

# # API 9  
# @router.post("/get-face-details")
# def get_face_details(event: dict):
#     response = get_face_details_helper(event)
#     return response





