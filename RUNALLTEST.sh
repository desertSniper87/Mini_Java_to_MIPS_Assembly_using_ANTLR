#!/bin/bash
for test in $(ls -a Test*.sh)
do
	echo "running "$test
	./$test
done
