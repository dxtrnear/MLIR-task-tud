1) no enough space on the mac, so external ssd: mine is formatted exFAT so doesn't support symbolic links (which llvm build and install rely on), so I create an APFS disk image on the SSD. (single growing file on the exFAT drive) 
bash:
hdiutil create -size 40g -type SPARSEBUNDLE -fs APFS -volname mlirwork /Volumes/Transcend/mlir_task/mlirwork.sparsebundle
hdiutil attach /Volumes/Transcend/mlir_task/mlirwork.sparsebundle
sudo mdutil -i off /Volumes/mlirwork

2) to ensure reproductibility evtng will stay as dybamic variables on scripts (set jobs hardly to 6 but could be modified voa script)

