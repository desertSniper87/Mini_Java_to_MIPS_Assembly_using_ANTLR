#!/bin/bash
./compile.sh
javac Int.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser Int.java > /tmp/test.asm
diff <(java Int | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
