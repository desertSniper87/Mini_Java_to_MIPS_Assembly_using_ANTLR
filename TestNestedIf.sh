#!/bin/bash
./compile.sh
javac NestedIf.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser NestedIf.java > /tmp/test.asm
diff <(java NestedIf | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
