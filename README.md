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


## Step 2: Kubernetes
* Minikube was installed using the following two commands in the shell by running it as an administrator
    New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
    Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
    
    "$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
    if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
    [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
    }
    "
* The command "minikube start" was executed to start the kubernetes server
* The command "kubectl version" was executed to check the version of kubectl
* A new file was added in the project's root directory "postgres-deployment.yaml" along with "postgres-secret.yaml". The secrets file contains the database username, password and database server name. The deployment file contains the specifications of the pod and the postgres image that must be pulled in the container in the pod to run the database server. The service file was appended in the deployment file and the type was given as "Clustor IP"
* Another file was added in the project's root directory "next-deployment.yaml". The deployment file contains the specifications of the pod and the local image that must be pulled in the container in the pod to run the next js application. The name of the image built using the Docker file in this directory was specified in this deployment. The service file was appended in the deployment file and the type was given as "LoadBalancer" so that it can be exposed on the web and can be accessed using the external IP that gets assigned to this along with the port that was specified in the yaml file. In this case the image policy was set to "IfNotPresent" which means that it will first check for that image locally before looking for it in the remote registery 
* Another file was added in the project's root directory "third-deployment.yaml". The deployment file contains the specifications of the pod and the local image that must be pulled in the container in the pod to run the next js application. The name of the image built using the Docker file in this directory was specified in this deployment. The service file was appended in the deployment file and the type was given as "NodePort" so that it exposes that port mentioned in this file. The image policy in this case was also set to "IfNotPresent"
* After the creation of each file, the commnd "kubectl apply -f [file.yaml]" was executed. The file.yaml file contains the name of the three deployment files and the secret file and the commands "kubectl get deployments" and "kubectl get pods" was executed to check the status of each deployment and pod
* The command "minikube service next-service" was run to access the external IP that gets assigned to this deployment so that it can be viewed on the web using this IP address along with the port speicified in the yaml file for this deployment

*The difference between the three services i.e., The Cluster IP, NodePort and LoadBalancer is that the ClusterIP service creates a virtual IP inside the Kubernetes cluster that can route traffic to pods matching the service selector. It's meant for internal communication between services within the cluster. External traffic from outside the cluster can't directly reach pods exposed through ClusterIP whereas the NodePort service exposes a specific port on all nodes in the cluster. This port is then forwarded to the service, which further directs traffic to the pods. External clients can access the pods by using the NodeIP and the assigned port. The load balancer has two purposes, it is responsible for distributing traffic to the pods within the cluster and it enables external clients to access the pods by hitting the load balancer's IP.