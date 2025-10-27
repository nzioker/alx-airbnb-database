-- ------------------------------------------------------------
-- USERS
-- ------------------------------------------------------------
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
('11111111-1111-1111-1111-111111111111', 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw_1', '+254700111111', 'host'),
('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw_2', '+254700222222', 'guest'),
('33333333-3333-3333-3333-333333333333', 'Carol', 'Admin', 'admin@example.com', 'hashed_pw_3', NULL, 'admin');

-- ------------------------------------------------------------
-- PROPERTIES
-- ------------------------------------------------------------
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '11111111-1111-1111-1111-111111111111', 'Seaside Villa', 'A beautiful villa overlooking the ocean.', 'Mombasa, Kenya', 150.00),
('b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', '11111111-1111-1111-1111-111111111111', 'Nairobi Apartment', 'Modern apartment in the city center.', 'Nairobi, Kenya', 90.00),
('c3c3c3c3-c3c3-c3c3-c3c3-c3c3c3c3c3c3', '11111111-1111-1111-1111-111111111111', 'Maasai Mara Camp', 'Safari tent experience near Maasai Mara reserve.', 'Narok, Kenya', 200.00),
('d4d4d4d4-d4d4-d4d4-d4d4-d4d4d4d4d4d4', '11111111-1111-1111-1111-111111111111', 'Lake House', 'Quiet house by the lake for relaxation.', 'Naivasha, Kenya', 120.00);

-- ------------------------------------------------------------
-- BOOKINGS
-- ------------------------------------------------------------
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
('bkg001-bkg0-bkg0-bkg0-bkg000000001', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-2222-2222-2222-222222222222', '2025-02-10', '2025-02-15', 750.00, 'confirmed'),
('bkg002-bkg0-bkg0-bkg0-bkg000000002', 'b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', '22222222-2222-2222-2222-222222222222', '2025-03-05', '2025-03-07', 180.00, 'confirmed'),
('bkg003-bkg0-bkg0-bkg0-bkg000000003', 'c3c3c3c3-c3c3-c3c3-c3c3-c3c3c3c3c3c3', '22222222-2222-2222-2222-222222222222', '2025-04-01', '2025-04-05', 800.00, 'confirmed'),
('bkg004-bkg0-bkg0-bkg0-bkg000000004', 'd4d4d4d4-d4d4-d4d4-d4d4-d4d4d4d4d4d4', '22222222-2222-2222-2222-222222222222', '2025-05-10', '2025-05-12', 240.00, 'pending'),
('bkg005-bkg0-bkg0-bkg0-bkg000000005', 'b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', '22222222-2222-2222-2222-222222222222', '2025-06-20', '2025-06-23', 270.00, 'canceled'),
('bkg006-bkg0-bkg0-bkg0-bkg000000006', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-2222-2222-2222-222222222222', '2025-07-01', '2025-07-04', 450.00, 'confirmed');

-- ------------------------------------------------------------
-- PAYMENTS
-- ------------------------------------------------------------
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
('pay001-pay0-pay0-pay0-pay000000001', 'bkg001-bkg0-bkg0-bkg0-bkg000000001', 750.00, 'credit_card'),
('pay002-pay0-pay0-pay0-pay000000002', 'bkg002-bkg0-bkg0-bkg0-bkg000000002', 180.00, 'paypal'),
('pay003-pay0-pay0-pay0-pay000000003', 'bkg003-bkg0-bkg0-bkg0-bkg000000003', 800.00, 'stripe'),
('pay004-pay0-pay0-pay0-pay000000004', 'bkg004-bkg0-bkg0-bkg0-bkg000000004', 240.00, 'credit_card'),
('pay005-pay0-pay0-pay0-pay000000005', 'bkg005-bkg0-bkg0-bkg0-bkg000000005', 270.00, 'paypal'),
('pay006-pay0-pay0-pay0-pay000000006', 'bkg006-bkg0-bkg0-bkg0-bkg000000006', 450.00, 'stripe');

-- ------------------------------------------------------------
-- REVIEWS
-- ------------------------------------------------------------
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
('rev001-rev0-rev0-rev0-rev000000001', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-2222-2222-2222-222222222222', 5, 'Beautiful villa with a stunning view!'),
('rev002-rev0-rev0-rev0-rev000000002', 'b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', '22222222-2222-2222-2222-222222222222', 4, 'Clean apartment, close to everything.'),
('rev003-rev0-rev0-rev0-rev000000003', 'c3c3c3c3-c3c3-c3c3-c3c3-c3c3c3c3c3c3', '22222222-2222-2222-2222-222222222222', 5, 'Amazing safari experience!'),
('rev004-rev0-rev0-rev0-rev000000004', 'd4d4d4d4-d4d4-d4d4-d4d4-d4d4d4d4d4d4', '22222222-2222-2222-2222-222222222222', 3, 'Nice lake view but a bit far from shops.'),
('rev005-rev0-rev0-rev0-rev000000005', 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-2222-2222-2222-222222222222', 4, 'Second visit! Still lovely.'),
('rev006-rev0-rev0-rev0-rev000000006', 'b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', '22222222-2222-2222-2222-222222222222', 5, 'Great communication with the host.');

-- ------------------------------------------------------------
-- MESSAGES
-- ------------------------------------------------------------
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
('msg001-msg0-msg0-msg0-msg000000001', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hi Alice, is the Seaside Villa available in February?'),
('msg002-msg0-msg0-msg0-msg000000002', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Hi Bob, yes it is! I’ve reserved it for you.'),
('msg003-msg0-msg0-msg0-msg000000003', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Thanks! Can I check in early?'),
('msg004-msg0-msg0-msg0-msg000000004', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Sure, early check-in is fine.'),
('msg005-msg0-msg0-msg0-msg000000005', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'I loved the villa, thank you!'),
('msg006-msg0-msg0-msg0-msg000000006', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'You’re welcome anytime, Bob!');

-- ------------------------------------------------------------
-- END OF SEED DATA
-- ------------------------------------------------------------
