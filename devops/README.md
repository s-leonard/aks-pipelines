## Kubernetes YAML Files

The ```devops``` folder will be packaged up as part of the release. 

```
kubectl get nodes --kubeconfig ../env/.kubeconfig
```
kubectl apply -f ./website/deployment-website.yaml -n dev --kubeconfig ../env/.kubeconfig