# aws-networking-workshop
https://catalog.workshops.aws/networking/en-US
## Connecting to On-Premises
### Establish VPN Connection
s2s VPNの冗長化を行う場合は以下の通り。ただし、挙動が不安定になるので注意。  
`X.X.X.X`と`Y.Y.Y.Y`には、トンネルIPアドレスを指定する。  
`Z.Z.Z.Z`には、カスタマーゲートウェイアドレスを指定する。
```
conn Tunnel1
    authby=secret
    auto=start
    left=%defaultroute
    leftid=Z.Z.Z.Z
    right=X.X.X.X
    type=tunnel
    ikelifetime=8h
    keylife=1h
    phase2alg=aes_gcm
    ike=aes256-sha2_256;dh14
    keyingtries=%forever
    keyexchange=ike
    leftsubnet=172.16.0.0/16
    rightsubnet=10.0.0.0/14
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart_by_peer
conn Tunnel2
    authby=secret
    auto=start
    left=%defaultroute
    leftid=Z.Z.Z.Z
    right=Y.Y.Y.Y
    type=tunnel
    ikelifetime=8h
    keylife=1h
    phase2alg=aes_gcm
    ike=aes256-sha2_256;dh14
    keyingtries=%forever
    keyexchange=ike
    leftsubnet=172.16.0.0/16
    rightsubnet=10.0.0.0/14
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart_by_peer
```
事前共有鍵も２つ必要なので追加する。
```
Z.Z.Z.Z X.X.X.X: PSK "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456"
Z.Z.Z.Z Y.Y.Y.Y: PSK "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456"
```