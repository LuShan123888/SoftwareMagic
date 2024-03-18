---
title: 换k张
categories:
  - Software
  - Algorithm
  - 动态规划
---
# 换k张

## 问题描述

- 给出一个可重集合，并希望你从中选出一个尽可能大的子集使得其中没有两个数是"连续”的（连续是指即这两个数之差的绝对值不超过 1)
- **输入描述**：第一行有一个整数 n (1<=n<=100000)，代表小团给你的可重集大小，第二行有 n 个空格隔开的整数（范围在 1 到 200000 之间），代表小团给你的可重集。
- **输出描述**：输出满足条件的最大子集的大小。

```java
样例输入。
1 2 3 5 6 7
样例输出。
4
```

## 代码实现

```java
public class Solution {

    public static void main(String[] args) {
        System.out.println(new Solution().changeK(new int[]{1, 2, 3, 5, 6, 7}));
    }

    public int changeK(int[] nums) {
        // dp[i]表示截止第i个元素，符合条件的最大子集大小。
        int[] dp = new int[nums.length + 1];
        List<Integer> set = Arrays.stream(nums).boxed().distinct().sorted().collect(Collectors.toList());
        set.add(0, -1);
        dp[0] = 0;
        dp[1] = 1;
        int ans = 0;
        for (int i = 2; i < set.size(); i++) {
            dp[i] = dp[i - 1];
            if (set.get(i) > set.get(i - 1) + 1) {
                // 不相邻则加入nums[i]
                dp[i] = Math.max(dp[i - 1] + 1, dp[i]);
            }
            // 由于去过重，所以num[i]一定与[i-2]不相邻。
            dp[i] = Math.max(dp[i - 2] + 1, dp[i]);
            ans = Math.max(ans, dp[i]);
        }
        return ans;
    }

}
```
