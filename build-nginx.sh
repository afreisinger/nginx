#!/bin/sh
#Build NGINX  Docker container
#

# Usage EXAMPLE: ./build-nginx.sh ubuntu18.04
distro="$(tr [A-Z] [a-z] <<< "$1")" # set to lowercase

    # Set build directory
    build_dir='./nginx'
    
    # remove Dockerfile here (if exists)
    # rm $build_dir/Dockerfile || true
     
     rm -rf $build_dir/* || true

    # copy desired Dockerfile
    cp Dockerfiles/$distro/Dockerfile $build_dir
    cp -R etc/ $build_dir/etc
    cp -R html/ $build_dir/html
    cp -R snippets/ $build_dir/snippets
    cp -R certs/ $build_dir/certs
    cp -R includes/ $build_dir/includes

    ls $build_dir
    

    # Build and tag it as "nginx-plus-[distro]"
    docker build -t nginx-$distro -t localhost:5005/nginx-$distro $build_dir --pull --no-cache # No caching
    docker push localhost:5005/nginx-$distro

    # Show all docker containers build with names containing "nginx-plus-"
    printf "\n"
    printf "Nginx  containers built:"
    printf "\n"
    docker images | grep nginx

    # remove Dockerfile from the build directory (if exists)
    rm -rf $build_dir/* || true