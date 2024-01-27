# The ArchiMate® Verifier

A solution that allows verification of ArchiMate® models
against validity statements
and formal data sets, e.g. exports from infrastructure services or business apps.

# Getting started

## Prerequisites

The examples provided below assume
that you have installed and configured
[Docker](https://docs.docker.com/compose/install/)
and [Docker Compose](https://docs.docker.com/compose/install/).

Clone this repository. Make sure that you have following folders and files
in your current folder.
~~~
compose.yaml
compose.ui.yaml
compose.git.yaml
examples/
verification_scripts_sql/
verification_scripts_cql/
~~~

## Basic verifications

We are going to use _Archimate3.2 Reference sheets.archimate_ model by _RemcoSchellekensNS_.
<br/>Download it from
[here on GitHub](https://github.com/RemcoSchellekensNS/Archimate/blob/main/Archimate3.2%20Reference%20sheets.archimate).
<br/>Place the model file in _examples_ folder.

Run following command. 
~~~sh
ARCHI_FOLDER=./examples \
ARCHI_FILE="Archimate3.2 Reference sheets.archimate" \
docker compose run --rm sqlite
~~~

We expect it to produce output as the following.
~~~
Executing verification scripts...
/usr/var/verification_scripts/duplicate-element-names.sql
Error! Duplicate element names:|Artifact|Artifact
Error! Duplicate element names:|Business Object|BusinessObject
Error! Duplicate element names:|dummy|ApplicationService
...
/usr/var/verification_scripts/empty-view.sql
/usr/var/verification_scripts/unused-elements.sql
/usr/var/verification_scripts/unused-relations.sql
Verification completed
~~~

## Capability of leveraging _Neo4j_ graph database and _Cypher Query Language_ (CQL) for verifications  

To test this capability, run following command.
The only difference from the above is that runs _neo4j_ container.
~~~sh
ARCHI_FOLDER=./examples \
ARCHI_FILE="Archimate3.2 Reference sheets.archimate" \
docker compose run --rm neo4j
~~~

This time we expect the output to be like the following.
~~~
Importing the Archimate model to Neo4j...
+--------------------+
| Imported elements: |
+--------------------+
| 165                |
+--------------------+
...

Executing verification scripts...
import/verification_scripts_cql/duplicate-element-names.cypher
Error! Duplicate element names, Type, Name
"id-5b620626cb01470fa03cc24e69cfebf6", "ApplicationService", "dummy"
"id-906aee6b07e443fbbaeca8138c89baa2", "ApplicationService", "dummy"
...
"id-7e8ec9f4f0364a69b1d72ade21f8fa9b", "Artifact", "Artifact"
"id-90bc0d5f23b4479183896557f7a9779c", "Artifact", "Artifact"
"id-fdc89820d2da497493d2896399dc7917", "BusinessObject", "Business Object"
"id-9465b2c8e3484e6b97f9eff0cd16abe4", "BusinessObject", "Business Object"
import/verification_scripts_cql/empty-view.cypher
import/verification_scripts_cql/unused-elements.cypher
Verification completed
~~~

## Verify one of the models you have

Copy your model file to _examples_ folder,
or alternatively, modify ```ARCHI_FOLDER``` variable to point to your model files folder.
<br/>Modify ```ARCHI_FILE``` providing the model's file name.

## Analyze model interactively using SQL queries

Using the previous setup, run following command.
~~~sh
ARCHI_FOLDER=./examples \
ARCHI_FILE="Archimate3.2 Reference sheets.archimate" \
docker compose -f compose.yaml -f compose.ui.yaml run --rm  sqlite
~~~

It is important that we specify ```-f compose.ui.yaml``` which makes the setup run SQLite as interactive shell.
So, expect to see sqlite command prompt waiting for your interactive commands.
~~~
...
Verification completed
SQLite version 3.32.1 2020-05-25 16:19:56
Enter ".help" for usage hints.
sqlite>
~~~

Let's type in following SQL query.
~~~
SELECT e.Name, e.ID
FROM elements e 
JOIN folder_content fc ON fc.ObjectID=e.ID 
JOIN folders f ON f.ID=fc.FolderID
WHERE f.Type="strategy"
  AND e.Name!="";
~~~
With this query we ask it to find all ArchiMate _elements_
that reside in ArchiMate _folders_ of type _strategy_.
(In other words, all elements of _Strategy_ layer of the model.)
(We exclude all element that have empty name as
_Archimate3.2 Reference sheets.archimate_ model has some, and we are not interested in them.)

We expect to see following result.
~~~
Course of Action|id-0bd5f8241c0b428da90329046a7899f8
Resource|id-63ea29e7eba542df8395f96bc17cff26
Capability|id-76c259bd73124d2b9a0382fe6346cb96
Value Stream|id-7a4447848ab846cd843885116ee9d4be
~~~

To exit SQLite shell, type in and "execute" ```.quit``` command.
~~~
sqlite> .quit<Enter>
~~~

In case you are interested in learning more on using SQLite's power,
let we forward you to these two pages:
[_SQL As Understood By SQLite_](https://www2.sqlite.org/lang.html) and [_Special commands to sqlite3 (dot-commands)_](https://www2.sqlite.org/cli.html#special_commands_to_sqlite3_dot_commands_).

## Analyze model interactively using CQL queries

Using the previous setup, run following command.
Similar to the above, but this time we are going to use _Neo4j_ and its _Browser_ web UI.

Run it with this command.
~~~sh
ARCHI_FOLDER=./examples \
ARCHI_FILE="Archimate3.2 Reference sheets.archimate" \
docker compose -f compose.yaml -f compose.ui.yaml run --rm --service-ports neo4j
~~~
It's important the command line has ```--service-ports``` option to make the container's port 7474 available for requests. 

After it's done and has outputted _Verification completed_,
open http://localhost:7474/ in the browser. This is _Neo4j Browser_'s UI.

Copy following CQL query,
then paste it to the UI,
then press _Ctrl-Enter_ to execute it.
~~~cypher
MATCH (n)-[:Archi_LivesIn]->(:Archi_Folder{type:"strategy"})
WHERE NOT n.name=""
RETURN n
~~~

Query result should look like this.
![image](.README.images/00.png) 

Let's try some other query.
~~~cypher
MATCH (n:TechnologyService)-[r]-(e)
WHERE NOT n.name=""
  AND NOT r.name STARTS WITH "Archi_"
RETURN n, e, r
~~~
Semantics of this query is _Find all TechnologyService elements, and show all their relations_.

![image](.README.images/01.png)

# Verify model against "the real world" 

In this example we are going to use model stored in _examples/aws-resources/model.archimate_ file
and list of S3 buckets, we pretend exist in our AWS account, in file _examples/aws-resources/aws-s3-buckets.csv_

(You can easily produce similar output by using following AWS CLI command.)
~~~sh 
aws s3api list-buckets --query "Buckets[].[Name]" --output text
~~~

Let's verify whether our model contains correct representation of the buckets.

The repository has both SQL and CQL versions of the verification scripts.

To execute SQL scripts, run this command.
~~~sh
ARCHI_FOLDER=./examples/aws-resources \
ARCHI_FILE=model.archimate \
ADDITIONAL_DATA_FOLDER=./examples/aws-resources/additional_data \
SQLITE_SCRIPTS_FOLDER=./examples/aws-resources/verification_scripts_sql \
docker compose run --rm sqlite
~~~

This is the output we expect from the verification run:
~~~
Executing verification scripts...
/usr/var/verification_scripts/00-import-data.sql
/usr/var/verification_scripts/01-verify-s3-buckets.sql
Error! Model contains bucket that does not exist:|bucket-in-model
Error! S3 bucket not represented in model:|yet_another_example_bucket
Verification completed
~~~

To execute CQL version of the scripts, run following command.
~~~sh
ARCHI_FOLDER=./examples/aws-resources \
ARCHI_FILE=model.archimate \
ADDITIONAL_DATA_FOLDER=./examples/aws-resources/additional_data \
NEO4J_SCRIPTS_FOLDER=./examples/aws-resources/verification_scripts_cql \
docker compose run --rm neo4j
~~~

The output we expect:
~~~
Executing verification scripts...
import/verification_scripts_cql/00-import-data.cypher
Imported items from aws-s3-buckets.csv:
3
import/verification_scripts_cql/01-verify-s3-buckets.cypher
Error!
"S3 bucket not represented in model:  yet_another_example_bucket"
"Model contains bucket that does not exist:  bucket-in-model"
Verification completed
~~~

# Usage

This is summary of command line syntax:
~~~
docker compose [-f compose.yaml [-f compose.ui.yaml] [-f compose.git.yaml]] run [--service-ports] --rm sqlite|neo4j
~~~

There are four things you leverage to control how this solution behaves:
(1) which container to run;
(2) Compose YAML files;
(3) environment variables;
(4) Docker Compose's command line parameters.

## Which container

```sqlite``` to execute SQL scripts.

```neo4j``` to execute CQL scripts.


## Compose files

```compose.yaml``` configures basic functionality. Always required. You either explicitly specify ```-f compose.yaml```, or provide no ```-f``` parameter letting Docker Compose to default to this file. (Read [this part of Docker Compose's documentation](https://docs.docker.com/compose/reference/#use--f-to-specify-name-and-path-of-one-or-more-compose-files).)

```compose.ui.yaml``` enables _SQLite interactive shell_ or _Neo4j Browser_'s UI (_Neo4j Browser_ also requires providing ```--service-ports``` parameter. See below.)

```compose.git.yaml``` makes the solution read the model from Git repository rather than from _.archimate_ file. (It also requires providing ```GIT_*``` environment variables. See below.)

You can combine ```compose.ui.yaml``` and ```compose.git.yaml``` when you need both features.

In case you provide any of the non-default YAMLs, you need to include ```-f compose.yaml``` explicitly.
<br/>So, full syntax of ```-f``` part of _Docker_ command line looks like this. 
```
[-f compose.yaml [-f compose.ui.yaml] [-f compose.git.yaml] ]
```

## Environment variables

```ARCHI_FOLDER``` Default value is ```.``` (current folder)
<br/>```ARCHI_FILE``` Default value is ```model.archimate```
The solution processes model file with this name you provide in this folder. 
<br/>```ARCHI_FILE2``` (Optional) The second model for model comparison.

```SQLITE_SCRIPTS_FOLDER``` Default value is ```./verification_scripts_sql```
<br/>The solution runs SQL scripts it finds in this folder.
<br/>Regardless to the files' extensions, it treats all files in the folder as SQL scripts.
<br/>The folder can contain subfolders. All subfolders get processed recursively.
It runs the scripts one by one in alphabetical order of subfolder and file names. 

```NEO4J_SCRIPTS_FOLDER``` Default value is ```./verification_scripts_cql```
<br/>The solution runs CQL scripts it finds in this folder.
<br/>Regardless to the files' extensions, it treats all files in the folder as CQL scripts.
<br/>The folder can contain subfolders. All subfolders get processed recursively.
It runs the scripts one by one in alphabetical order of subfolder and file names. 
<br/>```NEO4J_VERSION``` Default value is ```5.15```
<br/>Make Neo4j container run the specified version.

```ADDITIONAL_DATA_FOLDER``` Default value is ```./additional_data```
<br/>Additional data you make available to _Neo4j_ as files in as _import/additional_data_ directory.

(To make ```GIT_*``` variables come to effect, you need to enable support for Git as described above.) 

```GIT_URL``` Maps to  _--modelrepository.cloneModel_ parameter of the Archimate tool's CLI [described here](https://github.com/archimatetool/archi/wiki/Archi-Command-Line-Interface#:~:text=modelrepository).
<br/>```GIT_USER``` Maps to  _--modelrepository.userName_
<br/>```GIT_PASSWORD_FILES_FOLDER``` and ```GIT_PASSWORD_FILE``` map to  _--modelrepository.passFile_

There are several ways how you can provide environment variables to your _docker_ command.
Read this [part of _Docker Compose_'s documentation](https://docs.docker.com/compose/environment-variables/set-environment-variables/)

## Docker CLI parameters

It is recommended to us ```--rm``` parameter to automatically remove the container when it exits.

## Cleaning up temporary Docker volume

There is a volume this solution create. To remove it, run following command.
~~~sh
docker compose rm --volumes
~~~
