-- Vô hiệu hóa kiểm tra khóa ngoại để chèn dữ liệu theo lô
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES 'utf8mb4';

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES
(2, NOW(), 'system', 'Đạt mốc 100 điểm', '/uploads/badges/rank_dong.jpg', 'Hạng Đồng', 100, NOW(), 'system'),
(3, NOW(), 'system', 'Đạt mốc 500 điểm', '/uploads/badges/rank_bac.jpg', 'Hạng Bạc', 500, NOW(), 'system'),
(4, NOW(), 'system', 'Đạt mốc 1000 điểm', '/uploads/badges/rank_vang.jpg', 'Hạng Vàng', 1000, NOW(), 'system'),
(5, NOW(), 'system', 'Đạt mốc 5000 điểm', '/uploads/badges/rank_kim_cuong.jpg', 'Kim Cương', 5000, NOW(), 'system');
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;


-- ---------------------------------
-- Bảng 1: Gói cước (plans)
-- (Tạo 10 gói cước khác nhau)
-- ---------------------------------
LOCK TABLES `plans` WRITE;
/*!40000 ALTER TABLE `plans` DISABLE KEYS */;
INSERT INTO `plans` (`id`, `active`, `created_at`, `created_by`, `description`, `duration_in_days`, `name`, `price`, `updated_at`, `updated_by`)
VALUES
(1, 1, NOW(), 'system', 'Truy cập toàn bộ tính năng trong 30 ngày.', 30, 'Gói Premium 1 Tháng', 99000.00, NOW(), 'system'),
(2, 1, NOW(), 'system', 'Truy cập toàn bộ tính năng trong 90 ngày.', 90, 'Gói Premium 3 Tháng', 279000.00, NOW(), 'system'),
(3, 1, NOW(), 'system', 'Truy cập toàn bộ tính năng trong 180 ngày.', 180, 'Gói Premium 6 Tháng', 529000.00, NOW(), 'system'),
(4, 1, NOW(), 'system', 'Truy cập toàn bộ tính năng trong 365 ngày.', 365, 'Gói Premium 1 Năm', 999000.00, NOW(), 'system'),
(5, 1, NOW(), 'system', 'Gói Standard 1 tháng (Tính năng hạn chế).', 30, 'Gói Standard 1 Tháng', 49000.00, NOW(), 'system'),
(6, 1, NOW(), 'system', 'Gói Standard 1 năm (Tính năng hạn chế).', 365, 'Gói Standard 1 Năm', 499000.00, NOW(), 'system'),
(7, 0, NOW(), 'system', 'Gói sự kiện Valentine (Đã hết hạn).', 60, 'Gói Tình Yêu', 149000.00, NOW(), 'system'),
(8, 0, NOW(), 'system', 'Gói sự kiện Hè (Đã hết hạn).', 90, 'Gói Mùa Hè', 199000.00, NOW(), 'system'),
(9, 1, NOW(), 'system', 'Truy cập trọn đời, không giới hạn.', 9999, 'Gói Trọn Đời', 2499000.00, NOW(), 'system'),
(10, 1, NOW(), 'system', 'Gói học thử miễn phí 7 ngày.', 7, 'Học Thử 7 Ngày', 0.00, NOW(), 'system');
/*!40000 ALTER TABLE `plans` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 2: Người dùng (users)
-- (backup.sql đã tạo user 1, 2. Ta thêm 8 user nữa cho đủ 10)
-- (Mật khẩu cho tất cả là '123456')
-- ---------------------------------
LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `active`, `created_at`, `created_by`, `email`, `last_activity_date`, `name`, `password`, `point`, `refresh_token`, `streak_count`, `updated_at`, `updated_by`, `badge_id`, `role_id`)
VALUES
-- Mật khẩu: '12345678' -> $2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu
(3, 1, NOW(), 'system', 'premium.user@gmail.com', CURDATE(), 'Premium User', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 150, NULL, 5, NOW(), 'system', 2, 2), -- role_id = 2 (PREMIUM)
(4, 1, NOW(), 'system', 'normal.user@gmail.com', CURDATE(), 'Normal User', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 20, NULL, 1, NOW(), 'system', 1, 3), -- role_id = 3 (USER)
(5, 1, NOW(), 'system', 'teacher.demo@gmail.com', CURDATE(), 'Demo Teacher', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 500, NULL, 10, NOW(), 'system', 3, 1), -- role_id = 1 (ADMIN)
(6, 1, NOW(), 'system', 'student.a@gmail.com', CURDATE(), 'Student Alpha', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 10, NULL, 0, NOW(), 'system', 1, 3), -- role_id = 3 (USER)
(7, 1, NOW(), 'system', 'student.b@gmail.com', CURDATE(), 'Student Beta', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 75, NULL, 3, NOW(), 'system', 1, 3), -- role_id = 3 (USER)
(8, 1, NOW(), 'system', 'pro.learner@gmail.com', CURDATE(), 'Pro Learner', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 1200, NULL, 30, NOW(), 'system', 4, 2), -- role_id = 2 (PREMIUM)
(9, 1, NOW(), 'system', 'test.user.01@gmail.com', CURDATE(), 'Test User 01', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 0, NULL, 0, NOW(), 'system', 1, 3), -- role_id = 3 (USER)
(10, 0, NOW(), 'system', 'disabled.user@gmail.com', CURDATE(), 'Disabled User', '$2b$10$0e4gOePZVA/X0z6hnvyHoenj/2QKy4LVJYlL2UnSeJZtrfQAfrpzu', 0, NULL, 0, NOW(), 'system', 1, 3); -- role_id = 3 (USER)
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 3: Gói đăng ký (subscriptions)
-- (Tạo 10 lượt đăng ký cho các user)
-- ---------------------------------
LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` (`active`, `created_at`, `end_date`, `payment_status`, `start_date`, `transaction_id`, `updated_at`, `plan_id`, `user_id`)
VALUES
-- User 3 (Premium) đang dùng Gói 1 Năm
(1, NOW(), DATE_ADD(NOW(), INTERVAL 365 DAY), 'PAID', NOW(), 'VNP_001', NOW(), 4, 3),
-- User 8 (Pro) đang dùng Gói Trọn Đời
(1, NOW(), DATE_ADD(NOW(), INTERVAL 9999 DAY), 'PAID', NOW(), 'VNP_002', NOW(), 9, 8),
-- User 2 (vunhatminh) đang Học Thử
(1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 'PAID', NOW(), 'VNP_003', NOW(), 10, 2),
-- User 4 (Normal) đã hết hạn Gói 1 Tháng
(0, DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), 'PAID', DATE_SUB(NOW(), INTERVAL 40 DAY), 'VNP_004', NOW(), 1, 4),
-- User 5 (Teacher) dùng Gói Trọn Đời (do là admin)
(1, NOW(), DATE_ADD(NOW(), INTERVAL 9999 DAY), 'PAID', NOW(), 'VNP_005', NOW(), 9, 5),
-- User 7 (Student Beta) đang dùng Gói 3 Tháng
(1, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY), 'PAID', NOW(), 'VNP_006', NOW(), 2, 7),
-- User 3 (Premium) có 1 gói đã hết hạn
(0, DATE_SUB(NOW(), INTERVAL 60 DAY), DATE_SUB(NOW(), INTERVAL 30 DAY), 'PAID', DATE_SUB(NOW(), INTERVAL 60 DAY), 'VNP_007', NOW(), 1, 3),
-- User 6 (Student Alpha) đang chờ thanh toán Gói 1 Tháng
(0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'PENDING', NOW(), 'VNP_008', NOW(), 1, 6),
-- User 9 (Test) đã thất bại thanh toán
(0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'FAILED', NOW(), 'VNP_009', NOW(), 5, 9),
-- User 10 (Disabled) có 1 gói đã hủy
(0, DATE_SUB(NOW(), INTERVAL 10 DAY), DATE_ADD(NOW(), INTERVAL 20 DAY), 'CANCELLED', DATE_SUB(NOW(), INTERVAL 10 DAY), 'VNP_010', NOW(), 1, 10);
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 4: Danh mục (categories)
-- (Tạo 15 danh mục, gồm 5 cha và 10 con)
-- ---------------------------------
LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`id`, `created_at`, `created_by`, `description`, `name`, `order_index`, `type`, `updated_at`, `updated_by`, `parent_id`)
VALUES
-- 5 Danh mục cha
(1, NOW(), 'system', 'Các chủ đề từ vựng', 'Vocabulary', 1, 'VOCABULARY', NOW(), 'system', NULL),
(2, NOW(), 'system', 'Các chủ điểm ngữ pháp', 'Grammar', 2, 'GRAMMAR', NOW(), 'system', NULL),
(3, NOW(), 'system', 'Luyện nghe qua video', 'Videos', 3, 'VIDEO', NOW(), 'system', NULL),
(4, NOW(), 'system', 'Luyện đọc qua bài báo', 'Articles', 4, 'ARTICLE', NOW(), 'system', NULL),
(5, NOW(), 'system', 'Luyện nghe chép chính tả', 'Dictation', 5, 'DICTATION', NOW(), 'system', NULL),
-- 10 Danh mục con
(6, NOW(), 'system', 'Từ vựng về chủ đề động vật', 'Animals', 1, 'VOCABULARY', NOW(), 'system', 1),
(7, NOW(), 'system', 'Từ vựng về chủ đề công việc', 'Jobs', 2, 'VOCABULARY', NOW(), 'system', 1),
(8, NOW(), 'system', 'Từ vựng về thức ăn', 'Food', 3, 'VOCABULARY', NOW(), 'system', 1),
(9, NOW(), 'system', 'Từ vựng về du lịch', 'Travel', 4, 'VOCABULARY', NOW(), 'system', 1),
(10, NOW(), 'system', 'Các thì trong tiếng Anh', 'Tenses', 1, 'GRAMMAR', NOW(), 'system', 2),
(11, NOW(), 'system', 'Giới từ (Prepositions)', 'Prepositions', 2, 'GRAMMAR', NOW(), 'system', 2),
(12, NOW(), 'system', 'Video luyện nghe cơ bản', 'Beginner Listening', 1, 'VIDEO', NOW(), 'system', 3),
(13, NOW(), 'system', 'Video luyện nghe nâng cao', 'Advanced Listening', 2, 'VIDEO', NOW(), 'system', 3),
(14, NOW(), 'system', 'Bài báo tin tức', 'News Articles', 1, 'ARTICLE', NOW(), 'system', 4),
(15, NOW(), 'system', 'Bài nghe chép cơ bản', 'Beginner Dictation', 1, 'DICTATION', NOW(), 'system', 5);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 5: Từ vựng (vocabularies)
-- (Tạo 10 từ vựng)

-- ---------------------------------
LOCK TABLES `vocabularies` WRITE;
/*!40000 ALTER TABLE `vocabularies` DISABLE KEYS */;
INSERT INTO `vocabularies` (`id`, `audio`, `created_at`, `created_by`, `definition_en`, `example_en`, `example_vi`, `image`, `meaning_vi`, `part_of_speech`, `pronunciation`, `updated_at`, `updated_by`, `word`, `category_id`)
VALUES
(1, 'https://dictionary.cambridge.org/us/media/english/us_pron/l/lio/lion_/lion.mp3', NOW(), 'system', 'A large wild cat.', 'The lion is strong.', 'Sư tử rất mạnh.', 'https://wallpaperaccess.com/full/427061.jpg', 'Sư tử', 'noun', '/ˈlaɪ.ən/', NOW(), 'system', 'Lion', 6),
(2, 'https://dictionary.cambridge.org/us/media/english/us_pron/t/tig/tiger/tiger.mp3', NOW(), 'system', 'A large wild cat with stripes.', 'Tigers live in Asia.', 'Hổ sống ở châu Á.', 'https://img4.thuthuatphanmem.vn/uploads/2019/12/17/hinh-nen-3d-vua-su-tu_103057594.jpg', 'Hổ', 'noun', '/ˈtaɪ.ɡər/', NOW(), 'system', 'Tiger', 6),
(3, 'https://dictionary.cambridge.org/us/media/english/us_pron/e/ele/eleph/elephant.mp3', NOW(), 'system', 'A very large grey mammal.', 'An elephant has a long trunk.', 'Voi có cái vòi dài.', 'https://toplist.vn/images/800px/voi-59305.jpg', 'Voi', 'noun', '/ˈel.ə.fənt/', NOW(), 'system', 'Elephant', 6),
(4, 'https://dictionary.cambridge.org/us/media/english/us_pron/d/doc/docto/doctor.mp3', NOW(), 'system', 'A person who treats sick people.', 'I need to see a doctor.', 'Tôi cần đi gặp bác sĩ.', 'https://watermark.lovepik.com/photo/20211126/large/lovepik-young-team-of-doctors-picture_501143033.jpg', 'Bác sĩ', 'noun', '/ˈdɒk.tər/', NOW(), 'system', 'Doctor', 7),
(5, 'https://dictionary.cambridge.org/us/media/english/us_pron/e/eng/engin/engineer.mp3', NOW(), 'system', 'A person who designs or builds things.', 'She is a software engineer.', 'Cô ấy là kỹ sư phần mềm.', 'https://acihome.vn/uploads/15/ky-su-giam-sat-xay-dung.jpg', 'Kỹ sư', 'noun', '/ˌen.dʒɪˈnɪər/', NOW(), 'system', 'Engineer', 7),
(6, 'https://dictionary.cambridge.org/us/media/english/us_pron/t/tea/teach/teacher.mp3', NOW(), 'system', 'A person who teaches students.', 'My teacher is very kind.', 'Giáo viên của tôi rất tốt bụng.', 'https://cdn.luatvietnam.vn/uploaded/Images/Original/2023/10/29/giao-vien-tieu-hoc-hang-i-1_2910135637.jpg', 'Giáo viên', 'noun', '/ˈtiː.tʃər/', NOW(), 'system', 'Teacher', 7),
(7, 'https://dictionary.cambridge.org/us/media/english/us_pron/a/app/apple/apple.mp3', NOW(), 'system', 'A round fruit with red or green skin.', 'An apple a day keeps the doctor away.', 'Một quả táo mỗi ngày giúp tránh xa bác sĩ.', 'https://hongngochospital.vn/wp-content/uploads/2013/11/tao-1.jpg', 'Quả táo', 'noun', '/ˈæp.əl/', NOW(), 'system', 'Apple', 8),
(8, 'https://dictionary.cambridge.org/us/media/english/us_pron/b/bre/bread/bread.mp3', NOW(), 'system', 'A basic food made from flour and water.', 'I eat bread for breakfast.', 'Tôi ăn bánh mì cho bữa sáng.', 'https://assets.epicurious.com/photos/562e49d300392e9c31da8947/master/pass/EP_10212015_BanhMi-4.jpg', 'Bánh mì', 'noun', '/bred/', NOW(), 'system', 'Bread', 8),
(9, 'https://dictionary.cambridge.org/us/media/english/us_pron/b/bre/bread/bread.mp3', NOW(), 'system', 'A vehicle that flies in the air.', 'The airplane is flying high.', 'Máy bay đang bay cao.', 'https://khoinguonsangtao.vn/wp-content/uploads/2022/10/hinh-anh-may-bay-tren-bau-troi-dep-sac-net.jpg', 'Máy bay', 'noun', '/ˈeə.pleɪn/', NOW(), 'system', 'Airplane', 9),
(10, 'https://dictionary.cambridge.org/us/media/english/us_pron/h/hot/hotel/hotel.mp3', NOW(), 'system', 'A place where you pay to stay.', 'We stayed at a nice hotel.', 'Chúng tôi đã ở một khách sạn đẹp.', 'https://khonggianxanh.com/wp-content/uploads/2020/09/4-mau-thiet-ke-sanh-khach-san-doc-dao-2020-2.jpg', 'Khách sạn', 'noun', '/həʊˈtel/', NOW(), 'system', 'Hotel', 9);
/*!40000 ALTER TABLE `vocabularies` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 6: Ngữ pháp (grammars)
-- (Tạo 10 chủ điểm ngữ pháp)
-- ---------------------------------
LOCK TABLES `grammars` WRITE;
/*!40000 ALTER TABLE `grammars` DISABLE KEYS */;
INSERT INTO `grammars` (`id`, `content`, `created_at`, `created_by`, `name`, `updated_at`, `updated_by`, `category_id`)
VALUES
(1, '<h2>Thì Hiện tại đơn (Present Simple)</h2><p>Dùng để diễn tả một thói quen, một sự thật hiển nhiên.</p>', NOW(), 'system', 'Thì Hiện Tại Đơn', NOW(), 'system', 10),
(2, '<h2>Thì Quá khứ đơn (Past Simple)</h2><p>Dùng để diễn tả hành động đã xảy ra và kết thúc trong quá khứ.</p>', NOW(), 'system', 'Thì Quá Khứ Đơn', NOW(), 'system', 10),
(3, '<h2>Thì Tương lai đơn (Future Simple)</h2><p>Dùng để diễn tả một quyết định tức thời, một dự đoán không căn cứ.</p>', NOW(), 'system', 'Thì Tương Lai Đơn', NOW(), 'system', 10),
(4, '<h2>Thì Hiện tại tiếp diễn (Present Continuous)</h2><p>Dùng để diễn tả hành động đang xảy ra tại thời điểm nói.</p>', NOW(), 'system', 'Thì Hiện Tại Tiếp Diễn', NOW(), 'system', 10),
(5, '<h2>Thì Hiện tại hoàn thành (Present Perfect)</h2><p>Dùng để diễn tả hành động bắt đầu trong quá khứ, kéo dài đến hiện tại.</p>', NOW(), 'system', 'Thì Hiện Tại Hoàn Thành', NOW(), 'system', 10),
(6, '<h2>Giới từ "In"</h2><p>Dùng cho không gian lớn (in Vietnam), tháng, năm (in 2025).</p>', NOW(), 'system', 'Giới từ "In"', NOW(), 'system', 11),
(7, '<h2>Giới từ "On"</h2><p>Dùng cho bề mặt (on the table), ngày (on Monday).</p>', NOW(), 'system', 'Giới từ "On"', NOW(), 'system', 11),
(8, '<h2>Giới từ "At"</h2><p>Dùng cho địa điểm cụ thể (at the airport), thời gian (at 5 PM).</p>', NOW(), 'system', 'Giới từ "At"', NOW(), 'system', 11),
(9, '<h2>Giới từ "For"</h2><p>Dùng để chỉ mục đích (for you), khoảng thời gian (for 2 hours).</p>', NOW(), 'system', 'Giới từ "For"', NOW(), 'system', 11),
(10, '<h2>Giới từ "With"</h2><p>Dùng để chỉ sự cùng với (with me), bằng (with a pen).</p>', NOW(), 'system', 'Giới từ "With"', NOW(), 'system', 11);
/*!40000 ALTER TABLE `grammars` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 7: Video (videos)
-- (Tạo 10 video)
-- ---------------------------------
LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` (`id`, `created_at`, `created_by`, `description`, `duration`, `subtitle`, `title`, `updated_at`, `updated_by`, `url`, `category_id`)
VALUES
(1, NOW(), 'system', 'Hội thoại cơ bản tại quán cà phê.', '02:45', '[{"time": "00:01", "line": "Hi, can I get a coffee?"}]', 'At the Coffee Shop', NOW(), 'system', 'https://www.youtube.com/watch?v=MhkLJo6piNo', 12),
(2, NOW(), 'system', 'Hỏi đường đi đến bưu điện.', '03:15', '[{"time": "00:02", "line": "Excuse me, where is the post office?"}]', 'Asking for Directions', NOW(), 'system', 'https://www.youtube.com/watch?v=9xmcNqiy6FY', 12),
(3, NOW(), 'system', 'Giới thiệu về gia đình.', '04:00', '[{"time": "00:01", "line": "This is my family."}]', 'My Family', NOW(), 'system', 'https://www.youtube.com/watch?v=I7irwtqzPxY', 12),
(4, NOW(), 'system', 'Mua sắm quần áo tại cửa hàng.', '05:20', '[{"time": "00:05", "line": "How much is this shirt?"}]', 'Shopping for Clothes', NOW(), 'system', 'https://www.youtube.com/watch?v=1ggEuGqyfg4&list=PLvBNwlqrsg59UhX3Z9cwSikVw-Wa6SXxD', 12),
(5, NOW(), 'system', 'Gọi món ăn tại nhà hàng.', '06:10', '[{"time": "00:03", "line": "Are you ready to order?"}]', 'Ordering Food', NOW(), 'system', 'https://www.youtube.com/watch?v=NfD5hgxGQ1U', 12),
(6, NOW(), 'system', 'Thảo luận về biến đổi khí hậu.', '10:30', '[{"time": "00:15", "line": "Climate change is a global issue."}]', 'Climate Change Discussion', NOW(), 'system', 'https://www.youtube.com/watch?v=aD4iW49F6c0', 13),
(7, NOW(), 'system', 'Bài giảng về kinh tế vĩ mô.', '15:00', '[{"time": "00:20", "line": "Today we discuss GDP."}]', 'Macroeconomics 101', NOW(), 'system', 'https://www.youtube.com/watch?v=H_fQp68ZQsw', 13),
(8, NOW(), 'system', 'Phỏng vấn xin việc bằng tiếng Anh.', '12:45', '[{"time": "00:10", "line": "Tell me about yourself."}]', 'Job Interview Tips', NOW(), 'system', 'https://www.youtube.com/watch?v=dm0xZrPBD_0', 13),
(9, NOW(), 'system', 'TED Talk: Sức mạnh của sự im lặng.', '18:22', '[{"time": "00:30", "line": "The power of silence..."}]', 'TED Talk: Silence', NOW(), 'system', 'https://www.youtube.com/watch?v=0y2jWsb0c_8', 13),
(10, NOW(), 'system', 'Vlog du lịch vòng quanh thế giới.', '25:00', '[{"time": "01:00", "line": "We arrived in Paris!"}]', 'World Travel Vlog', NOW(), 'system', 'https://www.youtube.com/watch?v=vMejNnJpkU0', 13);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 8: Bài báo (articles)
-- (Tạo 10 bài báo)
-- ---------------------------------
LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` (`id`, `audio`, `content`, `created_at`, `created_by`, `image`, `title`, `updated_at`, `updated_by`, `category_id`)
VALUES
(1, '/uploads/audio/article_1.mp3', '<h2>Thành phố tương lai</h2><p>Các nhà khoa học đang nghiên cứu...</p>', NOW(), 'system', '/uploads/articles/image/image_1.jpg', 'Building the City of the Future', NOW(), 'system', 14),
(2, '/uploads/audio/article_2.mp3', '<h2>AI thay đổi thế giới</h2><p>Trí tuệ nhân tạo đang phát triển nhanh...</p>', NOW(), 'system', '/uploads/articles/image/image_2.jpg', 'How AI is Changing the World', NOW(), 'system', 14),
(3, '/uploads/audio/article_3.mp3', '<h2>Lợi ích của việc ngủ đủ giấc</h2><p>Ngủ đủ 8 tiếng mỗi ngày...</p>', NOW(), 'system', '/uploads/articles/image/image_3.jpg', 'The Benefits of Sleep', NOW(), 'system', 14),
(4, '/uploads/audio/article_3.mp3', '<h2>Lịch sử Vua Arthur</h2><p>Liệu Vua Arthur có thật không? ...</p>', NOW(), 'system', '/uploads/articles/image/image_6.jpg', 'The Legend of King Arthur', NOW(), 'system', 14);
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 9: Chủ đề Nghe chép (dictation_topics)
-- (3 chủ đề)
-- ---------------------------------
LOCK TABLES `dictation_topics` WRITE;
/*!40000 ALTER TABLE `dictation_topics` DISABLE KEYS */;
INSERT INTO `dictation_topics` (`id`, `created_at`, `created_by`, `description`, `title`, `updated_at`, `updated_by`, `category_id`)
VALUES
(1, NOW(), 'system', 'Những câu ngắn và đơn giản.', 'Chủ đề 1: Câu ngắn', NOW(), 'system', 15),
(2, NOW(), 'system', 'Các câu hỏi về thời tiết.', 'Chủ đề 2: Thời tiết', NOW(), 'system', 15),
(3, NOW(), 'system', 'Hội thoại về gia đình.', 'Chủ đề 3: Gia đình', NOW(), 'system', 15);
/*!40000 ALTER TABLE `dictation_topics` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 10: Câu nghe chép (dictation_sentences)                                     >>>>>> FIX NỐT AUDIO CHO KHỚP <<<<<<
-- (Mỗi chủ đề 3 câu, tổng cộng 9 câu)
-- ---------------------------------
LOCK TABLES `dictation_sentences` WRITE;
/*!40000 ALTER TABLE `dictation_sentences` DISABLE KEYS */;
INSERT INTO `dictation_sentences` (`id`, `audio_url`, `correct_text`, `order_index`, `topic_id`)
VALUES
-- Chủ đề 1: Câu ngắn (Topic ID 1)
(1, '/uploads/dictations/topic1_1.mp3', 'The weather is nice today.', 1, 1),
(2, '/uploads/dictations/topic1_2.mp3', 'He plays football every weekend.', 2, 1),
(3, '/uploads/dictations/topic1_3.mp3', 'She is reading a book in the library.', 3, 1),

