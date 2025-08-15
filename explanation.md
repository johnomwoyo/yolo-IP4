# explanation.md

## 1. Choice of Kubernetes objects
- **MongoDB:** StatefulSet + volumeClaimTemplates (1Gi) to ensure stable storage and stable network identity for DB pods.
- **Backend & Frontend:** Deployments for rolling updates and ReplicaSets; 2 replicas to improve availability.
- **Services:** Backend uses ClusterIP (internal), Frontend uses LoadBalancer to receive traffic from outside.

## 2. How pods are exposed
- The frontend service is of type LoadBalancer (GKE assigns external IP).
- Backend remains internal to the cluster at http://backend-service:5000/api and is consumed by the frontend.

## 3. Persistent storage
- The StatefulSet creates PVCs for each pod using volumeClaimTemplates so volumes survive pod restarts and the data is preserved.

## 4. Git workflow
- Feature branch per work (`orchestration-setup`), descriptive commits at each step, then merge to master.
- At least 10 commits (this workflow) to show evolution.

## 5. Validation & debugging
- Steps included in README. Used `kubectl rollout status`, `kubectl logs` and `kubectl describe` when debugging.
