include *.mk

cluster?=dragonfly
export KUBECONFIG=$(HOME)/.k3d/kubeconfig-$(cluster).yaml

## install redis cli, create cluster, and deploy dragonfly
install: redis-cli cluster dragonfly

## install redis cli
redis-cli:
	hash redis-cli || brew install redis

## create k3s cluster
cluster:
	k3d cluster create $(cluster) -p 6379:6379@loadbalancer --wait
	@k3d kubeconfig write $(cluster) > /dev/null
	@echo "Probing until cluster is ready (~60 secs)..."
	@while ! kubectl get crd ingressroutes.traefik.containo.us 2> /dev/null ; do sleep 10 && echo $$((i=i+10)); done
	@echo -e "\nTo use your cluster set:\n"
	@echo "export KUBECONFIG=$(KUBECONFIG)"

## deploy dragonfly to kubes
dragonfly:
	kubectl apply -f https://raw.githubusercontent.com/dragonflydb/dragonfly-operator/main/manifests/dragonfly-operator.yaml
# create cluster with two replicas
	kubectl apply -f https://raw.githubusercontent.com/dragonflydb/dragonfly-operator/main/config/samples/v1alpha1_dragonfly.yaml
	kubectl apply -f infra/ingress.yaml

## ping
ping:
	redis-cli ping

## show kube logs
logs:
	kubectl logs -l "app.kubernetes.io/name=dragonfly" -f --tail=-1
