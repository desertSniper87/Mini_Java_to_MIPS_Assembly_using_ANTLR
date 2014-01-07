#!/bin/bash
./compile.sh
javac BasicMethodCall.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser BasicMethodCall.java > /tmp/test.asm
diff <(java BasicMethodCall | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
