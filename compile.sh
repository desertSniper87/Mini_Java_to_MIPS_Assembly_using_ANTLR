#!/bin/bash
rm -f MiniJavaV3*.java
java -jar ../antlr-4.1-complete.jar MiniJavaV3.g4
javac -cp ../antlr-4.1-complete.jar:. MiniJavaV3*.java 
