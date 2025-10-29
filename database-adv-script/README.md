# SQL Subqueries: Correlated vs Non-Correlated

This document demonstrates the implementation and differences between correlated and non-correlated subqueries in SQL, specifically applied to the Airbnb database schema.

## 📊 Subquery Types Explained

### Non-Correlated Subqueries
- **Execution**: Runs independently first, then passes result to main query
- **Dependency**: No reference to outer query columns
- **Performance**: Generally faster, executes once
- **Use Case**: When you need to filter based on a pre-calculated set of values

### Correlated Subqueries
- **Execution**: Runs once for each row in the main query
- **Dependency**: References columns from the outer query
- **Performance**: Can be slower for large datasets
- **Use Case**: When the subquery condition depends on each individual row

## 🔍 Key Queries

### 1. Non-Correlated Subquery: High-Rated Properties
Finds properties with average ratings greater than 4.0 using an independent subquery.

```sql
SELECT p.property_id, p.title, p.city
FROM properties p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM reviews r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

## 🗄️ Database Schema
The analysis is based on an Airbnb clone database with the following key tables:
- `users` - User information (hosts and guests)
- `properties` - Property listings with details
- `bookings` - Reservation records
- `reviews` - Guest reviews and ratings

## 📈 SQL Queries

### 1. User Booking Analysis (`user_booking_analysis.sql`)

**Objective**: Analyze user booking behavior and spending patterns.

**Key Metrics**:
- Total bookings per user
- Total amount spent
- Average booking value
- First and last booking dates

**Business Use Cases**:
- Identify most valuable customers (power users)
- Understand user booking frequency
- Segment users based on spending behavior
- Target marketing campaigns to frequent bookers

**Sample Insights**:
- Top 10 users by number of bookings
- Users with highest total spending
- Average booking value across user segments

### 2. Property Performance Ranking (`property_ranking_analysis.sql`)

**Objective**: Rank properties based on popularity and performance metrics.

**Key Features**:
- **Overall Ranking**: Properties ranked by total bookings
- **Category Ranking**: Properties ranked within their type (apartment, house, etc.)
- **Geographic Ranking**: Properties ranked within their city
- **Revenue Analysis**: Properties ranked by total revenue generated

**Window Functions Used**:
- `ROW_NUMBER()` - Unique sequential ranking
- `RANK()` - Ranking with gaps for ties
- `DENSE_RANK()` - Ranking without gaps for ties
- `PARTITION BY` - Ranking within categories

**Business Use Cases**:
- Identify most popular properties
- Benchmark property performance against competitors
- Help hosts understand their market position
- Inform pricing and marketing strategies

## 🛠️ SQL Techniques Demonstrated

### Aggregation Functions
- `COUNT()` - Count number of bookings
- `SUM()` - Calculate total revenue
- `AVG()` - Compute average values
- `MIN()/MAX()` - Find date ranges

### Window Functions
- `ROW_NUMBER()` - Assign unique ranks
- `RANK()` - Handle tied rankings with gaps
- `DENSE_RANK()` - Handle tied rankings without gaps
- `PARTITION BY` - Create ranking groups

### SQL Clauses
- `GROUP BY` - Group data for aggregation
- `HAVING` - Filter grouped results
- `JOIN` - Combine data from multiple tables
- `OVER()` - Define window for calculations

## 📊 Expected Output Examples

### User Booking Analysis Output
```
user_id | user_name       | user_type | total_bookings | total_spent | avg_booking_value
--------|-----------------|-----------|----------------|-------------|------------------
123     | John Smith      | guest     | 15             | $4,500      | $300
456     | Maria Garcia    | guest     | 12             | $3,200      | $267
```

### Property Ranking Output
```
property_id | title          | city    | total_bookings | overall_rank | rank_in_type
-----------|---------------|---------|----------------|-------------|-------------
789       | Beach Villa    | Miami   | 45             | 1           | 1
101       | City Loft      | NYC     | 42             | 2           | 1
```

