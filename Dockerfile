FROM tomcat:latest

MAINTAINER Tapojit Bhattacharya "tapojit.bhattacharya@gmail.com"

EXPOSE 8080

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ./webapp/target/*.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
