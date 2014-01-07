#!/bin/bash
./compile.sh
javac TestClsVar.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestClsVar.java > /tmp/test.asm
diff <(java TestClsVar | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
