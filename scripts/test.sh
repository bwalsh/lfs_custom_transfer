git lfs install
git config lfs.standalonetransferagent local
git config lfs.customtransfer.local.path "/Users/walsbr/Downloads/lfs_custom_transfer/transfer.py"
git config lfs.customtransfer.local.args ""
git config lfs.customtransfer.local.direction both
git config filter.local.smudge "/Users/walsbr/Downloads/lfs_custom_transfer/smudge.py  -- %f"

# see config
git config -l | grep lfs


#git lfs track "*.bin"
#git remote add origin https://github.com/bwalsh/ttt.git
#
#
#echo "Hello LFS" > myfile.bin
#git add .gitattributes myfile.bin
#git commit -m "Add binary"
#git push origin main --dry-run # Or whatever your flow is
#
#echo "Hello LFS 2" > myfile2.bin
#git add myfile2.bin
#git commit -m "Add binary2"
#git push origin main
