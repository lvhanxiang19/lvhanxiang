import random
import numpy as np
import matplotlib.pyplot as plt
import math
class PLA_Pocket:
    def __init__(self):
        self.train_num=0.8
        self.test_num=0.2
        self.data=[]
        self.labels=[]
        self.w=[]
        self.data_class_1=[]
        self.data_class_2=[]
        self.b=0
        self.labels_class_1=[]
        self.labels_class_2=[]
        self.last=0
    def generate_data(self):
        mu1 = [1,0]
        mu2 = [0,1]
        cov = np.eye(2)
        # 生成数据集
        num_samples = 200
        self.data_class_1 = np.random.multivariate_normal(mu1,cov, num_samples)
        self.data_class_2 = np.random.multivariate_normal(mu2,cov, num_samples)
        # 创建标签
        self.labels_class_1 = np.ones(num_samples)  # 类别 +1
        self.labels_class_2 = -np.ones(num_samples)  # 类别 -1
        # 合并数据集和标签
        self.data = np.vstack((self.data_class_1, self.data_class_2))
        self.labels = np.concatenate((self.labels_class_1, self.labels_class_2))

        # 打乱数据集（可选）

        plt.figure(figsize=(8, 6))
        plt.scatter(self.data_class_1[:, 0], self.data_class_1[:, 1], c='blue', label='Class +1')
        plt.scatter(self.data_class_2[:, 0], self.data_class_2[:, 1], c='red', label='Class -1')

        plt.title('Visualization of Generated Data')
        plt.xlabel('Feature 1')
        plt.ylabel('Feature 2')
        plt.legend()
        plt.grid(True)
        plt.show()

        # 现在，data 包含400个二维向量，labels 包含相应的400个标签（+1和-1）
    def train_test(self):
        i=0
        r=0
        wrong=[]
        while i<len(self.data):
            y_r=self.labels[i]
            x=self.data[i]
            y_p=int(math.copysign(1,np.matmul(self.w.transpose(),x)+self.b))
            if y_p==y_r:
                r=r+1
            else:
                wrong.append(i)
            i=i+1
        if len(wrong)==0:
            ran=0
        else:
            ran=self.last
            while self.last==ran:
                ran = np.random.randint(0, len(wrong))
                ran = wrong[ran]

            self.last=ran
        c=r/400
        return c,ran

    def init_(self):
        self.w=np.array([0,0])
        print("初始化的W：",self.w)
        print("初始化的b：",self.b)

    def update_pla(self):
        self.generate_data()
        time=0
        i=0
        while i<len(self.data):
            time=time+1
            x=self.data[i]
            y_r=self.labels[i]
            y_p=int(math.copysign(1.0,np.matmul(self.w.transpose(),x)+self.b))
            if y_p!=y_r:
                self.w=self.w+y_r*x
                self.b=self.b+y_r
                c,e=self.train_test()
                plt.figure(figsize=(8, 6))
                plt.scatter(self.data_class_1[:, 0], self.data_class_1[:, 1], c='blue', label='Class +1')
                plt.scatter(self.data_class_2[:, 0], self.data_class_2[:, 1], c='red', label='Class -1')
                # 绘制决策边界
                x_values = np.array([self.data_class_1.min(axis=0)[0], self.data_class_2.max(axis=0)[0]])
                y_values = -(self.w[0] * x_values + self.b) / self.w[1]
                plt.plot(x_values, y_values, label='Decision Boundary')
                plt.title('Visualization of Generated Data with Decision Boundary')
                plt.xlabel('Feature 1')
                plt.ylabel('Feature 2')
                plt.legend()
                plt.grid(True)
                plt.show()
                print("正确率为：",c)
                if c==1:
                    print("达到要求")
                    print("最终w", self.w)
                    print("最终b", self.b)
                    plt.figure(figsize=(8, 6))
                    plt.scatter(self.data_class_1[:, 0], self.data_class_1[:, 1], c='blue', label='Class +1')
                    plt.scatter(self.data_class_2[:, 0], self.data_class_2[:, 1], c='red', label='Class -1')
                    # 绘制决策边界
                    x_values = np.array([self.data_class_1.min(axis=0)[0], self.data_class_2.max(axis=0)[0]])
                    y_values = -(self.w[0] * x_values + self.b) / self.w[1]
                    plt.plot(x_values, y_values, label='Decision Boundary')
                    plt.title('Visualization of Generated Data with Decision Boundary')
                    plt.xlabel('Feature 1')
                    plt.ylabel('Feature 2')
                    plt.legend()
                    plt.grid(True)
                    plt.show()
                    break

            if i == len(self.data) - 1:
                i = 0


            if time == 100000:
                print("100000次循环内未找到分界面")
                print("最终w", self.w)
                print("最终b", self.b)
                break
            i=i+1

    def update_pocket(self):
        self.generate_data()
        time = 0
        i = 0
        while i < len(self.data):
            time = time + 1
            x = self.data[i]
            y_r = self.labels[i]
            y_p = int(math.copysign(1.0, np.matmul(self.w.transpose(), x) + self.b))
            c0, r0 = self.train_test()
            if (c0 == 1):
                print("达到要求")
                print("最终w", self.w)
                print("最终b", self.b)
                plt.figure(figsize=(8, 6))
                plt.scatter(self.data_class_1[:, 0], self.data_class_1[:, 1], c='blue', label='Class +1')
                plt.scatter(self.data_class_2[:, 0], self.data_class_2[:, 1], c='red', label='Class -1')
                # 绘制决策边界
                x_values = np.array([self.data_class_1.min(axis=0)[0], self.data_class_2.max(axis=0)[0]])
                y_values = -(self.w[0] * x_values + self.b) / self.w[1]
                plt.plot(x_values, y_values, label='Decision Boundary')
                plt.title('Visualization of Generated Data with Decision Boundary')
                plt.xlabel('Feature 1')
                plt.ylabel('Feature 2')
                plt.legend()
                plt.grid(True)
                plt.show()
                break
            if y_p != y_r:
                w = self.w
                self.w = self.w + y_r * x
                self.b = self.b + y_r
                c1,r1 = self.train_test()
                print(c1,'-----',c0)
                if c1 <= c0:
                    self.w = w
                    print("更新后的正确率为：",c1,"。小于更新前的：",c0)
                else:
                    self.w = self.w + self.labels[r1] * self.data[r1]
                    self.b = self.b + self.labels[r1]
                    plt.figure(figsize=(8, 6))
                    plt.scatter(self.data_class_1[:, 0], self.data_class_1[:, 1], c='blue', label='Class +1')
                    plt.scatter(self.data_class_2[:, 0], self.data_class_2[:, 1], c='red', label='Class -1')
                    # 绘制决策边界
                    x_values = np.array([self.data_class_1.min(axis=0)[0], self.data_class_2.max(axis=0)[0]])
                    y_values = -(self.w[0] * x_values + self.b) / self.w[1]
                    plt.plot(x_values, y_values, label='Decision Boundary')
                    plt.title('Visualization of Generated Data with Decision Boundary')
                    plt.xlabel('Feature 1')
                    plt.ylabel('Feature 2')
                    plt.legend()
                    plt.grid(True)
                    plt.show()
                    print("更新后的正确率高，为：",c1)
                    print("更新，随机选择的错分序号为：",r1)
            if i == len(self.data) - 1:
                i =0
            if time == 1000:
                print("1000次循环内未找到分界面")
                print("最终w", self.w)
                print("最终b", self.b)
                break
            i = i + 1



pla=PLA_Pocket()
pla.init_()
pla.update_pocket()










