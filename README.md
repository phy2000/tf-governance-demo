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

### Notice
Running the steps in this repository will create assets and data which generate Confluent billing charges.
The following command will remove the assets built by the demo:
```
terraform destroy
```
---
## Prerequisites
* Confluent Cloud account
* Terraform installed and in your PATH
* ksql-migrations tool installed and in your PATH
  * [Install ksqlDB](https://docs.ksqldb.io/en/latest/operate-and-deploy/installation/installing/)
  * Alternatively, you can [install a Confluent Platform package](https://docs.confluent.io/platform/current/installation/installing_cp/zip-tar.html#install-cp-using-zip-and-tar-archives).
* Confluent CLI installed and in your PATH
  * The cli can be [installed as a standalone command](https://docs.confluent.io/confluent-cli/current/overview.html#getting-started)

## Getting Started

Clone the repository, initialize terraform, and initialize the terraform variables
```
git clone https://github.com/phy2000/tf-governance-demo tf-governance-demo
cd tf-governance-demo
terraform init
cp terraform.tfvars.template terraform.tfvars
```

### Initialize the terraform variables
* Edit ```terraform.tfvars``` and add a Cloud API key and secret.
  * The API key must be associated with a user with OrganizationAdmin role
  * You may also use one of the alternate variable assignment methods described [here](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).

### Create the environment, cluster, topics, service accounts, and API keys
```
# Create the cloud cluster and start generating data:
scripts/01-Terraform-apply.sh

# Generate ksql-governance-demo/ksql-migrations.properties and scripts/env.vars
# Generate scripts/env_variables.env
scripts/02-Terraform-output.sh
```

### Initialize KSQL streams
``` 
# Initialize metadata for ksql-migrations
scripts/03-ksql-migrations.sh
```
### Start consumers
```
# This starts 3 consumers in the background
scripts/04-run-consumers.sh
```
## Use jmx-monitoring-stacks to create grafana dashboard
``` 
git clone https://github.com/confluentinc/jmx-monitoring-stacks $DESTDIR
# This script will copy the cloud environment variables and start
# an instance of grafana
# Follow the directions at the end:
scripts/05-run-monitoring-demo.sh $DESTDIR
```

## End the demos
``` 
# runs terraform destroy and stop.sh to end both demos
scripts/99-end-demo.sh
```
---
## TODO
- Reuse an existing environment
- REST scripts for setting data catalog example properties and tags
---
## Links

* [Confluent Terraform Provider with examples](https://github.com/confluentinc/terraform-provider-confluent)

* [Terraform Provider Reference](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs)

* [Stream Governance Tutorial](https://docs.confluent.io/cloud/current/stream-governance/stream-lineage.html#tutorial)

* [ksql-migrations tool](https://docs.ksqldb.io/en/latest/operate-and-deploy/migrations-tool)

* [Terraform Sensitive Output](https://support.hashicorp.com/hc/en-us/articles/5175257151891-How-to-output-sensitive-data-with-Terraform)

* [Confluent CLI Reference](https://docs.confluent.io/confluent-cli/current/overview.html)
---
## References

### Confluent CLI
``` 
Usage:
  confluent [command]

Available Commands:
  admin           Perform administrative tasks for the current organization.
  api-key         Manage API keys.
  asyncapi        Manage AsyncAPI document tooling.
  audit-log       Manage audit log configuration.
  byok            Manage your keys in Confluent Cloud.
  cloud-signup    Sign up for Confluent Cloud.
  completion      Print shell completion code.
  connect         Manage Kafka Connect.
  context         Manage CLI configuration contexts.
  environment     Manage and select Confluent Cloud environments.
  help            Help about any command
  iam             Manage RBAC and IAM permissions.
  kafka           Manage Apache Kafka.
  ksql            Manage ksqlDB.
  local           Manage a local Confluent Platform development environment.
  login           Log in to Confluent Cloud or Confluent Platform.
  logout          Log out of Confluent Cloud.
  pipeline        Manage Stream Designer pipelines.
  plugin          Manage Confluent plugins.
  price           See Confluent Cloud pricing information.
  prompt          Add Confluent CLI context to your terminal prompt.
  schema-registry Manage Schema Registry.
  service-quota   Look up Confluent Cloud service quota limits.
  shell           Start an interactive shell.
  update          Update the Confluent CLI.
  version         Show version of the Confluent CLI.

Flags:
      --version         Show version of the Confluent CLI.
  -h, --help            Show help for this command.
      --unsafe-trace    Equivalent to -vvvv, but also log HTTP requests and responses which may contain plaintext secrets.
  -v, --verbose count   Increase verbosity (-v for warn, -vv for info, -vvv for debug, -vvvv for trace).

Use "confluent [command] --help" for more information about a command.
```

### KSQL Migrations

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
### Terraform
``` 
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
  ```

