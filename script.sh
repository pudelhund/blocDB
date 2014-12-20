#!/bin/bash

for i in $( find . -name "*.rb" ) do
	$("/usr/bin/perl -pi -e 's/\r\n?/\n/g' $1")
done
