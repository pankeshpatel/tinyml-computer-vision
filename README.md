## TinyML-Computer-Vision

### Use cases

1. Detect Face
2. Detect Pet (Cat, Dog) 
3. Detect Gun
4. Detect NoteWorthy Vehicles:
  - (Ambulance, Firetruck) as Truck
  - Car detection
  - USPS, FedEx, DHL, Amazon Prime (Logo_Detection)
5. Detection of Packages/Couriers box

### aws-saas
    

  - `main.py`:
    This is the Main Python Program where the execution takes place. It requires `AWS_Constants.py`, `AWS_Rekognition.py`, `Capture_Video.py` python files to be in same folder. Before Running, Update your AWS - Cloud Credentials in `AWS_Constants.py` file

  -  `Index_Face.py`:
      This python Script is used to index known faces for Smart Doorbell usecase. 
      Indexed faces will be recognized when they are at your doorstep 

  -  `Capture_Video.py`
     This python script is used for capturing frames/images through camera stitching them together for making Video clip.

  -  `AWS_Rekognition.py`
     This Module holds all the AWS - Rekognition functions required to detect the  use-cases for a smart doorbell
     use-cases -> Detect Face, Pet (Cat, Dog), Gun, NoteWorthy Vehicle(Ambulance, Firetruck) as Truck
     Car, Packages/Couriers, Logo_Detection - USPS, FedEx, DHL, Amazon Prime

  -  `AWS_Constants.py`
    This Script is used to assign your AWS Credetials  which will be will be used to initialize the AWS - Cloud services. You can get your AWS - Cloud services credentials from your account settings  
    [Security Credetials](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credentials)

  -   `test-dataset-aws-rekognition`: 
    This folder contains test images that are used to test        AWS Rekognition Services.
 


### on-device computer vision



### classical computer vision


### backend server

### mobile app
 

### comparative analysis



### dissemination

- demos
- research papers
- talks


