#!/bin/bash

CONNECT_HOST=localhost

if [[ $1 ]];then
    CONNECT_HOST=$1
fi

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "csv-stocks-us",
  "config": {
    "connector.class": "com.github.jcustenborder.kafka.connect.spooldir.SpoolDirCsvSourceConnector",
    "topic": "stocks.parsed",
    "tasks.max": "1",
    "finished.path": "/tmp/spooldir/finished",
    "input.file.pattern": ".*\\\\.csv",
    "error.path": "/tmp/spooldir/error",
    "input.path": "/connect-stock-data",
    "halt.on.error": false,
    "timestamp.mode":"FIELD",
    "timestamp.field":"Date",
    "key.schema": "{\"name\":\"demo.kstreams.StockKey\",\"type\":\"STRUCT\",\"isOptional\":false,\"fieldSchemas\":{\"Symbol\":{\"type\":\"STRING\",\"isOptional\":false}}}",
    "value.schema": "{\"name\":\"demo.kstreams.StockTick\",\"type\":\"STRUCT\",\"isOptional\":false,\"fieldSchemas\":{\"Symbol\":{\"type\":\"STRING\",\"isOptional\":false},\"Date\":{\"name\":\"org.apache.kafka.connect.data.Timestamp\", \"type\":\"INT64\",\"version\":1,\"isOptional\":false},\"Open\":{\"name\":\"org.apache.kafka.connect.data.Decimal\",\"type\":\"BYTES\",\"parameters\":{\"scale\":3},\"isOptional\":false},\"High\":{\"name\":\"org.apache.kafka.connect.data.Decimal\",\"type\":\"BYTES\",\"parameters\":{\"scale\":3},\"isOptional\":false},\"Low\":{\"name\":\"org.apache.kafka.connect.data.Decimal\",\"type\":\"BYTES\",\"parameters\":{\"scale\":3},\"isOptional\":false},\"Close\":{\"name\":\"org.apache.kafka.connect.data.Decimal\",\"type\":\"BYTES\",\"parameters\":{\"scale\":3},\"isOptional\":false},\"Volume\":{\"name\":\"org.apache.kafka.connect.data.Decimal\",\"type\":\"BYTES\",\"parameters\":{\"scale\":0},\"isOptional\":false},\"OpenInt\":{\"type\":\"INT32\",\"isOptional\":true}}}",
    "csv.first.row.as.header": true
  }
}
EOF
)

echo "curl -X POST -H \"${HEADER}\" --data \"${DATA}\" http://${CONNECT_HOST}:8083/connectors"
curl -X POST -H "${HEADER}" --data "${DATA}" http://${CONNECT_HOST}:8083/connectors
echo