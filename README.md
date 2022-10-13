# must-gater-analysis
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
- Pods not in "Running" state.

## Prerequisites
```
- Cluster must-gather
- *jq* package installed
```

## How to use the shell script?
```
# sh must-gather-analysis.sh <path-to-must-gather-dir>
```
