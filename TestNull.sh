#!/bin/bash
./compile.sh
javac TestNull.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestNull.java > /tmp/test.asm
diff <(java TestNull | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
