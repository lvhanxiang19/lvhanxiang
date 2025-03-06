import os
import numpy as np
import torch
from torch.utils.data import DataLoader
from monai.transforms import (
    Compose, LoadImaged,  ScaleIntensityd, ToTensord,
    RandRotate90d, RandFlipd, RandZoomd
)
from monai.data import CacheDataset, Dataset, DataLoader
from monai.networks.nets import UNet
from monai.losses import DiceLoss
from monai.metrics import DiceMetric
from monai.utils import first
from monai.inferers import sliding_window_inference
import matplotlib.pyplot as plt
from dataset.dataset import MyDataSet
import glob
from torchvision import transforms
from unet_model.unet_model import UNet_monai
from monai.metrics import ConfusionMatrixMetric
from utils.evaluate_one_epoch import evaluate
from utils.dice_metric import DiceMetric
from monai.transforms import (
    RandGaussianNoise,      # 模拟高斯噪声（超声斑点噪声）
    RandGibbsNoise,         # 模拟MRI吉布斯伪影或超声部分容积效应
    Rand2DElastic,          # 弹性形变（模拟组织形变或探头压力变化）
    RandAdjustContrast,     # 调整对比度（模拟不同增益设置）
    RandCoarseDropout       # 模拟病灶遮挡或图像缺失
)
from monai.networks import one_hot
from monai.metrics import ConfusionMatrixMetric
if __name__ == "__main__":



    model = UNet_monai(n_channels=3, n_classes=2).cuda()
    model.load_state_dict(torch.load("C:/Users/32053/Desktop/unet_cells/weights/best_model_xibao_6_300.pth"))
    model.eval()
    data = sorted(glob.glob(os.path.join(r"C:\Users\32053\Desktop\unet_cells\xibao", "images", "*.png")))
    label = sorted(glob.glob(os.path.join(r"C:\Users\32053\Desktop\unet_cells\xibao", "masks", "*.png")))
    train_image_path = data;
    train_label_path = label
    val_image_path = data;
    val_label_path = label
    val_transform = transforms.Compose([transforms.ToTensor(),
                                        transforms.Normalize(mean=[0.485], std=[0.229])])
    val_dataset = MyDataSet(images_path=val_image_path,
                            label_path=val_label_path,
                            transform=val_transform)

    val_loader = torch.utils.data.DataLoader(val_dataset,
                                             batch_size=4,
                                             shuffle=False,
                                             pin_memory=True,
                                             num_workers=1)
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    Dice = DiceLoss(softmax=True
                    , to_onehot_y=True)
    total_dice = torch.zeros(1, 2).to(device)

    metric = ConfusionMatrixMetric(
        include_background=True,  # 包含背景类（二分类任务通常需要）
        metric_name= ["sensitivity", "specificity", "precision"],
        reduction="sum"  # 关键：累积所有批次的混淆矩阵
    )

    # 计算指标
    with torch.no_grad():
        number=0
        for i, test_data in enumerate(val_loader):
            test_images, test_labels = test_data["img"].cuda(), test_data["seg"].cuda()
            test_outputs = model(test_images)
            test_labels1=one_hot(test_labels,2)
            test_outputs1 = torch.argmax(test_outputs, dim=1,keepdim=True)
            dice_metric = 1-Dice(test_outputs,test_labels)
            total_dice = torch.add(total_dice, dice_metric)
            metric(test_outputs1, test_labels)
            number=number+1
        epoch_mean_dice=total_dice/number
        global_cm = metric.aggregate() # 形状 [num_classes, num_classes]
        s=global_cm[0].item()
        sp=global_cm[1].item()
        p=global_cm[2].item()
        print('sensitivity:{},  specificity:{}  ,  precision:{}'.format(s,sp,p))



        # print('evaluate---------epoch:{} , loss: {} , dice: {}  {}  {}  {}  {}'\
        #     .format(epoch,epoch_mean_loss,epoch_mean_dice[0][0].item()\
        #     ,epoch_mean_dice[0][1].item(),epoch_mean_dice[0][2].item(),epoch_mean_dice[0][3].item(),epoch_mean_dice[0][4].item()))
        print('dice: {} ' \
              .format( epoch_mean_dice[0][1].item()))




        # 计算指标

    with torch.no_grad():
        for i, test_data in enumerate(val_loader):
            test_images, test_labels = test_data["img"].cuda(), test_data["seg"].cuda()
            test_outputs = model(test_images)
            test_outputs = torch.argmax(test_outputs, dim=1).detach().cpu().numpy()

            # 可视化推理结果
            plt.figure("check", (18, 6))
            plt.subplot(1, 3, 1)
            plt.title("image")
            plt.imshow(test_images[0, 0, :, :].cpu(), cmap="gray")
            plt.subplot(1, 3, 2)
            plt.title("label")
            plt.imshow(test_labels[0, 0, :, :].cpu())
            plt.subplot(1, 3, 3)
            plt.title("output")
            plt.imshow(test_outputs[0, :, :])
            plt.show()

