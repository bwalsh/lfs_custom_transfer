GIT_LFS_SKIP_SMUDGE=1 git clone --verbose  https://github.com/bwalsh/ttt
cd ttt
./test.sh
git lfs pull -I myfile.bin
