离线安装步骤：

## 本地环境准备离线安装包 （需要有外网的机器，安装且启动了docker）

1. 下载辅助工具：

   ```
   https://github.com/rivernetio/tools
   ```

2. 创建离线安装包：  
   运行脚本:

   ```
   ./prepare_offline_package.sh
   ```

   在当前目录下产生 ```ansible-ecp.tar.gz```

## 部署环境安装离线安装包
1. 拷贝ansible-ecp到部署机，

   ```
   tar xvfz ansible-ecp.tar.gz
   cd ansible-ecp/
   ```

2. 配置机器间免秘钥登录（所有机器，可以参考ansible-ecp/scripts/pre-install.sh）

3. 安装ansible： 

   ```
   yum localinstall depends/rpm/ansible/*.rpm
   ```

4. 安装ecp：

   ```
   // inventory,添加机器信息
   ansible-playbook -v install.yml
   ```

5. 验证系统是否正确安装：

   ```
   浏览器访问：  IP:31081
   登录用户名：  admin
   登录密码：   password
   ```
   
