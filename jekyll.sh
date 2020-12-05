export JEKYLL_VERSION=3.8 
docker run --rm \
   -p 127.0.0.1:4000:4000/tcp \
   --volume="$PWD:/srv/jekyll" \
   --volume="$PWD/vendor/bundle:/usr/local/bundle" \
   -it jekyll/jekyll:$JEKYLL_VERSION \
   $@
