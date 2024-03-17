---
title: Hanoi塔问题
categories:
- Software
- Algorithm
- 递归与分治策略
---
# Hanoi塔问题

## 问题描述

- 设a, b, c是三个塔座, 开始时, 在塔座a上有一叠共n个圆盘, 这些圆盘自下而上, 由大到小地叠放在一起，各圆盘从小到大编号为1, 2, 3,...,n, 先要求将塔座a上的这一叠圆盘移到塔座b上, 并仍按同样顺序叠置, 在移动圆盘时应遵守一下移动规则:
    1. 每次只能移动一个圆盘
    2. 任何时刻都不允许将降大的圆盘压在较小的圆盘之上
    3. 在满足上述规则的前提下, 可将圆盘移至a, b, c任一塔座上

## 算法分析

- 当n=1时, 问题比较简单, 此时, 只要将编号为1的圆盘从塔座a移至塔座b上即可
- 当n>1时, 需要利用塔座c作为辅助塔座
    1. 将n-1个较小的圆盘依照移动规则从塔座a移至塔座c上
    2. 将剩下的最大圆盘从塔座a移至塔座b上
    3. 将n-1个较小的圆盘依照移动规则从塔座c移至塔座b上
- 由此可见, n个圆盘的移动问题就可分解为两次n-1个圆盘的移动问题, 这又可以递归地用上述方法来做

## 代码实现

### 流程图

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-10-2020-11-08-Flowchart-4823333.svg)

```java
public class Solution {

    public static void main(String[] args) {
        Stack<Integer> a = new Stack<>();
        Stack<Integer> b = new Stack<>();
        Stack<Integer> c = new Stack<>();
        int n = 5;
        for (int i = n; i > 0; i--) {
            a.push(i);
        }
        System.out.println("hanoi a init: " + a);
        Solution solution = new Solution();
        int count = solution.hanoi(n, a, b, c);
        solution.printStack(a, b, c);
        System.out.println("-----------end------------");
        System.out.println("共移动:" + count + "次");
    }

    int count = 0;

    public int hanoi(int n, Stack<Integer> a, Stack<Integer> b, Stack<Integer> c) {
        if (n > 0) {
            hanoi(n - 1, a, c, b);
            printStack(a, b, c);
            move(a, b);
            hanoi(n - 1, c, b, a);
        }
        return count;
    }

    public void move(Stack<Integer> a, Stack<Integer> b) {
        Integer temp;
        temp = a.pop();
        b.push(temp);
        count += 1;
    }

    public void printStack(Stack<Integer> x, Stack<Integer> y, Stack<Integer> z) {
        System.out.println("----------move------------");
        System.out.println("hanoi a" + x);
        System.out.println("hanoi b" + y);
        System.out.println("hanoi c" + z);
    }

}
```

- `hanoi(int n, Stack<Integer> a, Stack<Integer> b, Stack<Integer> c) `:将塔座a上自下而上, 由大到小叠放在一起的n个圆盘依移动规则移至塔座b上并仍按同样顺序叠放, 在移动过程中, 以塔座c作为辅助塔座
- `move(Stack<Integer> a, Stack<Integer> b)`:将塔座a最上层的圆盘移至塔座b上
    - `Stack<Integer> a`:塔座a
    - `Stack<Integer> b`:塔座b