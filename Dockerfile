# BashoBench

FROM phusion/baseimage:0.9.9
MAINTAINER Drew Kerrigan dkerrigan@basho.com

# Install Erlang
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y git && apt-get install -y curl && \
	apt-get install -y build-essential && apt-get update -qq && \
	apt-get install -y erlang && apt-get update -qq

# Install R
RUN echo "deb http://cran.cnr.berkeley.edu//bin/linux/ubuntu precise/" | sudo tee -a /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y --force-yes r-base && apt-get update -qq

# Install Basho Bench
RUN git clone git://github.com/basho/basho_bench.git /opt/basho_bench
RUN cd /opt/basho_bench && make all

# Setup the Basho Bench scripts & configs
RUN mkdir -p /opt/basho_bench/tests
RUN mkdir -p /opt/basho_bench/reports

ADD files/config /opt/basho_bench
ADD files/bin /opt/basho_bench/
ADD files/priv/summary.r /opt/basho_bench/priv/summary.r

# Workaround for the first run of make results failing
RUN cd /opt/basho_bench && make results || echo "R installation complete."

# Open a port for test reports
EXPOSE 9999

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Leverage the baseimage-docker init system
CMD ["/sbin/my_init", "--quiet"]
