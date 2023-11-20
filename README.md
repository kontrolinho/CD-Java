# CICD of Java Web Application using Docker, Jenkins, Nexus, SonarQube and Terraform

## Prerequisites

**You need to FORK this Repo**

Install **Terraform** and **AWS CLI**.

Check this [guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for **Terraform**.

Check this [guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for **AWS CLI**.

For **AWS Access Key** and **Secret Access Key** for configuring **AWS CLI**, visit this [blog post](https://aws.amazon.com/pt/blogs/security/wheres-my-secret-access-key/). 


## Installing and using Key Pairs

Check this [guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to install and manage key pairs at AWS.

Change ``` key_name ``` at ``` jenkins_instance.tf ```, ``` nexus_instance.tf ```, ``` sonar_instance.tf ```.

## Terraform

Use ```Terraform init``` to initialize Terraform Backend Services, and after this ```Terraform apply```.

This will create:

3 EC2s: Jenkins Instance, Nexus Instance and Sonar Instance.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ec2.png)


And 3 Security Groups, for each instance.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/3securitygroups.png)

And a edit for Jenkins connection for Sonar.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinssg.png)


## Jenkins Post-Installation

Connect via SSH to your Jenkins Instance and use:

``` sudo -i ```

``` systemctl status jenkins ```

Save your password.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinspassword.png)

Copy your public IPv4 Address, and connect via browser using the port 8080 and paste your password.

For example: ``` http://54.196.166.10:8080/ ``` - **Use HTTP, not HTTPS**.

Select **Install Suggested Plugins**

Now create an user.

## Jenkins Plugins

Go to ``` Manage Jenkins -> Plugins -> Available Plugins``` and install:

**Maven Integration**

**Github Integration**

**Nexus Artifact Uploader**

**SonarQube Scanner**

**Slack Notification**

**Build Timestamp**


## Nexus Post-Installation

Connect via SSH into your Nexus Instance, and use:

``` sudo -i ```

``` systemctl status nexus ``` - To check if nexus is running.

Press Q to quit.

Connect via browser in your Nexus using port 8081, example: ```52.90.163.90:8081 ```, and click at Sign In, to see the password's path.

Use at your SSH.

``` cat /opt/nexus/sonatype-work/nexus3/admin.password ```

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/nexuspassword.png)

Use the password at nexus, and the username **admin** .

Configure a new password, and click at **Disable anonymous access**.


## Nexus Repositories


At Nexus, go to **Server administration and configuration (Gear Icon) -> Repositories -> Create repository**

Let's create 4 repositories.

**maven2(hosted)**

**maven2(proxy)**

At Proxy paste **Maven dependency URL**, this will be a repository for maven dependencies.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/MavenProxy.png)

**maven2(hosted)**

Change Version Policy to **Snapshot**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/MavenSnapshot.png)

**maven2(group)**

At ```Group -> Member Repositories```, select the other repositories you created.

This repository will group the other repositories.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/MavenGroup.png)

**Save the name from your repositories**

## SonarQube

Go to SonarQube page only using the IPv4 in the browser.

In sonarqube only change the password.

**Make sure you have your Github correctly configured into your IDE**


# JDK and Maven Installation

At Jenkins Panel, go to ```Manage Jenkins -> Tools ```.

For **JDK**, we need to install JDK 11 and JDK 8:

**Name**: OracleJDK11

**JAVA_HOME**: /usr/lib/jvm/java-1.11.0-openjdk-amd64

click at Add JDK, and do this for JDK 8.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/JDK.png)

For **Maven**, click at Add Maven.

**Name**: MAVEN3

**Install Automatically**

**Version**: 3.9.5

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/MAVEN3.png)

Save.

## Nexus Credentials at Jenkins

Go to ``` Manage Jenkins -> Credentials -> System -> Global credentials (unrestricted) -> Add Credentials```

Kind => Username with Password

and Setup your **Nexus Username and Password**, create an **ID**, and a **Description**, and click at **Create**.

## Jenkins Environment

At file called Jenkinsfile, configure the environment:

```SNAP_REPO``` name of **Maven Snapshots** in Nexus Repository.

```NEXUS_USER``` Nexus **username**.

