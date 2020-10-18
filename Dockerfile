# https://hub.docker.com/_/ubuntu
FROM ubuntu:20.04

ENV ioq3_repo https://github.com/ioquake/ioq3.git
ENV ioq3_lib_dir /usr/lib/ioquake3
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# Build ioquake3 server from sources
# https://github.com/ioquake/ioq3
ENV ioq3_build_dir /var/tmp/ioq3_build
ENV build_libs 'git build-essential libsdl2-2.0 libsdl2-dev'
# http://www.libsdl.org
RUN apt-get install -y ${build_libs} \
 && git clone ${ioq3_repo} ${ioq3_build_dir} \
 && cd ${ioq3_build_dir}; make; make copyfiles \
 && mv ${ioq3_build_dir}/build/release-linux-x86_64 ${ioq3_lib_dir} \
 && mv ${ioq3_lib_dir}/ioq3ded.x86_64 ${ioq3_lib_dir}/ioq3ded \
 && rm -rf $ioq3_build_dir \
 && apt-get purge -y ${build_libs} \
 && apt-get autoremove -y

COPY package.json ${ioq3_lib_dir}

# Install nodejs
RUN apt-get install -y curl gnupg gnupg2 gnupg1 \
 && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt-get install -y nodejs \
 && cd ${ioq3_lib_dir}; npm i --production

# Assets
COPY q3a ${ioq3_lib_dir}
COPY target/out ${ioq3_lib_dir}

EXPOSE 27960/tcp
EXPOSE 27960/udp

WORKDIR ${ioq3_lib_dir}

CMD ["node", "./server.js", "+set", "dedicated", "1", "+set", "fs_game", "osp", "+seta", "com_hunkmegs", "64", "+exec", "ffa.cfg", "+seta", "rconpassword", "password", "+set", "sv_pure", "0"]
