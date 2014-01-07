#!/bin/bash
./compile.sh
javac HW4Struct.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW4Struct.java > /tmp/test.asm
diff <(java HW4Struct | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
