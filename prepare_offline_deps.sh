#!/bin/bash

###############################################
# Check current user
###############################################

if [[ `whoami` = "root" ]];
then
	echo "Hello, user root."
else
	echo "Please enter the password of user root."
	su
fi

###############################################
# Download RPM package
###############################################
yum install -y wget
echo "Downloading RPM packages, this may take a while."
#  Download rpms
mkdir ./ecp-rpm
cd ./ecp-rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/attr-2.4.46-12.el7.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/glusterfs-3.8.4-18.4.el7.centos.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/glusterfs-client-xlators-3.8.4-18.4.el7.centos.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/glusterfs-fuse-3.8.4-18.4.el7.centos.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/glusterfs-libs-3.8.4-18.4.el7.centos.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/kubeadm-1.7.5-0.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/kubectl-1.7.5-0.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/kubelet-1.7.5-0.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/kubernetes-cni-0.3.0.1-0.07a8a2.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/kubernetes-cni-0.5.1-0.x86_64.rpm
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/socat-1.7.3.2-2.el7.x86_64.rpm	
wget https://raw.githubusercontent.com/rivernetio/rpm/master/1.7.5/yum-plugin-versionlock-1.1.31-42.el7.noarch.rpm	
cd ..
tar zcvf ./ecp-rpm.tar.gz ./ecp-rpm/*.rpm 

#  Download docker rpm
mkdir ./docker
cd ./docker
wget https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.12.6-1.el7.centos.src.rpm
wget https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.12.6-1.el7.centos.x86_64.rpm
wget https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-debuginfo-1.12.6-1.el7.centos.x86_64.rpm
wget https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.12.6-1.el7.centos.noarch.rpm
wget https://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.12.6-1.el7.centos.src.rpm
cd ..
tar zcvf ./docker.tar.gz ./docker/*.rpm
echo "RPM packages downloaded successfully."

#  Download ansible rpm
mkdir ./ansible
cd ./ansible
wget https://raw.githubusercontent.com/rivernetio/rpm/master/ansible/ansible-2.4.2.0-1.el7.noarch.rpm
cd ..
tar zcvf ./ansible.tar.gz ./ansible/*.rpm
echo "RPM packages downloaded successfully."

###############################################
# Download ECP Charts
###############################################
echo "Downloading ECP Charts, this may take a while."
mkdir ./ecp-charts
cd ./ecp-charts
wget https://github.com/rivernetio/charts/raw/master/repo/stable/index.yaml
wget https://github.com/rivernetio/charts/raw/master/repo/stable/jupyter-1.0.0.tgz
wget https://github.com/rivernetio/charts/raw/master/repo/stable/tensorflow-serving-1.0.0.tgz
wget https://github.com/rivernetio/charts/raw/master/repo/stable/tensorflow-1.0.0.tgz
wget https://github.com/rivernetio/charts/raw/master/repo/stable/mnist-demo-0.1.0.tgz
cd ..
tar zcvf ./ecp-charts.tar.gz ./ecp-charts/*
echo "ECP Charts downloaded successfully."


##############################################################
# Configure docker image accelerator provided by Alibaba Cloud
##############################################################
tee /etc/docker/daemon.json <<-'EOF'
{
	"registry-mirrors": ["https://1gbxn0j2.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
echo "Docker image accelerator configured successfully."


GOOGLE_IMAGES=(
	k8s-dns-sidecar-amd64:1.14.4
	k8s-dns-kube-dns-amd64:1.14.4
	k8s-dns-dnsmasq-nanny-amd64:1.14.4
	kube-apiserver-amd64:v1.7.5
	kube-controller-manager-amd64:v1.7.5
	kube-scheduler-amd64:v1.7.5
	kube-proxy-amd64:v1.7.5
	etcd-amd64:3.0.17
)

CLUSTER_IMAGES=(
	docker.io/rivernet/k8s-dns-sidecar-amd64:1.14.4
	docker.io/rivernet/k8s-dns-kube-dns-amd64:1.14.4
	docker.io/rivernet/k8s-dns-dnsmasq-nanny-amd64:1.14.4
	docker.io/rivernet/kube-apiserver-amd64:v1.7.5
	docker.io/rivernet/kube-controller-manager-amd64:v1.7.5
	docker.io/rivernet/kube-scheduler-amd64:v1.7.5
	docker.io/rivernet/kube-proxy-amd64:v1.7.5
	docker.io/rivernet/etcd-amd64:3.0.17
	docker.io/rivernet/pause-amd64:3.0
	docker.io/rivernet/kubernetes-dashboard-amd64:v1.6.3
	docker.io/rivernet/etcd:v3.1.10
	docker.io/rivernet/node:v2.4.1
	docker.io/rivernet/cni:v1.10.0
	docker.io/rivernet/kube-policy-controller:v0.7.0
	docker.io/rivernet/flannel:v0.7.1-amd64
	docker.io/rivernet/rudder:4.1
	docker.io/rivernet/tiller:v2.6.2
	docker.io/rivernet/helm:v2.2.3
	docker.io/rivernet/canes:4.1
	docker.io/rivernet/elasticsearch:1.5.2
	docker.io/rivernet/fluentd-elasticsearch:v2.0.2
	docker.io/rivernet/events:4.1
	docker.io/rivernet/license:4.1
	docker.io/rivernet/lyra:4.1
	docker.io/rivernet/mysql-sky:4.1
	docker.io/rivernet/grafana-sky:4.1
	docker.io/rivernet/kube-state-metrics:v0.5.0
	docker.io/rivernet/node-exporter:0.12.0
	docker.io/rivernet/kube-api-exporter:master-2fe5dfb
	docker.io/rivernet/prometheus:v1.5.2
	docker.io/rivernet/k8s-prometheus-adapter:v0.2.0-beta.0
	docker.io/rivernet/pyxis:4.1
	docker.io/rivernet/river:4.1
	docker.io/rivernet/keystone:20161108
	docker.io/rivernet/skyform-sas:4.1
	docker.io/rivernet/ara:4.1
	docker.io/rivernet/curl:latest
)

HARBOR_IMAGES=(
	docker.io/rivernet/harbor-ui:4.1
	docker.io/rivernet/harbor-proxy:4.1
	docker.io/rivernet/harbor-mysql:4.1
	docker.io/rivernet/harbor-registry:4.1
	docker.io/rivernet/docker:stable-dind
)

APP_IMAGES=(
	docker.io/rivernet/jupyter:4.1.1
	docker.io/rivernet/tensorflow-serving:4.1
	docker.io/rivernet/tensorflow:4.1
	docker.io/rivernet/web-vote-app:v0.1
	docker.io/rivernet/redis:3.0
	docker.io/rivernet/redis_exporter:v0.14
	docker.io/rivernet/curl:latest
	docker.io/rivernet/tomcat:8.0.47-r0
	docker.io/rivernet/mnist-demo:4.1
)

GLUSTER_IMAGES=(
	docker.io/rivernet/gluster-centos:latest
	docker.io/rivernet/heketi:dev
)

function is_google_image() {
	image=$1
	googleImage=""
	for imageName in ${GOOGLE_IMAGES[@]}; do
		if [[ $image == *$imageName ]]; then
			googleImage=$imageName
		fi
	done
}

###############################################
# x86_64 Package
###############################################
function create_x86_64_package() {

	mkdir cluster charts harbor gluster

	local imageNames=

	local images=
	for image in ${CLUSTER_IMAGES[@]}; do
		docker pull $image
		is_google_image $image
		if [ "$googleImage" ]; then
			echo "tag $image to gcr.io/google_containers/$googleImage"
			docker tag $image gcr.io/google_containers/$googleImage
			images="$images gcr.io/google_containers/$googleImage"
		else
			images="$images $image"
		fi
	done

	echo
	echo "Generating cluster images, this may take a while."
	echo
	docker save  $images > cluster/ecp-cluster.tar

	images=""
	for image in ${HARBOR_IMAGES[@]}; do
		docker pull $image
		images="$images $image"
	done

	echo
	echo "Generating harbor images, this may take a while."
	echo
	docker save  $images > harbor/ecp-harbor.tar

	images=""
	for image in ${APP_IMAGES[@]}; do
		docker pull $image
		images="$images $image"
	done

	echo
	echo "Generating app images, this may take a while."
	echo
	docker save  $images > charts/ecp-charts.tar

	images=""
	for image in ${GLUSTER_IMAGES[@]}; do
		docker pull $image
		images="$images $image"
	done

	echo
	echo "Generating gluster images, this may take a while."
	echo
	docker save  $images > gluster/ecp-glusters.tar
}

create_x86_64_package
echo "x86_64 offline package created successfully."


