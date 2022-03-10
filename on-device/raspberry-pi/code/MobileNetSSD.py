'''
            -----------------------------------------------------------------------------------------------------
            			MobileNetSSD.py - This script is used for detecting common objects using
						pre-trained TFLite MobileNetSSD v2 model with Tensorflow Lite Interpreter
			  Objects: (e.g., Person, Pet [Dog, Cat], Car, Noteworthy Vehicle [Ambulance, Firetruck] as Truck )

                                        ** ML Model:MobileNetV2.tflite **
            -----------------------------------------------------------------------------------------------------
'''
#Importing libraries
import math
import time
import matplotlib.patches as patches
import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
from PIL import Image
import os
import pandas as pd
import re
import cv2


pattern="\d+"
NUM_RESULTS = 1917
NUM_CLASSES = 91

X_SCALE = 10.0
Y_SCALE = 10.0
H_SCALE = 5.0
W_SCALE = 5.0

#creating lists for filename, detected, time
index = []
files = []
scores_list = []
temp_scores = []
time_taken = []
detected = []

def load_box_priors(filename):
	with open(filename) as f:
		count = 0
		for line in f:
			row = line.strip().split(' ')
			box_priors.append(row)
			#print(box_priors[count][0])
			count = count + 1
			if count == 4:
				return


def load_labels(filename):
	my_labels = []
	input_file = open(filename, 'r')
	for l in input_file:
		my_labels.append(l.strip())
	return my_labels


def decode_center_size_boxes(locations):
	"""calculate real sizes of boxes"""
	for i in range(0, NUM_RESULTS):
		ycenter = locations[i][0] / Y_SCALE * np.float(box_priors[2][i]) + np.float(box_priors[0][i])
		xcenter = locations[i][1] / X_SCALE * np.float(box_priors[3][i]) + np.float(box_priors[1][i])
		h = math.exp(locations[i][2] / H_SCALE) * np.float(box_priors[2][i])
		w = math.exp(locations[i][3] / W_SCALE) * np.float(box_priors[3][i])

		ymin = ycenter - h / 2.0
		xmin = xcenter - w / 2.0
		ymax = ycenter + h / 2.0
		xmax = xcenter + w / 2.0

		locations[i][0] = ymin
		locations[i][1] = xmin
		locations[i][2] = ymax
		locations[i][3] = xmax
	return locations


def iou(box_a, box_b):
	x_a = max(box_a[0], box_b[0])
	y_a = max(box_a[1], box_b[1])
	x_b = min(box_a[2], box_b[2])
	y_b = min(box_a[3], box_b[3])

	intersection_area = (x_b - x_a + 1) * (y_b - y_a + 1)

	box_a_area = (box_a[2] - box_a[0] + 1) * (box_a[3] - box_a[1] + 1)
	box_b_area = (box_b[2] - box_b[0] + 1) * (box_b[3] - box_b[1] + 1)

	iou = intersection_area / float(box_a_area + box_b_area - intersection_area)
	return iou


def nms(p, iou_threshold, max_boxes):
	sorted_p = sorted(p, reverse=True)
	selected_predictions = []
	for a in sorted_p:
		if len(selected_predictions) > max_boxes:
			break
		should_select = True
		for b in selected_predictions:
			if iou(a[3], b[3]) >= iou_threshold:
				#print_iou = iou(a[3], b[3])
				#print("Intersection over Union:",print_iou)
				should_select = False
				break
		if should_select:
			selected_predictions.append(a)

	return selected_predictions

directory = 'Dataset/Test/Person'

