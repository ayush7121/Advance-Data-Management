# README — Neo4j Migration Assignment

**Course assignment**: Group Assessment — Neo4j Graph Database Migration

**Purpose**: This README explains the deliverables, assumptions, file structure, and step‑by‑step instructions for migrating the group's relational (EER) database into Neo4j, implementing the graph model, running Cypher import scripts, creating indexes, executing analytical algorithms from Neo4j Graph Data Science (GDS), and running example queries.

---

## 1. Project overview

Your group previously designed and implemented a relational/EER model for the company's data (Assessment 2). This assignment translates that model into a Neo4j graph model, migrates the existing relational CSV data into Neo4j, and demonstrates query & analytics use cases using Cypher and the Graph Data Science Library (GDSL).

You are free to adjust the relational model when converting to graph — any change must be documented and justified in the final report (see **Justification** section).

---

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

---

## 4. Cypher scripts (how to run)

> These example commands assume Neo4j 4.x/5.x running locally and that CSV files are placed in the `import` directory accessible to Neo4j.

### 4.1 Create indexes & constraints

`cypher/00_create_constraints_indexes.cypher` (example):

```cypher
// uniqueness constraints
CREATE CONSTRAINT customer_id_unique IF NOT EXISTS FOR (c:Customer) REQUIRE c.customer_id IS UNIQUE;
CREATE CONSTRAINT order_id_unique IF NOT EXISTS FOR (o:Order) REQUIRE o.order_id IS UNIQUE;
CREATE CONSTRAINT product_id_unique IF NOT EXISTS FOR (p:Product) REQUIRE p.product_id IS UNIQUE;

// indexes for faster lookups
CREATE INDEX customer_name_idx IF NOT EXISTS FOR (c:Customer) ON (c.last_name, c.first_name);
CREATE INDEX product_name_idx IF NOT EXISTS FOR (p:Product) ON (p.name);
```

Run in Neo4j Browser or via `cypher-shell`:

```bash
cypher-shell -u <user> -p <password> < 00_create_constraints_indexes.cypher
```

### 4.2 Import nodes

`cypher/01_load_nodes.cypher` — loads each entity from CSV into nodes:

```cypher
// Customers
LOAD CSV WITH HEADERS FROM 'file:///Customers.csv' AS row
MERGE (c:Customer {customer_id: row.customer_id})
SET c.first_name = row.first_name,
    c.last_name = row.last_name,
    c.email = row.email,
    c.city = row.city,
    c.state = row.state;

// Products
LOAD CSV WITH HEADERS FROM 'file:///Products.csv' AS row
MERGE (p:Product {product_id: row.product_id})
SET p.name = row.name,
    p.category = row.category,
    p.price = toFloat(row.price);
```

**Notes**: Cast numeric fields (`toInteger()`, `toFloat()`), parse dates (use `date(row.date)` if ISO format), and `MERGE` on natural key to avoid duplicates.

### 4.3 Import relationships

`cypher/02_load_relationships.cypher` — create relationships using `MATCH` + `MERGE`:

```cypher
// Customer placed Order
LOAD CSV WITH HEADERS FROM 'file:///Orders.csv' AS row
MATCH (c:Customer {customer_id: row.customer_id}), (o:Order {order_id: row.order_id})
MERGE (c)-[:PLACED {order_date: date(row.order_date)}]->(o);

// Order contains Product (order line items CSV may include quantity)
LOAD CSV WITH HEADERS FROM 'file:///OrderItems.csv' AS row
MATCH (o:Order {order_id: row.order_id}), (p:Product {product_id: row.product_id})
MERGE (o)-[r:CONTAINS]->(p)
SET r.quantity = toInteger(row.quantity), r.unit_price = toFloat(row.unit_price);
```

Run these scripts with `cypher-shell` or paste in Neo4j Browser.

---

## 5. Example Cypher query use cases (deliverable #3)

Include four use-cases of increasing complexity. Place them in `cypher/03_sample_queries.cypher` and save results in `results/query_results_sample.txt`.

### Use case A — Simple lookup (single-hop)

**Scenario**: Find a customer by email and list their orders.

```cypher
MATCH (c:Customer {email: 'alice@example.com'})-[:PLACED]->(o:Order)
RETURN c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date
ORDER BY o.order_date DESC LIMIT 10;
```

### Use case B — Aggregation (multi-hop)

**Scenario**: Top 5 products by total quantity sold.

```cypher
MATCH (o:Order)-[r:CONTAINS]->(p:Product)
RETURN p.product_id, p.name, SUM(r.quantity) AS total_sold
ORDER BY total_sold DESC LIMIT 5;
```

