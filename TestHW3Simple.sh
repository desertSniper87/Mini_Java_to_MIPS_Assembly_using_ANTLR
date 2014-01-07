#!/bin/bash
./compile.sh
javac HW3Simple.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW3Simple.java > /tmp/test.asm
diff <(java HW3Simple | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
