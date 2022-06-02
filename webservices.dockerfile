FROM ubuntu:18.04
RUN /bin/bash -c 'apt-get update; apt-get install -y openjdk-11-jre-headless; apt-get install sudo -y'
ENV JAVA_HOME "/usr/lib/jvm/java-11-openjdk-amd64"

RUN mkdir /usr/local/tomcat
COPY target/apache-tomcat-9.0.36 /usr/local/tomcat/apache-tomcat-9.0.36
COPY target/server.xml /usr/local/tomcat/apache-tomcat-9.0.36/conf/server.xml
EXPOSE 8080
RUN rm -rf /usr/local/tomcat/apache-tomcat-9.0.36/webapps/docs /usr/local/tomcat/apache-tomcat-9.0.36/webapps/*manager /usr/local/tomcat/apache-tomcat-9.0.36/webapps/examples
COPY target/webservices.war /usr/local/tomcat/apache-tomcat-9.0.36/webapps/webservices.war
COPY target/setenv.sh /usr/local/tomcat/apache-tomcat-9.0.36/bin/setenv.sh
RUN /bin/bash -c 'groupadd tomcat -g 998; useradd -rm -d /home/tomcat -s /bin/bash -g tomcat -G sudo,ignite -u 998 tomcat;'
RUN sudo usermod -a -G sudo tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat/

USER tomcat
WORKDIR /home/tomcat

ENTRYPOINT ["/usr/local/tomcat/apache-tomcat-9.0.36/bin/catalina.sh", "run"]
