#!/bin/zsh
# 注意确保挂载路径存在，各个参数正确，否则会卡住死机，无法umount
cd $(dirname $0)

# ------------------- 配置 ---------------------
disks=(
  "/Volumes/disk0=RW"
  "/Volumes/disk1=RW"
  "/Volumes/disk2=RW"
  "/Volumes/disk3=RW"
  "/Volumes/disk4=RW"
)
mount_path="/Volumes/pool"
mount_options="cow,max_files=32768,allow_other"

# 挂载前
function beforeMount() {
  # orb stop # 停止OrbStack
}

# 成功挂载路径后
function onMounted() {
  /usr/local/bin/orb start # 启动OrbStack
}

# ------------------- 功能 ---------------------
# 启动任务
function onLaunch() {
  exec 1>>log/$(date "+%Y-%m-%d").txt 2>&1
  echo "----onLaunch: mount unionfs----"
  beforeMount

  # 检测是否已经挂载
  mounted=$(mount | grep $mount_path)
  if [ -n "$mounted" ]; then
    echo "Already mounted: $mounted"
    onMounted
    return
  fi

  IFS=':'
  disks_join="${disks[*]}"

  # 等待5秒，确保磁盘挂载完成，后每8秒尝试一次，共20次
  sleep 5
  for i in {1..20}; do
    echo "Mounting attempt $i"

    # 挂载命令
    ./unionfs -o $mount_options $disks_join $mount_path

    if [ $? -eq 0 ]; then
      echo "Mounting successful"
      onMounted
      return
    fi
    sleep 8
  done
}

# 关机任务
function onShutdown() {
  echo "----onShutdown: umount unionfs----"
  umount $mount_path
}

function startup() {
  onLaunch
  tail -f /dev/null &
  wait $!
}

function shutdown() {
  onShutdown
  exit 0
}

trap shutdown SIGTERM
trap shutdown SIGKILL
trap shutdown SIGINT

startup
