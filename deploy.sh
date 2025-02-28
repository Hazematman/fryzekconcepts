# Old deploy to gitlab pages
# git subtree push --prefix html origin gh-pages

rsync -avz --delete html/ game.fryzekconcepts.com:/var/www/blog/