-- Chủ đề 2: Thời tiết (Topic ID 2)
(4, '/uploads/dictations/topic2_1.mp3', 'It is raining heavily outside.', 1, 2),
(5, '/uploads/dictations/topic2_2.mp3', 'The sun is shining bright.', 2, 2),
(6, '/uploads/dictations/topic2_3.mp3', 'What is the temperature today?', 3, 2),

-- Chủ đề 3: Gia đình (Topic ID 3)
(7, '/uploads/dictations/topic3_1.mp3', 'My father is a doctor.', 1, 3),
(8, '/uploads/dictations/topic3_2.mp3', 'I have two brothers and one sister.', 2, 3),
(9, '/uploads/dictations/topic3_3.mp3', 'We love having dinner together.', 3, 3);
/*!40000 ALTER TABLE `dictation_sentences` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 11: Bài Quiz (quizzes)
-- (Tạo 10 bài quiz)
-- ---------------------------------
LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
INSERT INTO `quizzes` (`id`, `created_at`, `description`, `title`, `updated_at`, `category_id`)
VALUES
(1, NOW(), 'Bài kiểm tra về từ vựng động vật.', 'Animals Vocab Quiz', NOW(), 6),
(2, NOW(), 'Bài kiểm tra về từ vựng công việc.', 'Jobs Vocab Quiz', NOW(), 7),
(3, NOW(), 'Bài kiểm tra về từ vựng thức ăn.', 'Food Vocab Quiz', NOW(), 8),
(4, NOW(), 'Bài kiểm tra về từ vựng du lịch.', 'Travel Vocab Quiz', NOW(), 9),
(5, NOW(), 'Bài kiểm tra về Thì Hiện Tại Đơn.', 'Present Simple Tense Quiz', NOW(), 10),
(6, NOW(), 'Bài kiểm tra về Thì Quá Khứ Đơn.', 'Past Simple Tense Quiz', NOW(), 10),
(7, NOW(), 'Bài kiểm tra về Giới từ In/On/At.', 'Prepositions Quiz (In/On/At)', NOW(), 11),
(8, NOW(), 'Bài kiểm tra tổng hợp Thì (Tenses).', 'Tenses Review Quiz', NOW(), 10),
(9, NOW(), 'Bài kiểm tra tổng hợp Giới từ.', 'Prepositions Review Quiz', NOW(), 11),
(10, NOW(), 'Bài kiểm tra từ vựng tổng hợp (Animals/Jobs).', 'Vocabulary Review (Animals/Jobs)', NOW(), 6);
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 12: Câu hỏi (questions)
-- (Tạo 10 câu hỏi cho Quiz 1: Animals Vocab Quiz)
-- ---------------------------------
LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` (`id`, `audio_url`, `correct_sentence`, `image_url`, `points`, `prompt`, `question_order`, `question_type`, `text_to_fill`, `quiz_id`, `vocabulary_id`)
VALUES
-- Quiz 1: Animals Vocab Quiz (ID 1) - Dữ liệu gốc của bạn
(3, NULL, 'Elephant', NULL, 10, 'A very large grey mammal with a trunk: An ______ has a long trunk.', 1, 'FILL_IN_BLANK', 'An ______ has a long trunk.', 1, 3),
(4, NULL, 'What does the doctor do?', NULL, 10, 'Translate this sentence: Bác sĩ làm gì?', 2, 'TRANSLATE_VI_TO_EN', 'Bác sĩ làm gì?', 1, 4),
(5, NULL, 'Cô ấy là một kỹ sư', NULL, 10, 'Translate this sentence: She is an engineer', 3, 'TRANSLATE_EN_TO_VI', 'She is an engineer.', 1, 5),
(7, NULL, 'Apple', NULL, 10, 'This fruit is usually red or green: An ______ a day keeps the doctor away.', 4, 'FILL_IN_BLANK', 'An ______ a day keeps the doctor away.', 1, 7),
(10, NULL, 'We stay at a hotel', NULL, 10, 'We stay at a hotel', 5, 'ARRANGE_WORDS', 'a / at / hotel / We / stay', 1, 10),

-- Quiz 2: Jobs Vocab Quiz (ID 2) - Bổ sung
(11, NULL, 'Doctor', NULL, 10, 'This person works in a hospital and treats sick people.', 1, 'FILL_IN_BLANK', 'A ______ works in a hospital.', 2, 4),
(12, NULL, NULL, NULL, 10, 'A person who designs or builds things like bridges or software.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 2, 5),
(13, NULL, NULL, NULL, 10, 'This person teaches students in a school.', 3, 'MULTIPLE_CHOICE_TEXT', NULL, 2, 6),

-- Quiz 3: Food Vocab Quiz (ID 3) - Bổ sung
(15, NULL, 'Bread', NULL, 10, 'We often eat this for breakfast, made from flour.', 2, 'FILL_IN_BLANK', 'I eat ______ for breakfast.', 3, 8),

-- Quiz 4: Travel Vocab Quiz (ID 4) - Bổ sung
(16, NULL, NULL, NULL, 10, 'A place where you pay to stay when you are on vacation.', 1, 'MULTIPLE_CHOICE_TEXT', NULL, 4, 10),
(17, NULL, 'Airplane', NULL, 10, 'A vehicle that flies in the air.', 2, 'FILL_IN_BLANK', 'The ______ is flying high.', 4, 9),

-- Quiz 5: Present Simple Tense Quiz (ID 5) - Bổ sung
(18, NULL, 'works', NULL, 10, 'She _____ (work) in a hospital.', 1, 'FILL_IN_BLANK', 'She ______ in a hospital.', 5, NULL),
(19, NULL, NULL, NULL, 10, 'They _____ (not, like) coffee.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 5, NULL),
(20, NULL, NULL, NULL, 10, 'He _____ (watch) TV every night.', 3, 'MULTIPLE_CHOICE_TEXT', NULL, 5, NULL),

-- Quiz 6: Past Simple Tense Quiz (ID 6) - Bổ sung
(21, NULL, 'went', NULL, 10, 'Yesterday, I _____ (go) to the cinema.', 1, 'FILL_IN_BLANK', 'Yesterday, I ______ to the cinema.', 6, NULL),
(22, NULL, NULL, NULL, 10, 'He _____ (not, see) the movie.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 6, NULL),

-- Quiz 7: Prepositions Quiz (In/On/At) (ID 7) - Bổ sung
(23, NULL, NULL, NULL, 10, 'The meeting is ___ 5 PM.', 1, 'MULTIPLE_CHOICE_TEXT', NULL, 7, NULL),
(24, NULL, NULL, NULL, 10, 'My birthday is ___ Monday.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 7, NULL),
(25, NULL, NULL, NULL, 10, 'I live ___ Vietnam.', 3, 'MULTIPLE_CHOICE_TEXT', NULL, 7, NULL),

-- Quiz 8: Tenses Review Quiz (ID 8) - Bổ sung
(26, NULL, 'is climbing', NULL, 10, 'Look! The cat _____ (climb) the tree.', 1, 'FILL_IN_BLANK', 'Look! The cat ______ the tree.', 8, NULL),
(27, NULL, NULL, NULL, 10, 'I _____ (be) here for two hours.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 8, NULL),

-- Quiz 9: Prepositions Review Quiz (ID 9) - Bổ sung
(28, NULL, NULL, NULL, 10, 'He is afraid ___ spiders.', 1, 'MULTIPLE_CHOICE_TEXT', NULL, 9, NULL),
(29, NULL, NULL, NULL, 10, 'She is good ___ tennis.', 2, 'MULTIPLE_CHOICE_TEXT', NULL, 9, NULL),

-- Quiz 10: Vocabulary Review (Animals/Jobs) (ID 10) - Bổ sung
(30, NULL, 'This is a lion', NULL, 10, 'Sắp xếp lại câu:', 1, 'ARRANGE_WORDS', 'a / lion / This / is', 10, 1),
(31, NULL, 'She is an engineer', NULL, 10, 'Sắp xếp lại câu:', 2, 'ARRANGE_WORDS', 'an / is / She / engineer', 10, 5);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;




-- ---------------------------------
-- Bảng 13: Lựa chọn (question_choices)
-- (Tạo 3 lựa chọn cho mỗi câu hỏi trắc nghiệm (ID 1, 2, 6, 8, 9))
-- ---------------------------------
LOCK TABLES `question_choices` WRITE;
/*!40000 ALTER TABLE `question_choices` DISABLE KEYS */;
INSERT INTO `question_choices` (`id`, `content`, `image_url`, `is_correct`, `question_id`)
VALUES
-- Quiz 2 (Jobs) - Q12
(1, 'Engineer', NULL, 1, 12),
(2, 'Teacher', NULL, 0, 12),
(3, 'Doctor', NULL, 0, 12),
-- Quiz 2 - Q13
(4, 'Doctor', NULL, 0, 13),
(5, 'Engineer', NULL, 0, 13),
(6, 'Teacher', NULL, 1, 13),

