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

// All the sensitive data is masked in the below script output for security reasons.
$ must-gather-analysis must-gather/must-gather.local.6xxxxxxxxxxxx/
Using:  /home/test/must-gather/must-gather.local.6xxxxxxxxxxxx/quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-eb235cxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



----------Cluster Infrastructure Details----------

  spec:
    cloudConfig:
      name: ""
    platformSpec:
      type: oVirt
  status:
    apiServerInternalURI: https://api-int.cluster.ayush.com:6443
    apiServerURL: https://api.cluster.ayush.com:6443
    etcdDiscoveryDomain: cluster.ayush.com
    infrastructureName: ayush-ha77c
    platform: oVirt
    platformStatus:
      ovirt:
        apiServerInternalIP: 10.17x.x.x
        ingressIP: 10.17x.x.x
        nodeDNSIP: 10.17x.x.x
      type: oVirt

----------ETCD Endpoint Health----------

ENDPOINT                    HEALTH  TOOK
--------                    ------  ----
https://10.17x.x.x:2379     true    13.716977ms
https://10.17x.x.x:2379     true    14.175194ms
https://10.17x.x.x:2379     true    15.776627ms

----------ETCD Endpoint Status----------

ENDPOINT                    VERSION  DB-SIZE-IN-BYTES  RAFT-TERM  RAFT-INDEX  RAFT-APPLIED-INDEX
--------                    -------  ----------------  ---------  ----------  ------------------
https://10.17x.x.x:2379     3.4.9    667508736         100        1294176771  1294176771
https://10.17x.x.x:2379     3.4.9    667467776         100        1294176771  1294176771
https://10.17x.x.x:2379     3.4.9    667316224         100        1294176771  1294176771

----------ETCD Member List----------

NAME                       PEER-ADDRS                  CLIENT-ADDRS
----                       ----------                  ------------
ayush-ha77c-master-1       https://10.17x.x.x:2380     https://10.17x.x.x:2379
ayush-ha77c-master-0       https://10.17x.x.x:2380     https://10.17x.x.x:2379
ayush-ha77c-master-2       https://10.17x.x.x:2380     https://10.17x.x.x:2379

----------Clusterversion details----------

NAME     VERSION  AVAILABLE  PROGRESSING  SINCE  STATUS
version  4.6.32   True       False        37d    Cluster version is 4.6.32


***ClusterVersion spec***

  spec:
    channel: stable-4.6
    clusterID: 41dxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx
    desiredUpdate:
      force: false
      image: quay.io/openshift-release-dev/ocp-release@sha256:8670af6f4040f5aaf4613485b2e73425b748e91b987f6da044c8a9b3215263b3
      version: 4.6.32


***ClusterVersion conditions***

    - lastTransitionTime: "2020-09-24T12:29:38Z"
      message: Done applying 4.6.32
      status: "True"
      type: Available
    - lastTransitionTime: "2022-01-20T19:44:13Z"
      status: "False"
      type: Failing
    - lastTransitionTime: "2021-07-07T19:12:12Z"
      message: Cluster version is 4.6.32
      status: "False"
      type: Progressing
    - lastTransitionTime: "2022-01-10T08:48:49Z"
      status: "True"
      type: RetrievedUpdates


