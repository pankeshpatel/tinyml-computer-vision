## TinyML-Computer-Vision

### Use cases

- Detect Face
- Detect Pet (Cat, Dog) 
- Detect Gun
- Detect NoteWorthy Vehicles:
  - (Ambulance, Firetruck) as Truck
  - Car detection
  - USPS, FedEx, DHL, Amazon Prime (Logo_Detection)
- Detection of Packages/Couriers box

### approach 1: aws-saas
    

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
 


### approach 2: on-device computer vision
 - Devices 
   - [Raspberry PI 3 Model B+](https://www.amazon.in/gp/product/B07BDR5PDW/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
   - [NVIDIA Jetson Nano](https://www.amazon.in/gp/product/B07PZHBDKT/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
   - [Arduino Nano 33 BLE](http://store.arduino.cc/products/arduino-nano-33-ble)



### approach 3: classical computer vision


### comparative analysis


### api-server

### mobile app
 
### dissemination

- demos
- research papers
- talks