-- Quiz 4 (Travel) - Q16
(7, 'Airplane', NULL, 0, 16),
(8, 'Hotel', NULL, 1, 16),
(9, 'Food', NULL, 0, 16),

-- Quiz 5 (Tenses) - Q19
(10, 'don''t like', NULL, 1, 19),
(11, 'doesn''t like', NULL, 0, 19),
(12, 'not like', NULL, 0, 19),
-- Quiz 5 - Q20
(13, 'watches', NULL, 1, 20),
(14, 'watch', NULL, 0, 20),
(15, 'is watch', NULL, 0, 20),

-- Quiz 6 (Past Simple) - Q22
(16, 'not saw', NULL, 0, 22),
(17, 'didn''t see', NULL, 1, 22),
(18, 'no see', NULL, 0, 22),

-- Quiz 7 (Prepositions) - Q23, Q24, Q25
(19, 'at', NULL, 1, 23), (20, 'on', NULL, 0, 23), (21, 'in', NULL, 0, 23),
(22, 'at', NULL, 0, 24), (23, 'on', NULL, 1, 24), (24, 'in', NULL, 0, 24),
(25, 'at', NULL, 0, 25), (26, 'on', NULL, 0, 25), (27, 'in', NULL, 1, 25),

-- Quiz 8 (Review) - Q27
(28, 'have been', NULL, 1, 27), (29, 'am', NULL, 0, 27), (30, 'was', NULL, 0, 27),