```NEXUS_PASS``` Nexus **Password**.

```RELEASE_REPO``` name of **Maven Release** in Nexus Repository 

```CENTRAL_REPO``` name of **Maven Central** in Nexus Repository

```NEXUS_IP``` **PRIVATE** IPv4 of Nexus Instance.

```NEXUS_PORT``` Port of Nexus Instance : **8081**

```NEXUS_GRP_REPO``` name of Maven Group in Nexus Repository

```NEXUS_LOGIN``` **ID** you previously created at Jenkins Credentials.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/JenkinsEnvironment.png)

## Jenkins Pipeline Job

In **Jenkins Dashboard**, click at ```New Item```.

Enter a **Name** and select **Pipeline**.

At ``` Pipeline -> Definition ``` select ``` Pipeline Script from SCM ```

**SCM** select **Git**.

**Repositories -> Repository URL** paste your **Forked URL**, its at **YOUR PROFILE**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/SSH_Github.png)

**Credentials** select ```Add -> Jenkins```

Under **Add Credentials**

**Kind -> SSH Username with Private Key**

**ID** = githublogin

**Description** = githublogin

**username** = git

At **Private Key** select **Enter Directly**

Now you need to paste your **private key** of Github.

Send at **Git Bash** or some Terminal:

```cat ~/.ssh/id_rsa```

This is your **PRIVATE Key**, copy and paste at **Key**.

**Add**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/Github_Key.png)

## Resolving Error Code 128

This error is caused because SSH is trying to connect and Jenkins is questioning: Do you want to connect in? And we need to store the GitHub Identity.

Let's resolve this.

First of all, **SSH to Jenkins Server**.

Go to **Root** User: ``` sudo -i ```

And switch to **Jenkins** User: ``` su - jenkins ```

paste this, switching to your **Repository SSH**:

``` git ls-remote -h YOUR_REPOSITORY_SSH HEAD```

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/SSH_Github.png)

If you get an error, **don't worry**, only needed to store your Private Key.

You can check the auth with ``` cat .ssh/known_hosts ```

**Switch** your credentials at jenkins remove the error **notification**.

**Branches to Build -> Branch Specifier** type ``` */main ```, Github don't uses master branch as main branch.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/JenkinsBranch.png)

**Save**.

Now at Pipeline Page, click at Build Now.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/Finished_Success.png)


**Good Job** now your Jenkins have all **Maven Dependencies**.

## Github Webhook

Let's run the job to everytime there are a commit, **Jenkins build now automatically**.

Copy your **IPv4 IP + Port from Jenkins**, at my case is ``` http://54.196.166.10:8080/ ```.

At your forked project, ```Settings -> Webhook```.

**Add Webhook**, and paste your **Jenkins URL** at **Payload URL**, and at the end add ``` github-webhook/ ```. It needs the slash " / " at the end.

**Content type** select ```application/json```.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/Payload_Webhook.png)

**Add Webhook**

Enter at your webhook, and click at Recent Deliveries

If are everything fine, there's a Green Check at the left

If something is wrong, there a Red X, **check the IP, Port, Security Group**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/Webhook_Success.png)

Back to **Pipeline at Jenkins**, click at **Configure**

under **Build Triggers** select **Github hook trigger for GitScm Polling**.

**Save**.

At Jenkinsfile:
**Test** - Will execute a shell command to run a unit test, it will generate some report that will later uploaded on SonarQube.

**Checklist Analysis** - Will execute a shell command to run a code analysis tool, which will check for any issues with your code and suggest you best practicies on vulnerabilities.

And after commit:

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/JenkinsAuto.png)


## Code Analysis with SonarQube

Lets Setup the sonnar scanner tool

``` Jenkins Dashboard -> Manage Jenkins -> Global Tools Configuration ```

Under **SonarQube Scanner**, click **Add SonarQube Scanner**.

**Name**: sonarscanner

**Version**: SonarQube Scanner 4.7.0.2747

**Save**

At **Configure System**, under **SonarQube Server**, check **Environment variables** and click **Add SonarQube**.

Name: sonarserver

Server URL: http://PRIVATE_IP_SONAR_INSTANCE

at my case: http://172.31.22.172

