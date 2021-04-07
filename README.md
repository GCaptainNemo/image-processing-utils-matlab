# 图像处理工具箱
代码资源在src文件夹内，对应图像资源在resources文件内。

## 包括内容：
1. 傅里叶变换去除波纹噪声
2. 图像插值（最近邻、双线性、立方卷积）
3. 线性最小二乘求解变换系数
4. 直方图均衡化与灰度线性拉伸
5. 均值滤波和中值滤波
6. 大津阈值分割
7. 边缘检测算子（Laplace，sobel，Roberts，kirsch算子）
8. 图像修复综合作业（hough变换 + 区域生长法）

## 对应代码：
1. src/remove_water_marking.m, src/remove_water_marking2.m
2. src/lena_interpolation.m
3. src/leastSquare.m
4. src/HE.m, src/gray_linear_stretch.m
5. src/average_median_filter.m
6. src/OTSU.m
7. src/edge_detection_operator.m
8. src/hough_transform.m

## 补充：
1. Matlab图像手动配准 (jupyter_notebook/registration.ipynb)
2. Matlab水域分割 (jupyter_notebook/watershed.ipynb)

## 参考资料
[1] [watershed-CSDN](https://blog.csdn.net/u011583927/article/details/53413825)

[2] [jupyter-notebook Matlab](https://blog.csdn.net/ZHzfzdr/article/details/86101205?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&dist_request_id=1328769.80956.16177695400576005&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control)




