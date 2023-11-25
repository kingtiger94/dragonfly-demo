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

When a new pod starts in an existing cluster it be a replica and do a full sync. A full sync takes ~10 sec for a db with 1 key.

## Resources

The operator watches the `dragonfly-sample` CRD which manages:

- 2 pods, one master, one replica
- A service pointing at the master

## References

- [Install Dragonfly Kubernetes Operator](https://www.dragonflydb.io/docs/managing-dragonfly/operator/installation)
