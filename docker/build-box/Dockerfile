FROM phusion/holy-build-box-64:latest
MAINTAINER  <aiverson@aiverson-nixos>

RUN mkdir deps
RUN yes | yum install xz git

WORKDIR deps

#RUN /hbb_exe/activate-exec bash -c "git clone -b release https://github.com/ninja-build/ninja && cd ninja && python ./configure.py --bootstrap && cp ./ninja /bin/ninja"
COPY fetch-llvm.sh ./
RUN bash fetch-llvm.sh

COPY deps-builder.sh deps-builder.sh
RUN bash deps-builder.sh
