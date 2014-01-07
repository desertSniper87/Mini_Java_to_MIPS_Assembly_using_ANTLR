#!/bin/bash
./compile.sh
javac TestPolymorphicMethodCall.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestPolymorphicMethodCall.java > /tmp/test.asm
diff <(java TestPolymorphicMethodCall | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
