---
title: N皇后问题
categories:
- Software
- Algorithm
- 回溯法
---
# N皇后问题

## 问题描述

- 在`n x n`格的棋盘上防止彼此不受攻击的n个皇后,按照国际象棋的规则,皇后可以攻击与之处在同一行或同一列或同一斜线上的棋子,n后问题等价于在`n x n`格的棋盘上放置n格皇后,任何2个皇后不放在同一行或同一列或同一斜线上

## 算法设计

- 为了判断一个位置所在的列和两条斜线上是否已经有皇后,使用三个集合`columns`,`diagonals1`和`diagonals2` 分别记录每一列以及两个方向的每条斜线上是否有皇后
- 列的表示法很直观,一共有N 列,每一列的下标范围从0到N−1,使用列的下标即可明确表示每一列
- 如何表示两个方向的斜线呢？对于每个方向的斜线,需要找到斜线上的每个位置的行下标与列下标之间的关系

方向一的斜线为从左上到右下方向,同一条斜线上的每个位置满足行下标与列下标之差相等,例如(0,0) 和 (3,3)在同一条方向一的斜线上,因此使用行下标与列下标之差即可明确表示每一条方向一的斜线
- 方向二的斜线为从右上到左下方向,同一条斜线上的每个位置满足行下标与列下标之和相等,例如(3,0)和(1,2) 在同一条方向二的斜线上,因此使用行下标与列下标之和即可明确表示每一条方向二的斜线

## 回溯法

### 代码实现

#### 流程图

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-21-Flowchart-8545082.png)

```java
public class test {
    
    public static void main(String[] args) {
        int n = 4;
        int[] queens = new int[n];
        List<List<String>> solutions = new ArrayList<>();
        Arrays.fill(queens, -1);
        Set<Integer> columns = new HashSet<>();
        Set<Integer> diagonals1 = new HashSet<>();
        Set<Integer> diagonals2 = new HashSet<>();
        backtrack(solutions, queens, n, 0, columns, diagonals1, diagonals2);
        for (List<String> i : solutions) {
            for (String j : i) {
                System.out.println(j);
            }
            System.out.println();
        }
    }

    static public void backtrack(List<List<String>> solutions, int[] queens, int n, int row, Set<Integer> columns, Set<Integer> diagonals1, Set<Integer> diagonals2) {
        //说明已经得出结果,打印棋盘,并存于结果集
        if (row == n) {
            List<String> board = generateBoard(queens, n);
            solutions.add(board);
        } else {
            for (int i = 0; i < n; i++) {
                //在同一列
                if (columns.contains(i)) {
                    continue;
                }
                //在同左斜线
                int diagonal1 = row - i;
                if (diagonals1.contains(diagonal1)) {
                    continue;
                }
                //在同右斜线
                int diagonal2 = row + i;
                if (diagonals2.contains(diagonal2)) {
                    continue;
                }
                //适合的位置
                queens[row] = i;
                //记录新放置的皇后
                columns.add(i);
                diagonals1.add(diagonal1);
                diagonals2.add(diagonal2);
                //判断下一行
                backtrack(solutions, queens, n, row + 1, columns, diagonals1, diagonals2);
                //下一行没有合适的位置,执行回溯操作
                queens[row] = -1;
                columns.remove(i);
                diagonals1.remove(diagonal1);
                diagonals2.remove(diagonal2);
            }
        }
    }

    //生成棋盘
    static public List<String> generateBoard(int[] queens, int n) {
        List<String> board = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            char[] row = new char[n];
            Arrays.fill(row, '.');
            row[queens[i]] = 'Q';
            board.add(new String(row));
        }
        return board;
    }

}
```

- `backtrack(List<List<String>> solutions, int n, int row, Set<Integer> columns, Set<Integer> diagonals1, Set<Integer> diagonals2)`:计算第row行可以安置皇后的位置
    - `List<List<String>> solutions`:保存所有成功结果的结果集
    - `int n`:表示棋盘的大小
    - `int row`:表示要计算的行
    - ` int[] queens`:表示皇后在每一行的位置,a[i]=j,表示第i行的第j列的有皇后
    - `Set<Integer> columns`:记录已经被占用的列
    - `Set<Integer> diagonals1`:记录已经被占用的左斜线
    - `Set<Integer> diagonals2`:记录已经被占用的右斜线
- `List<String> generateBoard(int[] queens, int n)`:通过皇后的位置生成棋盘
    - ` int[] queens`:表示皇后在每一行的位置,a[i]=j,表示第i行的第j列的有皇后
    - `int n`:表示棋盘的大小

## 迭代法

### 代码设计

#### 流程图

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2020-12-21-Flowchart%2520(1).png)

```java
public class test {
    static int n = 5;
    // x[k]表示第k个皇后放在第k行第x[k]列
    static int[] x = new int[n + 1];

    public static void main(String[] args) {
        System.out.println((x.length - 1) + "皇后的解为:");
        Nqueens(n);
    }

    static public void Nqueens(int n) {
        //k表示当前行,x[k]是当前列
        x[1] = 0;
        int k = 1;
        while (k > 0) {
            //搜索下一列
            x[k] = x[k] + 1;
            while ((x[k] <= n) && !place(k))
                //判断是否没出列,其次,判断是否能放在这个列,不能下一个列判断
                x[k] = x[k] + 1;
            //找到一个合适的位置
            if (x[k] <= n) {
                //是否是一个完整的解
                if (k == n) {
                    for (int i = 1; i < x.length; i++) {
                        System.out.print(" " + x[i]);
                    }
                    System.out.println();
                } else {
                    //否则搜索下一行
                    k = k + 1;
                    x[k] = 0;
                }
            } else {
                //回溯到上一行
                k = k - 1;
            }
        }
    }

    static private boolean place(int k) {
        //如果一个皇后能放在第k行和x[k]列则返回true,否则返回false
        int i = 1;
        while (i < k) {
            //同一列有两个皇后以及在同一个对角线上
            if (x[i] == x[k] || Math.abs(x[i] - x[k]) == Math.abs(i - k)) {
                return false;
            }
            i++;
        }
        return true;
    }

}
```

- `static public void Nqueens(int n)`:计算n后问题
    - `int n`:皇后的数量
- ` static private boolean place(int k)`:判断皇后的位置是否可行
    - `int k`:表示第`k`行和`x[k]`列的位置