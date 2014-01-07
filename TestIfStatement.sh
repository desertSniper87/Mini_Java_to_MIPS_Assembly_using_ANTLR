#!/bin/bash
./compile.sh
javac TestIfStatement.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestIfStatement.java > /tmp/test.asm
diff <(java TestIfStatement | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
