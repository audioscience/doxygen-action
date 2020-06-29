#!/bin/bash

if [ ! -d $2 ]; then
    echo "Path $2 (working-dir) could not be found!"
fi

if [ ! -d $1 ]; then
    echo "Path $1 (doxyfile-path) could not be found!"
fi

if [ ! -d $3 ]; then
    echo "Path $3 (output-dir) could not be found!"
fi

if [ ! -d $4 ]; then
    echo "Path $4 (hpi-dir) could not be found!"
fi

hpiversion=$(python $4/hpi_version.py {"dotted"})

sed "s!PROJECT_NUMBER.*!PROJECT_NUMBER         = Version_$hpiversion!g;s!OUTPUT_DIRECTORY.*!OUTPUT_DIRECTORY       = $3/dox!g" $1/doxyfile.dox > $3/d.dox
cd $2
doxygen $3/d.dox > $3/doxygen.log
cp stylesheet.css $3/dox/html
sed -i "s/Modules/Functions/g" $3/dox/html/*.html

hpi_version_minor=$(python $4/hpi_version.py {"minor"})
if (( ${hpi_version_minor} % 2 == 0 ))
then
   DOCSUBDIR=html
else
   DOCSUBDIR=beta_html
fi

LOCAL_DIR=$3/dox/html
REMOTE_DIR=internet/download/sdk/$5_usermanual_html/${DOCSUBDIR}
HOST=ftp.audioscience.com
ftp -n $HOST <<END_SCRIPT
quote USER $6
quote PASS $7
passive
cd $REMOTE_DIR
lcd $LOCAL_DIR
prompt
mput *.html
mput *.png
mput *.css
quit
END_SCRIPT