### Use case C — Pattern search (medium complexity)

**Scenario**: Find customers who ordered the same product as a particular customer (collaborative interest).

```cypher
MATCH (target:Customer {customer_id:'C123'})-[:PLACED]->(:Order)-[:CONTAINS]->(p:Product)
MATCH (other:Customer)-[:PLACED]->(:Order)-[:CONTAINS]->(p)
WHERE other.customer_id <> target.customer_id
RETURN other.customer_id, other.first_name, other.last_name, collect(DISTINCT p.name) AS shared_products
LIMIT 20;
```

### Use case D — Path finding (complex)

**Scenario**: Shortest path between two customers via shared products or employees.

```cypher
MATCH (a:Customer {customer_id:'C123'}), (b:Customer {customer_id:'C789'})
MATCH p = shortestPath((a)-[*..6]-(b))
RETURN p LIMIT 1;
```

---

## 6. Centrality analytics use case (deliverable #4)

**Objective**: Identify influential customers or hub products using a centrality algorithm (e.g., PageRank or Betweenness). We show PageRank as an example.

`cypher/04_gds_centrality.cypher`:

```cypher
// 1. Create an in-memory graph in GDS
CALL gds.graph.drop('commerceGraph', false) YIELD graphName
CALL gds.graph.create(
  'commerceGraph',
  ['Customer','Order','Product','Employee'],
  {
    PLACED: {orientation: 'UNDIRECTED'},
    CONTAINS: {orientation: 'UNDIRECTED'},
    SERVES: {orientation: 'UNDIRECTED'}
  }
) YIELD graphName, nodeCount, relationshipCount;

// 2. Run PageRank
CALL gds.pageRank.write({
  nodeProjection: ['Customer','Product'],
  relationshipProjection: {
    PLACED: {type: 'PLACED', orientation: 'UNDIRECTED'},
    CONTAINS: {type: 'CONTAINS', orientation: 'UNDIRECTED'}
  },
  maxIterations: 20,
  dampingFactor: 0.85,
  writeProperty: 'pagerank'
}) YIELD nodePropertiesWritten, ranIterations;

// 3. Inspect top results
MATCH (c:Customer)
RETURN c.customer_id, c.first_name, c.last_name, c.pagerank
ORDER BY c.pagerank DESC LIMIT 10;
```

**Deliverables**: include `gds_results_sample.csv` with top-k nodes and their centrality scores and a short analysis interpreting who the hubs are and why.

---

## 7. Similarity analytics use case (deliverable #5)

**Objective**: Find similar products based on customers who bought them using the Node Similarity algorithm (Jaccard / cosine on neighborhoods).

`cypher/05_gds_similarity.cypher`:

```cypher
// Create graph projection (if not already created)
CALL gds.graph.create('prodGraph', ['Product','Customer'], {BOUGHT: {type: 'CONTAINS', orientation: 'UNDIRECTED'}}) YIELD graphName;

// Run node similarity for Product nodes
CALL gds.nodeSimilarity.write({
  nodeProjection: 'Product',
  relationshipProjection: {
    CONTAINS: {type: 'CONTAINS', orientation: 'UNDIRECTED'}
  },
  topK: 5,
  writeProperty: 'sim_products'
}) YIELD nodesCompared, similarityPairsWritten;

// Query similar products
MATCH (p:Product)
RETURN p.product_id, p.name, p.sim_products
LIMIT 20;
```

**Deliverables**: sample CSV of product pairs with similarity scores and a short paragraph recommending how marketing could use this (e.g., cross-sell bundles).

---

## 8. Expected outputs and what to include in the final report

* Diagram of the Neo4j data model (`model_diagrams/neo4j_data_model.png`).
* Cypher scripts used to create constraints, import nodes & relationships (`cypher/*.cypher`).
* Sample CSV files used for import (`csv/`).
* Four Cypher query use cases with explanation and sample outputs (`cypher/03_sample_queries.cypher` + `results/query_results_sample.txt`).
* Centrality and similarity analysis scripts and exported results (`cypher/04_gds_centrality.cypher`, `cypher/05_gds_similarity.cypher`, `results/gds_results_sample.csv`).
* Final written report describing model changes, reasoning, performance tradeoffs, and results (`report/final_report.pdf`).

---

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
```

---

If you want, I can also:

* produce a ready-to-run set of Cypher scripts adapted to your exact CSV column names (just paste your CSV header lines here), or
* generate the Neo4j data model diagram PNG from a small schema spec.

Good luck — team work only, and do not submit individual work.
