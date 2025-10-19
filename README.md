# README — Neo4j Migration Assignment

**Course assignment**: Group Assessment — Neo4j Graph Database Migration

**Purpose**: This README explains the deliverables, assumptions, file structure, and step‑by‑step instructions for migrating the group's relational (EER) database into Neo4j, implementing the graph model, running Cypher import scripts, creating indexes, executing analytical algorithms from Neo4j Graph Data Science (GDS), and running example queries.

---

## 1. Project overview

Our group previously designed and implemented a relational/EER model for the company's data (Assessment 2). This assignment translates that model into a Neo4j graph model, migrates the existing relational CSV data into Neo4j, and demonstrates query & analytics use cases using Cypher and the Graph Data Science Library (GDSL).


## 2. Repository / file structure (expected)

```
/assignment_neo4j/
├─ README_Neo4j_Migration_Assignment.md   <- this file
├─ model_diagrams/
│  └─ neo4j_data_model.png                <- graph model diagram (exported image)
├─ csv/                                   <- CSV exports from relational DB
│  ├─ Customers.csv
│  ├─ Orders.csv
│  ├─ Products.csv
│  ├─ Employees.csv
│  └─ ...
├─ cypher/
│  ├─ 00_create_constraints_indexes.cypher
│  ├─ 01_load_nodes.cypher
│  ├─ 02_load_relationships.cypher
│  ├─ 03_sample_queries.cypher
│  ├─ 04_gds_centrality.cypher
│  └─ 05_gds_similarity.cypher
├─ results/
│  ├─ query_results_sample.txt
│  └─ gds_results_sample.csv
└─ report/
   └─ final_report.pdf
```

> Adjust filenames to match your actual CSV table names exported from Assessment 2. The `csv/` folder must contain header rows matching the fields used in the Cypher scripts.

---

## 3. Graph modelling (high level)

1. **Nodes** represent the major entity types from the relational model (e.g., `:Customer`, `:Order`, `:Product`, `:Employee`, `:Category`, `:Location`).
2. **Relationships** represent business associations and foreign keys (e.g., `(:Customer)-[:PLACED]->(:Order)`, `(:Order)-[:CONTAINS]->(:Product)`, `(:Employee)-[:SERVES]->(:Customer)`).
3. **Properties** on nodes should include stable identifiers (e.g., `customer_id`, `order_id`) and frequently queried attributes.
4. **When to change the relational design**: consider denormalizing where join-heavy queries are frequent (e.g., embedding `address` fields into `:Customer` nodes rather than a separate `:Address` node) — document tradeoffs.

Place an exported diagram `neo4j_data_model.png` in `model_diagrams/` — show node labels, relationship types, and important properties. Only include the schema (not the entire data graph).

## 9. Justification & design notes (short)

* **Why Neo4j?** Graph databases model relationships directly; they excel at connected-data queries (path-finding, recommendations, social-style queries) and scale for many graph analytics.
* **Schema changes**: Denormalize small lookup tables that cause expensive joins. Convert many-to-many join tables into relationship nodes/relationships with properties (like `OrderItem` → `(:Order)-[:CONTAINS {quantity, price}]->(:Product)`).
* **Performance tips**: Create constraints/indexes on frequently matched properties; use `MERGE` carefully; batch CSV imports to avoid transaction memory blowouts.

---

## 10. How to run everything (minimal steps)

1. Place CSV files in Neo4j `import` directory or update file URIs in scripts.
2. Start Neo4j Desktop / Aura / Server and ensure version supports GDS plugin.
3. Execute scripts in this order using `cypher-shell` or Neo4j Browser:

   * `00_create_constraints_indexes.cypher`
   * `01_load_nodes.cypher`
   * `02_load_relationships.cypher`
   * `03_sample_queries.cypher` (to run queries and capture results)
   * `04_gds_centrality.cypher` and `05_gds_similarity.cypher` (GDS analytics)
4. Export results from Browser or using `CALL apoc.export.csv.query(...)` if APOC is available.

---

## 11. Citations & references

* Neo4j Graph Data Science documentation: [https://neo4j.com/docs/graph-data-science/current/](https://neo4j.com/docs/graph-data-science/current/)
* Neo4j CSV import docs: [https://neo4j.com/docs/operations-manual/current/tools/csv-import/](https://neo4j.com/docs/operations-manual/current/tools/csv-import/)

---

## Appendix A — Example CSV header snippets

**Customers.csv**:

```
customer_id,first_name,last_name,email,city,state
C123,Alice,Smith,alice@example.com,Sydney,NSW
```

**Orders.csv**:

```
order_id,customer_id,order_date,total_amount
O1001,C123,2024-09-14,125.50
```

**OrderItems.csv**:

```
order_id,product_id,quantity,unit_price
O1001,P200,2,45.00
