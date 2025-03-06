import matplotlib.pyplot as plt
from  PIL  import  Image
import  numpy as np
from torchvision import  transforms
import  torch
img_path = r"C:\Users\32053\Desktop\unet_cells\xibao\images\10.png"
label_path = r"C:\Users\32053\Desktop\unet_cells\xibao\labels\10.png"
import cv2

img2 = cv2.imread(img_path)


img = Image.open(img_path)
img = transforms.RandomHorizontalFlip()(img)
img = transforms.CenterCrop
img = transforms.ToTensor()(img)  # W，H，C ——> C，H，W  ，除255，归一化到[0,1] 输出是[1,512,512]
print(img)
# img = Image.fromarray(img.astype('uint8')).convert('RGB')
# matrix = cv2.imread(path)
# print(matrix.shape)
# # plt.imshow(matrix[:,:,0]*255.0)
# # plt.show()
# cv2.imshow('s',matrix)
# cv2.waitKey()