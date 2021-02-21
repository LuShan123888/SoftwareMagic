---
title: IDEA Vim插件
categories:
- Software
- Tools
- IDEA
---
# IDEA Vim插件

## 配置

- `~/.ideavimrc`

```
" 设置leader键为空格
let mapleader=" "

noremap <leader>j gt
noremap <leader>k gT
noremap <leader>h :action Back<CR>
noremap <leader>l :action Forward<CR>
noremap <leader>v :action VimVisualToggleBlockMode<CR>
noremap <leader>fs :action FileStructurePopup<CR>

noremap <leader>ga :action GotoAction<CR>
noremap <leader>gc :action GotoClass<CR>
noremap <leader>gd :action GotoDeclaration<CR>
noremap <leader>gi :action GotoImplementation<CR>
noremap <leader>gs :action GotoSuperMethod<CR>
noremap <leader>gt :action GotoTest<CR>

noremap / :action Find<CR>
"noremap f :action AceAction<CR>
"noremap F :action AceTargetAction<CR>
"-----------------------------------------------------------------------------------------
"显示当前的模式
set showmode
"同步系统剪贴板
set clipboard=unnamed
"滚动锁定显示
set scrolloff=5
" 自动换行
set wrap
" 设置相对的行号
set relativenumber
" 大写光标移动按键多次执行
noremap J 7j
noremap K 5k
noremap H 5h
noremap L 7l
" 设置光标回到行首
noremap <C-h> 0
" 设置光标回到行尾
noremap <C-l> $
"---------------------------------------------------------------------------
:set keep-english-in-normal
```

