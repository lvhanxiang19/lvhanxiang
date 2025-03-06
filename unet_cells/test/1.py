import torch
from monai.metrics import ConfusionMatrixMetric

# 初始化混淆矩阵计算器
metric = ConfusionMatrixMetric(include_background=True)

# 模拟数据（Batch=2，二分类）
preds = torch.tensor([[[1, 0], [0, 1]], [[1, 1], [0, 0]]], dtype=torch.int)
labels = torch.tensor([[[1, 0], [1, 1]], [[1, 0], [1, 0]]], dtype=torch.int)

# 更新指标状态
metric(preds, labels)

# 获取全局混淆矩阵
global_cm = metric.aggregate()
print(global_cm)
# 调整形状（若为一维）
if global_cm.ndim == 1:
    global_cm_2d = global_cm.reshape(2, 2)
else:
    global_cm_2d = global_cm

# 提取指标
tn = global_cm_2d[0, 0].item()
fp = global_cm_2d[0, 1].item()
fn = global_cm_2d[1, 0].item()
tp = global_cm_2d[1, 1].item()

print(f"TN={tn}, FP={fp}, FN={fn}, TP={tp}")