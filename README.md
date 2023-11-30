# DevOps - Assignment 4

## Step 1: Project Setup:
* Git hub repository was created
* Command "npx create-next-app assignment4" was used to create a next.js app
* Command "npm i" executed to install all the dependencies
* Execute the commands "npm i -D prisma",  "npm install @prisma/client", "npm i tsx" and "npx prisma init" to install prisma, prisma client and tsx which is used to run the seed file which contains the initial values that the database is populated with. Then prisma is initialized using the init command which creates a prisma folder containing the schema file
* A table was then added in the schema file and the seed file was created to populate the database table with some initial values
* The .env file was modified to add the database url containing the database username, password and name
* A docker file was then created for building the image of the web application, specifying the ports on which the application would be accessible and the commands that need to be executed to run the application
* "docker build -t assignment ." command was executed to create a docker image with the name "assignment" which would be used to deploy the application
### Logs:
        [+] Building 144.2s (12/12) FINISHED
        => [internal] load build definition from Dockerfile                                                               0.0s 
        => => transferring dockerfile: 176B                                                                               0.0s 
        => [internal] load .dockerignore                                                                                  0.0s 
        => => transferring context: 2B                                                                                    0.0s 
        => [internal] load metadata for docker.io/library/node:18-alpine                                                  3.8s 
        => [auth] library/node:pull token for registry-1.docker.io                                                        0.0s 
        => [1/6] FROM docker.io/library/node:18-alpine@sha256:3428c2de886bf4378657da6fe86e105573a609c94df1f7d6a70e57d2b5  0.0s 
        => [internal] load build context                                                                                 10.7s 
        => => transferring context: 1.40MB                                                                               10.3s 
        => CACHED [2/6] RUN mkdir -p /app                                                                                 0.0s 
        => CACHED [3/6] WORKDIR /app                                                                                      0.0s 
        => [4/6] COPY . .                                                                                                25.6s 
        => [5/6] RUN npm i                                                                                               38.7s 
        => [6/6] RUN npm run build                                                                                       57.9s 
        => exporting to image                                                                                             7.3s 
        => => exporting layers                                                                                            7.2s 
        => => writing image sha256:19977cb7448cedc719ae462ebc149d5ba08d181c77e4e6542126a6764309585e                       0.0s 
        => => naming to docker.io/library/assignment


## Step 2: Kubernetes
* Minikube was installed by executing the commands specified in the official documentation in the shell by running it as an administrator
* The command "minikube start" was executed to start the kubernetes server
### Logs:
        * minikube v1.32.0 on Microsoft Windows 10 Pro 10.0.19045.3693 Build 19045.3693
        * Using the docker driver based on existing profile
        * Starting control plane node minikube in cluster minikube
        * Pulling base image ...
        * Updating the running docker "minikube" container ...
        * Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
        * Configuring bridge CNI (Container Networking Interface) ...
        * Verifying Kubernetes components...
        ! Executing "docker container inspect minikube --format={{.State.Status}}" took an unusually long time: 3.5063768s
        * Restarting the docker service may improve performance.
        - Using image gcr.io/k8s-minikube/storage-provisioner:v5
        - Using image docker.io/kubernetesui/dashboard:v2.7.0
        - Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
        * Some dashboard features require the metrics-server addon. To enable all features please run:

                minikube addons enable metrics-server


        * Enabled addons: storage-provisioner, dashboard, default-storageclass
        Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

* The command "kubectl version" was executed to check the version of kubectl

* A new file was added in the project's root directory "postgres-deployment.yaml" along with "postgres-secret.yaml". The secrets file contains the database username, password and database server name. The deployment file contains the specifications of the pod and the postgres image that must be pulled in the container in the pod to run the database server. The service file was appended in the deployment file and the type was given as "Clustor IP"
* Another file was added in the project's root directory "next-deployment.yaml". The deployment file contains the specifications of the pod and the local image that must be pulled in the container in the pod to run the next js application. The name of the image built using the Docker file in this directory was specified in this deployment. The service file was appended in the deployment file and the type was given as "LoadBalancer" so that it can be exposed on the web and can be accessed using the external IP that gets assigned to this along with the port that was specified in the yaml file. In this case the image policy was set to "IfNotPresent" which means that it will first check for that image locally before looking for it in the remote registery 
* Another file was added in the project's root directory "third-deployment.yaml". The deployment file contains the specifications of the pod and the local image that must be pulled in the container in the pod to run the next js application. The name of the image built using the Docker file in this directory was specified in this deployment. The service file was appended in the deployment file and the type was given as "NodePort" so that it exposes that port mentioned in this file. The image policy in this case was also set to "IfNotPresent"
* The local docker daemon was connected to the minikube's docker daemon using the command "minikube docker-env" so all the images built using the build command would be stored inside the minikube's local repository
* The image "assigment" was build again using "docker build -t assignment ."
* After the creation of each file, the command "kubectl apply -f [file.yaml]" was executed. The file.yaml file contains the name of the three deployment files and the secret file and the commands "kubectl get deployments" and "kubectl get pods" was executed to check the status of each deployment and pod
* The command "minikube service next-service" was run to access the external IP that gets assigned to this deployment so that it can be viewed on the web using this IP address along with the port speicified in the yaml file for this deployment
* The command "kubectl apply -f next-deployment.yaml" was executed again after deleting the previous version to apply the new external IP to the service
* The external IP was accessed using the command "kubectl get svc next-service"

* Deployments: 
![Image Alt text](/public/images/k8s.JPG "Deployments")

* Services:
![Image Alt text](/public/images/services.JPG "Services")

* The difference between the three services i.e., The Cluster IP, NodePort and LoadBalancer is that the ClusterIP service creates a virtual IP inside the Kubernetes cluster that can route traffic to pods matching the service selector. It's meant for internal communication between services within the cluster. External traffic from outside the cluster can't directly reach pods exposed through ClusterIP whereas the NodePort service exposes a specific port on all nodes in the cluster. This port is then forwarded to the service, which further directs traffic to the pods. External clients can access the pods by using the NodeIP and the assigned port. The load balancer has two purposes, it is responsible for distributing traffic to the pods within the cluster and it enables external clients to access the pods by hitting the load balancer's IP.