***ClusterVersion history***

    - completionTime: "2021-07-07T19:12:12Z"
      image: quay.io/openshift-release-dev/ocp-release@sha256:8670af6f4040f5aaf4613485b2e73425b748e91b987f6da044c8a9b3215263b3
      startedTime: "2021-07-07T17:05:27Z"
      state: Completed
      verified: false
      version: 4.6.32
    - completionTime: "2021-03-04T13:29:12Z"
      image: quay.io/openshift-release-dev/ocp-release@sha256:08ef16270e643a001454410b22864db6246d782298be267688a4433d83f404f4
      startedTime: "2021-03-04T11:12:11Z"
      state: Completed
      verified: false
      version: 4.6.18
    - completionTime: "2021-03-04T10:55:56Z"
      image: quay.io/openshift-release-dev/ocp-release@sha256:f3ce0aeebb116bbc7d8982cc347ffc68151c92598dfb0cc45aaf3ce03bb09d11
      startedTime: "2021-03-04T08:55:22Z"
      state: Completed
      verified: true
      version: 4.5.24
    - completionTime: "2020-10-15T13:33:22Z"
      image: quay.io/openshift-release-dev/ocp-release@sha256:8d104847fc2371a983f7cb01c7c0a3ab35b7381d6bf7ce355d9b32a08c0031f0
      startedTime: "2020-10-15T12:28:23Z"
      state: Completed
      verified: true
      version: 4.5.13
    - completionTime: "2020-09-24T12:29:38Z"
      image: quay.io/openshift-release-dev/ocp-release@sha256:4d048ae1274d11c49f9b7e70713a072315431598b2ddbb512aee4027c422fe3e
      startedTime: "2020-09-24T11:59:13Z"
      state: Completed
      verified: false
      version: 4.5.11

----------Install-config file----------

    install-config: |
      apiVersion: v1
      baseDomain: ayush.com
      compute:
      - architecture: amd64
        hyperthreading: Enabled
        name: worker
        platform:
          ovirt:
            cpu:
              cores: 8
              sockets: 2
            memoryMB: 65536
            osDisk:
              sizeGB: 150
            vmType: server
        replicas: 3
      controlPlane:
        architecture: amd64
        hyperthreading: Enabled
        name: master
        platform:
          ovirt:
            cpu:
              cores: 4
              sockets: 2
            memoryMB: 32768
            osDisk:
              sizeGB: 150
            vmType: server
        replicas: 3
      metadata:
        creationTimestamp: null
        name: cluster
      networking:
        clusterNetwork:
        - cidr: 10.2x.x.x/14
          hostPrefix: 23
        machineNetwork:
        - cidr: 10.17X.x.x/21
        networkType: OpenShiftSDN
        serviceNetwork:
        - 10.21x.x.x/16
      platform:
        ovirt:
          api_vip: 10.17x.x.x
          dns_vip: 10.17x.x.x
          ingress_vip: 10.17x.x.x
          ovirt_cluster_id: 13xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx
          ovirt_network_name: V3xxxxx
          ovirt_storage_domain_id: 14xxxxxx-xxxx-xxxx-xxxx-dxxxxxxxxxxxxxxx
          vnicProfileID: 8xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx
      proxy:
        httpProxy: http://test-proxy.com:80
        httpsProxy: http://test-proxy.com:80
        noProxy: .cluster.ayush.com,10.17x.x.x/21,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,localhost,127.0.0.1,oauth-openshift.apps.cluster.ayush.com,10.x.x.x/8,.apps.cluster.ayush.com
      publish: External
      pullSecret: ""
      sshKey: |
        ssh-rsa AAAABxxxxxxxxxxxxxxxxxx

----------Cluster-wide-proxy details----------

spec:
  httpProxy: http://test-proxy.com:80
  httpsProxy: http://test-proxy.com:80
  noProxy: .cluster.ayush.com,10.17x.x.x/21,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,localhost,127.0.0.1,oauth-openshift.apps.cluster.ayush.com,10.x.x.x/8,.apps.cluster.ayush.com
  trustedCA:
    name: custom-ca
status:
  httpProxy: http://test-proxy.com:80
  httpsProxy: http://test-proxy.com:80
  noProxy: .cluster.ayush.com,10.17x.x.x/21,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,10.17x.x.,localhost,127.0.0.1,oauth-openshift.apps.cluster.ayush.com,10.x.x.x/8,.apps.cluster.ayush.com

----------Cluster Operators----------

