#!/bin/bash
./compile.sh
javac TestObjAssgn.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser TestObjAssgn.java > /tmp/test.asm
diff <(java TestObjAssgn | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
