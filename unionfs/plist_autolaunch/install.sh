#!/bin/bash
cd $(dirname $0)

# 先运行↓ ↓ ↓
sudo chmod u+x ./boot.sh
sudo chmod u+x ./install.sh
sudo chmod u+x ./uninstall.sh

# 安装plist
# * mkdir 需要管理员权限
# 用户权限 => /Library/LaunchAgents/
# 管理员权限 => /Library/LaunchDaemons/ 且 「sudo launchctl」
# 当前用户 => ~/Library/LaunchAgents/
sudo cp ./boot.unionfs.plist /Library/LaunchAgents/

# 加入开机启动
launchctl load /Library/LaunchAgents/boot.unionfs.plist

