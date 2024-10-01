# Udemy Sergii Demianchuk. Source files for the course "How to secure web application with AWS WAF and CloudWatch"

## Setup

1. Install docker according to your's operating system: https://docs.docker.com/engine/install/

2. Install docker-compose according to your's operating system: https://docs.docker.com/compose/install/

3. Run docker compose to bring up docker environment: docker-compose up -d

4. Test page is available on http://localhost:5000/test?parameter=2

###How to stop and remove container
docker-compose stop

###How to check logs
docker logs udemy_security_python_app -f
   
###How to check coding standards
docker exec -it udemy_security_python_app flake8

###How to run tests
docker exec -it udemy_security_python_app pytest -s

###How to work with terraform
terraform init
terraform apply -var-file ../env.tfvars

###SSH configuration
Host udemy-flask
    HostName 3.112.87.211
    User ubuntu
    IdentitiesOnly yes
    IdentityFile ~/.sergii-blog-keys/dev-ec2-2