# Terraform Streaming Governance Demo



## Introduction
This repository deploys a Confluent Cloud cluster with a Datagen source connector and ksqlDB queries to create an example dataflow for Confluent's [Stream Governance Tutorial](https://docs.confluent.io/cloud/current/stream-governance/stream-lineage.html#tutorial)

We use Confluent's 
[terraform provider](https://github.com/confluentinc/terraform-provider-confluent) 
to deploy these components on the Confluent Cloud:

* Kafka cluster
* Kafka connect and Datagen source connector
* ksqlDB cluster

We use the
[```ksql-migrations```](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool)
tool to deploy the queries which create the dataflow described in the tutorial. 

## Getting Started

Clone the repository, initialize terraform, and initialize the terraform variables
```
git clone https://github.com/phy2000/tf-governance-demo tf-governance-demo
cd tf-governance-demo
terraform init
cp terraform.tfvars.template terraform.tfvars
```
* Edit ```terraform.tfvars``` and add a Cloud API key and secret with OrgAdmin rolebinding
  * You may also use one of the alternate variable assignment methods described [here](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).

* Build the kafka cluster, ksql cluster, and connectors
  * ```terraform apply```
* Create the ```ksql-migrations.properties``` file
  * ```terraform output -raw ksql-properties > ksql-governance-demo/ksql-migrations.properties```
* Initialize ksql-migrations
  *  No need to run ```ksql-migrations new-project```
  * The properties file and project subdirectories are created already.
* Setup the ksql-migrations metadata
  *  ```ksql-migrations -c ksql-governance-demo/ksql-migrations.properties initialize-metadata```
* Create the streams for the tutorial
  * ```ksql-migrations -c ksql-governance-demo/ksql-migrations.properties apply -v 1```

## References
### KSQL Migrations 
[ksql-migrations tool](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool)

#### Subcommands
```
usage: ksql-migrations [ {-c | --config-file} <config-file> ] <command> [ <args> ]

Commands are:
    apply                 Migrates the metadata schema to a new schema version.
    create                Creates a blank migration file with the specified description, which can then be populated with ksqlDB statements and applied as the next schema version.
    destroy-metadata      Destroys all ksqlDB server resources related to migrations, including the migrations metadata stream and table and their underlying Kafka topics. WARNING: this is not reversible!
    help                  Display help information
    info                  Displays information about the current and available migrations.
    initialize-metadata   Initializes the migrations schema metadata (ksqlDB stream and table) on the ksqlDB server.
    new-project           Creates a new migrations project directory structure and config file.
    validate              Validates applied migrations against local files.

See 'ksql-migrations help <command>' for more information on a specific
command.
```


### Links

* [Confluent Terraform Provider with examples](https://github.com/confluentinc/terraform-provider-confluent)

* [Sample Project for Confluent Terraform Provider](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/guides/sample-project)

* [Stream Governance Tutorial](https://docs.confluent.io/cloud/current/stream-governance/stream-lineage.html#tutorial)

* [ksql-migrations tool](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool)

* [Terraform Sensitive Output](https://support.hashicorp.com/hc/en-us/articles/5175257151891-How-to-output-sensitive-data-with-Terraform)