# Mac Nas

> 施工中

配置 MacOS 为 NAS 或 HomeServer 的方法汇总

已经折腾完的配置包括：
- 硬盘校验/冗余 -> Snapraid
- 多盘合并 -> UnionFS-Fuse
- Docker应用 -> OrbStack


## 安装

下载本仓库所有文件，放置于 `~/nas` 文件夹

> 可以修改位置，注意修改配置中相关路径

### 确认硬盘

安装好所有硬盘，并确认对应分区名字（挂载到 `/Volumes` 的名字），可在磁盘工具app中修改，或手动修改，可参考这里的配置，修改为 `disk0` ~ `disk4` ...

查看硬盘挂载情况的方法，打开终端输入：

```zsh
mount
```

打开挂载文件夹的方法，打开终端输入：

```zsh
open /Volumes
```

### SnapRaid 配置

编辑 `snapraid/snapraid.conf`，修改校验盘、内容列表存放位置、数据盘

执行第一次 sync，全盘同步

```zsh
chmod u+x ./snapraid/snapraid-sync.sh
./snapraid/snapraid-sync.sh
```

编辑 `snapraid/boot.sh`，修改相关定时任务

> 施工中，尚未完成

### UnionFS-Fuse 配置

编辑 `unionfs/boot.sh`，修改如下配置信息：
- `disks` 根据磁盘情况修改
- `mount_path`根据要挂载的路径修改
- `beforeMount` 和 `onMounted` 内可添加挂载前、挂载成功后的操作，默认挂载后启动OrbStack
- 脚本中执行程序或shell要用完整路径，可使用 `which 程序名` 查看

> 关于 Unionfs 和 OrbStack 容器服务的启动顺序有待验证，如无法保证，则可在 `系统设置>通用>登录项` 中关闭 `OrbStack` 的自启动，确保使用 Unionfs 下路径的容器正常运行

```sh
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
```

### 软链接 pool

生成软链接，然后把 `用户目录/nas/pool` 的软连接文件拖到Finder侧边栏中，方便查看，避免重新挂载/重启系统后侧边栏进入 pool 失败

```bash
ln -s /Volumes/pool ~/nas/pool
```

### 开启自启服务

打开 `系统设置>通用>登录项` 添加 `boot.app` 到登录项中并启用

如需编辑，打开 `自动操作.app` | `Automator.app`，用app编辑 `boot.app`，或直接编辑 `boot.app/Contents/document.wflow` L62 开始的脚本内容

脚本中建议编辑的内容如下，启动脚本列表会非阻塞执行，即前一个脚本阻塞时不会影响后面的脚本执行

```
# 启动时运行脚本
scripts=(
  ~/nas/unionfs/boot.sh
  ~/nas/snapraid/boot.sh
)
```


### OrbStack

> 官网：https://orbstack.dev/

安装方法

```
brew install orbstack
```

> 施工中，其他未完待续
