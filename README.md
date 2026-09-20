# 📦 Inventory & Supply Chain Analytics

**Database:** PostgreSQL / Standard SQL  
**Focus:** Inventory management, supply chain analytics, and data quality validation.

## 📌 Executive Summary
This project focuses on modeling and querying a relational database designed for supply chain and inventory management. The analytical queries extract critical business insights regarding product consumption patterns, pending requisitions, and anomaly detection in the delivery process.

## 🏗️ Architecture & Data Model

The schema models an end-to-end inventory lifecycle:
1. **`venda` (Sales/Consumption):** Tracks point-of-sale consumption, product pricing, and quantities sold per branch.
2. **`pedido_compra` (Purchase Orders):** Records procurement requests, expected delivery dates, and pending quantities from suppliers.
3. **`entradas_mercadoria` (Goods Receipt):** Logs actual inventory intake via invoices (NFe), received quantities, and unit costs.

## 📊 Analytical Deliverables

### 1. Consumption & Sales Analysis
Aggregates monthly sales volume and total revenue generated per product, providing a baseline for inventory turnover rates.

### 2. Supply Chain Bottlenecks
Identifies products with pending requisitions—orders that have been placed but not yet fully received—highlighting potential supplier delays or fulfillment issues.

### 3. Inventory Anomalies
Detects unconsumed and unreceived products within specific reporting periods, enabling the identification of ghost inventory or procurement inefficiencies.

### 4. High-Demand Requisition Tracking
Transforms and filters purchase order data to isolate high-demand items (requiring more than 10 requests in a given period), concatenating product keys for streamlined reporting.

## 🛡️ Data Quality & Validation Strategy
To ensure executive-level trust in the data, the following validation protocols are established:
- **ETL Integrity Checks:** Validating data completeness throughout the extraction and loading phases.
- **Null & Typology Audits:** Running automated queries to identify null fields and verify column data types.
- **Pre-computed Validation Views:** Utilizing ready-made queries for cross-referencing sales, active orders, and registered products against expected periodic benchmarks.

## 🚀 Quick Start

1. Execute the DDL statements in `inventory_supply_chain_analytics.sql` to generate the schema.
2. Run the grouped analytical queries to extract the necessary supply chain KPIs.
