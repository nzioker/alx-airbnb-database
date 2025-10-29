# Database Performance Monitoring and Refinement Report

## Executive Summary
This document outlines the continuous performance monitoring process for the Airbnb database, identifying bottlenecks in frequently used queries, and implementing optimizations to improve overall system performance.

## Monitoring Methodology

### Tools Used
- **EXPLAIN ANALYZE** - Detailed query execution analysis
- **SHOW PROFILE** - MySQL query profiling (if applicable)
- **pg_stat_statements** - PostgreSQL query statistics
- **Index usage statistics** - Monitor index effectiveness
- **Table statistics** - Analyze data distribution

### Key Performance Indicators
- Query execution time
- Rows scanned vs rows returned
- Buffer hits vs disk reads
- Index usage effectiveness
- Join performance

---

## Frequently Used Queries Analysis

### Query 1: Property Search with Filters

#### Original Query
```sql
-- Property search with multiple filters
EXPLAIN (ANALYZE, BUFFERS, COSTS, VERBOSE)
SELECT 
    p.property_id,
    p.title,
    p.property_type,
    p.room_type,
    p.bedrooms,
    p.bathrooms,
    p.price_per_night,
    p.city,
    p.rating,
    COUNT(r.review_id) as review_count,
    AVG(r.rating) as avg_rating
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
WHERE p.city = 'New York'
    AND p.property_type = 'apartment'
    AND p.bedrooms >= 1
    AND p.bathrooms >= 1
    AND p.price_per_night BETWEEN 50 AND 200
    AND p.status = 'active'
GROUP BY p.property_id, p.title, p.property_type, p.room_type, 
         p.bedrooms, p.bathrooms, p.price_per_night, p.city, p.rating
HAVING AVG(r.rating) >= 4.0 OR AVG(r.rating) IS NULL
ORDER BY p.rating DESC, p.price_per_night ASC
LIMIT 20;
