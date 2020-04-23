# Cloud Playground

A demo environment that show, how to provision a web application on a cloud provider such as AWS, using provisioning and configuration management tools like Terraform and Ansible.

## Requirements

- Ubuntu 18.04

- Joomla

- Nginx

#### Once deployed, the application should be:

- Secure
- Fast
- Fault tolerant
- Adaptive to average load
- Backup the webserver logs with rotation of 7 days
- Notification when more than 10 4xx requests are returned by application


### Prerequisites

You need some tools/software and configuration in order try this demo

- [Create an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- [Create an IAM user with Admin Full access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [Setting up your workstation and configure aws cli](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)
- [Install and configure Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Install and configure Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Generate an ssh key](https://confluence.atlassian.com/bitbucketserver052/creating-ssh-keys-935362650.html)
- [Create an account on keybase](https://keybase.io/download)

- Have a personal domain name; in this example we will use the domain [1]: https://develop.alessioscuderi.it

### Get and Try

- Clone the repository
- Change directory and move into the project directory

#### Create and configure a variable vault

Ansible Vault can encrypt any structured data file used by Ansible. In this case we are going to create a vault for the project's variables in order to encrypt them. 

#### Create the vault

```
ansible-vault create <YOUR-PATH>/host_vars/variables.yml
```

After the creation you have to edit the file and include the variables that you need. For this demo you might configure the following variables:

```
    site_name: "cms-kata"

    vhost_name: "katavhost"

    site_title: "CMS Kata cloud engineer exercise"

    site_url: "develop.alessioscuderi.it"

    joomla_ver: "3.9.11"

    package_url: "https://github.com/joomla/joomla-cms/releases/download/{{joomla_ver}}/Joomla_{{joomla_ver}}-Stable-Full_Package.tar.gz"

    get_from_repo: true

    reinstallation: true

    import_sql: true
    import_sql_files:
      - { path: "templates/tables.sql", name: "tables.sql" }

    delete_installation_dir: true

    site_owner: "www-data"
    site_group: "www-data"

    project_dir: "/var/www/{{site_name}}/html"
 
    db_host: "{{ lookup('file', 'rds-endpoint.txt') }}"

    db_user : "CHANGE-WITH-YOUR-DB-USER"

    db_pass: "CHANGE-WITH-YOUR-DB-PASS"

    db_name: "CHANGE-WITH-YOUR-DB-NAME"

    joomla_db: "CHANGE-WITH-YOUR-JOOMLA-DB-NAME"
    joomla_user: "CHANGE-WITH-YOUR-JOOMLA-DB-USER"

    db_port: "3306"

    joomla_admin_mail: "CHANGE-WITH-YOUR-ADMIN-EMAIL"

    site_secret: "CKvBideKpFh7YALy"

    site_dbprefix: "jos_"

    joomla_login: "YOUR-WEBSITE-USERNAME"
    joomla_pass: "YOUR-WEBSITE-PASS"


    joomla_domain: "develop.alessioscuderi.it"

    access_key_id: "{{ lookup('file', 'access-key-ID.txt') }}"
    access_key_secret: "{{ lookup('file', 'access-secret-key.txt') }}"
    aws_region: "eu-west-1"
    aws_output_format: "json"

    default_user: "ubuntu"
    default_group: "ubuntu"
```
#### Edit the vault file

```
ansible-vault edit <YOUR-PATH>/host_vars/variables.yml
```
Insert the above variables, remember to fill all the missing variables, save and quit.

#### Edit the variables PATH
 
Edit ***kata-web.yml*** file and correct the path of the variables in my example

***MY-PATH/ansible-conf/host_vars/variables.yml***



- Create a **terraform.tfvars** in which you'll put the personal/secret informations about your AWS IAM admin user, the region and other password like the db password. ***remember to put this file in .gitignore***


```

AWS_ACCESS_KEY = "YOUR-ACCESS-KEY-ID"
AWS_SECRET_KEY = "YOUR-SECRET-KEY"
AWS_REGION     = "YOUR-DEFAULT-REGION"
RDS_PASSWORD   = "YOUR-RDS-DB-PASS"
PATH_TO_PRIVATE_KEY = "PATH-OF-YOUR-GENERATED-PRIVATE-KEY"
PATH_TO_PUBLIC_KEY = "PATH-OF-YOUR-GENERATED-PUBLIC-KEY"
RDS_USER = "ROOT-USERNAME-FOR-YOUR-DB"
RDS_NAME = "DEFAULT-DATABASE-NAME"
OFFICE_IP = "VPN-or-OFFICE-IP-ADDRESS-TO-WHITELIST"
HOME_IP = "PERSONAL-IP-ADDRESS-TO-WHITELIST"

```

Edit the ***play.sh*** bash script and ensure that the paths of the project/variables/secrets are correct

- Remember in this example we suppose that the password of your vault is located in this file ***~/.kata-vault-pass.txt***

```
TERRAFORM_DIR=<PATH-WHERE-YOU-INITIALIZED-TERRAFORM>
ANSIBLE_DIR=<ANSIBLE-DEFAULT-CONF>
KEY_PATH=<PATH-OF-YOUR-SSH-KEY>
```

When you finished exec the script play.sh to provision and configure your environment!

```bash play.sh ```

In the meanwhile have a coffee (it takes about 15 minutes)

When the playbook has finished it will show an output like this

```
PLAY RECAP ********************************************************************************************************
63.32.35.71                : ok=43   changed=34   unreachable=0    failed=0    skipped=3    rescued=0    ignored=0 
```

Type the following command in order to retrieve all the informations that you need from terraform

```
terraform output
```

Create a CNAME on your domain control panel that point to the load balancer address

For example :

```
develop IN CNAME kata-elb-1584155878.eu-west-1.elb.amazonaws.com.
```

Create also an SSL certificate on your AWS console in order to use HTTPS connections.

## Security features

At the beginning of the provisioning we created restricted security group in order to access to the instance from specific IP addresses. 

Improvements are scheduled in the "Improvements" section at end of the page.

### Fast and fault tollerant

The application load balancer help to be fast and manage the traffic better, but at the moment there aren't many features about this topic. In the "Improvements" section at end of the page you can see the improvements planned.

### Adaptive to Load Average

For this task we can use "Autoscaling" we can monitor the usual traffic and after that create autoscaling group that start automatically depending on the traffic or the load average (we can use health check for this).

### Server log backups 

We configured in the configuration steps with ansible the rotation of the access log files on nginx

### Monitoring and logging configuration

We have to receive a notification when more than 10 4XX requestes are returned by the app

```
Example in the AWS Console

```

## Future Improvements

###### [ Security ]

Install and configure security tools like ufw or fail2ban

Install and configure hardening tools like (apparmor / selinux)

###### [ Fast ]

Have a CDN (like CloudFront can help to be faster) 
Another things that can be implemented is a micro instance of In-Memory cache like Redis with the relative configuration on the CMS (Joomla) in order to work with this kind of cache.
There are also some extra tuning that can be done with the web server configuration or fpm module.

###### [ Fault tollerance ]

For the database we have an instance with MULTI-AZ that improve the performance. 
After a period of monitoring we can tune and optimize the databases level. 

Is a good things to create an autoscaling group or a failover instance in another availability zone.


## Documentation and references

* [Scaling From Zero to Your First 10 Million Users](https://www.youtube.com/watch?v=W8vRKnQOrX4) - Reference for improvements and other optimization features
* [Deploying App with Terraform on AWS](https://robertverdam.nl/2018/09/03/deploying-an-application-to-aws-with-terraform-and-ansible-part-1-terraform/) - Reference to interface terraform with AWS
* [Getting started with Ansible Playbook](https://www.ansible.com/blog/getting-started-writing-your-first-playbook) - Used to create the playbook
* [Joomla Ansible](https://github.com/radamanth/joomla-ansible) - Used as a reference to automatize the joomla deploy
* [Ansible Vault]() - Used to configure ansible vault
* [AWS logs]() - Used to configure access logs and alerting for 4XX Status code occurred in the app.

## Author

* **Alessio Scuderi** - *repository* - [Bitbucket](https://bitbucket.org/nocs/cloud-playground)


## Acknowledgments

* XPeppers cloud engineers team
* Amazon Web Services
* Open source communities
