#!/bin/bash
./compile.sh
javac HW3SimpleNoIfWhile.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW3SimpleNoIfWhile.java > /tmp/test.asm
diff <(java HW3SimpleNoIfWhile | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
