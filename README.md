# dbt\_project

This repository contains a modular, multi-layered [dbt](https://docs.getdbt.com/) project designed to transform and model data in a Snowflake data warehouse using the medallion architecture: **raw → intermediate → marts**.

---

##  Project Structure

```bash
.
dbt_project/
├── models/
│   ├── raw/             # Base seed tables (ingested from CSVs)
│   ├── intermediate/    # Cleansed data
│   └── marts/           # Final analytics-ready marts (facts and dims)
├── seeds/               # Source CSV data files
├── macros/              # Custom Jinja macros
├── tests/               # Generic and singular tests
├── snapshots/           # (Optional) Snapshots for SCD
├── dbt_project.yml      # Project configuration
├── CONTRIBUTING.md      # Contribution guidelines
└── README.md
```

---

##  Layers

* **Raw**: Seeded data from CSVs loaded into the `raw` schema.
* **intermediate**: Cleansed data models from the `raw` schema.
* **marts**: Analytical marts and reporting models (e.g., `fact_sales`, `dim_products`).

---

##  Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/techacct/dbt_project.git
cd dbt_project
```

### 2. Set up Your Profile

Edit `~/.dbt/profiles.yml`:

```yaml
dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password>
      role: <your_role>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: public  # Default, overridden in model configs
      threads: 4
```

### 3. Install Dependencies (if needed)


### 4. Load Raw Seed Data

```bash
dbt seed --full-refresh
```

### 5. Run All Models

```bash
dbt run
```

### 6. View Lineage Graph

```bash
dbt docs generate
```

```bash
dbt docs serve
```

Then visit: [http://localhost:8080](http://localhost:8080)

![Lineage Graph Screenshot](docs/images/dbt_lineage_example.png)

---

##  Key Models

| Layer  | Model Name          | Description                                   |
| ------ | ------------------- | --------------------------------------------- |
| intermediate | int\_\_sales\_details | Sales transactions with customer/product keys |
| marts   | dim\_products       | Product dimension with category joins         |
| marts   | dim\_customers      | Customer dimension table                      |
| marts   | fact\_sales         | Fact table with sales metrics                 |

---

##  Testing & Validation

* Tests live in `/tests/` and `schema.yml` files
* Types include `unique`, `not_null`, `accepted_values`
* Use `dbt test` to validate model outputs

```bash
dbt test
```

---

##  Seeds

All CSV files are located in the `seeds/` folder:

* `sales_details.csv`
* `cust_info.csv`
* `prd_info.csv`
* `PX_CAT_G1V2.csv`
* and others...

They are configured to load into the `raw` schema in `dbt_project.yml`:

```yaml
seeds:
  dbt_project:
    +schema: raw
    +quote_columns: false
```

---
