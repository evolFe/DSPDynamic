# 动态规划法 --- 解决 --- TSP旅行商问题

import numpy as np
import json, math


# 限制最大选择数目为MAX 尽量设置在20之内，因为该算法空间和时间复杂度相当高

class TSPDynamic(object):
    def __init__(self):
        self.count = 0

    def min_distance(self, s, init):
        if self.visited[s][init] != -1:
            return self.visited[s][init]
        if s == (1 << (self.count - 1)):
            return self.dp[self.count - 1][init]

        min_length = 100000.0
        min_index = 0
        for i in range(self.count - 1):
            if s & (1 << i):
                s_w = s & (~(1 << i))
                ret = self.min_distance(s_w, i)
                if (ret + self.dp[i][init]) < min_length:
                    min_length = ret + self.dp[i][init]
                    min_index = i
        self.paths[s][init] = min_index
        self.visited[s][init] = min_length
        return min_length

    # 测试数据 最需要的各个城市之间的距离 及 城市数量
    def _load_jsonfile(self):
        with open("city.json", 'r') as load_f:
            cities = json.load(load_f)
        return cities

    def config_dp_count(self):
        cities = self._load_jsonfile()
        self.count = len(cities)  # 初始化 count
        TSP_MAX = self.count
        self.dp = np.zeros((TSP_MAX, TSP_MAX), np.double)
        self.visited = np.full((2 ** TSP_MAX, TSP_MAX), -1.0)  # 从start 到 S集合 是否已经访问过 存储最小距离
        self.paths = np.zeros((2 ** TSP_MAX, TSP_MAX), np.int)  # 保存路径

        for i in range(self.count):  # 初始化 dp
            city1 = cities[i]
            for j in range(self.count):
                city2 = cities[j]
                self.dp[i][j] = math.sqrt((math.pow((city1['X'] - city2['X']), 2) +
                                           math.pow((city1['Y'] - city2['Y']), 2)))

    def calculate(self):
        self.config_dp_count()
        s = 0
        for i in range(1, self.count):
            s = s | (1 << i)

        distance = self.min_distance(s, 0)
        path_ret = [0]
        index = 0
        for i in range(self.count - 2):
            index = self.paths[s][index]
            path_ret.append(index)
            s = s & (~(1 << index))
        path_ret.append(self.count - 1)
        return (distance, path_ret)


if __name__ == '__main__':
    tsp = TSPDynamic()
    ret = tsp.calculate()
    print(ret)
