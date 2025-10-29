-- Query 2: Optimized query (after refactoring)
WITH booking_data AS (
    SELECT 
        b.booking_id,
        b.check_in_date,
        b.check_out_date,
        b.total_amount,
        b.booking_status,
        b.created_at as booking_created,
        b.user_id,
        b.property_id
    FROM bookings b
    WHERE b.booking_status IN ('confirmed', 'completed')
    ORDER BY b.created_at DESC
    LIMIT 1000
)
SELECT 
    bd.booking_id,
    bd.check_in_date,
    bd.check_out_date,
    bd.total_amount,
    bd.booking_status,
    bd.booking_created,
    
    -- User details (only essential fields)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.country,
    u.user_type,
    
    -- Property details (essential fields only)
    p.property_id,
    p.title as property_title,
    p.property_type,
    p.room_type,
    p.bedrooms,
    p.bathrooms,
    p.max_guests,
    p.price_per_night,
    p.city,
    p.state,
    p.country as property_country,
    
    -- Host details (minimal information)
    host.user_id as host_id,
    host.first_name as host_first_name,
    host.last_name as host_last_name,
    
    -- Payment details (only if needed)
    pay.payment_id,
    pay.amount as payment_amount,
    pay.payment_method,
    pay.payment_status
FROM booking_data bd
-- Use indexed joins
JOIN users u ON bd.user_id = u.user_id
JOIN properties p ON bd.property_id = p.property_id
JOIN users host ON p.host_id = host.user_id
LEFT JOIN payments pay ON bd.booking_id = pay.booking_id
ORDER BY bd.booking_created DESC;

-- Query 3: Further optimized for specific use cases
-- If you only need recent active bookings with minimal data
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.booking_status,
    u.first_name || ' ' || u.last_name as guest_name,
    u.email as guest_email,
    p.title as property_title,
    p.city as property_city,
    host.first_name || ' ' || host.last_name as host_name,
    pay.payment_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN users host ON p.host_id = host.user_id
LEFT JOIN payments pay ON b.booking_id = pay.booking_id
WHERE b.created_at >= CURRENT_DATE - INTERVAL '30 days'
    AND b.booking_status IN ('confirmed', 'completed')
ORDER BY b.created_at DESC
LIMIT 500;