NAME                                      VERSION  AVAILABLE  PROGRESSING  DEGRADED  SINCE
authentication                            4.6.32   True       False        False     17h
cloud-credential                          4.6.32   True       False        False     231d
cluster-autoscaler                        4.6.32   True       False        False     231d
config-operator                           4.6.32   True       False        False     519d
console                                   4.6.32   True       False        False     71d
csi-snapshot-controller                   4.6.32   True       False        False     71d
dns                                       4.6.32   True       False        False     230d
etcd                                      4.6.32   True       False        False     71d
image-registry                            4.6.32   True       False        False     71d
ingress                                   4.6.32   True       False        False     71d
insights                                  4.6.32   True       False        False     519d
kube-apiserver                            4.6.32   True       False        False     9d
kube-controller-manager                   4.6.32   True       False        False     71d
kube-scheduler                            4.6.32   True       False        False     71d
kube-storage-version-migrator             4.6.32   True       False        False     5h24m
machine-api                               4.6.32   True       False        False     231d
machine-approver                          4.6.32   True       False        False     519d
machine-config                            4.6.32   True       False        False     71d
marketplace                               4.6.32   True       False        False     71d
monitoring                                4.6.32   True       False        False     71d
network                                   4.6.32   True       False        False     30d
node-tuning                               4.6.32   True       False        False     230d
openshift-apiserver                       4.6.32   True       False        False     71d
openshift-controller-manager              4.6.32   True       False        False     9d
openshift-samples                         4.6.32   True       False        False     231d
operator-lifecycle-manager                4.6.32   True       False        False     231d
operator-lifecycle-manager-catalog        4.6.32   True       False        False     231d
operator-lifecycle-manager-packageserver  4.6.32   True       False        False     71d
service-ca                                4.6.32   True       False        False     71d
storage                                   4.6.32   True       False        False     4d

----------Nodes Status----------

NAME                       STATUS  ROLES   AGE   VERSION          INTERNAL-IP  EXTERNAL-IP  OS-IMAGE                                                      KERNEL-VERSION                CONTAINER-RUNTIME
ayush-ha77c-infra-0-xxxxx  Ready   infra   230d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8
ayush-ha77c-master-0       Ready   master  519d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8
ayush-ha77c-master-1       Ready   master  519d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8
ayush-ha77c-master-2       Ready   master  519d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8
ayush-ha77c-prod-2-1xxxx   Ready   worker  274d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8
ayush-ha77c-prod-2-2xxxx   Ready   worker  314d  v1.19.0+d670f74  10.17x.x.x   <none>       Red Hat Enterprise Linux CoreOS 46.82.202105291300-0 (Ootpa)  4.18.0-193.51.1.el8_2.x86_64  cri-o://1.19.1-16.rhaos4.6.git130633b.el8

----------MCP Status----------

NAME    CONFIG                                            UPDATED  UPDATING  DEGRADED  MACHINECOUNT  READYMACHINECOUNT  UPDATEDMACHINECOUNT  DEGRADEDMACHINECOUNT  AGE
infra   rendered-infra-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   True     False     False     4             4                  4                    0                     507d
master  rendered-master-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  True     False     False     3             3                  3                    0                     519d
worker  rendered-worker-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  True     False     False     28            28                 28                   0                     519d

----------Machines Status----------

NAME                        PHASE    TYPE  REGION  ZONE  AGE
ayush-ha77c-infra-0-xxxxx   Running                      230d
ayush-ha77c-prod-2-1xxxx    Running                      274d
ayush-ha77c-prod-2-2xxxx    Running                      314d
ayush-ha77c-master-0        Running                      519d
ayush-ha77c-master-1        Running                      519d
ayush-ha77c-master-2        Running                      519d

----------Machineset Status----------

NAME                  DESIRED  CURRENT  READY  AVAILABLE  AGE
ayush-ha77c-infra-0   1        1        1      1          507d
ayush-ha77c-prod-2    2        2        2      2          314d

----------Failing Pods----------

NAMESPACE                                         NAME                                                     READY  STATUS     RESTARTS  AGE    IP             NODE
openshift-kube-storage-version-migrator           migrator-9b45646f-858vq                                  0/1    Failed     0         18d                   ayush-ha77c-infra-0-xxxxx
openshift-marketplace                             redhat-operators-f6ntt                                   0/1    Pending    0         1h53m  10.22x.x.x     ayush-ha77c-infra-0-xxxxx

