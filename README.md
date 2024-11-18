# meeting_demo

- Folder : eks_cronjob_py_chg_asg , implement EKS 尖峰 / 離峰時間的 ASG node 數量
1. 修改 Yaml 中的env ， 控制eks node group node 數量，還有告警通知slack

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

