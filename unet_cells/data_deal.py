import os
import shutil
from PIL import Image
import cv2
import glob
raw_path1=r"C:\Users\32053\Desktop\Dataset_BUSI_with_GT\benign"
raw_path2=r"C:\Users\32053\Desktop\Dataset_BUSI_with_GT\malignant"
raw_path3=r"C:\Users\32053\Desktop\Dataset_BUSI_with_GT\normal"
img_path=r"C:\Users\32053\Desktop\unet_cells\xibao\images"
label_path=r"C:\Users\32053\Desktop\unet_cells\xibao\masks"
label1=r"C:\Users\32053\Desktop\Dataset_BUSI_with_GT\label1"
def data_deal(raw_path,label_path,img_path):
    filenames=os.listdir(raw_path)
    len_tr=int(0.9*len(filenames))
    len_ts=len(filenames)-len_tr







