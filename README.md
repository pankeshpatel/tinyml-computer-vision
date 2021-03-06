## TinyML-Computer-Vision

### Use cases

- Detect Face
- Detect Pet (Cat, Dog) 
- Unsafe Content Detection (e.g., Gun)
- Detect NoteWorthy Vehicles:
  - (Ambulance, Firetruck) as Truck
  - Car detection
  - USPS, FedEx, DHL, Amazon Prime (Logo_Detection)
- Detection of Packages/Couriers box

### approach 1: aws-saas for video analytics
    
 - We here implement Advance Scene Detection Analytics across Edge and Cloud resources.The proposal uses AWS(Amazon Web Services) as a base platform for implementation.

 - It is an attempt to mimic the scenario described in the paper [Demonstration of a Cloud-based Software Framework for Video Analytics Application using Low-Cost IoT Devices](https://arxiv.org/abs/2010.07680).

- For more detailed explantation of paper watch this video [A Cloud-based Smart Doorbell using Low-Cost COTS  Devices](https://www.youtube.com/watch?v=42mx4Z2PDwA).


#### AWS Services Used

 -  AWS Rekognition - For advance scence detection in a video
 -  AWS Kinesis - For uploading video analytics data of edge to AWS cloud.
 -  AWS DynamoDB - For storing video analytics data in Cloud.
 -  AWS S3- For storing videos and frames (images) of edge at Cloud.
 -  AWS SNS - For service notification
    


#### code structure

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

#### code structure

 - `Gun_Detect.py`:
    This script is used for detecting Harmful Weapon Detection (e.g. GUN) using TensorFlow Lite Interpreter.
    - **Model Name: gun_model_2.2.tflite**
 - `Logo_Detect.py`:
    This script is used for detecting Logos of Courier Companies - DHL, FedEx, Amazon Prime, USPS on Delivery Vans
    using TensorFlow Lite Interpreter.  
    - **Model Name: LogoModel.tflite**
 - `MobileNetSSD.py`:
    This script is used for detecting common objects using pre-trained TFLite MobileNetSSD v2 model with TensorFlow Lite Interpreter.
    Objects: (e.g., Person, Pet [Dog, Cat], Car, Noteworthy Vehicle [Ambulance, Firetruck] as Truck )
    - **Model Name:MobileNetV2.tflite**
 - `Package_Detect.py`:
    This script is used for detecting packages/couriers delivered to your doorsteps.
    - **Model Name: PackageModel.tflite**
 - `test-dataset-ondevice-dl`:
    This folder contains test images that are used to test On-Device Object Detection Models.
 - `test-dataset-ondevice-dl`:
    This folder contains train images that are used to custom models for package detection and logo detection (e.g., DHL, FedEx, USPS, Amazon Prime)
 - `TFLite model`:
    This folder contains all the TFLite models (pre-trained & custom trained) used for object detection.    
 - `labelmap`:
    This folder contains label_map.txt files which refers to the class names for pre-trained and custom Deep Learning Models.
 - `result`:
    This folder contains object detection results for the experiments performed on Raspberry Pi and Nvidia Jetson Nano.

### approach 3: classical computer vision

#### viola-jones algorithm - **haar cascade**

#### code structure

- `main.py`: This script contains the code for detecting the use case for a smart doorbell using HAAR Cascade
             use-cases -> Detect Face, Pet (Cat, Dog), Gun, Noteworthy Vehicle(Ambulance, Firetruck) as Truck
                          Car, Packages/Couriers, Logo Detection - USPS, FedEx, DHL, Amazon Prime

- `CascadeClassifier`
  - `FrontalFace_cascade.xml` -- For Face detection
  - `Gun_cascade.xml` -- For Harmful weapon detection
  - `Cat_cascade.xml` -- For Cat detection
  - `Dog_cascade.xml` -- For Dog detection
  - `Ambulance_cascade` -- For Ambulance detection
  - `Firetruck_cascade` -- For Firetruck detection
  - `Package_cascade.xml` -- For Package detection
  - `Amazon_cascade.xml` -- For Amazon Prime Logo detection
  - `DHL_cascade.xml` -- For DHL Logo detection
  - `FedEx_cascade.xml` -- For FedEx Logo detection
  - `Usps_cascade.xml` -- For USPS Logo detection


### comparative analysis


### api-server

### mobile app
 
### disseminations

- Research Papers
  - [A Distributed Framework to Orchestrate Video Analytics Applications](https://arxiv.org/abs/2009.09065)
  
  - [Demonstration of a Cloud-based Software Framework for Video Analytics Application using Low-Cost IoT Devices](https://arxiv.org/abs/2010.07680)

  - [A Demonstration of Smart Doorbell Design Using Federated Deep Learning](https://arxiv.org/abs/2010.09687)

- Demos
  - For more detailed explantation of paper watch this video [A Cloud-based Smart Doorbell using Low-Cost COTS  Devices](https://www.youtube.com/watch?v=42mx4Z2PDwA).


- Talks