box_priors = []
dict1 = {}
def detect():
    for filename in os.listdir(directory):
        f = os.path.join(directory, filename)
        print(filename)
        fileNo = re.findall(pattern,filename)
        print(int(fileNo[0]))
        files.append(filename)
        index.append(int(fileNo[0]))
        image_file = f
        # Add tflite model file here
        model_file = "tflite_models/ssdlite_mobilenet_v2_coco.tflite"
        # add path for label_map_mobilenetSSD.txt
        label_file = "label_maps/label_map_mobilenetSSD.txt"
        box_prior_file = "tmp/box_priors.txt"
        input_mean = 127.5
        input_std = 127.5
        min_score = 50.0
        max_boxes = 10
        floating_model = False
        show_image = True
        alt_output_order = False

        interpreter = tf.lite.Interpreter(model_path=model_file)
        interpreter.allocate_tensors()

        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        print('input_details :', input_details)
        print('output_details:', output_details)

        if input_details[0]['dtype'] == type(np.float32(1.0)):
            floating_model = True

        height = input_details[0]['shape'][1]
        width = input_details[0]['shape'][2]
        img = Image.open(image_file)
        img = img.resize((width, height))

        input_data = np.expand_dims(img, axis=0)

        if floating_model:
            input_data = (np.float32(input_data) - input_mean) / input_std

        interpreter.set_tensor(input_details[0]['index'], input_data)

        #start_time = time.time()
        start_time = time.process_time()
        interpreter.invoke()
        #finish_time = time.time()
        elapsed_time = time.process_time() - start_time
        #print("time spent:", ((finish_time - start_time) * 1000))
        print("Time spent:", elapsed_time)
        time_taken.append(elapsed_time)
        #box_priors = []
        load_box_priors(box_prior_file)
        labels = load_labels(label_file)

        p_index = 0
        o_index = 1
        if alt_output_order:
            p_index = 1
            o_index = 0

        predictions = np.squeeze(interpreter.get_tensor(output_details[p_index]['index']))
        output_classes = np.squeeze(interpreter.get_tensor(output_details[o_index]['index']))
        #print("predictions : ", len(predictions), predictions)
        #print("output_classes : ", len(output_classes), output_classes)
        print(output_details[p_index]['quantization'])
        if not floating_model:
            p_scale, p_mean = output_details[p_index]['quantization']
            o_scale, o_mean = output_details[o_index]['quantization']

            predictions = (predictions - p_mean * 1.0) * p_scale
            output_classes = (output_classes - o_mean * 1.0) * o_scale

        decode_center_size_boxes(predictions)

        pruned_predictions = [[], ]
        for c in range(1, NUM_CLASSES):
            pruned_predictions.append([])
            for r in range(0, NUM_RESULTS):
                score = 1. / (1. + math.exp(-output_classes[r][c]))
                if score > 0.01:
                    rect = (predictions[r][1] * width, predictions[r][0] * width, predictions[r][3] * width, predictions[r][2] * width)

                    # スコア, インデックス, ラベル, 矩形座標を追加
                    pruned_predictions[c].append((output_classes[r][c], r, labels[c], rect))

        final_predictions = []
        for c in range(1, NUM_CLASSES):
            predictions_for_class = pruned_predictions[c]
            suppressed_predictions = nms(predictions_for_class, 0.5, max_boxes)
            final_predictions = final_predictions + suppressed_predictions

        if show_image:
            fig, ax = plt.subplots(1)
        temp_scores.clear()
        final_predictions = sorted(final_predictions, reverse=True)[:max_boxes]
        for e in final_predictions:
            score = 100. / (1. + math.exp(-e[0]))
            score_string = '{0:2.0f}%'.format(score)
            print("Score String:", e)
            temp_scores.append(score)
            print(score_string, e[2], e[3])
            if score < min_score:
                break
            left, top, right, bottom = e[3]
            rect = patches.Rectangle((left, top), (right - left), (bottom - top), linewidth=1, edgecolor='r', facecolor='none')

            if show_image:
                # Add the patch to the Axes
                ax.add_patch(rect)
                ax.text(left, top, e[2] + ': ' + score_string, fontsize=6, bbox=dict(facecolor='y', edgecolor='y', alpha=0.5))
        scores_list.append(max(temp_scores))
        if(len(temp_scores) > 0):
            detected.append(1)
        else:
            detected.append(0)
        if show_image:
            ax.imshow(img)
            plt.title(model_file)
            plt.show()
    print(str(len(index))+ ":" +str(len(files)) + ":"+str(len(scores_list)) + ":"
          + str(len(detected))+":" + str(len(time_taken)))
    dict1 = {'fileNo':index,'filename': files, 'Scores': scores_list, 'Detected':detected, 'time': time_taken}

    df = pd.DataFrame(dict1)

     #saving the dataframe
    df.to_csv('person.csv')
    #df.to_excel("/home/pi/Downloads/SSDLiteMobileNetV2-tflite-master/Amazon.xlsx")
detect()
