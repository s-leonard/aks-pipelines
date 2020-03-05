echo "$(terraform output kube_config)\"" >> .kubeconfig

# ./terraform output kube_config > .kubeconfig

kubectl apply -f ../apps/allowed.yaml --namespace dev --kubeconfig .kubeconfig

kubectl create namespace dev --kubeconfig .kubeconfig