# Kubernetes through Jenkins - 15 Lab Sets

Folder per set. Each has a Jenkinsfile (and the Kubernetes YAML it uses).
Windows Jenkins (bat steps) + Docker Desktop Kubernetes. Tool paths and KUBECONFIG
are set inside every Jenkinsfile (same pattern as the working demo).

| Set | Folder | What the pipeline does |
|----|--------|-----------------------|
| 1 | set01-connection | kubectl version, cluster-info, nodes, API access |
| 2 | set02-deploy-sample-app | deploys your Java image pugazhmsp/rice-traders-app |
| 3 | set03-pod | creates a Pod from pod.yaml, waits for Ready |
| 4 | set04-deployment | Deployment (2 x nginx), checks rollout |
| 5 | set05-service | Deployment + NodePort Service 30081, curl test |
| 6 | set06-scale | scales 1 -> 3 replicas |
| 7 | set07-update-image | updates image nginx:1.24 -> 1.25 |
| 8 | set08-configmap | ConfigMap (env var + index.html), Service 30082 |
| 9 | set09-pvc | PVC + Pod mounting it, writes/reads a file |
| 10 | set10-readiness-probe | Deployment with readinessProbe |
| 11 | set11-github-auto-deploy | pollSCM trigger: push to GitHub = auto deploy (30083) |
| 12 | set12-docker-build-deploy | build image, push Docker Hub, deploy (30084) |
| 13 | set13-rolling-update | RollingUpdate, rollout status/history, auto rollback on failure |
| 14 | set14-troubleshoot | bad image: detects failure, prints diagnostics, rolls back (build = UNSTABLE) |
| 15 | set15-full-cicd | GitHub -> test -> Docker build -> smoke test -> push -> Kubernetes -> verify (30085) |

## Setup (once)
1. Put this folder in a GitHub repo and push:
       git init
       git add .
       git commit -m "K8s Jenkins lab"
       git branch -M main
       git remote add origin https://github.com/<you>/<lab-repo>.git
       git push -u origin main
   (if the push is rejected: git pull origin main --rebase, then push again)
2. Jenkins credential `dockerhub-creds` (already created) is used by Sets 12 and 15.
3. Docker Desktop must be running with Kubernetes enabled.

## Create a Jenkins job per set
New Item > name (e.g. Set03-Pod) > Pipeline > OK >
Pipeline script from SCM > Git > repo URL > Branch `*/main` >
Script Path = `set03-pod/Jenkinsfile` > Save > Build Now.
Tip: after the first job, use New Item > "Copy from" and only change the Script Path.

## Notes
- Set 11: run once manually, then edit the text in k8s.yaml (Version 1 -> Version 2), commit and push.
  Jenkins builds by itself within ~2 minutes. (A real GitHub webhook needs a public Jenkins URL.)
- Set 14 finishing UNSTABLE (yellow) is the expected result: failure detected + rolled back.
- Sets 12/15: the Docker Hub repos lab-web-app / lab-fullstack-app are created on first push. Keep them Public.
- HTTP checks run INSIDE the cluster (kubectl run + curl against the Service name) because Docker Desktop's
  Kubernetes does not publish NodePorts on localhost. To open a page in your browser use, for example:
      kubectl port-forward svc/web-svc 8081:80      then browse http://localhost:8081
- Clean up everything afterwards: run cleanup.bat
