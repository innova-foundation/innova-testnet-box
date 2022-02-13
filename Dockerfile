# innova-testnet-box docker image

FROM ubuntu:18.04
LABEL maintainer="CircuitBreaker <sarris88p@gmail.com>"
ARG DEBIAN_FRONTEND=noninteractive

# install make
RUN apt-get update && \
	apt-get install --yes make wget

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

ENV INNOVA_CORE_VERSION "4.3.9.1"

# download and build the innova binaries
RUN mkdir tmp \
&& cd tmp \
&& apt-get update && apt-get -y upgrade \
&& apt-get -y install build-essential libssl-dev libdb++-dev libboost-all-dev libminiupnpc-dev libqrencode-dev libevent-dev obfs4proxy libcurl4-openssl-dev \
&& apt-get -y install git \
&& apt-get -y install make \
&& apt-get -y install wget \
&& wget https://www.openssl.org/source/openssl-1.0.1j.tar.gz \
&& tar -xzvf openssl-1.0.1j.tar.gz \
&& cd openssl-1.0.1j \
&& ./config \
&& make depend \
&& make install \
&& ln -sf /usr/local/ssl/bin/openssl `which openssl` \
&& cd /tmp

RUN git clone https://github.com/innova-foundation/innova \
&& cd innova/src \
&& make OPENSSL_INCLUDE_PATH=/usr/local/ssl/include OPENSSL_LIB_PATH=/usr/local/ssl/lib -f makefile.unix \
&& strip innovad \
&& sudo yes | cp -rf innovad /usr/bin/

# clean up
RUN rm -r tmp

# copy the testnet-box files into the image
ADD . /home/tester/innova-testnet-box

# make tester user own the innova-testnet-box
RUN chown -R tester:tester /home/tester/innova-testnet-box

# color PS1
RUN mv /home/tester/innova-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/innova-testnet-box

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/bash"]
