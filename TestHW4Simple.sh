#!/bin/bash
./compile.sh
javac HW4Simple.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW4Simple.java > /tmp/test.asm
diff <(java HW4Simple | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
