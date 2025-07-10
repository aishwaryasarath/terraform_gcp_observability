# Stress test redis to force eviction
```
for i in {1..10000}; do redis-cli -h <REDIS_IP> set key$i "$(head -c 10000 /dev/urandom | base64)" EX 3600; done
```


