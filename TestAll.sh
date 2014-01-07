#!/bin/bash
./compile.sh
javac TestAll.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestAll.java > /tmp/test.asm
diff <(java TestAll | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
