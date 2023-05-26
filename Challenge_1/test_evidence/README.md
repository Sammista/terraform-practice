# terraform-practice

**Brief**

1. Create a folder called challenge_1, add another folder called test_evidence
2. add this readme.md file 
3. Create folder called terraform config
4. Create EC2 instance with it's own VPC in us-east-1, with the latest Amazon Linux 2 AMI.
5. It should also have a public IP address. 
6. Create SSH keys and output values.

**How I did this**
First of all install Terraform

1.  Right clicked in the file explorer in VS code to create the new folders.
2.  Right clicked in the file explorer in VS code to create the new file.
3.  As per 1.
4.  First define the AWS provider. Also a main.tf file is needed. I added the main.tf file into the terraform config folder. 
    I then added the provider for AWS. I used https://registry.terraform.io/providers/hashicorp/aws/latest and clicked 'Use Provider' and copied the supplied code into my main.tf.
    I then ran terraform init to initilise it. Next I created the VPC. This is done before you create any instances. I did this by defining a resource and used the intellesense to work out the code.  I also created all of the networking assets needed in the VPC, this includes internet gateway - to enable internet connections, subnet and route table - linked to the internet gateway. 
    I then created the aws ami, using the aws data provider. In order to get the most recent I used 'most_recent = true'.
5. A public IP address was achieved by using the map_public_ip_on_launch = "true" flag within creating the subnet.
6.  Create SSH keypair. In order to do this I first created the TLS_private key, I then use the value created in there to get the public key. 
    local file resource type to output the .pem file.
    I referenced ref1 for help. in generating the .pem file locally.

**How to replicate**

prereqs: awscli, terraform, github desktop, VSCode.

1. clone my github repos by clicking clone in Github desktop. 
2. Then click open in VS code. 
3. run terraform init - this will download the relevant providers.
5. Create your profile by adding the login details to your .aws file- Note. Although I was able to run this intitally ok, on subsequent runs I  could not get my the profile to work while using Terraform and VSCODE. To work around this I store them as sensitive variables, supplying the values as input variables with each command, so that I am not storing these credentials in source.
 If you encounter similar issues you can simply run:
 terraform plan -var 'access_key=YOURACCESSKEY' -var 'secret_key=YOURSECRETKEY' otherwise, if your profile works you can run terraform plan.
6. Once you have ran Terraform plan, the script will output the details to connect the EC2 instance using SSH.
7. When using SSH to connect to the instance run chmod 400 keypair2.pem to avoid getting an error.
8. Once you have ran Terraform plan, run Terraform apply. This will apply all of the changes in the plan.
9. It should output ssh details (public dns, and .pem file location) connect using these: for example 
    ssh -i "keypair2" ec2-user@ec2-3-88-187-57.compute-1.amazonaws.com 



**References**
- ref1 = https://rohan6820.medium.com/integrating-a-vpc-with-ec2-via-terraform-608efd6ef96c
- Pluralsight, getting started with Terraform.
- https://developer.hashicorp.com/terraform/cli/commands/plan#input-variables-on-the-command-line
- https://gmusumeci.medium.com/how-to-deploy-an-amazon-linux-ec2-instance-in-aws-using-terraform-d3ed50998714

