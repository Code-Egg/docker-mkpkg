#!/usr/bin/env bash
PUSH=''
CONFIG=''
TAG=''
BUILDER='coldegg'
REPO='mkpkg'
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m" 
    echow '-V, --version [VERSION_NUMBER]'
    echo "${EPACE}${EPACE}Example: bash build.sh -V 101"
    echow '--push'
    echo "${EPACE}${EPACE}Example: build.sh -V101 --push, will push to the dockerhub"
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        help_message
    fi
}

build_image(){
    if [ -z "${1}" ]; then
        help_message
    else
        echo "${1}"
        docker build . --tag ${BUILDER}/${REPO}:${1} --build-arg VERSION=${1}
    fi    
}

test_image(){
    ID=$(docker run -d ${BUILDER}/${REPO})
    sleep 1
    docker exec -i ${ID} su -c 'mkdir -p /var/www/vhosts/localhost/html/ \
    && echo "<?php phpinfo();" > /var/www/vhosts/localhost/html/index.php \
    && /usr/local/lsws/bin/lswsctrl restart >/dev/null '

    HTTP=$(docker exec -i ${ID} curl -s -o /dev/null -Ik -w "%{http_code}" http://localhost)
    HTTPS=$(docker exec -i ${ID} curl -s -o /dev/null -Ik -w "%{http_code}" https://localhost)
    docker kill ${ID}
    if [[ "${HTTP}" != "200" || "${HTTPS}" != "200" ]]; then
        echo '[X] Test failed!'
        echo "http://localhost returned ${HTTP}"
        echo "https://localhost returned ${HTTPS}"
        exit 1
    else
        echo '[O] Tests passed!' 
    fi
}

push_image(){
    if [ ! -z "${PUSH}" ]; then
        if [ -f ~/.docker/coldegg/config.json ]; then
            CONFIG=$(echo --config ~/.docker/coldegg)
        fi
        docker ${CONFIG} push ${BUILDER}/${REPO}:${1}
        if [ ! -z "${TAG}" ]; then
            docker tag ${BUILDER}/${REPO}:${1} ${BUILDER}/${REPO}:${2}
            docker ${CONFIG} push ${BUILDER}/${REPO}:${2}
        fi
    else
        echo 'Skip Push.'    
    fi
}

main(){
    build_image ${VERSION}
    #test_image ${VERSION}
    push_image ${VERSION} ${TAG}
}

check_input ${1}
while [ ! -z "${1}" ]; do
    case ${1} in
        -[hH] | -help | --help)
            help_message
            ;;
        -[vV] | -version | --version) shift
            check_input "${1}"
            VERSION="${1}"
            ;;            
        -[tT] | -tag | -TAG | --tag) shift
            TAG="${1}"
            ;;       
        --push )
            PUSH=true
            ;;            
        *) 
            help_message
            ;;              
    esac
    shift
done

main