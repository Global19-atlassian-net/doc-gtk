#!/bin/sh
#just for testing!

cd "`dirname "$0"`"

if [ $# -lt 2 ]; then
    echo "Usage: ./gen_manual.sh <language> <type>"
    echo "type: html phpweb test demo"
    exit 1
fi

language=$1
type=$2
realtype=$type

stylesheetdir=stylesheets
php=php
manualfile=manual.xml
test=0

if [ ! -d manual/$language ]; then
    echo "There is no manual for language $language"
    exit 2
fi

if [ ! -d build ]; then
    mkdir build
fi

if [ ! -d build/$language ]; then
    mkdir build/$language
fi

if [ $type == "test" ]; then
	if [ $# -lt 3 ]; then
		echo "Please pass the id as third parameter"
		exit 4
	fi
	test=1
	manualfile=test_manual.xml
	type=html
	
	#generate the file
	$php -q liveGen.php $3
fi

build_dir=build/$language/$type
manualpath=manual/$language/$manualfile

if [ $type == "html" ]; then
    xslfile=$stylesheetdir/html/chunk.xsl
elif [ $type == "phpweb" ]; then
    xslfile=$stylesheetdir/html/phpweb.xsl
elif [ $type == "demo" ]; then
    xslfile=$stylesheetdir/html/chunk.xsl
    manualpath=manual/demo_manual.xml
else 
    echo "There is no type $type."
    exit 3
fi

if [ $test == "1" ]; then
	build_dir=build/$language/test
fi


#
# we've got all necessary data; generate the manual
#
if [ ! -d $build_dir ]; then
    mkdir $build_dir
else 
    #empty the dir
    rm -R $build_dir/*
fi

xsltproc --param base.dir "'./$build_dir/'" --xinclude $xslfile $manualpath

#copy images
# I want to copy the linked images only. But how do I accomplish this
# without losing directory structure?
#cp --target-directory=build/en/test/images/ `grep -oh 'src="[^"]*"' build/en/test/* | sed s/src=\"//g | sed s/\"//g`
# this one doesn't keep the directories
cp -R images build/en/$realtype/

#highlight php sources
#we need to escape the wildcard, because php doesn't allow enough
# parameters - and could someone please tell me how to prevent
# wildcard escaping? That "\\*" is a hack which is only understood
# by highlight.php
$php scripts/highlight.php php "build/$language/$realtype/\\*.html"

#distribute over several files
if [ $type == "html" ] && [ $test == "0" ] && [ ! $type == "demo" ]; then
    $php -q distribute_html.php $language
fi
