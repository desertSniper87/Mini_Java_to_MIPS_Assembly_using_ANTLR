#!/bin/bash
./compile.sh
javac TestConcatExpr.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestConcatExpr.java > /tmp/test.asm
diff <(java TestConcatExpr | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
