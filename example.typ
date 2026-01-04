#import "style.typ": *
#show: style

#set document(title: "最优化理论与方法实验报告", author: "✕✕✕", description: "基于神经网络的房价预测建模与优化分析")

#title[基于神经网络的房价预测建模与优化分析]

#v(1em)

#let item(k, v) = terms.item(k, u(v))

// 设置实验日期
#let date = datetime.today()

// 设置课程和个人信息
#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 1em,
  item("课程名称", "最优化理论与方法"), [], item("实验日期", date.display()),
  item("班级", "✕✕✕✕"), item("姓名", "✕✕✕"), item("学号", "✕✕✕✕✕"),
)

#outline()

= 问题描述

== 任务目标
#p[构建全连接神经网络，预测房价，重点设计基于反向传播算法的连接权优化方法，并分析不同优化算法效果。]

== 具体要求
#p[
  1. 使用包含1个隐藏层的神经网络：
  ```
  输入层(根据特征确定) → 隐藏层(确定隐层神经元数, Sigmoid或者ReLU隐函数) → 输出层(1, Linear)
  ```
  2. 实现基于梯度下降及其改进的反向传播算法训练网络
  3. 禁止使用TensorFlow/PyTorch等框架（仅允许使用`numpy`）
]

= 实验任务
== 模型构建与理论推导
首先加载波士顿房价数据集并进行观察：
```py
# 加载数据
boston = fetch_openml(name="boston", version=1)
X = boston.data.to_numpy()
y = boston.target.to_numpy().reshape(-1, 1)

print(X.shape)
print(y.shape)
```
发现共拥有13个输入的特征，1个输出的特征：
```
(506, 13)
(506, 1)
```
于是可以搭建一个有13个输入，1个输出的神经网络，要求只有一层隐藏层，于是我设定了隐藏层拥有10个神经元。

=== 前向计算
#p[
  设输入特征为 $X in bb(R)^(n times d)$，权重矩阵 $W_1 in bb(R)^(d times h)$，偏置 $b_1 in bb(R)^(1 times h)$，隐藏层激活函数为 $f(dot)$，输出层权重 $W_2 in bb(R)^(h times 10)$，偏置 $b_2 in bb(R)$。

  前向计算过程如下：

  1. 隐藏层线性变换：$Z_1 = X W_1 + b_1$
  2. 激活：$A_1 = f(Z_1)$
  3. 输出层线性变换：$hat(y) = A_1 W_2 + b_2$

  其中，$hat(y)$ 为模型预测的房价。]

=== 损失函数
#p[
  本实验采用均方误差（Mean Squared Error, MSE）作为损失函数，其定义为：
  $
    L = (1) / (n) sum_(i=1)^n (hat(y)_i - y_i)^2
  $
  其中，$hat(y)_i$ 表示模型预测值，$y_i$ 表示真实值，$n$ 为样本数量。MSE衡量预测值与真实值之间的平均平方差，值越小表示模型拟合效果越好。
]

=== 反向传播

#p[
  1. 损失函数为 $L = 1 / n sum (hat(y)_i - y_i)^2$，对输出层的梯度为
    $
      (partial L) / (partial hat(y)) = (2) / (n)(hat(y) - y)
    $

  2. 输出层权重和偏置的梯度：
    $
      (partial L) / (partial W_2) = A_1^T (partial L) / (partial hat(y))
    $
    $
      (partial L) / (partial b_2) = sum (partial L) / (partial hat(y))
    $

  3. 反向传播到隐藏层：
    $
      (partial L) / (partial A_1) = (partial L) / (partial hat(y)) W_2^T
    $
    $
      (partial L) / (partial Z_1) = (partial L) / (partial A_1) dot f'(Z_1)
    $

  4. 隐藏层权重和偏置的梯度：
    $
      (partial L) / (partial W_1) = X^T (partial L) / (partial Z_1)
    $
    $
      (partial L) / (partial b_1) = sum (partial L) / (partial Z_1)
    $

  5. 按照学习率更新参数。
]

== Python编程代码实现
完整代码实现放在了报告最后（@full-impletion）。
```py
# 前向计算
def forward(self, X):
    self.Z1 = X @ self.W1 + self.b1
    self.A1 = self.activation_func(self.Z1)
    self.Z2 = self.A1 @ self.W2 + self.b2
    return self.Z2

# 计算损失
def compute_loss(self, y_pred, y_true):
        return np.mean((y_pred - y_true) ** 2)

# 反向传播，使用简单梯度下降
def backward_with_gd(self, X, y_true, y_pred):
    m = y_true.shape[0]

    dZ2 = (y_pred - y_true) / m  # dLoss/dZ2
    dW2 = self.A1.T @ dZ2
    db2 = np.sum(dZ2, axis=0, keepdims=True)

    dA1 = dZ2 @ self.W2.T
    dZ1 = dA1 * self.activation_func_derivative(self.Z1)
    dW1 = X.T @ dZ1
    db1 = np.sum(dZ1, axis=0, keepdims=True)

    # 更新权重
    self.W2 -= self.lr * dW2
    self.b2 -= self.lr * db2
    self.W1 -= self.lr * dW1
    self.b1 -= self.lr * db1
```

