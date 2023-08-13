hexo clean && \
sh FrontMatter.sh && \
hexo generate && \
hexo deploy && \
git add . && \
git commit -m 'update notes' && \
git push