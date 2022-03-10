'''
            -----------------------------------------------------------------------------------------------------
            			Package_Detect.py - This script is used for detecting packages/couriers
                                        delivered to your doorsteps.

                                    ** ML Model: PackageModel.tflite **
            -----------------------------------------------------------------------------------------------------
'''
#Importing libraries
import os
import argparse
import cv2
import numpy as np
import sys
import glob
import importlib.util
import time
import re
import os
import pandas as pd
import tracemalloc
from memory_profiler import profile


#from tflite_runtime.interpreter import Interpreter
from tensorflow.lite.python.interpreter import Interpreter
print("Imported")

use_TPU  = False
file_no = []
files = []
detected = []
time_taken = []

@profile
def detect():

    PATH_TO_CKPT = "/home/pi/Desktop/TensorflowLite/Code/tflite1/package_model/detect.tflite"
    PATH_TO_LABELS = "/home/pi/Desktop/TensorflowLite/Code/tflite1/package_model/label_map.txt"
    # Load the label map
    with open(PATH_TO_LABELS, 'r') as f:
        labels = [line.strip() for line in f.readlines()]
        print(labels)

    print("Allocate tensor")
    interpreter = Interpreter(model_path=PATH_TO_CKPT)
    interpreter.allocate_tensors()
    print("Done Allocating")

    # Get model details
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    height = input_details[0]['shape'][1]
    width = input_details[0]['shape'][2]
    print("height:",height)
    print("width:",width)
    floating_model = (input_details[0]['dtype'] == np.float32)
    print(input_details)
    print(output_details)
    #print(output_details[0]['index'])

    min_conf_threshold = 0.65
    pattern="\d+"
    if_yes = True
    files = []
    scores_list = []
    input_mean = 127.5
    input_std = 127.5
    directory = "/home/pi/Desktop/TestDataset 25Dec/Package/1/"
    directory = "/home/pi/Desktop/MemoryProfilerTestImage/New"
    # Loop over every image and perform detection
    #for image_path in images:
    for filename in os.listdir(directory):
        f = os.path.join(directory, filename)
        fileNo = re.findall(pattern,filename)
        file_no.append(int(fileNo[0]))
        print(int(fileNo[0]))
        files.append(int(fileNo[0]))
        print(filename)

        image_path = f
        # Load image and resize to expected shape [1xHxWx3]
        image = cv2.imread(image_path)
        #print(image_path)
        image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        imH, imW, _ = image.shape
        image_resized = cv2.resize(image_rgb, (width, height))
        input_data = np.expand_dims(image_resized, axis=0)
        print("Input Data:",input_data.shape)
        # Normalize pixel values if using a floating model (i.e. if model is non-quantized)
        if floating_model:
            input_data = (np.float32(input_data) - input_mean) / input_std

        # Perform the actual detection by running the model with the image as input
        interpreter.set_tensor(input_details[0]['index'],input_data)
        start = time.time()
        interpreter.invoke()
        end = time.time() - start
        print(end)
        time_taken.append(end)
        # Retrieve detection results
        boxes = interpreter.get_tensor(output_details[1]['index'])[0] # Bounding box coordinates of detected objects
        #scores = interpreter.get_tensor(output_details[0]['index'])[0] # Bounding box coordinates of detected objects
        print("boxes:",boxes)
        classes = interpreter.get_tensor(output_details[3]['index'])[0] # Class index of detected objects
        #boxes = interpreter.get_tensor(output_details[1]['index'])[0] # Class index of detected objects
        print("classes:",classes)
        scores = interpreter.get_tensor(output_details[0]['index'])[0] # Confidence of detected objects
        print("scores:", scores)
        if(len(scores) > 0):
            detected.append("1")
        else:
            detected.append("0")
        num = interpreter.get_tensor(output_details[2]['index'])[0]  # Total number of detected objects (inaccurate and not needed)
        print("Num:",num)

        for i in range(len(scores)):
            if ((scores[i] > min_conf_threshold) and (scores[i] <= 1.0)):
            #if(if_yes):

                # Get bounding box coordinates and draw box
                # Interpreter can return coordinates that are outside of image dimensions, need to force them to be within image using max() and min()
                ymin = int(max(1,(boxes[i][0] * imH)))
                xmin = int(max(1,(boxes[i][1] * imW)))
                ymax = int(min(imH,(boxes[i][2] * imH)))
                xmax = int(min(imW,(boxes[i][3] * imW)))

                cv2.rectangle(image, (xmin,ymin), (xmax,ymax), (10, 255, 0), 2)

                # Draw label
                object_name = labels[int(classes[i])] # Look up object name from "labels" array using class index
                label = '%s: %d%%' % (object_name, int(scores[i]*100)) # Example: 'person: 72%'
                labelSize, baseLine = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.7, 2) # Get font size
                label_ymin = max(ymin, labelSize[1] + 10) # Make sure not to draw label too close to top of window
                cv2.rectangle(image, (xmin, label_ymin-labelSize[1]-10), (xmin+labelSize[0], label_ymin+baseLine-10), (255, 255, 255), cv2.FILLED) # Draw white box to put label text in
                cv2.putText(image, label, (xmin, label_ymin-7), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2) # Draw label text


        # All the results have been drawn on the image, now display the image
        image = cv2.resize(image, (800, 600))
        cv2.imshow('Object detector', image)
        #cv2_imshow(image)


        # Press any key to continue to next image, or press 'q' to quit
        if cv2.waitKey(0) == ord('q'):
            break

    dict = {'filename': files, 'detected': detected, 'time': time_taken}

    df = pd.DataFrame(dict)

    # saving the dataframe
    df.to_csv('package.csv')

tracemalloc.start()
detect()
current, peak = tracemalloc.get_traced_memory()
print(f"Current memory usage is {current / 10**6}MB; Peak was {peak / 10**6}MB")
tracemalloc.stop()
