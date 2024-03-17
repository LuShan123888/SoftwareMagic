---
title: 至多包含K个不同字符的最长子串
categories:
  - Software
  - Algorithm
  - 滑动窗口
---
# 至多包含K个不同字符的最长子串

## 问题描述

- 给定一个字符串 s，找出至多包含 k 个不同字符的最长子串 T

```javascript
示例 1:
输入： s = "eceba", k = 2
输出： 3
解释：则 T 为 "ece"，所以长度为 3

示例 2:
输入： s = "aa", k = 1
输出： 2
解释：则 T 为 "aa"，所以长度为 2
```

## 代码实现

```java
public class Solution {

    public static void main(String[] args) {
        System.out.println(new Solution().lengthOfLongestSubstringKDistinct("eceba", 2));
    }

    int lengthOfLongestSubstringKDistinct(String s, int k) {
        int maxLength = 0;
        HashMap<Character, Integer> map = new HashMap<>();
        for (int left = 0, right = 0; right < s.length(); right++) {
            map.put(s.charAt(right), map.getOrDefault(s.charAt(right), 0) + 1);
            while (map.size() > k) {
                if (map.get(s.charAt(left)) != null && map.get(s.charAt(left)) > 1) {
                    map.put(s.charAt(left), map.get(s.charAt(left)) - 1);
                } else {
                    map.remove(s.charAt(left));
                }
                left++;
            }
            maxLength = Math.max(maxLength, right - left + 1);
        }
        return maxLength;
    }
}
```

