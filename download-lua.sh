version=`cat version`
file=lua-${version}.tar.gz
test -f ${file} || wget https://www.lua.org/ftp/${file}
tar zxf ${file}
rm ${file}
