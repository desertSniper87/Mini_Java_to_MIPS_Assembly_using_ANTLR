#!/bin/bash
./compile.sh
javac HW4FieldInheritance.java
java -cp ../antlr-4.1-complete.jar:. MiniJavaV3Parser HW4FieldInheritance.java > /tmp/test.asm
diff <(java HW4FieldInheritance | sed '$a\') <(java -jar ../Mars4_4.jar /tmp/test.asm | tail -n +3)