----------Pod restart above 10----------

NAMESPACE                                         NAME                                        READY  STATUS     RESTARTS  AGE
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-4tz6v                 3/3    Running    53        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-5cwsm                 3/3    Running    53        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-5v9l8                 3/3    Running    54        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-6c4ds                 3/3    Running    52        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-74f2j                 3/3    Running    53        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-7k6x6                 3/3    Running    19        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-7pv2n                 3/3    Running    19        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-7wghb                 3/3    Running    50        231d
openshift-cluster-csi-drivers                     ovirt-csi-driver-node-8bb8g                 3/3    Running    52        231d


----------kube-apiserver pod logs----------


***kube-apiserver-ayush-ha77c-master-0***

2022-02-28T17:56:21.449874516Z I0228 17:56:21.449602      27 client.go:360] parsed scheme: "passthrough"
2022-02-28T17:56:21.449874516Z I0228 17:56:21.449676      27 passthrough.go:48] ccResolverWrapper: sending update to cc: {[{https://10.17x.x.x:2379  <nil> 0 <nil>}] <nil> <nil>}
2022-02-28T17:56:21.449874516Z I0228 17:56:21.449686      27 clientconn.go:948] ClientConn switching balancer to "pick_first"
2022-02-28T17:56:21.450083555Z I0228 17:56:21.449832      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0a18fb5e0, {CONNECTING <nil>}
2022-02-28T17:56:21.459024517Z I0228 17:56:21.458822      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0a18fb5e0, {READY <nil>}
2022-02-28T17:56:21.460215008Z I0228 17:56:21.460126      27 controlbuf.go:508] transport: loopyWriter.run returning. connection error: desc = "transport is closing"
2022-02-28T17:56:23.230281957Z I0228 17:56:23.230041      27 client.go:360] parsed scheme: "endpoint"
2022-02-28T17:56:23.230281957Z I0228 17:56:23.230095      27 endpoint.go:68] ccResolverWrapper: sending new addresses to cc: [{https://10.17x.x.x:2379  <nil> 0 <nil>} {https://10.17x.x.x:2379  <nil> 0 <nil>} {https://10.17x.x.x:2379  <nil> 0 <nil>} {https://localhost:2379  <nil> 0 <nil>}]
2022-02-28T17:56:23.240408538Z I0228 17:56:23.240223      27 store.go:1378] Monitoring kubeapiservers.operator.openshift.io count at <storage-prefix>//operator.openshift.io/kubeapiservers
2022-02-28T17:56:23.259151131Z I0228 17:56:23.258966      27 cacher.go:402] cacher (*unstructured.Unstructured): initialized

***kube-apiserver-ayush-ha77c-master-1***

