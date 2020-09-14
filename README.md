# Drone EKS Helm

Deploy helm chart to EKS using local chart.

## Drone instructions:

In pipeline step, environment variables need to be set for EKS:
ex:

```yaml
deploy:
  image: neolife/drone-eks-helm:latest
  eks_cluster: myfirstcluster
  environment:
    AWS_ACCESS_KEY_ID:
      from_secret: aws_access_key_id
    AWS_SECRET_ACCESS_KEY:
      from_secret: aws_secret_access_key
  settings:
    namespace: default
    release_name: my-chart-release-name
    chart_path: ./chart-path
    tag: ${DRONE_COMMIT_SHA:0:8}
    additional_settings:
    - image.pullPolicy=Always
  when:
    branch: master
```