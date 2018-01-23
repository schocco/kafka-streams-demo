# Kafka Streams Demo

**Stock Data Processing with Spring Cloud Stream and the Confluent Platform**


## Setup

- Check the docker bridge IP (`docker network inspect bridge`) and change the URLs in the
  `application.yml` config file and in the `KAFKA_ADVERTISED_LISTENERS` url in the `docker-compose.yml` files if needed
- Download the Stock Data CSVs
  ```bash
  cd cp-docker
  ./download-data.sh
  ```
- Start the docker containers with Kafka, Zookeeper, Kafka Connect and the Schema Registry.
  ```bash
  docker-compose up -d
  docker-compose ps
  ```
- When all containers are up, create a new connect task for the CSV import to a Kafka Topic.  
  The connect plugin will register the schema of the imported data in the Schema registry.
  ```bash
  ./start-connector.sh
  curl localhost:8083/connector-plugins | jq
  ```
- The connector will send messages to Kafka when CSVs are placed in `cp-docker/connect/spool-input`
  ```bash
  head -n 10 us-etfs.csv > connect/spool-input/etfs.csv 
  ```
- When the application is started, it should receive the messages of the first few rows.
  The Messages are sent in Avro format and are deserialized to pojos, which were created with the
  Avro maven plugin
  
## References

- Confluent Schema Registry: https://docs.confluent.io/current/schema-registry/docs/intro.html
- Kafka Connect Plugin for CSV import: https://github.com/jcustenborder/kafka-connect-spooldir
- Spring Cloud Stream Reference: https://docs.spring.io/spring-cloud-stream/docs/Elmhurst.M3/reference/htmlsingle/
- Spring Cloud Stream Kafka Binder: https://docs.spring.io/autorepo/docs/spring-cloud-stream-binder-kafka-docs/1.1.0.M1/reference/htmlsingle/
- Kafka Streams: https://kafka.apache.org/documentation/streams/