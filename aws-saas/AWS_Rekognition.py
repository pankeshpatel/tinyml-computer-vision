'''
         -----------------------------------------------------------------------------------------------------
            This Module holds all the AWS - Rekognition functions required to detect the 
            use-cases for a smart doorbell
            use-cases -> Detect Face, Pet (Cat, Dog), Gun, NoteWorthy Vehicle(Ambulance, Firetruck) as Truck
                                Car, Packages/Couriers, Logo_Detection - USPS, FedEx, DHL, Amazon Prime
         -----------------------------------------------------------------------------------------------------
'''


import boto3
import AWS_Constants

# Assigning AWS Credentials for using Cloud services
your_region_name =  AWS_Constants.your_region_name
your_aws_access_key_id = AWS_Constants.your_aws_access_key_id
your_aws_secret_access_key = AWS_Constants.your_aws_secret_access_key

# Initializing AWS Rekognition Client 
rekog_client = boto3.client("rekognition", region_name = your_region_name, aws_access_key_id = your_aws_access_key_id,
                    aws_secret_access_key = your_aws_secret_access_key)
    
# Initializing AWS Rekognition - Custom Labels ARNs
Package_Model_ARN = "arn:aws:rekognition:us-east-1:714655694284:project/package_detection/version/package_detection.2022-01-18T17.05.30/1642505730800" 
Logo_Model_ARN = "arn:aws:rekognition:us-east-1:714655694284:project/logo-detection/version/logo-detection.2022-03-01T18.47.23/1646140643597"

collectionId = 'addFace' #Used for Face Rekognition Only ( Create new Collection Using Index-Faces.py )

def Face_detection(img_bytes):
    """
    This function takes the input the bytearray of the image.
    Job --> Does FaceRekognition of the image
    Expected Output --> Detected Person and notification_type
    """
    detected_person = ''
    notification_type = ''
    # Detecting Faces in the Immage
    faceDetectionResponse = rekog_client.detect_faces(
                   Image=
                        {
                            'Bytes': img_bytes
                        },
                        Attributes=['ALL']
                    )

    # Check Face detection in an image
    # If there is a registered face(s) into a collection
    if len(faceDetectionResponse['FaceDetails']) != 0:
        # Search the face into the collection
        rekog_face_response = rekog_client.search_faces_by_image(
        CollectionId = collectionId,
        Image={ 
            'Bytes': img_bytes  
            }, 
        FaceMatchThreshold= 70,
        MaxFaces=10
        )
        
        if rekog_face_response['FaceMatches']:
            print('Detected, ',rekog_face_response['FaceMatches'][0]['Face']['ExternalImageId'])
            detected_person += rekog_face_response['FaceMatches'][0]['Face']['ExternalImageId']
            notification_type += 'known'
            
        else:
            notification_type += 'unknown'
            detected_person += 'unknown '
            print('No faces matched')
            
    return (detected_person, notification_type)
    
def Label_detection(img_bytes):
    """
    This function takes the input the bytearray of the image.
    Job --> Does Label Detection of the image
    Expected Output --> Set of the detected labels and JSON object received after detect_labels
    """
    labels_on_watch_list = [] # Labels from DetectLables api saved here
    
    #Detecting labels in the image
    rekog_response = rekog_client.detect_labels(
                Image={
                    'Bytes': img_bytes
                },
                MaxLabels=10,
                MinConfidence= 90.0
            )
    for label in rekog_response['Labels']: 
            labels_on_watch_list.append(label['Name']) 
     
    return (set(labels_on_watch_list), rekog_response) 
    
def Animal_Detection(labels_on_watch_list_set, rekog_response):
    """
    This function takes the input labels_on_watch_list_set and rekog_response.
    Job --> Does Animal Detection in the image
    Expected Output --> Detected Animal and notification_type
    """
    detected_animal = ''
    notification_type = ''
    flag = False
    animal_categories_list = ["Cat", "Dog", "Pet", "Labrador Retriever", "Puppy"]
    # It can detect other animals as well but we are restricting to Cat and Dog for our usecase
    #animal_categories_list = ["Cat", "Tiger","Kangaroo","Elephnat","Panda","Dog" , "Pet" , "Canine" , "Labrador Retriever" , "Puppy"]
    for c in labels_on_watch_list_set:
        for d in animal_categories_list:
            if c == d:
                flag = True
                print("Animal Detected ---- " + c)
                detected_animal = c
                break
        if flag:
            notification_type += 'animal'
            break
    return (detected_animal, notification_type)

