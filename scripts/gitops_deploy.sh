#!/bin/bash
repo=git@github.com:jorgyp/test_api.git

#install flux
kubectl apply -f https://raw.githubusercontent.com/fluxcd/flux/helm-0.10.1/deploy-helm/flux-helm-release-crd.yaml
kubectl create ns flux
helm upgrade -i flux \
--set helmOperator.create=true \
--set helmOperator.createCRD=false \
--set git.url=$repo \
--namespace flux \
fluxcd/flux
sleep 60

#configure git
public_key=$(kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2)
echo "please copy this key into git’s repository: $public_key"
read -p "Press [Enter] once complete…"

#simulate CI pipeline and confirm GitOps works 
echo "Please open a new terminal window to run upcoming commands"
echo "Check if flux has deployed new app using: kubectl get pods -A"
echo "Check if flux logs: kubectl -n flux logs -f deployment/flux"
echo "Once deployed check api message: kubectl exec -it <pod_name> -n test-api -- /bin/sh -c \'curl 127.0.0.1:8080\'"
read -p "Press [Enter] once complete…"
echo "Simulate CI process of app change and deploy: Adjust test message in server.js and save change. Rebuild docker container, push new docker image to registry, and adjust workloads/test_api.yaml manifest to reflect new app version."
read -p "Press [Enter] once complete…"
echo "run: git add .; git commit -m 'test gitOps change'; git push"
echo "wait for flux to notice change on git run: kubectl -n flux logs deployment/flux"
echo "kubectl get pods -A and run: kubectl exec -it <pod_name> -n test-api -- /bin/sh -c \'curl 127.0.0.1:8080 to see new message\'"
