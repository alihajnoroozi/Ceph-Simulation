sudo su
crictl version
crictl info

vim apache_sandbox.json

{
    "metadata": {
        "name": "apache-sandbox",
        "namespace": "default",
        "attempt": 1,
        "uid": "hdishd83djaidwnduwk28bcsb"
    },
    "linux": {
    },
    "log_directory": "/tmp"
}

vim container_apache.json

{
  "metadata": {
      "name": "apache"
    },
  "image":{
      "image": "httpd"
    },
  "log_path":"apache.0.log",
  "linux": {
  }
}

crictl runp apache_sandbox.json
POD_ID=`crictl pods | tail -n1 | awk '{print $1}'`
crictl inspectp --output table $POD_ID

crictl pull httpd
sudo crictl create $POD_ID container_apache.json apache_sandbox.json
CONTAINER_ID=`crictl ps -a | tail -n1 | awk '{print $1}'`
crictl start $CONTAINER_ID
CINTAINER_IP_ADDR=`crictl inspect $CONTAINER_ID | grep -i "io.kubernetes.cri-o.IP"`
curl $CINTAINER_IP_ADDR