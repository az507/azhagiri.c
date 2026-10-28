@echo off
REM Removes everything created by the 15 lab sets
set PATH=C:\Program Files\Docker\Docker\resources\bin;%PATH%
kubectl delete deployment,service,pod,configmap,pvc -l part-of=agile-lab --ignore-not-found
echo Done.
