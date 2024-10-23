# Setup Elastic Stack in Kubernetes using Helm 
This guide details the steps required to set up the Elastic Stack (Elasticsearch, Kibana, Logstash, Filebeat) in a Kubernetes cluster using Helm.  
This guide is inspired by the article "How to install Elastic Search using Helm into Kubernetes" .

## Prerequisites
A running Kubernetes cluster.
Helm installed on your local machine.
kubectl installed and configured to interact with your Kubernetes cluster.

## Steps
1. Add Elastic Helm Repository
First, you need to add the Elastic Helm repository to your Helm client:

``` bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

2. Create Namespace
We will use a namespace called monitoring. You can create it using:
```
kubectl create namespace monitoring
```

Alternatively, we will use --create-namespace in our Helm commands to create the namespace if it doesn't exist.

3. Install Elasticsearch
Create a values.yml file under the elasticsearch directory with your custom configurations. Then use the following command to install Elasticsearch:
```
helm install elasticsearch elastic/elasticsearch -f elasticsearch/values.yml -n monitoring --create-namespace
```

4. Install Filebeat
Create a values.yml file under the filebeat directory with your custom configurations. Then use the following command to install Filebeat:
```
helm install filebeat elastic/filebeat -f filebeat/values.yml -n monitoring --create-namespace
```

5. Install Logstash
Create a values.yml file under the logstash directory with your custom configurations. Then use the following command to install Logstash:
```
helm install logstash elastic/logstash -f logstash/values.yml -n monitoring --create-namespace
```

6. Install Kibana
Create a values.yml file under the kibana directory with your custom configurations. Then use the following command to install Kibana:
```
helm install kibana elastic/kibana -f kibana/values.yml -n monitoring --create-namespace
```

7. Ensure You Have the Latest Chart Versions
To ensure you are using the latest chart versions from the Elastic Helm repository:
```
helm repo update
```
This will update your Helm repository information to the latest versions available.

8. Port Forwarding
To access Kibana from your local machine, set up port forwarding:
```
kubectl port-forward svc/kibana-kibana 5601:5601 -n monitoring
```

You can now access Kibana at http://localhost:5601 .

9. Retrieve Auto-generated Usernames and Passwords
If you have enabled security features, use the following commands to retrieve auto-generated usernames and passwords.

For Elasticsearch:
```
kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.username}" | base64 --decode
echo

kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.password}" | base64 --decode
echo
```

For Kibana:
```
kubectl get secret kibana-kibana -o jsonpath="{.data.kibana-username}" | base64 --decode
echo

kubectl get secret kibana-kibana -o jsonpath="{.data.kibana-password}" | base64 --decode
echo
```

# Full Script
To simplify the process, you can use the following shell script to install all components:

```
#!/bin/bash

NAMESPACE="monitoring"
VALUES_DIR="."

Update the Helm repo to get the latest chart versions
helm repo add elastic https://helm.elastic.co
helm repo update

Install or upgrade the charts with the latest version available in the Helm repo
helm install elasticsearch elastic/elasticsearch -f "$VALUES_DIR/elasticsearch/values.yml" -n $NAMESPACE --create-namespace
helm install filebeat elastic/filebeat -f "$VALUES_DIR/filebeat/values.yml" -n $NAMESPACE --create-namespace
helm install logstash elastic/logstash -f "$VALUES_DIR/logstash/values.yml" -n $NAMESPACE --create-namespace
helm install kibana elastic/kibana -f "$VALUES_DIR/kibana/values.yml" -n $NAMESPACE --create-namespace
```

## How to Run the Full Script
Save the script: Save the above script in a file, for example deploy-helm.sh.
Make it executable: Run chmod +x deploy-helm.sh to make the script executable.
Create values.yml files: Ensure you have your custom values.yml files in the respective directories (elasticsearch, filebeat, logstash, kibana).
Execute the script: Run ./deploy-helm.sh to deploy the entire Elastic Stack.
References
How to install Elastic Search using Helm into Kubernetes
Elastic Helm Charts Documentation
Acknowledgements
Special thanks to https://github.com/angwenyi for the insights and initial work that inspired this guide.

Feel free to adjust the values.yml configuration as needed for your specific requirements.

This README should guide you through setting up the Elastic Stack in a Kubernetes environment using Helm, following the structure and information provided in the linked article.