2022-02-28T17:56:07.050838714Z I0228 17:56:07.050748      27 clientconn.go:948] ClientConn switching balancer to "pick_first"
2022-02-28T17:56:07.051026063Z I0228 17:56:07.050905      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0d7a312a0, {CONNECTING <nil>}
2022-02-28T17:56:07.065638296Z I0228 17:56:07.063157      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0d7a312a0, {READY <nil>}
2022-02-28T17:56:07.065638296Z I0228 17:56:07.065450      27 controlbuf.go:508] transport: loopyWriter.run returning. connection error: desc = "transport is closing"
2022-02-28T17:56:20.876834208Z I0228 17:56:20.876691      27 client.go:360] parsed scheme: "passthrough"
2022-02-28T17:56:20.876834208Z I0228 17:56:20.876751      27 passthrough.go:48] ccResolverWrapper: sending update to cc: {[{https://10.17x.x.x:2379  <nil> 0 <nil>}] <nil> <nil>}
2022-02-28T17:56:20.876915244Z I0228 17:56:20.876763      27 clientconn.go:948] ClientConn switching balancer to "pick_first"
2022-02-28T17:56:20.877252416Z I0228 17:56:20.877178      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0d616a490, {CONNECTING <nil>}
2022-02-28T17:56:20.884117176Z I0228 17:56:20.884006      27 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0d616a490, {READY <nil>}
2022-02-28T17:56:20.884938487Z I0228 17:56:20.884845      27 controlbuf.go:508] transport: loopyWriter.run returning. connection error: desc = "transport is closing"

***kube-apiserver-ayush-ha77c-master-2***

2022-02-28T17:56:38.300638400Z I0228 17:56:38.300595      28 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0f8cc5120, {CONNECTING <nil>}
2022-02-28T17:56:38.310389826Z I0228 17:56:38.310252      28 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc0f8cc5120, {READY <nil>}
2022-02-28T17:56:38.311346973Z I0228 17:56:38.311257      28 controlbuf.go:508] transport: loopyWriter.run returning. connection error: desc = "transport is closing"
2022-02-28T17:56:41.370807043Z E0228 17:56:41.370546      28 authentication.go:53] Unable to authenticate the request due to an error: [invalid bearer token, square/go-jose: error in cryptographic primitive, token lookup failed]
2022-02-28T17:56:42.138054632Z I0228 17:56:42.137901      28 client.go:360] parsed scheme: "passthrough"
2022-02-28T17:56:42.138119653Z I0228 17:56:42.137963      28 passthrough.go:48] ccResolverWrapper: sending update to cc: {[{https://10.17x.x.x:2379  <nil> 0 <nil>}] <nil> <nil>}
2022-02-28T17:56:42.138119653Z I0228 17:56:42.137976      28 clientconn.go:948] ClientConn switching balancer to "pick_first"
2022-02-28T17:56:42.140272547Z I0228 17:56:42.138119      28 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc1013a3ec0, {CONNECTING <nil>}
2022-02-28T17:56:42.145916416Z I0228 17:56:42.145752      28 balancer_conn_wrappers.go:78] pickfirstBalancer: HandleSubConnStateChange: 0xc1013a3ec0, {READY <nil>}
2022-02-28T17:56:42.146740663Z I0228 17:56:42.146659      28 controlbuf.go:508] transport: loopyWriter.run returning. connection error: desc = "transport is closing"

----------ETCD pod logs----------


***etcd-ayush-ha77c-master-0***

2022-02-28T18:02:55.617049793Z 2022-02-28 18:02:55.616922 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:02:58.909621541Z 2022-02-28 18:02:58.909524 I | embed: rejected connection from "10.17x.x.x:58676" (error "EOF", ServerName "")
2022-02-28T18:03:00.623705309Z 2022-02-28 18:03:00.623601 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:03.909707127Z 2022-02-28 18:03:03.909627 I | embed: rejected connection from "10.17x.x.x:58846" (error "EOF", ServerName "")
2022-02-28T18:03:05.605324231Z 2022-02-28 18:03:05.605197 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:08.908943384Z 2022-02-28 18:03:08.908616 I | embed: rejected connection from "10.17x.x.x:59026" (error "EOF", ServerName "")
2022-02-28T18:03:10.596783775Z 2022-02-28 18:03:10.596667 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:13.909240245Z 2022-02-28 18:03:13.908703 I | embed: rejected connection from "10.17x.x.x:59184" (error "EOF", ServerName "")
2022-02-28T18:03:15.602071984Z 2022-02-28 18:03:15.601966 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:18.909969406Z 2022-02-28 18:03:18.909878 I | embed: rejected connection from "10.17x.x.x:59328" (error "EOF", ServerName "")

***etcd-ayush-ha77c-master-1***

