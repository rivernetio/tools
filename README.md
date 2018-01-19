离线安装步骤：

## 本地环境准备离线安装包 （需要有外网的机器，安装且启动了docker）

```
yum install -y docker git
service docker start
```

1. 下载辅助工具：

   ```
   git clone https://github.com/rivernetio/tools.git
   ```

2. 创建离线安装包：  
   运行脚本:

   ```
   cd tools
   chmod +x prepare_offline_package.sh
   ./prepare_offline_package.sh
   ```

   在当前目录下产生 ```ansible-ecp.tar.gz```

## 部署环境安装离线安装包
1. 拷贝ansible-ecp到部署机，

   ```
   tar xvfz ansible-ecp.tar.gz
   cd ansible-ecp/
   ```

2. 配置机器间免秘钥登录（所有机器，可以参考https://linux.cn/article-5444-1.html ）

3. 安装ansible： 

   ```
   yum localinstall depends/rpm/ansible/*.rpm
   ```

4. 安装ecp：

   ```
   // 修改inventory文件,添加机器信息。重点修改[master]、[node]、[glusterfs]
   // 默认会安装glusterfs，至少需要三台机器，且每台机器两块盘，配置其中一块盘给glusterfs使用
   // 如果选择不安装glusterfs，添加--skip-tags="glusterfs"参数，如下：
   // ansible-playbook -v install.yml --skip-tags="glusterfs"
   ansible-playbook -v install.yml
   ```

5. 验证系统是否正确安装：

   ```
   浏览器访问：  IP:31081
   登录用户名：  admin
   登录密码：   password
   ```
   