Let's create a SonarQube autentication for Server authentication token.

Connect to SonarQube from Browser, using the **IPv4 from Sonar Instance**.

Log in to admin account (admin/admin).

Go to My ```Account -> Security```.

**Generate Tokens -> Name: jenkins**

and click at **Generate**

Copy your **Generated Token**.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinstokensonar.png)

Back to **Server authentication token** at **Jenkins**.

Under Kind, select **Secret Text**.

Paste your **Token at Secret**

**ID, Description**: sonartoken

**Add**.

Select **sonartoken** at **Server Autentication Token**

**Save**

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinssonar.png)


Jenkins:

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinsanalysis.png)

Sonar:

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/sonaranalysis.png)

## SonarQube Quality Gates

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/quality.png)

As you can see, with the **Default** SonarQube Quality Gates, the code **passed** from the test, let's **change the Quality Gates**.

At SonarQube Dashboard, click at **Quality Gates**.

Let's create a Quality Gate, click at **Create** and **name it**.

Under **Add Condition** select **On Overall Code**,

and **Quality Gate Fails when**, select **Bugs**, and select a **Value**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/bugs.png)

If you want it FAIL, set to **25**.

Now **Attach** your quality gate to your project

At your project at SonarQube : ``` Project Settings -> Quality Gate ``` and select the custom Quality Gate you created.

## Creating a Jenkins Webhook for SonarQube

At ``` Project Settings -> Webhooks ``` - Create.

Name: jenkinswebhook

URL: Use the PRIVATE IPv4 of Jenkins Instance, and the Port. and add ```/sonarqube-webhook ```At my case:

``` http://172.31.30.10:8080/sonarqube-webhook ```

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/sonarwebhook.png)

## Jenkins Stage Quality Gates

Remove the Comment brakets from ```Jenkinsfile``` at **Stage Quality Gate**

This will timeout when the QualityGate doesn't respond, so don't wait for infinity, it waits for maximum 1 hour, it can be minutes changing unit: 'HOURS'.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/qualityfail.png)

But we want it to pass, only raise the bar, Update the condition from Quality Gate at SonarQube to 100.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/cond.png)

## Timestamp

When uploaded a new artifact, it should have a different version number, and the best approach for that is a Timestamp.

``` Jenkins Dashboard -> Manage Jenkins -> Configure System```

Under Build Timestamp, we can change **Timezone** (Brazil/East), (Africa/Cairo)...

and the **Pattern**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/timestamp.png)

## Slack Notification

Create an Account at [Slack](http://www.slack.com)

Visit the [Apps to Slack](https://slack.com/apps) and search for **Jenkins CI**

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/slackj.png)

And click at the Button **Add to Slack**.

Create and Select your channel for Slack Notifications, and Add.

Under **Step 3**, copy the **Integration token credential ID**.

**Save Settings**.

Now back to **Jenkins Dashboard**, and go to ``` Manage Jenkins -> Configure System ```

and under Slack

**Workspace**: Your Workspace Name

Credential -> Add -> Jenkins

Under Kind -> **Secret Text**

Paste your **Slack Token**

**ID and Description**: slacktoken

**Add**.

under **Credential** select **slacktoken**

**Default channel / Member id** : Select the channel you created for Slack Notifications

Click at **Test Connection**

**If you get an error, recreate everything, slack room, credential, default channel...**

**Save**.

Lets make the message, remove the comment brakets at ```Jenkinsfile```, at **Post Slack Notifications**.
And, the colors for it! Remove the comment brakets at **Def**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/slackst.png)

So, when a Developer makes a code Change, they commit to the repository, it's going to build the artifact, download dependencies from Nexus, Unit tests, Code Analysis, a Sonar Analysis uploading all the results on the SonarQube Server, and If the Quality Gates are passed, upload the Artifact to the Repository, and send a Notification if the code passed or failed in the Slack.

## Terraform

Terraform will create a IAM User cicd-jenkins, with policies ECSFullAccess, and EC2ContainerRegistryFullAccess.

A private ECR  with encryption type AES256, and mutable.

First of all, enter at AWS IAM, Users, the created user and Create a new Access Key. 

Save the .CSV file.

## Jenkins

