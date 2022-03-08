'''
            -----------------------------------------------------------------------------------------------------
                This python script is used for capturing frames/images through camera stitching them
                together for making a Video clip.
            -----------------------------------------------------------------------------------------------------
'''

# importing necessary libraries and modules
import cv2
import time
import pytz
import uuid
from imutils.video import VideoStream
import signal
import datetime
import sys
import os
from imutils import paths
import progressbar
import cProfile, pstats, io
import json

#Calculating the Timestamp
utc_dt = pytz.utc.localize(datetime.datetime.now())
now_ts_utc = (utc_dt - datetime.datetime(1970, 1, 1, tzinfo=pytz.utc)).total_seconds()

# The time at which camera will capture the image
sec = 2.0
frame_id = str(uuid.uuid4())#Unique for every image
time_stamp = datetime.datetime.now().strftime("%Y-%m-%d-%H%M") # Name of the folder in which the frames are stored.


#Create Directory for local storage
cwd = os.getcwd()
if os.path.isdir(cwd + '/output') == False :
    os.mkdir(cwd + '/output')
    os.mkdir(cwd + '/output/images')
    os.mkdir(cwd + '/output/videos')


def capture_frames():
    """
    Job -> Captures frames and stores in the output/images folder on local device.
    """
    # function to handle keyboard interrupt
    def signal_handler(sig, frame):
        print("[INFO] You pressed `ctrl + c`! Your pictures are saved" \
            " in the output directory you specified...")
        sys.exit(0)

    # construct the argument parser and parse the arguments
    output_image = 'output/images'
    delay = 0.04 #in seconds

    # initialize the output directory path and create the output
    # directory
    outputDir = os.path.join(output_image, time_stamp)
    os.makedirs(outputDir)

    # initialize the video stream and allow the camera sensor to warmup
    print("[INFO] warming up camera...")
    #vs = VideoStream(src=0).start()
    vs = VideoStream(usePiCamera=False, resolution=(1920, 1280),
        framerate=30).start()
    #time.sleep(0)

    # set the frame count to zero
    count = 0

    # signal trap to handle keyboard interrupt
    signal.signal(signal.SIGINT, signal_handler)
    print("[INFO] Press `ctrl + c` to exit, or 'q' to quit if you have" \
        " the display option on...")

    # loop over frames from the video stream
    while count!=100:
        # grab the next frame from the stream
        frame = vs.read()

        # draw the timestamp on the frame
        ts = datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p")
        cv2.putText(frame, ts, (10, frame.shape[0] - 10),
            cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)

        # write the current frame to output directory
        filename = str(count) + ".jpg"
        cv2.imwrite(os.path.join(outputDir, filename), frame)

        # increment the frame count and sleep for specified number of
        # seconds
        count += 1
        time.sleep(delay)

    # close any open windows and release the video stream pointer
    print("[INFO] cleaning up...")
    vs.stop()

def video_making():
    """
    Job --> Takes images from output/images folder stitches it together and saves back to output/videos folder
    """
    # function to get the frame number from the image path
    def get_number(imagePath):
        return int(imagePath.split(os.path.sep)[-1][:-4])

    inputs = 'output/images/' + str(time_stamp)
    output_vid = 'output/videos'
    fps = 10

    # initialize the FourCC and video writer
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    writer = None

    # grab the paths to the images, then initialize output file name and
    # output path
    imagePaths = list(paths.list_images(inputs))
    #outputFile = "{}.mp4".format(inputs.split(os.path.sep)[2])
    outputFile = frame_id + ".avi"
    outputPath = os.path.join(output_vid, outputFile)
    print("[INFO] building {}...".format(outputPath))

    # initialize the progress bar
    widgets = ["Building Video: ", progressbar.Percentage(), " ",
        progressbar.Bar(), " ", progressbar.ETA()]
    pbar = progressbar.ProgressBar(maxval=len(imagePaths),
        widgets=widgets).start()

    # loop over all sorted input image paths
    for (i, imagePath) in enumerate(sorted(imagePaths, key=get_number)):
        # load the image
        image = cv2.imread(imagePath)

        # initialize the video writer if needed
        if writer is None:
            (H, W) = image.shape[:2]
            writer = cv2.VideoWriter(outputPath, fourcc, fps,
                (W, H), True)

        # write the image to output video
        writer.write(image)
        pbar.update(i)

    # release the writer object
    print("[INFO] cleaning up...")
    pbar.finish()
    writer.release()
    video_name = "output/videos/"+frame_id

    conv = os.system('ffmpeg -an -i '+video_name+'.avi -vcodec libx264 -pix_fmt yuv420p -profile:v baseline -level 3 '+ video_name+'.mp4')

    return 0



def convert_to_bytearray():

    """
        Job --> This function takes the image and converting into bytearray
                as it is the required input format for AWS Rekognition APIs to work !!!
    """
    #time.sleep(3)
    frame = cv2.imread('output/images/'+str(time_stamp)+'/20.jpg')
    retval, buff = cv2.imencode(".jpg", frame)
    return bytearray(buff)
