#!/bin/bash
./compile.sh
javac Str.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser Str.java > /tmp/test.asm
diff <(java Str | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
