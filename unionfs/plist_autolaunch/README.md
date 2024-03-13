# Plist 自启动方法

移动本目录下所有文件到上级目录

```bash
# 假设在本目录
cp ./* ../
cd ..
```

修改 `boot.unionfs.plist:L14` 路径参数为实际绝对路径

```xml
<string>/Users/purp1e/nas/unionfs/boot.sh</string>
```

## 启用自启

```bash
chmod u+x install.sh
./install.sh
```

## 关闭自启

```bash
./uninstall.sh
```


## 需要管理员权限的情况

`unionfs` 无需管理员权限即可运行，如您在编写**需要管理员权限的脚本**时想用本方法，则应修改文件：

- **install.sh**
- **uninstall.sh**

修改内容：

- `/Library/LaunchAgents/` -> `/Library/LaunchDaemons/`
- `launchctl` -> `sudo launchctl`