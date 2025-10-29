-- Step 1: Create the master table with same structure but no data
CREATE TABLE bookings_partitioned (
    booking_id SERIAL,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    guests_count INTEGER DEFAULT 1,
    special_requests TEXT,
    CONSTRAINT bookings_partitioned_pkey PRIMARY KEY (booking_id, check_in_date)
) PARTITION BY RANGE (check_in_date);

-- Step 2: Create partitions for different time periods
-- Partition for historical data (before 2023)
CREATE TABLE bookings_historical PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2000-01-01') TO ('2023-01-01');

-- Partition for 2023 data
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for 2024 data
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for 2025 data
CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition for future bookings (2026 and beyond)
CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2100-01-01');

-- Step 3: Create indexes on partitioned table for better performance
CREATE INDEX idx_bookings_partitioned_check_in ON bookings_partitioned(check_in_date);
CREATE INDEX idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_partitioned_status ON bookings_partitioned(booking_status);
CREATE INDEX idx_bookings_partitioned_created ON bookings_partitioned(created_at);
CREATE INDEX idx_bookings_partitioned_user_date ON bookings_partitioned(user_id, check_in_date);

-- Step 4: Migrate data from original bookings table to partitioned table
-- Note: This might take time for large tables. Consider doing it during maintenance window.
INSERT INTO bookings_partitioned 
SELECT * FROM bookings;

-- Step 5: Verify data distribution across partitions
SELECT 
    tableoid::regclass AS partition_name,
    count(*) AS row_count
FROM bookings_partitioned 
GROUP BY partition_name 
ORDER BY partition_name;

-- Step 6: Create a function to automatically create new partitions
CREATE OR REPLACE FUNCTION create_booking_partition()
RETURNS void AS $$
DECLARE
    current_year INTEGER;
    next_year INTEGER;
    partition_start DATE;
    partition_end DATE;
    partition_name TEXT;
BEGIN
    current_year := EXTRACT(YEAR FROM CURRENT_DATE);
    next_year := current_year + 1;
    
    partition_start := to_date(current_year::text || '-01-01', 'YYYY-MM-DD');
    partition_end := to_date(next_year::text || '-01-01', 'YYYY-MM-DD');
    partition_name := 'bookings_' || current_year::text;
    
    -- Check if partition already exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_class 
        WHERE relname = partition_name 
        AND relkind = 'r'
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF bookings_partitioned FOR VALUES FROM (%L) TO (%L)',
            partition_name, partition_start, partition_end
        );
        RAISE NOTICE 'Created partition: %', partition_name;
    ELSE
        RAISE NOTICE 'Partition % already exists', partition_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Step 7: Create a monthly partition strategy for more granular partitioning (Optional)
-- Uncomment if you need monthly partitions for very high-volume data
/*
CREATE TABLE bookings_partitioned_monthly (
    LIKE bookings_partitioned INCLUDING ALL
) PARTITION BY RANGE (check_in_date);

-- Create monthly partitions for current year
DO $$
DECLARE
    month_start DATE;
    month_end DATE;
    partition_name TEXT;
BEGIN
    FOR i IN 0..11 LOOP
        month_start := date_trunc('month', CURRENT_DATE) + (i || ' months')::interval;
        month_end := month_start + '1 month'::interval;
        partition_name := 'bookings_' || to_char(month_start, 'YYYY_MM');
        
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF bookings_partitioned_monthly FOR VALUES FROM (%L) TO (%L)',
            partition_name, month_start, month_end
        );
    END LOOP;
END $$;
*/

-- Step 8: Update foreign key constraints if they exist
-- Note: You may need to drop and recreate foreign keys to reference the partitioned table

-- Step 9: Create views for backward compatibility if needed
CREATE OR REPLACE VIEW bookings AS
SELECT * FROM bookings_partitioned;

-- Step 10: Test queries on partitioned table
-- Query to test partition pruning
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) 
FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2024-03-01' AND '2024-03-31';

-- Query to test performance with joins
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_amount,
    u.first_name,
    u.last_name,
    p.title as property_title
FROM bookings_partitioned b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.check_in_date BETWEEN '2024-01-01' AND '2024-12-31'
    AND b.booking_status = 'confirmed'
ORDER BY b.check_in_date;

-- Performance Test Queries

-- Test 1: Date range query on original table (if still exists)
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) 
SELECT COUNT(*) 
FROM bookings 
WHERE check_in_date BETWEEN '2024-03-01' AND '2024-03-31';

-- Test 2: Date range query on partitioned table
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) 
SELECT COUNT(*) 
FROM bookings_partitioned 
WHERE check_in_date BETWEEN '2024-03-01' AND '2024-03-31';

-- Test 3: Complex query with joins on original table
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_amount,
    u.first_name,
    u.last_name
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE b.check_in_date BETWEEN '2024-01-01' AND '2024-06-30'
    AND b.booking_status = 'confirmed'
ORDER BY b.check_in_date;

-- Test 4: Complex query with joins on partitioned table
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_amount,
    u.first_name,
    u.last_name
FROM bookings_partitioned b
JOIN users u ON b.user_id = u.user_id
WHERE b.check_in_date BETWEEN '2024-01-01' AND '2024-06-30'
    AND b.booking_status = 'confirmed'
ORDER BY b.check_in_date;

-- Test 5: Aggregation query on original table
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT 
    DATE_TRUNC('month', check_in_date) as month,
    COUNT(*) as booking_count,
    AVG(total_amount) as avg_amount
FROM bookings
WHERE check_in_date BETWEEN '2023-01-01' AND '2024-12-31'
    AND booking_status = 'completed'
GROUP BY DATE_TRUNC('month', check_in_date)
ORDER BY month;

-- Test 6: Aggregation query on partitioned table
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT 
    DATE_TRUNC('month', check_in_date) as month,
    COUNT(*) as booking_count,
    AVG(total_amount) as avg_amount
FROM bookings_partitioned
WHERE check_in_date BETWEEN '2023-01-01' AND '2024-12-31'
    AND booking_status = 'completed'
GROUP BY DATE_TRUNC('month', check_in_date)
ORDER BY month;
