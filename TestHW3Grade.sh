#!/bin/bash
./compile.sh
javac HW3GraderTest.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW3GraderTest.java > /tmp/test.asm
diff <(java HW3GraderTest | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
