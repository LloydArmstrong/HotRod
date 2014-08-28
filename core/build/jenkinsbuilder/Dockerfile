FROM panoptix/jenkins

MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>

WORKDIR /tmp
RUN $JAVA_HOME/bin/jar xvf /tmp/jenkins.war  WEB-INF/slave.jar

ENTRYPOINT sleep 10; $JAVA_HOME/bin/java -jar WEB-INF/slave.jar -jnlpUrl http://jenkins:8080/computer/hotrod-builder/slave-agent.jnlp

