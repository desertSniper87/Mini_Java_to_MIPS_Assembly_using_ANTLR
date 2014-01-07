#!/bin/bash
./compile.sh
javac HW3Level5Test.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW3Level5Test.java > /tmp/test.asm
diff <(java HW3Level5Test | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
