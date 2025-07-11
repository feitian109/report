import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import fetch_openml
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# 固定随机数种子
np.random.seed(24)

# 加载数据
boston = fetch_openml(name="boston", version=1)
X = boston.data.to_numpy()
y = boston.target.to_numpy().reshape(-1, 1)

print(X.shape)
print(y.shape)

# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 数据标准化
scaler_X = StandardScaler()
scaler_y = StandardScaler()
X_train = scaler_X.fit_transform(X_train)
X_test = scaler_X.transform(X_test)
y_train = scaler_y.fit_transform(y_train)
y_test = scaler_y.transform(y_test)


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


class NeuralNetwork:
    def __init__(self, input_size, hidden_size, output_size, activation_func, activation_func_derivative, lr=0.01):
        # 权重初始化
        self.W1 = np.random.randn(input_size, hidden_size)
        self.b1 = np.zeros((1, hidden_size))
        self.W2 = np.random.randn(hidden_size, output_size)
        self.b2 = np.zeros((1, output_size))
        self.lr = lr

        # 设定激活函数及其导数
        self.activation_func = activation_func
        self.activation_func_derivative = activation_func_derivative

        # 设定反向传播方法
        self.backward = self.backward_with_gd

        # 用于 Adam 的参数
        self.adam_params = {
            "mW1": np.zeros_like(self.W1),
            "vW1": np.zeros_like(self.W1),
            "mb1": np.zeros_like(self.b1),
            "vb1": np.zeros_like(self.b1),
            "mW2": np.zeros_like(self.W2),
            "vW2": np.zeros_like(self.W2),
            "mb2": np.zeros_like(self.b2),
            "vb2": np.zeros_like(self.b2),
        }

        # 记录训练轮数
        self.iterations = 0

    # 计算损失
    def compute_loss(self, y_pred, y_true):
        return np.mean((y_pred - y_true) ** 2)

    # 前向计算
    def forward(self, X):
        self.Z1 = X @ self.W1 + self.b1
        self.A1 = self.activation_func(self.Z1)
        self.Z2 = self.A1 @ self.W2 + self.b2
        return self.Z2

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

    # 训练
    def train(self, X, y, epochs=1000):
        losses = []
        for _ in range(epochs):
            self.iterations += 1
            y_pred = self.forward(X)
            loss = self.compute_loss(y_pred, y)
            losses.append(loss)
            self.backward(X, y, y_pred)
        return losses


# 初始化网络
nn = NeuralNetwork(
    input_size=13,
    hidden_size=10,
    output_size=1,
    activation_func=relu,
    activation_func_derivative=relu,
    lr=0.01,
)

# 训练模型
losses = nn.train(X_train, y_train, epochs=500)

# 预测
y_pred = nn.forward(X_test)

# 反标准化并评估
y_pred_inv = scaler_y.inverse_transform(y_pred)
y_test_inv = scaler_y.inverse_transform(y_test)

# 计算均方误差
mse = np.mean((y_pred_inv - y_test_inv) ** 2)
print(f"\nTest Loss (MSE): {mse:.4f}")

plt.figure(figsize=(8, 4))
plt.title("Neural Network With Simple GD (lr=0.1)")
plt.xlabel("Iterations")
plt.ylabel("Training Loss (MSE)")
plt.plot(range(len(losses)), losses)
plt.grid()
plt.show()
