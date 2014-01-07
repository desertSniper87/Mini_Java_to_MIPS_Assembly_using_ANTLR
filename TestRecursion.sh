#!/bin/bash
./compile.sh
javac TestRecursion.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestRecursion.java > /tmp/test.asm
diff <(java TestRecursion | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
