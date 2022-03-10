'''
        -----------------------------------------------------------------------------------------------------
            main.py - This script contains the code for detecting the usecase for a smart doorbell
                                            using HAAR Cascade
            use-cases -> Detect Face, Pet (Cat, Dog), Gun, NoteWorthy Vehicle(Ambulance, Firetruck) as Truck
                Car, Packages/Couriers, Logo_Detection - USPS, FedEx, DHL, Amazon Prime
        -----------------------------------------------------------------------------------------------------
'''

# importing libraries
import numpy as np
import cv2
import datetime
import time
import os
import pandas as pd
import re
import psutil
from imutils import paths

print("Imported")

#Add the directory of sample test images
DIRECTORY = ''

files = []
detected = []
time_taken = []
# loop over the frames of the video
object_exist = False
# load our image and convert it to grayscale
def detect():
    for image in os.listdir(DIRECTORY):
        f = os.path.join(DIRECTORY, image)
        frame = cv2.imread(f)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gray = cv2.GaussianBlur(gray, (21, 21), 0)
        #Detect Object
        '''
        CascadeClassifier - FrontalFace_cascade.xml - For Face detection
                          - Gun_cascade.xml - For Harmful weapon detection
                          - Cat_cascade.xml - For Cat detection
                          - Dog_cascade.xml - For Dog detection
                          - Ambulance_cascade - For Ambulance detection
                          - Firetruck_cascade - For Firetruck detection
                          - Package_cascade.xml - For Package detection
                          - Amazon_cascade.xml - For Amazon Prime Logo detection
                          - DHL_cascade.xml - For DHL Logo detection
                          - FedEx_cascade.xml - For FedEx Logo detection
                          - Usps_cascade.xml - For USPS Logo detection
        '''
        object_exist = cv2.CascadeClassifier('FrontalFace_cascade.xml')
        start = time.time()
        result = object_exist.detectMultiScale(gray, 1.3, 5, minSize = (100, 100))
        if len(result) > 0:
            object_exist = True
        else:
            object_exist = False
        end = time.time() - start
        print(end)
        time_taken.append(end)
        for (x,y,w,h) in result:
            frame = cv2.rectangle(frame,(x,y),(x+w,y+h),(255,0,0),2)
            roi_gray = gray[y:y+h, x:x+w]
            roi_color = frame[y:y+h, x:x+w]
        # draw the text and timestamp on the frame
        cv2.putText(frame, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),

                        (10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)
        # show the frame and record if the user presses a key
        cv2.imshow("Security Feed", frame)
        cv2.waitKey(0)
        if object_exist:
            print("Object detected")
            detected.append("1");
        else:
            print("Object NOT detected")
            detected.append("0");

detect()
