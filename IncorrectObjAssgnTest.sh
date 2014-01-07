#!/bin/bash
./compile.sh
javac TestObjAssgn.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser IncorrectObjAssgn.java > /dev/null
