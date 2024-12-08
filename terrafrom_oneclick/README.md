# terraform_auto

# Required module resource 
```
### Phase - I Build UP Basic infra ###
1 : VPC
2 : SecurityGroup for EC2
3 : EC2 - BastionHost (depend_on: iam-role,securitygroup,ami)
4 : EFS
5 : S3 
6 : SNS
7.1 : SNS - Subscribe's Lambda
8 : ParameterStore
9 : Cloudwatch (log )
10: Cloudwatch (metric-alarm)
11 : MSK
12 : RDS (parameter group 手動先建立好，修改參數)
13 : ElasticCache

### Phase -II (因為需要 Domain ACM 申請關係，只能模擬測試) ###
14 : SSL
15 : ALB-TargetGroup
16 : ALB  + ALB Rule

```
# Version Required 
```
required_version: = ">= 1.9.0"
required_providers: "~> 5.0"
```

#  Variables Desc
```
def-variables.tf : 變數預設值寫在這，裡頭是 aws_region / environment / business_division

terraform.tfvars : 共同變數設定檔，會覆蓋def-variables.tf

conf-variables.auto.tfvars : Module 變數設定檔

<module_name>-variables.tf : Module 預設變數值，會被 conf-variables.auto.tfvars 覆蓋掉。

```

# Execute 
```
terraform init
teraform plan
terraform play
terraform output -json > terraform.output.json
```

# SOP #

```
Pre-Task : 
A: Create RDS Postgres's rds parameter group for Debezium ( 參數太多 寫到 Terraform 中 太慢)
 - A.1:  vim global 預設變數 （def-variables.tf）
         vim global 覆蓋變數  （terraform.tfvars）
-  A.2 : Modify local 變數檔 "conf-variables.auto.tfvars"
（ps：variable priority : conf-variables.auto.tfvars > terraform.tfvars > def-variables.tf ）


B: Bastion EC2 的ubuntu ssh key 在secret folder 
C: Cluudwatch Alarm Slack 's Lambda python 在 Lambda Folder


Step 1: Terraform Build UP Infra 
cd terraform-proj-aws 
terraform init
terrafrom plan
terraform apply

Step 2:  Terraform apply Build all Alarm (terraform-proj-cwalarm-phase3)
a: Vim conf-variables.auto.tfvars
b: terraform plan && terraform apply

```