Enter at jenkins plugins and install

Docker Pipeline

CloudBees Docker Build and Publish

Amazon ECR

Pipeline: AWS Steps

AWS Credentials

## Creating credentials for AWS

```Manage Jenkins > Credentials > System > Global Credentials```

Under kind -> **AWS Credentials**

**Id, description**: awscreds

**Access key id**: access key created from IAM User

**Secret access key**: secret access key created from IAM User


# Installing and configuring Docker at Jenkins

Connect via SSH at your **Jenkins Instance**

First of all, install **Docker**, visit this [guide](https://docs.docker.com/engine/install/ubuntu/).


Now you need to add Jenkins User to Docker's Group

```sudo -i```

```usermod -aG docker jenkins```

```id jenkins```

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/jenkinsgroup.png)

and restart jenkins:
```systemctl restart jenkins```


## Jenkinsfile ECR Variables


Change 3 variables at **StagePipeline/Jenkinsfile**:

registryCredential: Your AWS Region, at my case im using us-east-1.

appRegistry: Your Repository URI at Amazon Elastic Container Registry.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/amazonecr.png)

vprofileRegistry: 'https://PASTE_YOUR_URI_WITHOUT_/NAME'

for my example: 'https://024936713889.dkr.ecr.us-east-1.amazonaws.com'


## New CICD Pipeline for Docker

Create a new Pipeline at Jenkins

```Jenkins Dashboard -> New Item```

Give a name and select Pipeline

Mark GitHub hook trigger for GITScm polling

Under **Pipeline** select **Pipeline Script from SCM**

**SCM**: Git

at **Repository URL** paste your **Repository SSH Git**

and **Credentials** select **git (githublogin)**

Under **Branches to Build** at **Branch Specifier** type ```*/cicd-jenkins```

and at **Script Path** specify the path for JenkinsFile, at my case ```StagePipeline/Jenkinsfile```

**Save**.

Click at **Build Now**.

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/cicdpipeline1.png)

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/cicdpipeline2.png)

## AWS ECS Task Definition

```ecr.tf``` creates an ECR Repository called ciecr.

```ecs.tf``` creates an ECS Cluster called cicdjenkins.

```iamuser.tf, iamuserpolicy``` creates an IAM User and Policies for ECS and ECR access.

Now create a task definition

```AWS Console -> Amazon Elastic Container Service -> Task Definition -> Create new task definition```

**Task definition configuration**

**Task Definition Family**: Name the task definition



**Infrastructure requirements**

**Launch Type**: AWS Fargate

**Operating System/Architecture**: Linux/X86_64

**Task Size**:

**CPU** = 1vCPU

**Memory** = 2GB

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ImageInfra.png)

**Container 1**

**Name**: cicontainer

**Image URI**: ECR Image URI, found at ```Amazon ECR -> Repositories -> ciecr```

**Container Port**: 8080

**Resource allocation limits - conditional**:

**CPU**: 1

**Memory**: 2GB

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ImageContainer.png)



## Creating an ECS Service

```Amazon Elastic Container Service -> Cluster -> cicdjenkins -> service```

Under **Environment**, **compute configuration (advanced)**

**Compute Options**: Launch type

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ECSEnvi.png)


Under **Deployment configuration**, at **Family** select your **Task Definition Family**

**Service name**: Name your service.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/DeployC.png)


Under **Networking** at **Security Group**, create a **new security group**

Name your **Security Group Name** and **Security Group description**

Under **Inbound rules for security groups**

**Type**: HTTP

**Source**: Anywhere

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/sgECS.png)


Under **Load Balancing - optional**

**Load balancer type** - Application Load Balancer

**Load balancer name**: Name your load balancer

**Health Check grace period**: 30 seconds

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/cialb.png)

Under Target Group

**Target group Name**: Name your Target Group

**Health check path**: /login

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/citg.png)


## Target Groups

```AWS Console -> EC2 -> Target Group -> Health Checks -> Edit```

Under **Health Checks** click at **Advanced health checks settings**

**Health check port**: Select **Overrite** and set 8080

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/tg8080.png)


**Save**.



## Security Groups

``` AWS Console -> Security Group```

Select the **Security Group** you created

