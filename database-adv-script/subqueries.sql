-- Query 1: 
SELECT 
    p.property_id,
    p.title,
    p.property_type,
    p.city,
    p.price_per_night,
    p.rating as property_rating,
    (SELECT AVG(r.rating) 
     FROM reviews r 
     WHERE r.property_id = p.property_id) as calculated_avg_rating
FROM properties p
WHERE p.property_id IN (
    -- Non-correlated subquery: runs independently first
    SELECT r.property_id
    FROM reviews r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
AND p.status = 'active'
ORDER BY calculated_avg_rating DESC;



-- Query 2: 
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_type,
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) as total_bookings
FROM users u
WHERE (
    -- Correlated subquery: references outer query (u.user_id)
    SELECT COUNT(*) 
    FROM bookings b 
    WHERE b.user_id = u.user_id
    AND b.booking_status IN ('confirmed', 'completed')
) > 3
ORDER BY total_bookings DESC;

