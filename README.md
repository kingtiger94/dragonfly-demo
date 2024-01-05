# dragonfly demo

dragonfly running in a local kubernetes cluster.

## Getting started

Prerequisites:

- [k3d](https://k3d.io/) (for creating a local kubernetes cluster)
- kubectl

Install redis cli, create k3d cluster and deploy dragonfly:

```
make install
```

## Usage

Endpoints:

- dragonfly: tcp://localhost:6379

Run

- `make ping`
- `make delete-master` delete the master to observe failover

## Failover

When the master dies, a replica will be promoted to master within ~1 sec.

Clients connect to the service which points at the master. During the 1 sec failover a request from the `redis-cli` will fail with:

```
Error: Server closed the connection
```

The python redis client uses a connection pool which can handle disconnects and won't error.

When a new pod starts in an existing cluster its a replica and does a full sync to reach the [stable sync state](https://github.com/dragonflydb/dragonfly/issues/1132).
A full sync takes ~10 sec for a db with 1 key, when the database is [not persisted to disk](https://www.dragonflydb.io/docs/managing-dragonfly/operator/snapshot-pvc).

## Resources

The [operator](https://github.com/dragonflydb/dragonfly-operator/blob/main/manifests/dragonfly-operator.yaml) creates:

- [CRD](https://github.com/dragonflydb/dragonfly-operator/blob/main/api/v1alpha1/dragonfly_types.go) `dragonflies.dragonflydb.io`
- ClusterRoles `dragonfly-operator-manager-role`, `dragonfly-operator-metrics-reader`, `dragonfly-operator-proxy-role`

and the following in the `dragonfly-operator-system` namespace:

- ServiceAccount `dragonfly-operator-controller-manager` bound to `dragonfly-operator-manager-role`, `dragonfly-operator-proxy-role`
- Role `dragonfly-operator-leader-election-role`
- Service `dragonfly-operator-controller-manager-metrics-service`
- Deployment `dragonfly-operator-controller-manager` with 1 replica

We create [dragonfly-sample](infra/dragonfly.yaml) which the operator watches and then creates:

- 2 pods, one master, one replica
- A service pointing at the master

## References

- [Install Dragonfly Kubernetes Operator](https://www.dragonflydb.io/docs/managing-dragonfly/operator/installation)
- [The operator upgrades replicas before the master](https://github.com/dragonflydb/dragonfly-operator/issues/61)
