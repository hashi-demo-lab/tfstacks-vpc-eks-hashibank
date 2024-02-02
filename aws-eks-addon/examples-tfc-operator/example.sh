#!usr/bin/zsh
doormat login -f && eval $(doormat aws export --account ${DOORMAT_AWS_USER})
VARSET=varset-UTad3ixYVAvo41W9
doormat aws tf-push variable-set --id $VARSET --role arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer

kubectl config use-context docker-desktop

#namespace
NAMESPACE="app-platform-k8s"
kubectl config set-context --current --namespace="$NAMESPACE"

kubectl apply -k .



kubectl get module --watch

kubectl get configmap --watch

#To force run
#kubectl patch module module-eks-addon --type=merge --patch '{"spec": {"restartedAt": "'`date -u -Iseconds`'"}}'


