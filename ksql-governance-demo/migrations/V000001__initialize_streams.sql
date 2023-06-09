CREATE STREAM stocks WITH (KAFKA_TOPIC = 'stocks', VALUE_FORMAT = 'AVRO');
CREATE STREAM stocks_under_100 WITH (KAFKA_TOPIC='stocks_under_100', PARTITIONS=10, REPLICAS=3) AS SELECT * FROM stocks WHERE (price <= 100);
CREATE STREAM stocks_buy WITH (KAFKA_TOPIC='stocks_buy', PARTITIONS=10, REPLICAS=3) AS SELECT * FROM stocks WHERE side='BUY';
CREATE STREAM stocks_sell WITH (KAFKA_TOPIC='stocks_sell', PARTITIONS=10, REPLICAS=3) AS SELECT * FROM stocks WHERE side='SELL';
CREATE TABLE STOCKS_TABLE (MyKey String Primary Key) WITH (KAFKA_TOPIC='stocks', VALUE_FORMAT='AVRO');
CREATE TABLE QUERYABLE_STOCKS_TABLE AS SELECT * FROM STOCKS_TABLE;