2022-02-28T18:03:01.785555802Z 2022-02-28 18:03:01.785490 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:02.240885025Z 2022-02-28 18:03:02.240810 I | embed: rejected connection from "10.17x.x.x:44978" (error "EOF", ServerName "")
2022-02-28T18:03:06.787914674Z 2022-02-28 18:03:06.787844 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:07.240769300Z 2022-02-28 18:03:07.240701 I | embed: rejected connection from "10.17x.x.x:45130" (error "EOF", ServerName "")
2022-02-28T18:03:11.763073872Z 2022-02-28 18:03:11.762972 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:12.241305923Z 2022-02-28 18:03:12.240959 I | embed: rejected connection from "10.17x.x.x:45282" (error "EOF", ServerName "")
2022-02-28T18:03:16.766040169Z 2022-02-28 18:03:16.765970 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:17.241006841Z 2022-02-28 18:03:17.240928 I | embed: rejected connection from "10.17x.x.x:45430" (error "EOF", ServerName "")
2022-02-28T18:03:21.801156447Z 2022-02-28 18:03:21.801077 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:22.241522228Z 2022-02-28 18:03:22.241443 I | embed: rejected connection from "10.17x.x.x:45608" (error "EOF", ServerName "")

***etcd-ayush-ha77c-master-2***

2022-02-28T18:03:01.797067295Z 2022-02-28 18:03:01.796981 I | embed: rejected connection from "10.17x.x.x:57330" (error "EOF", ServerName "")
2022-02-28T18:03:03.302173429Z 2022-02-28 18:03:03.302087 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:06.797336970Z 2022-02-28 18:03:06.797223 I | embed: rejected connection from "10.17x.x.x:57440" (error "EOF", ServerName "")
2022-02-28T18:03:08.310310888Z 2022-02-28 18:03:08.310245 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:11.797514542Z 2022-02-28 18:03:11.797176 I | embed: rejected connection from "10.17x.x.x:57584" (error "EOF", ServerName "")
2022-02-28T18:03:13.310316656Z 2022-02-28 18:03:13.310223 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:16.797424239Z 2022-02-28 18:03:16.797327 I | embed: rejected connection from "10.17x.x.x:57690" (error "EOF", ServerName "")
2022-02-28T18:03:18.293575713Z 2022-02-28 18:03:18.293489 I | etcdserver/api/etcdhttp: /health OK (status code 200)
2022-02-28T18:03:21.797574867Z 2022-02-28 18:03:21.797498 I | embed: rejected connection from "10.17x.x.x:57840" (error "EOF", ServerName "")
2022-02-28T18:03:23.300674878Z 2022-02-28 18:03:23.300593 I | etcdserver/api/etcdhttp: /health OK (status code 200)

----------kube-controller-manager pod logs----------


***kube-controller-manager-ayush-ha77c-master-0***

2022-02-28T17:56:51.555011262Z I0228 17:56:51.554891       1 horizontal.go:1124] Successfully updated status for test
2022-02-28T17:56:51.654819359Z I0228 17:56:51.654721       1 horizontal.go:1124] Successfully updated status for cluster
2022-02-28T17:56:51.791647300Z I0228 17:56:51.791538       1 horizontal.go:1124] Successfully updated status for app
2022-02-28T17:56:51.889959431Z I0228 17:56:51.889862       1 horizontal.go:1124] Successfully updated status for deployment
2022-02-28T17:56:51.995375851Z I0228 17:56:51.995294       1 horizontal.go:1124] Successfully updated status for application
2022-02-28T17:56:52.110215073Z I0228 17:56:52.110120       1 horizontal.go:1124] Successfully updated status for sample-app
2022-02-28T17:56:52.160498717Z I0228 17:56:52.160360       1 horizontal.go:1124] Successfully updated status for logging
2022-02-28T17:56:52.300894975Z I0228 17:56:52.300755       1 horizontal.go:1124] Successfully updated status for monitoring

***kube-controller-manager-ayush-ha77c-master-1***