-- Quiz 9 (Review) - Q28, Q29
(31, 'of', NULL, 1, 28), (32, 'with', NULL, 0, 28), (33, 'for', NULL, 0, 28),
(34, 'in', NULL, 0, 29), (35, 'at', NULL, 1, 29), (36, 'on', NULL, 0, 29);
/*!40000 ALTER TABLE `question_choices` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 14: Lượt làm quiz (user_quiz_attempts)
-- (Tạo 10 lượt làm bài)
-- ---------------------------------
LOCK TABLES `user_quiz_attempts` WRITE;
/*!40000 ALTER TABLE `user_quiz_attempts` DISABLE KEYS */;
INSERT INTO `user_quiz_attempts` (`id`, `completed_at`, `score`, `started_at`, `status`, `quiz_id`, `user_id`)
VALUES
-- User 2 làm Quiz 1 (Animals) - Đúng 4/5 câu (40 điểm)
(1, NOW(), 40, NOW(), 'COMPLETED', 1, 2),
-- User 3 làm Quiz 2 (Jobs) - Đúng 3/3 câu (30 điểm)
(2, NOW(), 30, NOW(), 'COMPLETED', 2, 3),
-- User 4 làm Quiz 5 (Tenses) - Đúng 2/3 câu (20 điểm)
(3, NOW(), 20, NOW(), 'COMPLETED', 5, 4);
/*!40000 ALTER TABLE `user_quiz_attempts` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 15: Câu trả lời (user_answers)
-- (Tạo 10 câu trả lời cho Lượt làm 1 (của User 2, làm Quiz 1))
-- ---------------------------------
LOCK TABLES `user_answers` WRITE;
/*!40000 ALTER TABLE `user_answers` DISABLE KEYS */;
INSERT INTO `user_answers` (`is_correct`, `points_awarded`, `user_answer_text`, `question_id`, `selected_choice_id`, `user_quiz_attempt_id`)
VALUES
-- == Chi tiết cho Attempt 1 (User 2 - Quiz 1 Animals - 40 điểm) ==
-- Q3 (Elephant): Đúng
(1, 10, 'Elephant', 3, NULL, 1),
-- Q4 (Dịch): Đúng
(1, 10, 'What does the doctor do?', 4, NULL, 1),
-- Q5 (Dịch): Đúng
(1, 10, 'She is an engineer', 5, NULL, 1),
-- Q7 (Apple): Sai (Điền nhầm 'Fruit')
(0, 0, 'Fruit', 7, NULL, 1),
-- Q10 (Sắp xếp): Đúng
(1, 10, 'We stay at a hotel', 10, NULL, 1),

