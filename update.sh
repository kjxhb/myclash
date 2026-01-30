#！/bin/sh

# 备份clash.yaml
cp clash.yaml clash-backup.yaml

# 下载Ruk1ng001.yamll
curl -o Ruk1ng001.yaml "https://api.dler.io/sub?target=clash&url=https%3A%2F%2Fraw.githubusercontent.com%2FRuk1ng001%2FfreeSub%2Fmain%2Fclash.yaml&config=https%3A%2F%2Fraw.githubusercontent.com%2Fkjxhb%2Fmyclash%2Fmain%2Fmyclash.ini&filename=Ruk1ng001.yaml&sort=true&udp=true"

# 删除Ruk1ng001.yaml中的hyster节点和其它节点
sed -i '/hyster/d' Ruk1ng001.yaml
sed -i '/14.18.253.178/d' Ruk1ng001.yaml
sed -i '/89.110.79.39/d' Ruk1ng001.yaml

# 复制Ruk1ng001.yaml中的节点所有信息到1.yaml临时文件
grep '{name: .*' Ruk1ng001.yaml > 1.yaml

# 复制1.yaml中的节点到2.yaml临时文件，并删除除节点名称外的其它信息
grep -o "name: .*, server:" 1.yaml > 2.yaml
sed -i 's/name:/      -/g; s/, server://g' 2.yaml

# 删除clash.yaml的原节点
sed -i '/github.com\/Ruk1ng001/d' clash.yaml

# 在clash.yaml中查找第一个proxies，并在其下一行插入1.yaml中的节点（添加节点）
line1=$(grep -n 'proxies' clash.yaml | sed -n '1s/:.*//p')
sed -i "${line1}r 1.yaml" clash.yaml

# 在clash.yaml中查找第二个proxies，并在其下一行插入2.yaml的节点名称（添加“自动选择”分组的节点名称）
line2=$(grep -n 'proxies' clash.yaml | sed -n '2s/:.*//p')
sed -i "${line2}r 2.yaml" clash.yaml

# 在clash.yaml中查找第二个'自动选择'，并在其下一行插入2.yaml的节点名称（添加“节点选择”分组的节点名称）
line3=$(grep -n '自动选择' clash.yaml | sed -n '2s/:.*//p')
sed -i "${line3}r 2.yaml" clash.yaml

# 删除1.yaml和2.yaml等临时文件
rm 1.yaml && rm 2.yaml && rm Ruk1ng001.yaml
