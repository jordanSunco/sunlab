set clspath=".;./bin;./lib/mina-core-1.1.jar;./lib/sgs.jar;./lib/slf4j-api-1.4.0.jar;./lib/slf4j-jdk14-1.4.0.jar;./lib/db.jar"
java -Djava.library.path="./lib/bdb/win32-x86" ^
     -Djava.util.logging.config.file="./conf/sgs-logging.properties" ^
	 -Dcom.sun.sgs.config.file="./conf/sgs-config.properties" ^
     -cp %clspath% ^
     com.sun.sgs.impl.kernel.Kernel ^
     ./conf/sgsApp.properties