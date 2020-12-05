---
layout: post
title:  "Building a jekyll site using docker"
date:   2020-12-03 07:28:46 -0600
categories: jekyll docker
---
This is how I use, build, and test my jekyll site locally without polluting my system with npm or ruby installations. Instead, I rely on a docker installation to run the tooling.

The key to this working is to put the following shell script `jekyll.sh` in my jekyll site repository. This script allows me to run commands that you would normally be able to run if you had jekyll installed natively.

{% highlight shell linenos %}
export JEKYLL_VERSION=3.8 
docker run --rm \
   -p 127.0.0.1:4000:4000/tcp \
   --volume="$PWD:/srv/jekyll" \
   --volume="$PWD/vendor/bundle:/usr/local/bundle" \
   -it jekyll/jekyll:$JEKYLL_VERSION \
   $@
{% endhighlight %}

Let's go through the script line by line.

1. `export JEKYLL_VERSION=3.8`  
Set a shell variable `JEKYLL_VERSION` to `3.8`. This will be used when pulling the docker image in the next command
1. `docker run --rm \`  
Run a docker container and remove it when the process (or command) exits
1. `-p 127.0.0.1:4000:4000/tcp \`  
Map the port 4000 on the host machine to port 4000 inside the docker container
1. `--volume="$PWD:/src/jekyll" \`  
Map the host's present working directory (PWD) to `/src/jekyll` on the container. This is where the the container expects to find the jekyll site source code
1. `--volume="$PWD/vendor/bundle:/usr/local/bundle" \`  
Map the host's `/vendor/bundle` folder inside the present working directory to the container's `/usr/local/bundle` folder. This is where the jekyll commands will cache ruby packages. These packages will be persisted on the host machine inside the mapped folder which allows caching to happen between commands even though the container is removed after each command
1. `-it jekyll/jekyll:$JEKYLL_VERSION \`  
  * The `-it` flags specifies that we will be interacting with the container's shell so it will map "standard in" (stdin) to the host's shell to allow user input
  * Runs the `jekyll/jekyll` docker image with the specified version set in step #1
1. `$@` is a shell script feature that maps the user arguments to the shell's command. If you run the script like `./myscript.sh firstArg secondArg`, those arguments would replace the `$@` in the shell script. This allows the person running the script to pass in any command they want and it will attempt to run the command in the docker container

Finally, you can set this script (we'll call it `jekyll.sh`) to be executable and then use it to run jekyll commands on your host machine.

{% highlight shell %}
$ chmod +x ./jekyll.sh
$ ./jekyll.sh jekyll build
$ ./jekyll.sh jekyll serve --watch --drafts
{% endhighlight %}
