#!/bin/bash
./compile.sh
javac NestedWhile.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser NestedWhile.java > /tmp/test.asm
diff <(java NestedWhile | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
