# 1) Create the folder
sudo mkdir -p /home/administrator/newfolder

# 2) Make 'administrator' the owner (recursively)
sudo chown -R administrator:administrator /home/administrator/newfolder

# 3) Set permissions:
#    755 = rwx for owner, rx for group & others (common for shared read)
sudo chmod -R 755 /home/administrator/newfolder

# (Optional) For private folder, use 700 (owner only)
# sudo chmod -R 700 /home/administrator/newfolder

# 4) Verify
ls -ld /home/administrator/newfolder
