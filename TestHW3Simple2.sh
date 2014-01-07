#!/bin/bash
./compile.sh
javac HW3Test.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW3Test.java > /tmp/test.asm
diff <(java HW3Test | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
