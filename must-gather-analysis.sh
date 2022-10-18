#!/bin/bash
#
# NAME
#    must-gather analysis for cluster health
#
#
# Description
#    This script analyze the must-gather to verify cluster health, deployment type, etc.


BOLD=$(tput bold)
REGULAR=$(tput sgr0)
RED='\033[0;31m'
PURPLE='\033[0;35m'
MUSTGATHER=${1}
ARGS=${#}

function validate {
	if [ ${ARGS} -eq 0 ]
	then
		echo "No must-gather supplied!"
		echo "USAGE: $0 <must-gather-directory>"
		exit 1
	elif [ ${ARGS} -gt 1 ]
	then
		echo "Only must-gather should be provided!"
		echo "USAGE: $0 <must-gather-directory>"
		exit 1
	elif ! [ -x "$(command -v omg)" ]
	then
		echo 'Error: omg command not found!' >&2
		echo 'Visit "https://pypi.org/project/o-must-gather" for install instructions.'
		exit 1
	elif ! [ -x "$(command -v jq)" ]
	then
		echo 'Error: jq command not found!' >&2
		echo 'Visit "https://stedolan.github.io/jq/download" for install instructions.'
		exit 1
	else
		rm -f ~/.omgconfig && omg use ${MUSTGATHER}
		echo -e "\n"
	fi
}

### fetch cluster infrastructure details
function infrastructure {
	Infrastructures=$MUSTGATHER/*/cluster-scoped-resources/config.openshift.io/infrastructures.yaml
	if [ -f $Infrastructures ];
	then
		cat $Infrastructures | sed -n '/uid/,/kind/{ //!p }'
	else
		echo -e "\n***${BOLD}infrastructures.yaml not found***\n${REGULAR}"
	fi
}

### fetch ETCD endpoint health
function etcdEndpointHealth {
	ETCDEndpointHealth=$MUSTGATHER/*/etcd_info/endpoint_health.json
	if [ -f $ETCDEndpointHealth ];
	then
		cat $ETCDEndpointHealth | jq -r '(["ENDPOINT","HEALTH","TOOK"] | (.,map(length*"-"))), (.[] | [.endpoint, .health, .took]) | @tsv' | column -t
	else
		echo -e "\n***${BOLD}endpoint_health.json not found***\n${REGULAR}"
	fi
}

### fetch ETCD endpoint status
function etcdEndpointStatus {
	ETCDEndpointStatus=$MUSTGATHER/*/etcd_info/endpoint_status.json
	if [ -f $ETCDEndpointStatus ];
	then
		cat $ETCDEndpointStatus | jq -r '(["ENDPOINT","VERSION","DB-SIZE-IN-BYTES", "RAFT-TERM", "RAFT-INDEX", "RAFT-APPLIED-INDEX"] | (.,map(length*"-"))), (.[] | [.Endpoint, .Status.version, .Status.dbSize, .Status.header.raft_term, .Status.raftIndex, .Status.raftAppliedIndex]) | @tsv' | column -t
	else
		echo -e "\n***${BOLD}endpoint_status.json not found***\n${REGULAR}"
	fi
}

### fetch ETCD members list
function etcdMemberList {
	ETCDMemberList=$MUSTGATHER/*/etcd_info/member_list.json
	if [ -f $ETCDMemberList ];
	then
		cat $ETCDMemberList | jq -r '(["NAME","PEER-ADDRS","CLIENT-ADDRS"] | (.,map(length*"-"))), (.members[] | [.name, .peerURLs[], .clientURLs[]]) | @tsv' | column -t
	else
		echo -e "\n***${BOLD}member_list.json not found***\n${REGULAR}"
	fi
}

### fetch clusterversion details
function clusterversion {
	ClusterVersion=$MUSTGATHER/*/cluster-scoped-resources/config.openshift.io/clusterversions.yaml
	omg get clusterversion
	if [ -f $ClusterVersion ];
	then
		echo -e "\n\n${PURPLE}***ClusterVersion spec***\n${REGULAR}"
		cat $ClusterVersion | sed -n '/uid/,/version/{ /uid/!p }'

		echo -e "\n\n${PURPLE}***ClusterVersion conditions***\n${REGULAR}"
		cat $ClusterVersion | sed -n '/lastTransitionTime/,/desired/{ /desired/!p }'

		echo -e "\n\n${PURPLE}***ClusterVersion history***\n${REGULAR}"
		cat $ClusterVersion | sed -n '/completionTime/,/observedGeneration/{ /observedGeneration/!p }'
	else
		echo -e "\n***${BOLD}clusterversions.yaml not found***\n${REGULAR}"
	fi
}

### Fetch install-config.yaml
function InstallConfigYAML {
	InstallConfig=$MUSTGATHER/*/namespaces/kube-system/core/configmaps.yaml
	if [ -f $InstallConfig ];
	then
		cat $InstallConfig | sed -n '/install-config/{p; :loop n; p; /kind/q; b loop}' | grep -v kind
	else
		echo -e "\n***${BOLD}install-config.yaml not found***\n${REGULAR}"
	fi

# loop in GNU sed: sed -n '/trigger/{p; :loop n; p; /trigger/q; b loop}'
# Explanation:
# 1. When you see the first /trigger/, start a block of commands
# 2. p -- print the line
# 3. :loop -- set a label named loop
# 4. n -- get the next line
# 5. p -- print the line
# 6. /trigger/q -- if the line matches /trigger/ then exit sed
# 7. b -- jump to loop
}

### verify if cluster-wide proxy configured or not
function ClusterWideProxy {
	Proxy=$MUSTGATHER/*/cluster-scoped-resources/config.openshift.io/proxies/cluster.yaml
	if [ -f $Proxy ];
	then
		cat $Proxy | sed -n '/uid/,/kind/{ //!p }'
	else
		echo -e "\n***${BOLD}cluster-wide proxy details not found***\n${REGULAR}"
	fi
}

### cluster-operator status
function ClusterOperator {
	omg get co
}

### Nodes status
function nodes {
	omg get nodes -o wide
}

### MCP status
function mcp {
	omg get mcp
}

### machines status
function machine {
	omg get machine -n openshift-machine-api
}

### machineset status
function machine {
	omg get machineset -n openshift-machine-api
}


### pods status
function pods {
	omg get pod -o wide -A | grep -Ev 'Running|Succeeded'
}

### fetch kube-apiserver pod logs
function KubeApiserver {
	MasterNodes=$(cat $MUSTGATHER/*/cluster-scoped-resources/core/nodes/* | grep -i "node-role.kubernetes.io/master: """ -A200 | awk '/resourceVersion/{print a}{a=$0}' | awk '{ print "kube-apiserver-" $2 }' | tr '\n' ' ')
	for i in $(echo $MasterNodes); do
		if [ -f $MUSTGATHER/*/namespaces/openshift-kube-apiserver/pods/$i/kube-apiserver/kube-apiserver/logs/current.log ];
		then
			echo -e "\n${PURPLE}***$i***\n${REGULAR}"
			cat $MUSTGATHER/*/namespaces/openshift-kube-apiserver/pods/$i/kube-apiserver/kube-apiserver/logs/current.log | tail -n 10
		else
			echo -e "\n***${BOLD}$i pod logs not found***\n${REGULAR}"
		fi
	done
}

### fetch ETCD pod logs
function ETCDPodLogs {
	MasterNodes=$(cat $MUSTGATHER/*/cluster-scoped-resources/core/nodes/* | grep -i "node-role.kubernetes.io/master: """ -A200 | awk '/resourceVersion/{print a}{a=$0}' | awk '{ print "etcd-" $2 }' | tr '\n' ' ')
	for i in $(echo $MasterNodes); do
		if [ -f $MUSTGATHER/*/namespaces/openshift-etcd/pods/$i/etcd/etcd/logs/current.log ];
		then
			echo -e "\n${PURPLE}***$i***\n${REGULAR}"
			cat $MUSTGATHER/*/namespaces/openshift-etcd/pods/$i/etcd/etcd/logs/current.log | tail -n 10
		else
			echo -e "\n***${BOLD}$i pod logs not found***\n${REGULAR}"
		fi
	done
}

### fetch kube-controller-manager pod logs
function KubeControllerManager {
	MasterNodes=$(cat $MUSTGATHER/*/cluster-scoped-resources/core/nodes/* | grep -i "node-role.kubernetes.io/master: """ -A200 | awk '/resourceVersion/{print a}{a=$0}' | awk '{ print "kube-controller-manager-" $2 }' | tr '\n' ' ')
	for i in $(echo $MasterNodes); do
		if [ -f $MUSTGATHER/*/namespaces/openshift-kube-controller-manager/pods/$i/kube-controller-manager/kube-controller-manager/logs/current.log ];
		then
			echo -e "\n${PURPLE}***$i***\n${REGULAR}"
			cat $MUSTGATHER/*/namespaces/openshift-kube-controller-manager/pods/$i/kube-controller-manager/kube-controller-manager/logs/current.log | tail -n 10
		else
			echo -e "\n***${BOLD}$i pod logs not found***\n${REGULAR}"
		fi
	done
}

function title {
	echo -e "\n${BOLD}${RED}----------${1}----------\n${REGULAR}"
}

function main {

	validate

	title "Cluster Infrastructure Details"
	infrastructure

	title "ETCD Endpoint Health"
	etcdEndpointHealth

	title "ETCD Endpoint Status"
	etcdEndpointStatus

	title "ETCD Member List"
	etcdMemberList

	title "Clusterversion details"
	clusterversion

	title "Install-config file"
	InstallConfigYAML

	title "Cluster-wide-proxy details"
	ClusterWideProxy

	title "Cluster Operators"
	ClusterOperator

	title "Nodes Status"
	nodes

	title "MCP Status"
	mcp

	title "Machines Status"
	machine

	title "Machineset Status"
	machine

	title "Failing Pods"
	pods

	title "kube-apiserver pod logs"
	KubeApiserver

	title "ETCD pod logs"
	ETCDPodLogs

	title "kube-controller-manager pod logs"
	KubeControllerManager
}

main