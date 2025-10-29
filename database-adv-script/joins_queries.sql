-- Query 1: 
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.booking_status,
    b.created_at as booking_created,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone,
    u.country,
    u.user_type
    
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
WHERE b.booking_status IN ('confirmed', 'completed')
ORDER BY b.created_at DESC
LIMIT 100;

-- Query 2: LEFT JOIN - All properties and their reviews (including properties with no reviews)
SELECT 
    p.property_id,
    p.title,
    p.property_type,
    p.city,
    p.state,
    p.country,
    p.price_per_night,
    p.rating as property_rating,
    p.status,
    
    -- Review details (will be NULL if no reviews)
    r.review_id,
    r.rating as review_rating,
    r.comment,
    r.created_at as review_date,
    
    -- Reviewer information
    u.user_id as reviewer_id,
    u.first_name as reviewer_first_name,
    u.last_name as reviewer_last_name
    
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
LEFT JOIN users u ON r.user_id = u.user_id
WHERE p.status = 'active'
ORDER BY p.property_id, r.created_at DESC;


-- Query 3: FULL OUTER JOIN - All users and all bookings

SELECT 
    COALESCE(u.user_id, b.user_id) as user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_type,
    u.created_at as user_created,
    
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.booking_status,
    b.created_at as booking_created,
    
    -- Flag to identify data anomalies
    CASE 
        WHEN u.user_id IS NULL THEN 'Booking without user'
        WHEN b.booking_id IS NULL THEN 'User without booking'
        ELSE 'User with booking'
    END as data_status
    
FROM users u
FULL OUTER JOIN bookings b ON u.user_id = b.user_id
ORDER BY 
    CASE 
        WHEN u.user_id IS NULL THEN 1
        WHEN b.booking_id IS NULL THEN 2
        ELSE 3
    END,
    u.user_id, 
    b.booking_id;
