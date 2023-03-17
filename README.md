# Terraform Streaming Governance Demo

https://github.com/confluentinc/terraform-provider-confluent



## References
### KSQL Migrations 
The ksql-migrations tool supports migrations files containing the following types of ksqlDB statements:

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
[Sample Project for Confluent Terraform Provider](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/guides/sample-project)

[Stream Governance Tutorial](https://docs.confluent.io/cloud/current/stream-governance/stream-lineage.html#tutorial)

[ksql-migrations tool](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool)