# base on Ubuntu 21.10
FROM ubuntu:21.10

# prevent interactive prompts when installing software
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies from Ubuntu repos
RUN apt update && apt install -y ghdl ghdl-llvm python3 python3-pip git make

# create build directory
RUN mkdir /build
WORKDIR /build

# fetch git repos
RUN git clone https://github.com/connorcl/simctrl
RUN git clone https://github.com/connorcl/fpgasim

# set up control API
WORKDIR /build/simctrl
RUN pip3 install -r requirements.txt

# set up VHDL simulator
WORKDIR /build/fpgasim
RUN make
RUN cp fpgasim.vpi /build/simctrl/

# expose ports for API and simulation
EXPOSE 5000 12346

WORKDIR /build/simctrl
CMD ["uwsgi", "--ini", "uwsgi.ini"]