-- == Chi tiết cho Attempt 2 (User 3 - Quiz 2 Jobs - 30 điểm) ==
-- Q11 (Điền từ Doctor): Đúng
(1, 10, 'Doctor', 11, NULL, 2),
-- Q12 (Trắc nghiệm Engineer): Đúng (Chọn ID 1)
(1, 10, NULL, 12, 1, 2),
-- Q13 (Trắc nghiệm Teacher): Đúng (Chọn ID 6)
(1, 10, NULL, 13, 6, 2),

-- == Chi tiết cho Attempt 3 (User 4 - Quiz 5 Tenses - 20 điểm) ==
-- Q18 (Điền từ): Đúng
(1, 10, 'works', 18, NULL, 3),
-- Q19 (Trắc nghiệm): Đúng (Chọn ID 10 - don't like)
(1, 10, NULL, 19, 10, 3),
-- Q20 (Trắc nghiệm): Sai (Chọn ID 14 - watch, đúng là watches)
(0, 0, NULL, 20, 14, 3);

/*!40000 ALTER TABLE `user_answers` ENABLE KEYS */;
UNLOCK TABLES;
-- ---------------------------------
-- Bảng 16: Sổ tay từ vựng (user_vocabularies)
-- (Tạo 10 bản ghi lưu từ vựng)
-- ---------------------------------
LOCK TABLES `user_vocabularies` WRITE;
/*!40000 ALTER TABLE `user_vocabularies` DISABLE KEYS */;
INSERT INTO `user_vocabularies` (`created_at`, `ease_factor`, `last_reviewed_at`, `level`, `next_review_at`, `repetitions`, `reivew_interval`, `updated_at`, `user_id`, `vocabulary_id`)
VALUES
-- User 2 (vunhatminh) lưu 3 từ
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 2, 1), -- Lion
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 2, 7), -- Apple
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 2, 9), -- Airplane
-- User 3 (Premium) lưu 3 từ
(NOW(), 2.3, NOW(), 2, DATE_ADD(NOW(), INTERVAL 0 DAY), 2, 3, NOW(), 3, 2), -- Tiger
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 3, 4), -- Doctor
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 3, 10), -- Hotel
-- User 4 (Normal) lưu 2 từ
(NOW(), 2.6, NOW(), 3, DATE_ADD(NOW(), INTERVAL 0 DAY), 3, 7, NOW(), 4, 3), -- Elephant
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 4, 5), -- Engineer
-- User 8 (Pro) lưu 2 từ
(NOW(), 2.7, NOW(), 4, DATE_ADD(NOW(), INTERVAL 0 DAY), 4, 15, NOW(), 8, 6), -- Teacher
(NOW(), 2.5, NOW(), 1, DATE_ADD(NOW(), INTERVAL 0 DAY), 1, 1, NOW(), 8, 8); -- Bread
/*!40000 ALTER TABLE `user_vocabularies` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 17: Bài đăng (posts)
-- (Tạo 10 bài đăng)
-- ---------------------------------
LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` (`id`, `active`, `caption`, `created_at`, `created_by`, `updated_at`, `updated_by`, `user_id`)
VALUES
(1, 1, 'Hello everyone! I just started learning English. Does anyone have tips for remembering vocabulary?', NOW(), 'system', NOW(), 'system', 4), -- User 4
(2, 1, 'I found the "Animals Vocab Quiz" (Quiz ID 1) very useful! I got 80 points on my first try.', NOW(), 'system', NOW(), 'system', 2), -- User 2
(3, 1, 'The job vocabulary (Category ID 7) is difficult. Any mnemonics for "engineer"?', NOW(), 'system', NOW(), 'system', 7), -- User 7
(4, 1, 'Just finished the "Present Simple Tense Quiz". Grammar is tough!', NOW(), 'system', NOW(), 'system', 8), -- User 8
(5, 1, 'What is everyone s favorite video lesson? I liked "At the Coffee Shop".', NOW(), 'system', NOW(), 'system', 3), -- User 3
(6, 1, 'I am looking for a study partner. I am currently learning prepositions (Category ID 11).', NOW(), 'system', NOW(), 'system', 4), -- User 4
(7, 1, 'Just reached a 30-day streak! Feeling motivated!', NOW(), 'system', NOW(), 'system', 8), -- User 8
(8, 1, 'The "Dictation" feature is amazing for listening practice.', NOW(), 'system', NOW(), 'system', 2), -- User 2
(9, 1, 'Does the Premium plan (ID 4) worth it? Thinking of upgrading.', NOW(), 'system', NOW(), 'system', 9), -- User 9
(10, 1, 'Post by admin to test features.', NOW(), 'system', NOW(), 'system', 1); -- User 1 (Admin)
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 18: Lượt thích (likes)
-- (Tạo 10 lượt thích)
-- ---------------------------------
LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` (`created_at`, `post_id`, `user_id`)
VALUES
-- Post 1 (by User 4) được 3 likes
(NOW(), 1, 2), -- User 2
(NOW(), 1, 3), -- User 3
(NOW(), 1, 8), -- User 8
-- Post 2 (by User 2) được 2 likes
(NOW(), 2, 4), -- User 4
(NOW(), 2, 5), -- User 5 (Teacher)
-- Post 4 (by User 8) được 3 likes
(NOW(), 4, 2), -- User 2
(NOW(), 4, 3), -- User 3
(NOW(), 4, 7), -- User 7
-- Post 5 (by User 3) được 2 likes
(NOW(), 5, 4), -- User 4
(NOW(), 5, 8); -- User 8
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

-- ---------------------------------
-- Bảng 19: Bình luận (comments)
-- (Tạo 10 bình luận)
-- ---------------------------------
LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` (`id`, `content`, `created_at`, `created_by`, `updated_at`, `updated_by`, `parent_comment_id`, `post_id`, `user_id`)
VALUES
-- Bình luận cho Post 1 (by User 4)
(1, 'Welcome! I find that using flashcards (like the notebook feature here) helps a lot.', NOW(), 'system', NOW(), 'system', NULL, 1, 2),
(2, 'I agree! Also, try to use the new words in a sentence.', NOW(), 'system', NOW(), 'system', NULL, 1, 8),
(3, 'Thanks for the tips! I will try it.', NOW(), 'system', NOW(), 'system', 1, 1, 4), -- User 4 trả lời Cmt 1
-- Bình luận cho Post 2 (by User 2)
(4, 'Nice score! I got 100 on that quiz.', NOW(), 'system', NOW(), 'system', NULL, 2, 3),
(5, 'How did you study for it?', NOW(), 'system', NOW(), 'system', NULL, 2, 4),
(6, 'I just reviewed the words in the "Animals" category (ID 6).', NOW(), 'system', NOW(), 'system', 5, 2, 3), -- User 3 trả lời Cmt 5
-- Bình luận cho Post 4 (by User 8)
(7, 'Keep practicing! The "Tenses" grammar section (ID 10) is very clear.', NOW(), 'system', NOW(), 'system', NULL, 4, 5),
-- Bình luận cho Post 9 (by User 9)
(8, 'Yes, 100% worth it. You get access to all advanced videos (ID 13) and articles (ID 14).', NOW(), 'system', NOW(), 'system', NULL, 9, 8),
(9, 'I am on the 1-year plan (ID 4) and I love it.', NOW(), 'system', NOW(), 'system', NULL, 9, 3),
-- Bình luận cho Post 10 (by User 1)
(10, 'Test comment from a normal user.', NOW(), 'system', NOW(), 'system', NULL, 10, 4);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

-- Kích hoạt lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;

-- Dump completed