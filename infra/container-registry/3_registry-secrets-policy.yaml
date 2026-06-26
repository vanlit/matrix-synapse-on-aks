apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: bind-imagepullsecret
spec:
  rules:
  - name: add-secret
    match:
      resources:
        kinds:
        - Pod
    mutate:
      patchStrategicMerge:
        spec:
          imagePullSecrets:
            - name: registry-pullsecret