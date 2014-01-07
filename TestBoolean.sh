#!/bin/bash
./compile.sh
javac TestBoolean.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestBoolean.java > /tmp/test.asm
diff <(java TestBoolean | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