```Inbound Rules -> Edit Inbound Rules```

Let's add **2 Rules**

**Port Range**: 8080

**Source**: Anywhere IPv4

and

**Port Range**: 8080

**Source**: Anywhere IPv6

**Save Rules**

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/inbrule.png)


## Pipeline for ECS

At ```StagePipeline/Jenkinsfile```, configure the cluster and service at environment.

and at Stage Deploy to ECS Staging, verify your region correctly.

This shell command ```sh ...``` this is telling to update the service, and redeploy, forcefully delete the old container and deploy a new container with the latest image.

And let's clear old containers, images and volumes, connect at Jenkins Instance via SSH and run:

```sudo -i```

```docker system prune```

Let's Build now at Jenkins.


## Promote to Production Environment

Let's create a **Production Cluster**

```AWS Console -> Amazon Elastic Container Service -> Clusters -> Create Cluster```

Under **Cluster configuration**

**Cluster name**: Name your cluster


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodcluster.png)


Create a **Task Definition**:

```AWS Console -> Amazon Elastic Container Service -> Task Definitions -> Create a new task definition```

Under **Task definition configuration** at **Task definition family**, **name your Task Definition**.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ciprodtask.png)


Under **Infrastructure requirements**:

**Task Size**: 

**CPU**: 1vCPU

**Memory**: 2GB


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/inframem.png)


Under **Container - 1**, Container Details:

**Name**: Name your new Prod Container

**Image URI**: Your Image URI from Amazon Elastic Container Registry 

**Container Port**: 8080

**Memory hard limit**: 2


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/contprod.png)


## Creating Launch Type Service

```Elastic Container Service -> Clusters```

Enter at your ```Prod Cluster -> Services -> Create (Deploy)```

Under **Environment**, Compute configuration (advanced), **Compute options**, select **Launch Type**


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/launchprod.png)


Under **Deployment Configuration**,

**Family** select your **Prod** Task Definition Family

**Service Name**: Name your prod service.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodsvc.png)


Under **Networking**,

**Security Group -> Create a new Security Group**

**Give a Name and Description** for your **New Security Group**

At **Inbound rules for security groups**,

**Type**: HTTP

**Source**: Anywhere

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodsg.png)


Under **Load balancing - optional**,

**Load Balancer type**: Application Load Balancer

**Health check grace period**: 30 seconds


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodalbsec.png)


Under **Target group**,

**Name** your target group,

**Health check path**: /login


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodtg.png)


**Create**

## Jenkinsfile at ProdPipeline


Switch to **prod branch**, at ```Prodpipeline/Jenkinsfile```, configure:

environment -> cluster = Cluster Prod Name, at my case ```ciprod```

environment -> service = Service Cluster Prod Name, at my case ```ciprodsvc```

**Stage Deploy to prod ECS -> Steps withAWS -> Region**: Type your AWS Region, at my case ```us-east-1```


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ciprod.png)

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ciprodjen.png)

![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/ciprodsvc.png)


## Create a Jenkins Production Pipeline

```Jenkins Dashboard -> New Item```

Name your **CICD Pipeline Prod**, and **Replicate the Pipeline from Docker Pipeline**.


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/cicopypipe.png)

Under **Branches to build**,

Change your **Branch Specifier** to ```*/prod```

**Script Path** to ```ProdPipeline/Jenkinsfile```

**Save**


## Overrite Prod Target Group

```AWS Console -> EC2 -> Target Group```

Select your **Prod Target Group** -> **Health Check** -> **Edit**

Under **Advanced Health Check Settings**,

**Health check port**:

**Overrite**: 8080

**Save**


![alt text](https://github.com/kontrolinho/CICD-of-Java-Web-Application-using-Docker-Jenkins-Nexus-SonarQube-and-Terraform/blob/main/Read-Images/prodover.png)


## Prod Security Group 

```AWS Console -> EC2 -> Security Group```

Select your **Prod Security Group** -> **Inbound Rules** -> **Edit Inbound Rules**

Let's add **2 Rules**

**Port Range**: 8080

**Source**: Anywhere IPv4

and

**Port Range**: 8080

**Source**: Anywhere IPv6

**Save Rules**
