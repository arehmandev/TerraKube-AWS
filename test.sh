#!/bin/bash

NODE_ID=1
NODE_IP=10.0.1.10

/usr/bin/etcd2 --name=node${NODE_ID} \
          --data-dir=/var/lib/etcd2 \
          --initial-cluster node0=https://10.0.0.10:2380,node1=https://10.0.1.10:2380,node2=https://10.0.2.10:2380 \
          --initial-advertise-peer-urls https://${NODE_IP}:2380 \
          --listen-peer-urls https://${NODE_IP}:2380 \
          --listen-client-urls https://${NODE_IP}:2379,https://127.0.0.1:2379 \
          --advertise-client-urls https://${NODE_IP}:2379 \
          --client-cert-auth=true \
          --cert-file /etc/ssl/kubernetes/etcd.pem \
          --key-file /etc/ssl/kubernetes/etcdkey.pem \
          --trusted-ca-file /etc/ssl/kubernetes/ca.pem\
          --peer-client-cert-auth=true \
          --peer-trusted-ca-file /etc/ssl/kubernetes/ca.pem \
          --peer-cert-file /etc/ssl/kubernetes/etcd.pem \
          --peer-key-file /etc/ssl/kubernetes/etcdkey.pem \
          --initial-cluster-state new \
          --proxy on


etcdctl --endpoint https://127.0.0.1:2379 --cert-file /etc/ssl/kubernetes/etcd.pem --key-file /etc/ssl/kubernetes/etcdkey.pem --ca-file /etc/ssl/kubernetes/ca.pem cluster-health
