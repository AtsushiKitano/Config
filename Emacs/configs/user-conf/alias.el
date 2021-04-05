(setq eshell-command-aliases-list
      (append
       (list
        (list "-g L" "| less")
        (list "-g G" "| grep")
        (list "b" "brew")
        (list "gtree" "git log --graph --branches --pretty=\"format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset\"")
        (list "mkdir" "mkdir -p")
        (list "k" "kubectl")
        (list "kg" "kubectl get")
        (list "ke" "kubectl exec -it")
        (list "ka" "kubectl apply -f")
        (list "ka" "kubectl delete -f")
        (list "kpo" "kubectl get pod")
        (list "kde" "kubectl describe")
        (list "kbb" "kubectl run busybox --image=busybox --rm -it --restart=Never --command --")
        (list "h" "helm")
        (list "hs" "helm show")
        (list "hl" "helm list")
        (list "hr" "helm repo")
        (list "hi" "helm install")
        (list "hh" "helm history")
        (list "hug" "helm upgrade")
        (list "hrb" "helm rollback")
        (list "hui" "helm uninstall")
        (list "gs" "gsutil")
        (list "gc" "gcloud")
        (list "gcm" "gcloud compute")
        (list "gco" "gcloud container")
        (list "gcl" "gcloud container clusters")
        (list "gi" "gcloud compute instances")
        (list "gn" "gcloud compute networks")
        (list "gcs" "gcloud compute ssh")
        (list "gup" "sudo /usr/local/src/google-cloud-sdk/bin/gcloud components update")
        (list "gcmp" "sudo /usr/local/src/google-cloud-sdk/bin/gcloud components")
        (list "gcoi" "gcloud container images")
        (list "gcoc" "gcloud container clusters")
        (list "gcon" "gcloud container node-pools")
        (list "gcoo" "gcloud container operations")
        (list "gcos" "gcloud container subnets")
        (list "gcoh" "gcloud container hub")
        (list "gcob" "gcloud container binauthz")
        (list "t" "terraform")
        (list "tp" "terraform plan")
        (list "ta" "terraform apply")
        (list "td" "terraform destroy")
        (list "ti" "terraform init")
        (list "tw" "terraform workspace")
        (list "twl" "terraform workspace list")
        (list "tws" "terraform workspace select")
        (list "twn" "terraform workspace new")
        (list "tgu" "terraform get -update")
        (list "tf" "tfenv")
        (list "tfu" "tfenv use")
        (list "tfl" "tfenv list")
        (list "tfi" "tfenv install")
        (list "tflr" "tfenv list-remote")
        (list "rcp" "create-react-app")
        (list "p" "packer")
        (list "pb" "packer build")
        )
       ))