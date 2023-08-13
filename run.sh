hexo clean && \
sh front_matter.sh && \
hexo generate && \
hexo deploy && \
git add . && \
git commit -m 'update notes' && \
git push