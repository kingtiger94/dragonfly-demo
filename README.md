# dragonfly demo

dragonfly running in a local kubernetes cluster.

## Getting started

Prerequisites:

- [k3d](https://k3d.io/) (for creating a local kubernetes cluster)
- kubectl
- helm

Install redis cli, create k3d cluster and deploy dragonfly:

```
make install
```

## Usage

Endpoints:

- dragonfly: tcp://localhost:6379

Run

- `make ping`

## References

