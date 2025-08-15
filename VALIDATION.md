# Validation & Troubleshooting Notes

1. Verify that Mongo PVCs are created:
   kubectl get pvc

2. If frontend shows wrong API endpoint:
   - Rebuild frontend with --build-arg REACT_APP_API_URL="http://backend-service:5000/api"
   - Push the new image and restart the frontend deployment:
     kubectl rollout restart deployment/frontend-deployment

3. If LoadBalancer IP is pending:
   - Check GCP quotas and billing
   - Use `kubectl describe svc frontend-service` for events

4. If Mongo CrashLoopBackOff:
   - kubectl describe pod mongodb-0
   - kubectl logs pod mongodb-0
