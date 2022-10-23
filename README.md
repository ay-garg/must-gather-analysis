# must-gather-analysis
OpenShift 4 must-gather analysis script to verify cluster health by fetching the important data.

## The `must-gather-analysis` shell script fetches following data from the must-gather.
- Infrastructure
- ETCD
- ClusterVersion
- install-config.yaml
- cluster-wide proxy
- Cluster Operators
- Nodes
- MCP
- Machines
- Machineset
- Pods not in "Running" state
- control plane pod logs

## Prerequisites
```
- Cluster must-gather
- "o-must-gather" python module installed for "omg" command.
- "jq" package installed.
- "util-linux" and "bsdmainutils" packages installed for Red Hat and Debian based Linux Distributions respectively.
```

## How to use the shell script?
```
// The below command download the shell script at path "/usr/local/bin/must-gather-analysis", sets the execute permission and reloads the current shell.
$ sudo curl -o /usr/local/bin/must-gather-analysis https://raw.githubusercontent.com/ayush-garg-github/must-gather-analysis/main/must-gather-analysis.sh && sudo chmod +x /usr/local/bin/must-gather-analysis && $SHELL && exit

// Shell script can be executed by running "must-gather-analysis" for the specified must-gather.
$ must-gather-analysis <path-to-must-gather-dir>
```
