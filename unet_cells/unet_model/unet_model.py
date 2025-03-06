from torch import  nn
import torch.nn.functional as F
from monai.networks.nets import  UNet
from monai.networks.layers import Norm
from  monai.networks import  normal_init
import  torch
class UNet_monai(nn.Module):
    def __init__(self, n_channels, n_classes, bilinear=True):
        super().__init__()
        self.unet = UNet(spatial_dims=2,
            in_channels=n_channels,
            out_channels=n_classes,
            channels=(16, 32, 64, 128, 256,512),
            strides=(2, 2, 2, 2,2),
            norm=Norm.BATCH,num_res_units=2)
        self.unet.apply(normal_init)
        self._initialize_weights()

    def _initialize_weights(self):
        for m in self.modules():
            if isinstance(m, nn.Conv3d):
                nn.init.kaiming_normal_(m.weight, nonlinearity='relu')
                if m.bias is not None:
                    m.bias.data.zero_()

    def forward(self, x):
        output = self.unet(x)
        return output
