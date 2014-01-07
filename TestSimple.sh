#!/bin/bash
./compile.sh
javac Simple.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser Simple.java > /tmp/test.asm
diff <(java Simple | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
