# Retail Orders Analysis

Exploratory Data Analysis (EDA) and SQL analytics on a retail orders dataset stored in a PostgreSQL data warehouse.

## Project Overview

This project analyzes retail order data to answer key business questions about revenue, regional sales, sales growth, and profitability. It includes:

- **`orders_analysis.ipynb`** — Python notebook performing EDA and answering 5 analysis questions using `pandas`, `matplotlib`, `seaborn`, and `sqlalchemy`.
- **`sql_code.sql`** — Equivalent analytics implemented as SQL Server queries (window functions, CTEs).
- **`Orders.csv`** — The raw retail orders dataset.
- **`README.md`** — This documentation.

## Data

The dataset (`Orders.csv`) contains 9,426 retail order records across 24 columns (2010–2013), including:

| Column | Description |
|--------|-------------|
| Order Priority, Ship Mode | Order handling metadata |
| Discount, Unit Price, Shipping Cost | Pricing fields |
| Sales, Profit, Quantity ordered new | Financial metrics |
| Product Category, Sub-Category, Name | Product dimensions |
| Region, State or Province, City, Postal Code | Geographic dimensions |
| Customer ID, Name, Segment | Customer dimensions |
| Order Date, Ship Date | Time dimensions |

The data is loaded from a `retail_orders` table in a PostgreSQL database using SQLAlchemy.

## Analysis Questions

1. **Top 10 highest revenue generating products** — product revenue ranked by total `sales`.
2. **Top 5 highest selling products in each region** — per-region product sales ranking using group-wise sorting.
3. **Month-over-month growth comparison (2012 vs 2013)** — same-month sales comparison, e.g. Jan 2012 vs Jan 2013.
4. **Month with highest sales for each category** — best sales month per product category.
5. **Sub-category with highest profit growth (2013 vs 2012)** — fastest-growing sub-category by profit.

## Getting Started

### Prerequisites

- Python 3.12+
- PostgreSQL running locally with a `retail_orders` table loaded
- `%sql` (ipython-sql) extension available

### Installation

```bash
pip install pandas sqlalchemy matplotlib seaborn psycopg2-binary ipython-sql
```

### Running the Notebook

The notebook connects to Postgres via a SQLAlchemy engine. Update the connection string in the notebook if your credentials differ:

```python
engine = create_engine('postgresql://airflow:airflow@localhost/postgres')
```

Then run all cells in `orders_analysis.ipynb`.

## SQL Queries (`sql_code.sql`)

The SQL file provides a SQL Server equivalent for each question using window functions and common table expressions (CTEs). Column names containing spaces are wrapped in square brackets (e.g. `[Product Name]`, `[Order Date]`, `[Product Sub-Category]`).

## Notes / Known Considerations

- Revenue is defined as the `Sales` column (not `Profit`). `Profit` is used only for growth/profitability analysis (Q5).
- The notebook recalculates and reuses a single `sales` column; duplicate recalculations were removed.
- Output cells in the notebook reflect prior runs — re-run the notebook after code changes to refresh results.

## License

[MIT](LICENSE)

© 2025 davidonuna
