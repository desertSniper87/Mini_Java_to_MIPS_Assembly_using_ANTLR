#!/bin/bash
./compile.sh
javac TestIntArithmatic.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestIntArithmatic.java > /tmp/test.asm
diff <(java TestIntArithmatic  | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
