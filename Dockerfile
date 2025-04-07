FROM openjdk:8-jdk

ENV GLASSFISH_VERSION 4.1.1
ENV GLASSFISH_HOME /opt/glassfish4
ENV DEPLOY_DIR $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/

RUN apt-get update && apt-get install -y wget unzip && \
    wget -q http://download.oracle.com/glassfish/${GLASSFISH_VERSION}/release/glassfish-${GLASSFISH_VERSION}.zip -O /tmp/glassfish.zip && \
    unzip /tmp/glassfish.zip -d /opt/ && \
    rm /tmp/glassfish.zip

ENV PATH=$PATH:$GLASSFISH_HOME/bin

EXPOSE 4848 8090 8181

COPY target/*.war $DEPLOY_DIR/helloweb.war

RUN $GLASSFISH_HOME/bin/asadmin start-domain && \
    $GLASSFISH_HOME/bin/asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=8090 && \
    $GLASSFISH_HOME/bin/asadmin stop-domain

CMD ["asadmin", "start-domain", "-v"]