2022-02-18T19:03:36.002452392Z I0218 19:03:36.002444       1 tlsconfig.go:178] loaded client CA [11/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_aggregator-client-signer@1645081644" [] issuer="<self>" (2022-02-17 07:07:23 +0000 UTC to 2022-03-19 07:07:24 +0000 UTC (now=2022-02-18 19:03:36.002434207 +0000 UTC))
2022-02-18T19:03:36.002483177Z I0218 19:03:36.002466       1 tlsconfig.go:178] loaded client CA [12/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_aggregator-client-signer@1643785631" [] issuer="<self>" (2022-02-02 07:07:10 +0000 UTC to 2022-03-04 07:07:11 +0000 UTC (now=2022-02-18 19:03:36.002457899 +0000 UTC))
2022-02-18T19:03:36.002998217Z I0218 19:03:36.002943       1 tlsconfig.go:200] loaded serving cert ["serving-cert::/etc/kubernetes/static-pod-resources/secrets/serving-cert/tls.crt::/etc/kubernetes/static-pod-resources/secrets/serving-cert/tls.key"]: "kube-controller-manager.openshift-kube-controller-manager.svc" [serving] validServingFor=[kube-controller-manager.openshift-kube-controller-manager.svc,kube-controller-manager.openshift-kube-controller-manager.svc.cluster.local] issuer="openshift-service-serving-signer@xxxxxxxxxxx" (2021-10-24 12:09:22 +0000 UTC to 2023-10-24 12:09:23 +0000 UTC (now=2022-02-18 19:03:36.002902553 +0000 UTC))
2022-02-18T19:03:36.003458060Z I0218 19:03:36.003321       1 named_certificates.go:53] loaded SNI cert [0/"self-signed loopback"]: "apiserver-loopback-client@xxxxxxxxxxx" [serving] validServingFor=[apiserver-loopback-client] issuer="apiserver-loopback-client-ca@xxxxxxxxxxx" (2021-12-19 06:07:35 +0000 UTC to 2022-12-19 06:07:35 +0000 UTC (now=2022-02-18 19:03:36.003297839 +0000 UTC))
2022-02-18T19:11:34.767342118Z E0218 19:11:34.767160       1 leaderelection.go:325] error retrieving resource lock kube-system/kube-controller-manager: Get "https://api-int.cluster.ayush.com:6443/api/v1/namespaces/kube-system/configmaps/kube-controller-manager?timeout=10s": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
2022-02-18T19:11:38.468656928Z E0218 19:11:38.468146       1 authentication.go:53] Unable to authenticate the request due to an error: [invalid bearer token, context canceled]
2022-02-18T19:11:38.469077393Z E0218 19:11:38.468999       1 webhook.go:111] Failed to make webhook authenticator request: Post "https://api-int.cluster.ayush.com:6443/apis/authentication.k8s.io/v1/tokenreviews?timeout=10s": net/http: request canceled (Client.Timeout exceeded while awaiting headers)
2022-02-18T19:11:49.553130707Z E0218 19:11:49.553029       1 authentication.go:53] Unable to authenticate the request due to an error: [invalid bearer token, context canceled]
2022-02-18T19:11:49.553184761Z E0218 19:11:49.553136       1 webhook.go:111] Failed to make webhook authenticator request: Post "https://api-int.cluster.ayush.com:6443/apis/authentication.k8s.io/v1/tokenreviews?timeout=10s": net/http: request canceled (Client.Timeout exceeded while awaiting headers)
2022-02-18T19:11:50.063906384Z E0218 19:11:50.063796       1 leaderelection.go:325] error retrieving resource lock kube-system/kube-controller-manager: Get "https://api-int.cluster.ayush.com:6443/api/v1/namespaces/kube-system/configmaps/kube-controller-manager?timeout=10s": net/http: request canceled (Client.Timeout exceeded while awaiting headers)

***kube-controller-manager-ayush-ha77c-master-2***

