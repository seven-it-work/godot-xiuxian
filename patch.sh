git apply -force $(find *.patch)
rm -f $(find *.patch)
sh push.sh