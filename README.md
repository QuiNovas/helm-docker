Docker image that supports running helm charts without the use of k8s-installed tiller, using the [helm-tiller](https://github.com/rimusz/helm-tiller) project.

To use this image in a CI pipeline, copy your kube config to `/root/.kube/config` and run `helm tiller run ...`.