def Gun_Detection(img_bytes):
    """
    This function takes the input the bytearray of the image.
    Job --> Does Weapon Detection in the image
    Expected Output --> Detected Weapon and notification_type
    """
    unsafe_categories_list = []
    unsafe_list_set = []
    weapons = ["Gun","Weapon Violence","Weapon", "Handgun", "Weaponry","Violence"]
    
    detected_violence = ''
    notification_type = ''
    
    response_unsafe = rekog_client.detect_moderation_labels(
                     Image={
                            'Bytes': img_bytes
                        }
                    )
                    
    for label in response_unsafe['ModerationLabels']:
                unsafe_categories_list.append(label['Name'])

    # Convert List to Set (Unique Value)
    unsafe_list_set = set(unsafe_categories_list)        
    if any(c in weapons for c in unsafe_list_set):
        print("Unsafe Content (Gun, Weapons) Detected")
        detected_violence += 'Gun'
        notification_type  = 'suspicious'
    return (detected_violence, notification_type)

def Package_Detection(img_bytes):
    """
    This function takes the input the bytearray of the image.
    Job -->  Detects Package/Courier in the image
    Expected Output --> Detected Package and Notificaton Type
    """
    detected_Package = "" # Labels from DetectLables api saved here
    notification_type = ''
    packages = []
    packages_list_set = []
    package_name = ["package"]
    #Detecting labels in the image
    rekog_response = rekog_client.detect_custom_labels(
                Image={
                    'Bytes': img_bytes
                },
                MinConfidence=0.70,
                ProjectVersionArn=Package_Model_ARN
            )
     
    for customLabel in rekog_response['CustomLabels']:
        packages.append(customLabel['Name'])
        if(int(customLabel['Confidence'] > 70)):
            print(customLabel['Name'] + Detected)
            detected_Package += 'Package'
            notification_type  = 'Package'

    return (detected_Package, notification_type) 
    
def Logo_Detection(img_bytes):
    """
    This function takes the input the bytearray of the image.
    Job -->  Detects Logos for Courier Companies - i.e., Amazon Prime, DHL, FedEx, USPS
    Expected Output --> Detected Logo and Notification Type
    """
    detected_logo = "" # Labels from DetectLables api saved here
    notification_type = ''
    logo_list = []
    logo_list_set = []
    logo_name = ["dhl", "fedex", "usps", "prime"]
    #Detecting labels in the image
    rekog_response = rekog_client.detect_custom_labels(
                Image={
                    'Bytes': img_bytes
                },
                MinConfidence=0.90,
                ProjectVersionArn=Logo_Model_ARN
            )
     
    for customLabel in rekog_response['CustomLabels']:
        logo_list.append(customLabel['Name'])
        if(int(customLabel['Confidence'] > 90)):
            print("Logo Custom Label:", customLabel['Name'])
            detected_logo += customLabel['Name']
            notification_type  = 'Logo'     
    return (detected_logo, notification_type)


def Vehicle_Detection(labels_on_watch_list_set, rekog_response):
    """
    This function takes the input labels_on_watch_list_set and rekog_response.
    Job --> Does Animal Detection in the image
    Expected Output --> Detected Vehicle and notification_type
    """
    detected_vehicle = ''
    notification_type = ''
    flag = False
    vehicle_categories_list = ["Car", "Fire Truck","Truck", "Moving Van","Van", "Vehicle"]
    for c in labels_on_watch_list_set:
        for d in vehicle_categories_list:
            if c == d:
                flag = True
                print("Vehicle Detected ---- " + c)
                detected_vehicle = c
                break
        if flag:
            notification_type += 'Vehicle'
            break      
    return (detected_vehicle, notification_type)
    
# End of code