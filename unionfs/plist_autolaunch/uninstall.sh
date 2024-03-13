#!/bin/bash
# 卸载plist

set -e

# 用户权限 => /Library/LaunchAgents/
# 管理员权限 => /Library/LaunchDaemons/ 且 「sudo launchctl」
# ~/Library/... => 当前用户
launchctl unload /Library/LaunchAgents/boot.unionfs.plist