2022-02-18T19:03:26.959699180Z I0218 19:03:26.959652       1 tlsconfig.go:178] loaded client CA [7/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_kube-control-plane-signer@1642420233" [] issuer="<self>" (2022-01-17 11:50:32 +0000 UTC to 2022-03-18 11:50:33 +0000 UTC (now=2022-02-18 19:03:26.959645976 +0000 UTC))
2022-02-18T19:03:26.959699180Z I0218 19:03:26.959672       1 tlsconfig.go:178] loaded client CA [8/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "kubelet-bootstrap-kubeconfig-signer" [] issuer="<self>" (2020-09-24 11:49:50 +0000 UTC to 2030-09-22 11:49:50 +0000 UTC (now=2022-02-18 19:03:26.959662612 +0000 UTC))
2022-02-18T19:03:26.959736481Z I0218 19:03:26.959696       1 tlsconfig.go:178] loaded client CA [9/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_node-system-admin-signer@1640085446" [] issuer="<self>" (2021-12-21 11:17:25 +0000 UTC to 2022-12-21 11:17:26 +0000 UTC (now=2022-02-18 19:03:26.959687554 +0000 UTC))
2022-02-18T19:03:26.959736481Z I0218 19:03:26.959714       1 tlsconfig.go:178] loaded client CA [10/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_node-system-admin-signer@1614856637" [] issuer="<self>" (2021-03-04 11:17:17 +0000 UTC to 2022-03-04 11:17:18 +0000 UTC (now=2022-02-18 19:03:26.959705403 +0000 UTC))
2022-02-18T19:03:26.959745176Z I0218 19:03:26.959732       1 tlsconfig.go:178] loaded client CA [11/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_aggregator-client-signer@1645081644" [] issuer="<self>" (2022-02-17 07:07:23 +0000 UTC to 2022-03-19 07:07:24 +0000 UTC (now=2022-02-18 19:03:26.959723752 +0000 UTC))
2022-02-18T19:03:26.959768784Z I0218 19:03:26.959749       1 tlsconfig.go:178] loaded client CA [12/"client-ca-bundle::/etc/kubernetes/static-pod-certs/configmaps/client-ca/ca-bundle.crt,request-header::/etc/kubernetes/static-pod-certs/configmaps/aggregator-client-ca/ca-bundle.crt"]: "openshift-kube-apiserver-operator_aggregator-client-signer@1643785631" [] issuer="<self>" (2022-02-02 07:07:10 +0000 UTC to 2022-03-04 07:07:11 +0000 UTC (now=2022-02-18 19:03:26.959740492 +0000 UTC))
2022-02-18T19:03:26.960408330Z I0218 19:03:26.960357       1 tlsconfig.go:200] loaded serving cert ["serving-cert::/etc/kubernetes/static-pod-resources/secrets/serving-cert/tls.crt::/etc/kubernetes/static-pod-resources/secrets/serving-cert/tls.key"]: "kube-controller-manager.openshift-kube-controller-manager.svc" [serving] validServingFor=[kube-controller-manager.openshift-kube-controller-manager.svc,kube-controller-manager.openshift-kube-controller-manager.svc.cluster.local] issuer="openshift-service-serving-signer@xxxxxxxxxxx" (2021-10-24 12:09:22 +0000 UTC to 2023-10-24 12:09:23 +0000 UTC (now=2022-02-18 19:03:26.960334539 +0000 UTC))
2022-02-18T19:03:26.960617570Z I0218 19:03:26.960586       1 named_certificates.go:53] loaded SNI cert [0/"self-signed loopback"]: "apiserver-loopback-client@1640027066" [serving] validServingFor=[apiserver-loopback-client] issuer="apiserver-loopback-client-ca@1640027066" (2021-12-20 18:04:26 +0000 UTC to 2022-12-20 18:04:26 +0000 UTC (now=2022-02-18 19:03:26.960573868 +0000 UTC))
2022-02-18T19:04:28.699310672Z E0218 19:04:28.699165       1 leaderelection.go:325] error retrieving resource lock kube-system/kube-controller-manager: Get "https://api-int.cluster.ayush.com:6443/api/v1/namespaces/kube-system/configmaps/kube-controller-manager?timeout=10s": net/http: request canceled (Client.Timeout exceeded while awaiting headers)
2022-02-18T19:04:45.119083264Z E0218 19:04:45.118933       1 leaderelection.go:325] error retrieving resource lock kube-system/kube-controller-manager: Get "https://api-int.cluster.ayush.com:6443/api/v1/namespaces/kube-system/configmaps/kube-controller-manager?timeout=10s": net/http: request canceled (Client.Timeout exceeded while awaiting headers)
```
