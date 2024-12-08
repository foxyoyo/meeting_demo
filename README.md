# demo

# Folder : eks_cronjob_py_chg_asg , implement EKS 尖峰 / 離峰時間的 ASG node 數量
- 修改 Yaml 中的env ， 控制eks node group node 數量，還有告警通知slack

``` 
              env:
              - name: DESIRED_CAPACITY
                value: "10"
              - name: ASG_NAME
                value: "eksctl-demo-NodeGroup"
              - name: REGION
                value: "ap-northeast-1"
              - name: SLACK_TOKEN
                value: "xoxb-xxxxxxxxx"
              - name: SLACK_CHANNEL
                value: "#fox-test"
              - name: TEMPLATE_NAME
                value: "eksctl-demo-NodeGroup"
              - name: TEMPLATE_VERSION
                value: "1"
              - name: MAX_NODE
                value: "17"
              - name: MINI_NODE
                value: "10"
```

# Folder : terrafrom_oneclick
- 透過 one click 快速 Build出 整個region 下列的AWS infra resource

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

# Folder : athena_slack , 自己撰寫的python flask api 小工具，用於透過slack BOT 介面，可以快速得知目前prod 環境WAF 狀況，可以產出report / block ip /query status 
- 透過 help 可以取得指令參數

``` 
help # get all parameter 
show alarms
show iamdeny
show xx_waf
show xx_topip
block_ip x-x-x-x
```
![image](https://github.com/foxyoyo/meeting_demo/blob/master/athena_slack/help.png)
![image](https://github.com/foxyoyo/meeting_demo/blob/master/athena_slack/slack1.png)
![image](https://github.com/foxyoyo/meeting_demo/blob/master/athena_slack/slack2.png)

# Folder : check_ip_range , 快速檢查某個ip 隸屬哪段既有infra subnet 
- 修改IP_list ，把要作資產清查的ip 填入，執行 './check_IP_range.sh -c "subnet/mask" -f {file path of ip list }'
> Pre-required:
>>1. 透過 grepcidr 套件 (https://formulae.brew.sh/formula/grepcidr)
```
    brew install grepcidr (Mac)
    apt-get install grepcidr (ubuntu)
```

>>2. How to (如何使用)
```
    Example : ./check_IP_range.sh -c "subnet/mask" -f {file path of ip list }
```

>>>2.a 如果IP_list 中ip 有隸屬指定subnet 時：
```
    ./check_IP_range.sh -c "10.0.1.0/24" -f ./IP_list
    ===================
    The ip belong specifc subnet (10.0.1.0/24) as below : 
    10.0.1.23
```
>>>2.b 如果IP_list 中ip 無隸屬指定subnet 時：
```
    ./check_IP_range.sh -c "10.0.99.0/24" -f ./IP_list
    There are no any ip list in (./IP_list) in the 10.0.99.0/24
```

>>>2.c 如果缺少指定參數時：
```
    ./check_IP_range.sh -c "10.0.99.0/24"             
    Some or all of the parameters are empty
    Usage: $0 check_IP_range.sh -c "10.0.2.0/24" -f ./IP_list 
            -f: Your IP_list Path
            -c: Your Checking Subnet

```