== 使用Adam算法优化反向传播中的梯度下降
#p[
  Adam（Adaptive Moment Estimation）是一种自适应学习率优化算法，结合了动量法和RMSProp的思想。其核心思想是对每个参数分别维护一阶矩（梯度的指数加权平均）和二阶矩（梯度平方的指数加权平均），并进行偏差校正。简单推导如下：

  1. 初始化一阶矩 $m_0 = 0$，二阶矩 $v_0 = 0$，设学习率为 $alpha$，一阶和二阶衰减率分别为 $beta_1, beta_2$（如0.9, 0.999），以及极小常数 $epsilon$（如$10^(-8)$）防止除零。

  2. 每次迭代 $t$，计算当前梯度 $g_t$。

  3. 更新一阶矩估计：
    $
      m_t = beta_1 m_(t-1) + (1 - beta_1) g_t
    $

  4. 更新二阶矩估计：
    $
      v_t = beta_2 v_(t-1) + (1 - beta_2) g_t^2
    $

  5. 进行偏差修正：
    $
      hat(m)_t = m_t / (1 - beta_1^t)
    $
    $
      hat(v)_t = v_t / (1 - beta_2^t)
    $

  6. 更新参数：
    $
      theta_t = theta_(t-1) - alpha dot hat(m)_t / (sqrt(hat(v)_t) + epsilon)
    $
]
=== Adam算法Python代码实现
```py
# 反向传播，使用 Adam 优化
def backward_with_adam(self, X, y_true, y_pred, beta1=0.9, beta2=0.999, epsilon=1e-8):
    m = y_true.shape[0]
    t = self.iterations

    # 计算梯度
    dZ2 = (y_pred - y_true) / m
    dW2 = self.A1.T @ dZ2
    db2 = np.sum(dZ2, axis=0, keepdims=True)

    dA1 = dZ2 @ self.W2.T
    dZ1 = dA1 * self.activation_func_derivative(self.Z1)
    dW1 = X.T @ dZ1
    db1 = np.sum(dZ1, axis=0, keepdims=True)

    # 为每个 weight 和 bias 更新动量和参数
    for param, dparam, m_key, v_key in [
        (self.W1, dW1, "mW1", "vW1"),
        (self.b1, db1, "mb1", "vb1"),
        (self.W2, dW2, "mW2", "vW2"),
        (self.b2, db2, "mb2", "vb2"),
    ]:
        self.adam_params[m_key] = beta1 * self.adam_params[m_key] + (1 - beta1) * dparam
        self.adam_params[v_key] = beta2 * self.adam_params[v_key] + (1 - beta2) * (dparam**2)

        # 更正 bias
        m_corrected = self.adam_params[m_key] / (1 - beta1**t)
        v_corrected = self.adam_params[v_key] / (1 - beta2**t)

        # 更新参数
        param -= self.lr * m_corrected / (np.sqrt(v_corrected) + epsilon)
```

= 结果分析与报告
== 结果可视化
=== 损失函数曲线
#figure(image("images/gd.png"), caption: "简单梯度下降法")
#figure(image("images/adam.png"), caption: "Adam算法")

=== 与实验一至实验六的相关结果的对比分析
在保证`lr=0.01, iterations = 500`的情况下：
#figure(image("images/compare.png", height: 25%), caption: "实验一至实验六Lasso模型优化")

#p[
  通过对比发现，由于神经网络中考虑了每个神经元具有偏置参数（bias），所以最终神经网络对于波士顿房价问题的Loss更低，同时，使用神经网络可以获得比普通Lasso模型更好的收敛速度。
]

== 优化分析
=== ReLU和Sigmoid激活函数的比较
```py
# ReLU 激活函数
def relu(z):
    return np.maximum(0, z)

def relu_derivative(z):
    return np.sign(z)

# Sigmoid 激活函数
def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def sigmoid_derivative(z):
    s = sigmoid(z)
    return s * (1 - s)
```

=== 学习率设置合理性
当`lr=0.01`时:
#figure(image("images/gd.png"), caption: "Test Loss (MSE): 39.0493")

当`lr=0.1`时：
#figure(image("images/lr0_1.png"), caption: "训练出错，模型无法正常收敛")

当`lr=0.001`时：
#figure(image("images/lr0_001.png"), caption: "Test Loss (MSE): 132.5201")

#p[由此得出，当`lr`设置的过大的时候，模型无法正常收敛，当`lr`设置的过小，会降低模型收敛速度，而且在训练轮数过低的情况下会影响模型性能。]

=== 其他改进方案
#p[
  可以考虑继续增加隐藏层数量，进一步优化模型的拟合能力。
]

= 完整代码实现<full-impletion>
#raw(read("attachments/code.py"), block: true, lang: "py")
