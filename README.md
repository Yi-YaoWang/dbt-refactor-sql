# `dbt-macros-packages` Quickstart

[![Generic badge](https://img.shields.io/badge/dbt-1.8.8-blue.svg)](https://docs.getdbt.com/dbt-cli/cli-overview)
[![Generic badge](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)
[![Generic badge](https://img.shields.io/badge/Python-3.11.10-blue.svg)](https://www.python.org/)
[![Generic badge](https://img.shields.io/badge/Podman-5.0.2-blue.svg)](https://www.docker.com/)

This is a `dbt-macros-packages` quickstart template, that supports PostgreSQL run with podman. This turtorial assumed viewer has basic DBT and Jinja knowledge. If not please have these lessons first.
  - [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template)
  - [Jinja2-101-template](https://github.com/saastool/jinja2-101)
  
  This `dbt-macros-packages` quickstart taken from the various [dbt Developer Hub](https://docs.getdbt.com/guides/using-jinja) and the infrastructure is based on [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template), using `PostgreSQL` as the data warehouse. 

  If you have finished dbt-core-quickstart-template before, the infrastructure and architect we using here are total the same. That is to say, you can skip directly to [Step 3 Create a project​](#3-create-a-project)

- [`dbt-core` Quickstart](#dbt-core-quickstart)
- [Steps](#steps)
  - [1 Introduction​](#1-introduction)
  - [2 Create a repository and env prepare​](#2-create-a-repository-and-env-prepare)
  - [3 Create a project​](#3-create-a-project)
  - [4 Connect to PostgreSQL​](#4-connect-to-postgresql)
  - [5 Build Basic Model](#5-build-basic-model)
  - [6 Use a for loop in models for repeated SQL​](#6-use-a-for-loop-in-models-for-repeated-sql)
  - [7 Set Variables​](#7-set-variables)
  - [8 Build models on top of other models​​](#8-build-your-models-on-top-of-other-models)
  - [9 Use whitespace control to tidy up compiled code​](#9-use-whitespace-control-to-tidy-up-compiled-code)
  - [10 Use a macro to return payment methods​](#10-use-a-macro-to-return-payment-methods)
  - [11 Dynamically retrieve the list of payment methods](#11-dynamically-retrieve-the-list-of-payment-methods)
  - [12 Write modular macros](#12-write-modular-macros)
  - [13 Use a macro from a package​](#13-use-a-macro-from-a-package)

# Steps

## [1 Introduction​](https://docs.getdbt.com/guides/manual-install?step=1)

This template will develop and run dbt commands using the dbt Cloud CLI — a dbt Cloud powered command line with PostgreSQL.

- Prerequisites
  - Python/conda
  - Podman desktop
  - DBeaver
  - git client
  - visual code
  
  - ***Windows***: Path review for conda if VSCode have python runtime issue. Following path needs add and move to higher priority.

  ```
  C:\ProgramData\anaconda3\Scripts
  C:\ProgramData\anaconda3
  ```
  
- Create a GitHub account if you don't already have one.


## [2 Create a repository and env prepare​](https://docs.getdbt.com/guides/manual-install?step=2)

1. Create a new GitHub repository

- Find our Github template repository [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template)
- Click the big green 'Use this template' button and 'Create a new repository'.
- Create a new GitHub repository named **dbt-core-qs-ex1**.

![Click use template](.github/static/use-template.gif)

2. Select Public so the repository can be shared with others. You can always make it private later.
2. Leave the default values for all other settings.
3. Click Create repository.
4. Save the commands from "…or create a new repository on the command line" to use later in Commit your changes.
5. Install and setup envrionment

- Create python virtual env for dbt
  - For venv and and docker, using the [installation instructions](https://docs.getdbt.com/docs/core/installation-overview) for your operating system.
  - For conda in **Mac**, open terminal as usual

    ```command
    (base) ~ % conda create -n jinja 
    (base) ~ % conda activate jinja
    ```
    
  - For conda in **Windows**, open conda prompt terminal in ***system administrador priviledge***

    ```command
    (base) C:> conda create -n dbt dbt-core dbt-postgres
    (base) C:> conda activate dbt
    ```
    
  - ***Windows***: create shortcut to taskbar
    - Find application shortcut location

    ![Start Menu](.github/static/FindApp.png)

    - Copy and rename shortcut to venv name
    - Change location parameter to venv name
    
    ![Change location parameter](.github/static/venv_name.png)

    - Pin the shortcut to Start Menu


- Start up db and pgadmin
  . use admin/Password as connection
  
  - ***Windows***:
    
    ```
    (dbt) C:> cd C:\Proj\myProject\50-GIT\dbt-core-qs-ex1
    (dbt) C:> bin\db-start-pg.bat
    ```
    
  - ***Mac***:
    
    ```
    (dbt) ~ % cd ~/Projects/dbt-macros-packages/
    (dbt) ~ % source ./bin/db-start-pg.sh
    (dbt) ~ % source ./bin/db-pgadm.sh
    ``` 

## [3 Create a project​](https://docs.getdbt.com/guides/manual-install?step=3)

Make sure you have dbt Core installed and check the version using the dbt --version command:

```
dbt --version
```

- Init project in repository home directory
  Initiate the jaffle_shop project using the init command:

```python
dbt init dbt_jinja
```

DBT will configure connection while initiating project, just follow the information below. After initialization, the configuration can be found in `profiles.yml`.

```YAML
dbt_jinja:
  outputs:
    dev:
      dbname: postgres
      host: localhost
      user: admin      
      pass: Passw0rd 
      port: 5432
      schema: dbt_jinja
      threads: 1
      type: postgres
  target: dev
```


Navigate into your project's directory:

```command
cd dbt_jinja
```

Use pwd to confirm that you are in the right spot:

```command
 pwd
```

Use a code editor VSCode to open the project directory

```command
(dbt) ~\Projects\dbt_jinja> code .
```
Let's remove models/example/ directory, we won't use any of it in this turtorial

## [4 Connect to PostgreSQL​](https://docs.getdbt.com/guides/manual-install?step=4)

- Test connection config

```
dbt debug
``` 

- Load sample data
 We should copy this data from the `db/seeds` directory.

  - copy seeds data
  **Windows**
  ```
  copy ..\db\*.csv seeds
  dbt seed
  ```

  **Mac**
  ```
  cp ../db/*.csv seeds
  dbt seed
  ```
  
- Verfiy result in database client
This command will create and insert the `.csv` files to the `dbt_jinja.raw_payments` table

## [5 Build Basic Model](https://docs.getdbt.com/guides/using-jinja?step=2)

- Open your project in your favorite code editor.
- Create a new SQL file in the models directory, named models/**order_payment_method_amounts.sql**.
- Paste the following query into the models/**order_payment_method_amounts.sql** file.

```SQL
select
order_id,
sum(case when payment_method = 'bank_transfer' then amount end) as bank_transfer_amount,
sum(case when payment_method = 'credit_card' then amount end) as credit_card_amount,
sum(case when payment_method = 'gift_card' then amount end) as gift_card_amount,
sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
```

- From the command line, enter

```
dbt run
```

- This SQL sums up each payment method's amount by order. This is basic SQL writting, but with some potential maintainance issues:
  - If the logic or field name were to change, the code would need to be updated in three places.
  - Often this code is created by copying and pasting, which may lead to mistakes.
  - Other analysts that review the code are less likely to notice errors as it's common to only scan through repeated code.

  So let's resolve these issues by applying macros.

## [6 Use a for loop in models for repeated SQL​](https://docs.getdbt.com/guides/using-jinja?step=3)

An intuitive approached for repeated codes is using loop, so let's give it a try:

- Open the compiled SQL file in /target/compiled/dbt_jinja/models/**order_payment_method_amounts.sql**. Use a split screen in the code editor to keep both files open at once to check what Jinja  has compiled.

- Edit models/**order_payment_method_amounts.sql**:
  
```SQL
select
order_id,
{% for payment_method in ["bank_transfer", "credit_card", "gift_card"] %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
{% endfor %}
sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
```

- Enter the dbt run in command-line.

  The compiled SQL should be the same as lest step's SQL, but is much easier to maintained.

## [7 Set Variables​](https://docs.getdbt.com/guides/using-jinja?step=4)

You can now setting variables at the top of a model, as it helps with readability, and enables you to reference the list in multiple places if required. 

- Edit models/**order_payment_method_amounts.sql**:
  
```SQL
{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
{% endfor %}
sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
```

- Enter the dbt run in command-line.

## [8 Build models on top of other models​](https://docs.getdbt.com/guides/using-jinja?step=5)

As the previous query, our last column is outside of the `for` loop. If the last iteration of a loop is our final column, we need to ensure there isn't a trailing comma at the end, or it would cause error. like this:

```SQL
{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
```

However, we can use an `if` statement, along with the Jinja variable `loop.last`, to ensure we don't add an extraneous comma:

```SQL
{% set payment_methods = ["bank_transfer", "credit_card", "gift_card"] %}

select
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{% if not loop.last %},{% endif %}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
```

- Execute dbt run.

## [9 Use whitespace control to tidy up compiled code](https://docs.getdbt.com/guides/using-jinja?step=6)

If you have checked the compiled SQL in the `target/compiled` folder, you might have noticed that this code results in a lot of white space.

Let's git rid of it with whitespace control we have learnt from [Jinja2-101-template](https://github.com/saastool/jinja2-101) in order to tidy up our code:

```SQL
{%- set payment_methods = ["bank_transfer", "credit_card", "gift_card"] -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
```

- Execute dbt run.

## [10 Use a macro to return payment methods](https://docs.getdbt.com/guides/using-jinja?step=7)

Furthermore, we can wrap it up by using a macro in case we want to reuse multiple times in the future. We have practiced macro back in jinja2 101, now let's try using it with DBT.

DBT stored macros in `/macros/` folder, 
- Create a new SQL file in the macros directory, named macros/**get_payment_methods.sql**.
- Paste the following query into the macros/**get_payment_methods.sql** file:

```SQL
{% macro get_payment_methods() %}
{{ return(["bank_transfer", "credit_card", "gift_card"]) }}
{% endmacro %}
```

- Then edit models/**order_payment_method_amounts.sql**:

```SQL
{%- set payment_methods = get_payment_methods() -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
```

- Execute dbt run.

## [11 Dynamically retrieve the list of payment methods](https://docs.getdbt.com/guides/using-jinja?step=8)

The list is actually stored in `raw_payment`. If a new payment_method was introduced, inserted, or one of the existing methods was renamed, the list would need to be updated accordingly. We have to change macro into query.

- Paste the following query into the macros/**get_payment_methods.sql** file:

```SQL
{% macro get_payment_methods() %}

{% set payment_methods_query %}
select distinct
payment_method
from {{ ref('raw_payments') }}
order by 1
{% endset %}

{% set results = run_query(payment_methods_query) %}

{{ log(results, info=True) }}

{{ return([]) }}

{% endmacro %}
```

The easiest way to use a statement is through the `run_query macro`. For the first version, let's check what we get back from the database, by logging the results to the command line using the `log` function.

The command line gives us back the following:

```command
| column         | data_type |
| -------------- | --------- |
| payment_method | Text      |
```

This is an Agate table, a Python Library class. To get the payment methods back as a list, we need to do some further transformation.

```SQL
{% macro get_payment_methods() %}

{% set payment_methods_query %}
select distinct
payment_method
from {{ ref('raw_payments') }}
order by 1
{% endset %}

{% set results = run_query(payment_methods_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}
```

We used the execute variable to ensure that the code runs during the `parse` stage of dbt (otherwise an error would be thrown).

- Execute dbt run.

## [12 Write modular macros](https://docs.getdbt.com/guides/using-jinja?step=9)

The macro looks great now, but what if we want to use a specific part of the macro in the future?

To do that we must seperate macro into modular pieces, this is a very important coding methodology.

- Seperate SQL into macros/**get_column_values.sql** and macros/**get_payment_methods.sql**:

get_column_values.sql
```SQL
{% macro get_column_values(column_name, relation) %}

{% set relation_query %}
select distinct
{{ column_name }}
from {{ relation }}
order by 1
{% endset %}

{% set results = run_query(relation_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}
```

get_payment_methods.sql
```SQL
{% macro get_payment_methods() %}

{{ return(get_column_values('payment_method', ref('raw_payments'))) }}

{% endmacro %}
```

- Execute dbt run.

## [13 Use a macro from a package](https://docs.getdbt.com/guides/using-jinja?step=10)

Another powerful feature macro can do is their ability to be shared across projects. A number of useful dbt macros have already been written in the `dbt-utils` package. Actually the `get_column_values` macro from `dbt-utils` could be used instead of the `get_column_values` macro we wrote ourselves.

Install the `dbt-utils` package in the project.

- Add a file named `packages.yml` in dbt project. This should be at the same level as `dbt_project.yml` file.
- Paste the following query into the `packages.yml` file we just create:

```SQL
packages:
  - git: "https://github.com/dbt-labs/dbt-utils.git"
    revision: 1.3.0
```
`Git` tells DBT where to download the package, and site the git's **tag name** or **branch name** behind `revision`

- Execute `dbt deps`, then dbt would install designated package into ` dbt_packages` directory which is ignore by git in default.

- Paste the following query into the macros/**get_payment_methods.sql** file, in order to update the model to use the macro from the package instead:

```SQL
{%- set payment_methods = dbt_utils.get_column_values(
    table=ref('raw_payments'),
    column='payment_method'
) -%}

select
order_id,
{%- for payment_method in payment_methods %}
sum(case when payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount
{%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ ref('raw_payments') }}
group by 1
```

- Now we can remove the macros that we built in previous steps.

- Execute dbt run.

Our dbt-macros-packages turtorial ends here, we have learnt the potential of jinja with dbt, macro and package. This is just the tip of the iceberg, but it's enough to prepared anyone planning to dive in to any project that use dbt. Much more, if you want to learn more about what else can the packages do, please check in [dbt-util](https://github.com/dbt-labs/dbt-utils).
