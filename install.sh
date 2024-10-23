#!/bin/bash

NAMESPACE=${1:-monitoring}
VALUES_DIR=${2:-"."}

helm install elasticsearch elastic/elasticsearch -f "$VALUES_DIR/elasticsearch/values.yml" -n $NAMESPACE --create-namespace
helm install filebeat elastic/filebeat -f "$VALUES_DIR/filebeat/values.yml" -n $NAMESPACE --create-namespace
helm install logstash elastic/logstash -f "$VALUES_DIR/logstash/values.yml" -n $NAMESPACE --create-namespace
helm install kibana elastic/kibana -f "$VALUES_DIR/kibana/values.yml" -n $NAMESPACE --create-namespace