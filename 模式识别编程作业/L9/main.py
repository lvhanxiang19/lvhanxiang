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
    def generate_data(self):#生成训练集和测试集
        mu1 = [-5,0]
        mu2 = [0,5]
        cov = np.eye(2)
        # 生成数据集
        num_samples_train = 160
        self.data_class_1_tr = np.random.multivariate_normal(mu1,cov, num_samples_train)
        self.data_class_2_tr = np.random.multivariate_normal(mu2,cov, num_samples_train)
        self.labels_class_1_tr = np.ones(num_samples_train)  # 类别 +1
        self.labels_class_2_tr = -np.ones(num_samples_train)  # 类别 -1
        num_samples_test = 40
        self.data_class_1_ts = np.random.multivariate_normal(mu1, cov, num_samples_test)
        self.data_class_2_ts = np.random.multivariate_normal(mu2, cov, num_samples_test)
        # 创建标签
        self.labels_class_1_ts = np.ones(num_samples_test)  # 类别 +1
        self.labels_class_2_ts= -np.ones(num_samples_test)  # 类别 -1
        # 合并数据集和标签
        self.data = np.vstack((self.data_class_1_tr, self.data_class_2_tr))
        self.test = np.vstack((self.data_class_1_ts, self.data_class_2_ts))
        self.labels = np.concatenate((self.labels_class_1_tr, self.labels_class_2_tr))
        self.labels_test=np.concatenate((self.labels_class_1_ts, self.labels_class_2_ts))
        self.draw()
        # 现在，data 包含400个二维向量，labels 包含相应的400个标签（+1和-1）    #
    def draw(self):
        plt.figure(figsize=(8, 6))
        plt.scatter(self.data_class_1_tr[:, 0], self.data_class_1_tr[:, 1], c='blue', label='Class +1')
        plt.scatter(self.data_class_2_tr[:, 0], self.data_class_2_tr[:, 1], c='red', label='Class -1')
        # 绘制决策边界
        x_values = np.array([self.data_class_1_tr.min(axis=0)[0], self.data_class_2_tr.max(axis=0)[0]])
        y_values = -(self.w[0] * x_values + self.b) / self.w[1]
        plt.plot(x_values, y_values, label='Decision Boundary')
        plt.title('Visualization of Generated Data with Decision Boundary')
        plt.xlabel('Feature 1')
        plt.ylabel('Feature 2')
        plt.legend()
        plt.grid(True)
        plt.show()
    def draw_test(self):
        plt.figure(figsize=(8, 6))
        plt.scatter(self.data_class_1_ts[:, 0], self.data_class_1_ts[:, 1], c='blue', label='Class +1')
        plt.scatter(self.data_class_2_ts[:, 0], self.data_class_2_ts[:, 1], c='red', label='Class -1')
        # 绘制决策边界
        x_values = np.array([self.data_class_1_ts.min(axis=0)[0], self.data_class_2_ts.max(axis=0)[0]])
        y_values = -(self.w[0] * x_values + self.b) / self.w[1]
        plt.plot(x_values, y_values, label='Decision Boundary')
        plt.title('Visualization of Generated Data with Decision Boundary')
        plt.xlabel('Feature 1')
        plt.ylabel('Feature 2')
        plt.legend()
        plt.grid(True)
        plt.show()
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
        c=r/320
        return c,ran
    def test_test(self):
        i = 0;r = 0
        while i < len(self.test):
            y_r = self.labels_test[i]
            x = self.test[i]
            y_p = int(math.copysign(1, np.matmul(self.w.transpose(), x) + self.b))
            if y_p == y_r:
                r = r + 1
            i = i + 1
        c = r / 80
        return c
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
                c_r=self.test_test()
                print("训练集正确率为：",c)
                self.draw()
                print("测试集正确率为：",c_r)
                self.draw_test()
                if c==1:
                    print("达到要求")
                    print("最终w", self.w)
                    print("最终b", self.b)
                    self.draw()
                    c_r = self.test_test()
                    print("测试集正确率为：", c_r)
                    self.draw_test()
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
                self.draw()
                c_r = self.test_test()
                print("测试集正确率为：", c_r)
                self.draw_test()
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
                    c_r = self.test_test()
                    print("测试集正确率为：", c_r)
                    self.draw_test()
                else:
                    self.w = self.w + self.labels[r1] * self.data[r1]
                    self.b = self.b + self.labels[r1]
                    self.draw()
                    print("更新后的正确率高，为：",c1)
                    print("更新，随机选择的错分序号为：",r1)
                    c_r = self.test_test()
                    print("测试集正确率为：", c_r)
                    self.draw_test()
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









