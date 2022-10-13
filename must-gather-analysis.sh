#!/bin/bash
#
# NAME
#    must-gather analysis for cluster health
#
#
# Description
#    This script analyze the must-gather to verify cluster health, deployment type, etc.


bold=$(tput bold)
normal=$(tput sgr0)
RED='\033[0;31m'
PURPLE='\033[0;35m'

echo "must-gather: $1"
MustGather=$1
omg use $1
echo -e "\n"

### fetch cluster infrastructure details
function infrastructure {
    Infrastructures=$MustGather/*/cluster-scoped-resources/config.openshift.io/infrastructures.yaml
    if [ -f $Infrastructures ];
    then
        cat $Infrastructures | sed -n '/uid/,/kind/{ //!p }'
    else
        echo -e "***${bold}infrastructures.yaml not found***\n${normal}"
    fi
}

echo -e "${bold}${RED}-------Cluster Infrastructure Details-------\n${normal}"
infrastructure



### fetch ETCD endpoint health
function etcdEndpointHealth {
    ETCDEndpointHealth=$MustGather/*/etcd_info/endpoint_health.json
    if [ -f $ETCDEndpointHealth ];
    then
        cat $ETCDEndpointHealth | jq -r '(["ENDPOINT","HEALTH","TOOK"] | (.,map(length*"-"))), (.[] | [.endpoint, .health, .took]) | @tsv' | column -t
    else
        echo -e "***${bold}endpoint_health.json not found***\n${normal}"
    fi
}

echo -e "\n${bold}${RED}-------ETCD Endpoint Health-------\n${normal}"
etcdEndpointHealth


### fetch ETCD endpoint status
function etcdEndpointStatus {
    ETCDEndpointStatus=$MustGather/*/etcd_info/endpoint_status.json
    if [ -f $ETCDEndpointStatus ];
    then
        cat $ETCDEndpointStatus | jq -r '(["ENDPOINT","VERSION","DB-SIZE-IN-BYTES", "RAFT-TERM", "RAFT-INDEX", "RAFT-APPLIED-INDEX"] | (.,map(length*"-"))), (.[] | [.Endpoint, .Status.version, .Status.dbSize, .Status.header.raft_term, .Status.raftIndex, .Status.raftAppliedIndex]) | @tsv' | column -t
    else
        echo -e "***${bold}endpoint_status.json not found***\n${normal}"
    fi
}

echo -e "\n${bold}${RED}-------ETCD Endpoint Status-------\n${normal}"
etcdEndpointStatus



### fetch ETCD members list
function etcdMemberList {
    ETCDMemberList=$MustGather/*/etcd_info/member_list.json
    if [ -f $ETCDMemberList ];
    then
        cat $ETCDMemberList | jq -r '(["NAME","PEER-ADDRS","CLIENT-ADDRS"] | (.,map(length*"-"))), (.members[] | [.name, .peerURLs[], .clientURLs[]]) | @tsv' | column -t
    else
        echo -e "***${bold}member_list.json not found***\n${normal}"
    fi
}

echo -e "\n${bold}${RED}-------ETCD Member List-------\n${normal}"
etcdMemberList



### fetch clusterversion details
function clusterversion {
    ClusterVersion=$MustGather/*/cluster-scoped-resources/config.openshift.io/clusterversions.yaml
    omg get clusterversion
    if [ -f $ClusterVersion ];
    then
        echo -e "\n\n${PURPLE}***ClusterVersion spec***\n${normal}"
        cat $ClusterVersion | sed -n '/uid/,/version/{ /uid/!p }'

        echo -e "\n\n${PURPLE}***ClusterVersion conditions***\n${normal}"
        cat $ClusterVersion | sed -n '/lastTransitionTime/,/desired/{ /desired/!p }'

        echo -e "\n\n${PURPLE}***ClusterVersion history***\n${normal}"
        cat $ClusterVersion | sed -n '/completionTime/,/observedGeneration/{ /observedGeneration/!p }'
    else
        echo -e "***${bold}clusterversions.yaml not found***\n${normal}"
    fi
}

echo -e "\n${bold}${RED}-------clusterversion details-------\n${normal}"
clusterversion



### Fetch install-config.yaml
function InstallConfigYAML {
    InstallConfig=$MustGather/*/namespaces/kube-system/core/configmaps.yaml
    if [ -f $InstallConfig ];
    then
        cat $InstallConfig | sed -n '/install-config/{p; :loop n; p; /kind/q; b loop}' | grep -v kind
    else
        echo -e "***${bold}install-config.yaml not found***\n${normal}"
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

echo -e "\n${bold}${RED}-------install-config.yaml-------\n${normal}"
InstallConfigYAML



### verify if cluster-wide proxy configured or not
function ClusterWideProxy {
    Proxy=$MustGather/*/cluster-scoped-resources/config.openshift.io/proxies/cluster.yaml
    if [ -f $Proxy ];
    then
        cat $Proxy | sed -n '/uid/,/kind/{ //!p }'
    else
        echo -e "$***{bold}cluster-wide proxy details not found***\n${normal}"
    fi
}

echo -e "\n${bold}${RED}-------cluster-wide-proxy details-------\n${normal}"
ClusterWideProxy



### cluster-operator status
function ClusterOperator {
    omg get co
}

echo -e "\n${bold}${RED}-------Cluster Operators-------\n${normal}"
ClusterOperator




### Nodes status
function nodes {
    omg get nodes -o wide
}

echo -e "\n${bold}${RED}-------Nodes Status-------\n${normal}"
nodes


### MCP status
function mcp {
    omg get mcp
}

echo -e "\n${bold}${RED}-------MCP Status-------\n${normal}"
mcp



### machines status
function machine {
        omg get machine -n openshift-machine-api
}

echo -e "\n${bold}${RED}-------Machines Status-------\n${normal}"
machine


### machineset status
function machine {
        omg get machineset -n openshift-machine-api
}

echo -e "\n${bold}${RED}-------Machineset Status-------\n${normal}"
machine


### pods status
function pods {
        omg get pod -o wide -A | grep -Ev 'Running|Succeeded'
}

echo -e "\n${bold}${RED}-------Pods Status-------\n${normal}"
pods