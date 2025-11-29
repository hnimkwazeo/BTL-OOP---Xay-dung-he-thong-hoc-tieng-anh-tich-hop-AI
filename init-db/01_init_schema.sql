-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: four_stars_english
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `audio` varchar(2048) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `image` varchar(2048) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXcq8w96gfyt8e06ejjt7eln7oc` (`category_id`),
  CONSTRAINT `FK7i4rryg7kqwyyrr08temnc71e` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `badges`
--

DROP TABLE IF EXISTS `badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `badges` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `image` varchar(2048) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `point` int NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKcuebofvgkgi4g9fxde2kmpr1h` (`name`),
  CONSTRAINT `badges_chk_1` CHECK ((`point` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `badges`
--

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES (1,NOW(),'system','Default badge for new users.','/uploads/badges/rank_default.jpg','Chưa có hạng',0,NOW(),'system');
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `description` mediumtext,
  `name` varchar(150) NOT NULL,
  `order_index` int NOT NULL,
  `type` enum('ARTICLE','DICTATION','GRAMMAR','VIDEO','VOCABULARY') NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsaok720gsu4u2wrgbk10b5n8d` (`parent_id`),
  CONSTRAINT `FKsaok720gsu4u2wrgbk10b5n8d` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `categories_chk_1` CHECK ((`order_index` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_attachments`
--

DROP TABLE IF EXISTS `comment_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_attachments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_type` enum('AUDIO','DOCUMENT','FILE','IMAGE','VIDEO') NOT NULL,
  `file_url` varchar(2048) NOT NULL,
  `original_file_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `comment_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhgcebt3p6nx73il260nkt5bwg` (`comment_id`),
  CONSTRAINT `FKhgcebt3p6nx73il260nkt5bwg` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_attachments`
--

LOCK TABLES `comment_attachments` WRITE;
/*!40000 ALTER TABLE `comment_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `parent_comment_id` bigint DEFAULT NULL,
  `post_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX1x3vdhb5vv8eu5708riqe07wc` (`user_id`),
  KEY `IDX2ocgo3lfadb3wq0tx8wyt7sj2` (`post_id`),
  KEY `FK7h839m3lkvhbyv3bcdv7sm4fj` (`parent_comment_id`),
  CONSTRAINT `FK7h839m3lkvhbyv3bcdv7sm4fj` FOREIGN KEY (`parent_comment_id`) REFERENCES `comments` (`id`),
  CONSTRAINT `FK8omq0tc18jd43bu5tjh6jvraq` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKh4c7lvsc298whoyd4w9ta25cr` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictation_sentences`
--

DROP TABLE IF EXISTS `dictation_sentences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dictation_sentences` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `audio_url` varchar(255) NOT NULL,
  `correct_text` tinytext NOT NULL,
  `order_index` int DEFAULT NULL,
  `topic_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9kp490g9l4vel5q4oifop4k` (`topic_id`),
  CONSTRAINT `FK9kp490g9l4vel5q4oifop4k` FOREIGN KEY (`topic_id`) REFERENCES `dictation_topics` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictation_sentences`
--

LOCK TABLES `dictation_sentences` WRITE;
/*!40000 ALTER TABLE `dictation_sentences` DISABLE KEYS */;
/*!40000 ALTER TABLE `dictation_sentences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictation_topics`
--

DROP TABLE IF EXISTS `dictation_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dictation_topics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `category_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK475cpll5uw1fjlo97789i4d4v` (`category_id`),
  CONSTRAINT `FK475cpll5uw1fjlo97789i4d4v` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictation_topics`
--

LOCK TABLES `dictation_topics` WRITE;
/*!40000 ALTER TABLE `dictation_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `dictation_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grammars`
--

DROP TABLE IF EXISTS `grammars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `grammars` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_grammar_categoryid` (`category_id`),
  CONSTRAINT `FKoembp4g47tfxfpsbqq7fi7s4k` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grammars`
--

LOCK TABLES `grammars` WRITE;
/*!40000 ALTER TABLE `grammars` DISABLE KEYS */;
/*!40000 ALTER TABLE `grammars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `post_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK2jovqhqo324cubdomovkex03b` (`user_id`,`post_id`),
  KEY `FKry8tnr4x2vwemv2bb0h5hyl0x` (`post_id`),
  CONSTRAINT `FKnvx9seeqqyy71bij291pwiwrg` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKry8tnr4x2vwemv2bb0h5hyl0x` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `is_read` bit(1) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `type` enum('NEW_CONTENT','NEW_LIKE_ON_POST','NEW_REPLY','REVIEW_REMINDER') NOT NULL,
  `actor_id` bigint DEFAULT NULL,
  `recipient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4sd9fik0uthbk6d9rsxco4uja` (`actor_id`),
  KEY `FKqqnsjxlwleyjbxlmm213jaj3f` (`recipient_id`),
  CONSTRAINT `FK4sd9fik0uthbk6d9rsxco4uja` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKqqnsjxlwleyjbxlmm213jaj3f` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_role`
--

DROP TABLE IF EXISTS `permission_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_role` (
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  KEY `FK6mg4g9rc8u87l0yavf8kjut05` (`permission_id`),
  KEY `FK3vhflqw0lwbwn49xqoivrtugt` (`role_id`),
  CONSTRAINT `FK3vhflqw0lwbwn49xqoivrtugt` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FK6mg4g9rc8u87l0yavf8kjut05` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_role`
--

LOCK TABLES `permission_role` WRITE;
/*!40000 ALTER TABLE `permission_role` DISABLE KEYS */;
INSERT INTO `permission_role` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30),(1,31),(1,32),(1,33),(1,34),(1,35),(1,36),(1,37),(1,38),(1,39),(1,40),(1,41),(1,42),(1,43),(1,44),(1,45),(1,46),(1,47),(1,48),(1,49),(1,50),(1,51),(1,52),(1,53),(1,54),(1,55),(1,56),(1,57),(1,58),(1,59),(1,60),(1,61),(1,62),(1,63),(1,64),(1,65),(1,66),(1,67),(1,68),(1,69),(1,70),(1,71),(1,72),(1,73),(1,74),(1,75),(1,76),(1,77),(1,78),(1,79),(1,80),(1,81),(1,82),(1,83),(1,84),(1,85),(1,86),(1,87),(1,88),(1,89),(1,90),(1,91),(1,92),(1,93),(1,94),(1,95),(1,96),(1,97),(1,98),(1,99),(1,100),(1,101),(1,102),(1,103),(1,104),(1,105),(1,106),(1,107),(1,108),(1,109),(1,110),(1,111),(1,112),(1,113),(1,114),(1,115),(1,116),(1,117),(1,118),(1,119),(1,120),(1,121),(1,122),(1,123),(1,124),(1,125),(1,126),(1,127),(1,128),(1,129),(1,130),(1,131),(1,132),(1,133),(1,134);
/*!40000 ALTER TABLE `permission_role` ENABLE KEYS */;
UNLOCK TABLES;

-- --- Module: Auth (Xác thực) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 85);  
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 60);  

-- --- Module: Users (Người dùng) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 25);  
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 55);  
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 106); -- PUT /api/v1/users/me/password (Đổi mật khẩu)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 69);  -- GET /api/v1/users/me/dashboard (Lấy dashboard)

-- --- Module: Categories (Danh mục) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 19);  -- GET /api/v1/categories/tree (Lấy cây danh mục)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 23);  -- GET /api/v1/categories (Lấy danh sách danh mục)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 73);  -- GET /api/v1/categories/{id} (Xem chi tiết danh mục)

-- --- Module: Vocabularies (Từ vựng) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 94);  -- GET /api/v1/vocabularies (Xem danh sách từ vựng)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 20);  -- GET /api/v1/vocabularies/{id} (Xem chi tiết từ vựng)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 116); -- GET /api/v1/vocabularies/review (Lấy từ vựng để ôn tập)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 114); -- POST /api/v1/vocabularies/submit-review (Nộp kết quả ôn tập)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 108); -- POST /api/v1/vocabularies/review/generate-quiz (Tạo quiz từ sổ tay)

-- --- Module: Notebook (Sổ tay) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 90);  -- POST /api/v1/notebook/add/{vocabularyId} (Thêm từ vào sổ tay)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 40);  -- DELETE /api/v1/notebook/remove/{vocabularyId} (Xóa từ khỏi sổ tay)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 89);  -- GET /api/v1/notebook/recent (Xem từ vựng gần đây)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 65);  -- GET /api/v1/notebook/level/{level} (Xem từ theo cấp độ)

-- --- Module: Grammars (Ngữ pháp) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 62);  -- GET /api/v1/grammars (Xem danh sách ngữ pháp)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 100); -- GET /api/v1/grammars/{id} (Xem chi tiết ngữ pháp)

-- --- Module: Articles (Bài báo) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 30);  -- GET /api/v1/articles (Xem danh sách bài báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 83);  -- GET /api/v1/articles/{id} (Xem chi tiết bài báo)

-- --- Module: Videos (Video) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 18);  -- GET /api/v1/videos (Xem danh sách video)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 50);  -- GET /api/v1/videos/{id} (Xem chi tiết video)

-- --- Module: Dictations (Nghe chép) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 80);  -- GET /api/v1/dictations (Xem danh sách chủ đề nghe chép)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 86);  -- GET /api/v1/dictations/{id} (Xem chi tiết chủ đề)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 4);   -- POST /api/v1/dictations/submit (Nộp bài nghe chép)

-- --- Module: Quizzes (Làm bài quiz) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 68);  -- GET /api/v1/quizzes (Xem danh sách quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 103); -- GET /api/v1/quizzes/{id} (Xem chi tiết quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 120); -- POST /api/v1/quizzes/{id}/start (Bắt đầu làm quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 111); -- POST /api/v1/quizzes/submit (Nộp bài quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 15);  -- GET /api/v1/quizzes/attempts/{attemptId} (Xem kết quả)

-- --- Module: Posts (Bài viết) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 119); -- GET /api/v1/posts (Xem tất cả bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 42);  -- GET /api/v1/posts/{id} (Xem chi tiết bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 74);  -- GET /api/v1/posts/me (Xem bài viết của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 44);  -- POST /api/v1/posts (Tạo bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 96);  -- PUT /api/v1/posts/{id} (Sửa bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 123); -- DELETE /api/v1/posts/{id} (Xóa bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 133); -- POST /api/v1/files/upload (Upload file cho bài viết)

-- --- Module: Comments (Bình luận) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 35);  -- GET /api/v1/comments/post/{postId} (Xem bình luận của bài)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 2);   -- POST /api/v1/comments (Tạo bình luận)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 77);  -- PUT /api/v1/comments/{id} (Sửa bình luận)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 109); -- DELETE /api/v1/comments/{id} (Xóa bình luận)

-- --- Module: Likes (Thích) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 126); -- POST /api/v1/posts/{id}/like (Like bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 47);  -- DELETE /api/v1/posts/{id}/like (Unlike bài viết)

-- --- Module: Notifications (Thông báo) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 3);   -- GET /api/v1/notifications (Xem danh sách thông báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 124); -- GET /api/v1/notifications/unread-count (Đếm thông báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 97);  -- POST /api/v1/notifications/{id}/read (Đánh dấu đã đọc)

-- --- Module: Subscriptions & Payments (Gói cước & Thanh toán) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 5);   -- GET /api/v1/plans (Xem các gói cước)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 104); -- GET /api/v1/plans/{id} (Xem chi tiết gói)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 122); -- POST /api/v1/subscriptions (Tạo đơn đăng ký)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 71);  -- GET /api/v1/subscriptions (Xem các gói của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 56);  -- GET /api/v1/subscriptions/{id} (Xem chi tiết gói của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 91);  -- POST /api/v1/payments/vnpay/create/{subscriptionId} (Tạo link VNPAY)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 24);  -- GET /api/v1/payments/vnpay/return (VNPAY trả về)

-- --- Module: Public (Công khai) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 70);  -- GET /api/v1/leaderboard (Xem bảng xếp hạng)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 8);   -- GET /api/v1/badges (Xem danh sách huy hiệu)
INSERT INTO permission_role (role_id, permission_id) VALUES (2, 129); -- GET /api/v1/badges/{id} (Xem chi tiết huy hiệu)

-- ===================================================
-- == CẤP QUYỀN ĐẦY ĐỦ CHO ROLE_ID = 3 (USER) ==
-- ===================================================

-- --- Module: Auth (Xác thực) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 85);  -- GET /api/v1/auth/account (Kiểm tra trạng thái đăng nhập)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 60);  -- POST /api/v1/auth/logout

-- --- Module: Users (Người dùng) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 25);  -- GET /api/v1/users/me (Lấy thông tin cá nhân)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 55);  -- GET /api/v1/users/me/{id} (Cập nhật thông tin cá nhân - thường là PUT/PATCH)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 106); -- PUT /api/v1/users/me/password (Đổi mật khẩu)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 69);  -- GET /api/v1/users/me/dashboard (Lấy dashboard)

-- --- Module: Categories (Danh mục) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 19);  -- GET /api/v1/categories/tree (Lấy cây danh mục)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 23);  -- GET /api/v1/categories (Lấy danh sách danh mục)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 73);  -- GET /api/v1/categories/{id} (Xem chi tiết danh mục)

-- --- Module: Vocabularies (Từ vựng) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 94);  -- GET /api/v1/vocabularies (Xem danh sách từ vựng)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 20);  -- GET /api/v1/vocabularies/{id} (Xem chi tiết từ vựng)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 116); -- GET /api/v1/vocabularies/review (Lấy từ vựng để ôn tập)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 114); -- POST /api/v1/vocabularies/submit-review (Nộp kết quả ôn tập)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 108); -- POST /api/v1/vocabularies/review/generate-quiz (Tạo quiz từ sổ tay)

-- --- Module: Notebook (Sổ tay) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 90);  -- POST /api/v1/notebook/add/{vocabularyId} (Thêm từ vào sổ tay)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 40);  -- DELETE /api/v1/notebook/remove/{vocabularyId} (Xóa từ khỏi sổ tay)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 89);  -- GET /api/v1/notebook/recent (Xem từ vựng gần đây)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 65);  -- GET /api/v1/notebook/level/{level} (Xem từ theo cấp độ)

-- --- Module: Grammars (Ngữ pháp) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 62);  -- GET /api/v1/grammars (Xem danh sách ngữ pháp)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 100); -- GET /api/v1/grammars/{id} (Xem chi tiết ngữ pháp)

-- --- Module: Articles (Bài báo) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 30);  -- GET /api/v1/articles (Xem danh sách bài báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 83);  -- GET /api/v1/articles/{id} (Xem chi tiết bài báo)

-- --- Module: Videos (Video) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 18);  -- GET /api/v1/videos (Xem danh sách video)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 50);  -- GET /api/v1/videos/{id} (Xem chi tiết video)

-- --- Module: Dictations (Nghe chép) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 80);  -- GET /api/v1/dictations (Xem danh sách chủ đề nghe chép)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 86);  -- GET /api/v1/dictations/{id} (Xem chi tiết chủ đề)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 4);   -- POST /api/v1/dictations/submit (Nộp bài nghe chép)

-- --- Module: Quizzes (Làm bài quiz) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 68);  -- GET /api/v1/quizzes (Xem danh sách quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 103); -- GET /api/v1/quizzes/{id} (Xem chi tiết quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 120); -- POST /api/v1/quizzes/{id}/start (Bắt đầu làm quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 111); -- POST /api/v1/quizzes/submit (Nộp bài quiz)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 15);  -- GET /api/v1/quizzes/attempts/{attemptId} (Xem kết quả)

-- --- Module: Posts (Bài viết) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 119); -- GET /api/v1/posts (Xem tất cả bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 42);  -- GET /api/v1/posts/{id} (Xem chi tiết bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 74);  -- GET /api/v1/posts/me (Xem bài viết của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 44);  -- POST /api/v1/posts (Tạo bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 96);  -- PUT /api/v1/posts/{id} (Sửa bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 123); -- DELETE /api/v1/posts/{id} (Xóa bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 133); -- POST /api/v1/files/upload (Upload file cho bài viết)

-- --- Module: Comments (Bình luận) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 35);  -- GET /api/v1/comments/post/{postId} (Xem bình luận của bài)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 2);   -- POST /api/v1/comments (Tạo bình luận)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 77);  -- PUT /api/v1/comments/{id} (Sửa bình luận)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 109); -- DELETE /api/v1/comments/{id} (Xóa bình luận)

-- --- Module: Likes (Thích) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 126); -- POST /api/v1/posts/{id}/like (Like bài viết)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 47);  -- DELETE /api/v1/posts/{id}/like (Unlike bài viết)

-- --- Module: Notifications (Thông báo) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 3);   -- GET /api/v1/notifications (Xem danh sách thông báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 124); -- GET /api/v1/notifications/unread-count (Đếm thông báo)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 97);  -- POST /api/v1/notifications/{id}/read (Đánh dấu đã đọc)

-- --- Module: Subscriptions & Payments (Gói cước & Thanh toán) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 5);   -- GET /api/v1/plans (Xem các gói cước)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 104); -- GET /api/v1/plans/{id} (Xem chi tiết gói)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 122); -- POST /api/v1/subscriptions (Tạo đơn đăng ký)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 71);  -- GET /api/v1/subscriptions (Xem các gói của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 56);  -- GET /api/v1/subscriptions/{id} (Xem chi tiết gói của tôi)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 91);  -- POST /api/v1/payments/vnpay/create/{subscriptionId} (Tạo link VNPAY)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 24);  -- GET /api/v1/payments/vnpay/return (VNPAY trả về)

-- --- Module: Public (Công khai) ---
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 70);  -- GET /api/v1/leaderboard (Xem bảng xếp hạng)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 8);   -- GET /api/v1/badges (Xem danh sách huy hiệu)
INSERT INTO permission_role (role_id, permission_id) VALUES (3, 129); -- GET /api/v1/badges/{id} (Xem chi tiết huy hiệu)
--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `api_path` varchar(255) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `method` varchar(255) NOT NULL,
  `module` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'/api/v1/admin/videos/{id}','2025-10-07 18:20:52.760929','','GET','Admin','Access GET /api/v1/admin/videos/{id}',NULL,NULL),(2,'/api/v1/comments','2025-10-07 18:20:52.772201','','POST','Comments','Access POST /api/v1/comments',NULL,NULL),(3,'/api/v1/notifications','2025-10-07 18:20:52.777359','','GET','Notifications','Access GET /api/v1/notifications',NULL,NULL),(4,'/api/v1/dictations/submit','2025-10-07 18:20:52.780961','','POST','Dictations','Access POST /api/v1/dictations/submit',NULL,NULL),(5,'/api/v1/plans','2025-10-07 18:20:52.783606','','GET','Plans','Access GET /api/v1/plans',NULL,NULL),(6,'/api/v1/admin/categories/{id}','2025-10-07 18:20:52.791706','','PUT','Admin','Access PUT /api/v1/admin/categories/{id}',NULL,NULL),(7,'/api/v1/admin/categories','2025-10-07 18:20:52.796965','','POST','Admin','Access POST /api/v1/admin/categories',NULL,NULL),(8,'/api/v1/badges','2025-10-07 18:20:52.800770','','GET','Badges','Access GET /api/v1/badges',NULL,NULL),(9,'/api/v1/admin/grammars/{id}','2025-10-07 18:20:52.808708','','PUT','Admin','Access PUT /api/v1/admin/grammars/{id}',NULL,NULL),(10,'/api/v1/admin/dictations','2025-10-07 18:20:52.820593','','GET','Admin','Access GET /api/v1/admin/dictations',NULL,NULL),(11,'/api/v1/admin/users','2025-10-07 18:20:52.831584','','GET','Admin','Access GET /api/v1/admin/users',NULL,NULL),(12,'/api/v1/admin/vocabularies','2025-10-07 18:20:52.841514','','POST','Admin','Access POST /api/v1/admin/vocabularies',NULL,NULL),(13,'/api/v1/auth/register','2025-10-07 18:20:52.848088','','POST','Auth','Access POST /api/v1/auth/register',NULL,NULL),(14,'/api/v1/auth/refresh','2025-10-07 18:20:52.880622','','POST','Auth','Access POST /api/v1/auth/refresh',NULL,NULL),(15,'/api/v1/quizzes/attempts/{attemptId}','2025-10-07 18:20:52.885111','','GET','Quizzes','Access GET /api/v1/quizzes/attempts/{attemptId}',NULL,NULL),(16,'/api/v1/admin/articles','2025-10-07 18:20:52.899453','','POST','Admin','Access POST /api/v1/admin/articles',NULL,NULL),(17,'/api/v1/admin/dictations/{id}','2025-10-07 18:20:52.907112','','PUT','Admin','Access PUT /api/v1/admin/dictations/{id}',NULL,NULL),(18,'/api/v1/videos','2025-10-07 18:20:52.911270','','GET','Videos','Access GET /api/v1/videos',NULL,NULL),(19,'/api/v1/categories/tree','2025-10-07 18:20:52.917418','','GET','Categories','Access GET /api/v1/categories/tree',NULL,NULL),(20,'/api/v1/vocabularies/{id}','2025-10-07 18:20:52.925678','','GET','Vocabularies','Access GET /api/v1/vocabularies/{id}',NULL,NULL),(21,'/api/v1/admin/vocabularies/{id}','2025-10-07 18:20:52.932655','','GET','Admin','Access GET /api/v1/admin/vocabularies/{id}',NULL,NULL),(22,'/api/v1/admin/permissions','2025-10-07 18:20:52.939966','','GET','Admin','Access GET /api/v1/admin/permissions',NULL,NULL),(23,'/api/v1/categories','2025-10-07 18:20:52.943797','','GET','Categories','Access GET /api/v1/categories',NULL,NULL),(24,'/api/v1/payments/vnpay/return','2025-10-07 18:20:52.948962','','GET','Payments','Access GET /api/v1/payments/vnpay/return',NULL,NULL),(25,'/api/v1/users/me','2025-10-07 18:20:52.957979','','GET','Users','Access GET /api/v1/users/me',NULL,NULL),(26,'/api/v1/admin/plans','2025-10-07 18:20:52.961687','','GET','Admin','Access GET /api/v1/admin/plans',NULL,NULL),(27,'/api/v1/admin/roles/{id}','2025-10-07 18:20:52.965320','','DELETE','Admin','Access DELETE /api/v1/admin/roles/{id}',NULL,NULL),(28,'/api/v1/admin/quizzes/{id}','2025-10-07 18:20:52.969028','','PUT','Admin','Access PUT /api/v1/admin/quizzes/{id}',NULL,NULL),(29,'/api/v1/admin/permissions/{id}','2025-10-07 18:20:52.972661','','DELETE','Admin','Access DELETE /api/v1/admin/permissions/{id}',NULL,NULL),(30,'/api/v1/articles','2025-10-07 18:20:52.975966','','GET','Articles','Access GET /api/v1/articles',NULL,NULL),(31,'/api/v1/admin/badges/{id}','2025-10-07 18:20:52.979019','','DELETE','Admin','Access DELETE /api/v1/admin/badges/{id}',NULL,NULL),(32,'/api/v1/auth/google','2025-10-07 18:20:52.982748','','POST','Auth','Access POST /api/v1/auth/google',NULL,NULL),(33,'/api/v1/admin/badges','2025-10-07 18:20:52.986831','','GET','Admin','Access GET /api/v1/admin/badges',NULL,NULL),(34,'/api/v1/admin/categories/tree','2025-10-07 18:20:52.990686','','GET','Admin','Access GET /api/v1/admin/categories/tree',NULL,NULL),(35,'/api/v1/comments/post/{postId}','2025-10-07 18:20:52.995581','','GET','Comments','Access GET /api/v1/comments/post/{postId}',NULL,NULL),(36,'/api/v1/auth/forgot-password','2025-10-07 18:20:52.999049','','POST','Auth','Access POST /api/v1/auth/forgot-password',NULL,NULL),(37,'/api/v1/admin/plans/{id}','2025-10-07 18:20:53.001888','','GET','Admin','Access GET /api/v1/admin/plans/{id}',NULL,NULL),(38,'/api/v1/admin/users/{id}','2025-10-07 18:20:53.005448','','PUT','Admin','Access PUT /api/v1/admin/users/{id}',NULL,NULL),(39,'/api/v1/payments/vnpay/ipn','2025-10-07 18:20:53.008440','','GET','Payments','Access GET /api/v1/payments/vnpay/ipn',NULL,NULL),(40,'/api/v1/notebook/remove/{vocabularyId}','2025-10-07 18:20:53.011704','','DELETE','Notebook','Access DELETE /api/v1/notebook/remove/{vocabularyId}',NULL,NULL),(41,'/api/v1/admin/articles/{id}','2025-10-07 18:20:53.015284','','DELETE','Admin','Access DELETE /api/v1/admin/articles/{id}',NULL,NULL),(42,'/api/v1/posts/{id}','2025-10-07 18:20:53.018935','','GET','Posts','Access GET /api/v1/posts/{id}',NULL,NULL),(43,'/api/v1/admin/dashboard','2025-10-07 18:20:53.022188','','GET','Admin','Access GET /api/v1/admin/dashboard',NULL,NULL),(44,'/api/v1/posts','2025-10-07 18:20:53.025119','','POST','Posts','Access POST /api/v1/posts',NULL,NULL),(45,'/api/v1/admin/grammars/{id}','2025-10-07 18:20:53.028052','','DELETE','Admin','Access DELETE /api/v1/admin/grammars/{id}',NULL,NULL),(46,'/api/v1/admin/categories/{id}','2025-10-07 18:20:53.030961','','DELETE','Admin','Access DELETE /api/v1/admin/categories/{id}',NULL,NULL),(47,'/api/v1/posts/{id}/like','2025-10-07 18:20:53.034156','','DELETE','Posts','Access DELETE /api/v1/posts/{id}/like',NULL,NULL),(48,'/api/v1/auth/login','2025-10-07 18:20:53.038166','','POST','Auth','Access POST /api/v1/auth/login',NULL,NULL),(49,'/api/v1/admin/videos','2025-10-07 18:20:53.041355','','GET','Admin','Access GET /api/v1/admin/videos',NULL,NULL),(50,'/api/v1/videos/{id}','2025-10-07 18:20:53.045826','','GET','Videos','Access GET /api/v1/videos/{id}',NULL,NULL),(51,'/api/v1/admin/grammars','2025-10-07 18:20:53.048512','','POST','Admin','Access POST /api/v1/admin/grammars',NULL,NULL),(52,'/api/v1/admin/dictations','2025-10-07 18:20:53.051220','','POST','Admin','Access POST /api/v1/admin/dictations',NULL,NULL),(53,'/api/v1/admin/dictations/{id}','2025-10-07 18:20:53.053880','','DELETE','Admin','Access DELETE /api/v1/admin/dictations/{id}',NULL,NULL),(54,'/api/v1/admin/users/bulk','2025-10-07 18:20:53.056631','','POST','Admin','Access POST /api/v1/admin/users/bulk',NULL,NULL),(55,'/api/v1/users/me/{id}','2025-10-07 18:20:53.059793','','GET','Users','Access GET /api/v1/users/me/{id}',NULL,NULL),(56,'/api/v1/subscriptions/{id}','2025-10-07 18:20:53.062971','','GET','Subscriptions','Access GET /api/v1/subscriptions/{id}',NULL,NULL),(57,'/api/v1/admin/videos/{id}','2025-10-07 18:20:53.065671','','PUT','Admin','Access PUT /api/v1/admin/videos/{id}',NULL,NULL),(58,'/api/v1/admin/roles','2025-10-07 18:20:53.069576','','GET','Admin','Access GET /api/v1/admin/roles',NULL,NULL),(59,'/api/v1/admin/subscriptions','2025-10-07 18:20:53.073610','','GET','Admin','Access GET /api/v1/admin/subscriptions',NULL,NULL),(60,'/api/v1/auth/logout','2025-10-07 18:20:53.077866','','POST','Auth','Access POST /api/v1/auth/logout',NULL,NULL),(61,'/api/v1/admin/quizzes','2025-10-07 18:20:53.080889','','GET','Admin','Access GET /api/v1/admin/quizzes',NULL,NULL),(62,'/api/v1/grammars','2025-10-07 18:20:53.085719','','GET','Grammars','Access GET /api/v1/grammars',NULL,NULL),(63,'/api/v1/admin/users','2025-10-07 18:20:53.089591','','POST','Admin','Access POST /api/v1/admin/users',NULL,NULL),(64,'/api/v1/admin/users/{id}','2025-10-07 18:20:53.093044','','DELETE','Admin','Access DELETE /api/v1/admin/users/{id}',NULL,NULL),(65,'/api/v1/notebook/level/{level}','2025-10-07 18:20:53.095584','','GET','Notebook','Access GET /api/v1/notebook/level/{level}',NULL,NULL),(66,'/api/v1/admin/articles/{id}','2025-10-07 18:20:53.100047','','GET','Admin','Access GET /api/v1/admin/articles/{id}',NULL,NULL),(67,'/api/v1/admin/quizzes/{id}','2025-10-07 18:20:53.106710','','DELETE','Admin','Access DELETE /api/v1/admin/quizzes/{id}',NULL,NULL),(68,'/api/v1/quizzes','2025-10-07 18:20:53.110751','','GET','Quizzes','Access GET /api/v1/quizzes',NULL,NULL),(69,'/api/v1/users/me/dashboard','2025-10-07 18:20:53.114890','','GET','Users','Access GET /api/v1/users/me/dashboard',NULL,NULL),(70,'/api/v1/leaderboard','2025-10-07 18:20:53.127659','','GET','Leaderboard','Access GET /api/v1/leaderboard',NULL,NULL),(71,'/api/v1/subscriptions','2025-10-07 18:20:53.130972','','GET','Subscriptions','Access GET /api/v1/subscriptions',NULL,NULL),(72,'/api/v1/admin/roles/{id}','2025-10-07 18:20:53.134861','','GET','Admin','Access GET /api/v1/admin/roles/{id}',NULL,NULL),(73,'/api/v1/categories/{id}','2025-10-07 18:20:53.138489','','GET','Categories','Access GET /api/v1/categories/{id}',NULL,NULL),(74,'/api/v1/posts/me','2025-10-07 18:20:53.142978','','GET','Posts','Access GET /api/v1/posts/me',NULL,NULL),(75,'/api/v1/admin/badges/{id}','2025-10-07 18:20:53.146437','','GET','Admin','Access GET /api/v1/admin/badges/{id}',NULL,NULL),(76,'/api/v1/admin/permissions/{id}','2025-10-07 18:20:53.150472','','GET','Admin','Access GET /api/v1/admin/permissions/{id}',NULL,NULL),(77,'/api/v1/comments/{id}','2025-10-07 18:20:53.153860','','PUT','Comments','Access PUT /api/v1/comments/{id}',NULL,NULL),(78,'/api/v1/admin/permissions','2025-10-07 18:20:53.156777','','POST','Admin','Access POST /api/v1/admin/permissions',NULL,NULL),(79,'/api/v1/admin/quizzes/generate-from-category','2025-10-07 18:20:53.160034','','POST','Admin','Access POST /api/v1/admin/quizzes/generate-from-category',NULL,NULL),(80,'/api/v1/dictations','2025-10-07 18:20:53.162901','','GET','Dictations','Access GET /api/v1/dictations',NULL,NULL),(81,'/api/v1/admin/plans','2025-10-07 18:20:53.165620','','POST','Admin','Access POST /api/v1/admin/plans',NULL,NULL),(82,'/api/v1/admin/vocabularies/{id}','2025-10-07 18:20:53.168353','','PUT','Admin','Access PUT /api/v1/admin/vocabularies/{id}',NULL,NULL),(83,'/api/v1/articles/{id}','2025-10-07 18:20:53.171302','','GET','Articles','Access GET /api/v1/articles/{id}',NULL,NULL),(84,'/api/v1/admin/badges','2025-10-07 18:20:53.173673','','POST','Admin','Access POST /api/v1/admin/badges',NULL,NULL),(85,'/api/v1/auth/account','2025-10-07 18:20:53.176182','','GET','Auth','Access GET /api/v1/auth/account',NULL,NULL),(86,'/api/v1/dictations/{id}','2025-10-07 18:20:53.178639','','GET','Dictations','Access GET /api/v1/dictations/{id}',NULL,NULL),(87,'/api/v1/admin/grammars/{id}','2025-10-07 18:20:53.181034','','GET','Admin','Access GET /api/v1/admin/grammars/{id}',NULL,NULL),(88,'/api/v1/admin/categories/{id}','2025-10-07 18:20:53.183494','','GET','Admin','Access GET /api/v1/admin/categories/{id}',NULL,NULL),(89,'/api/v1/notebook/recent','2025-10-07 18:20:53.186255','','GET','Notebook','Access GET /api/v1/notebook/recent',NULL,NULL),(90,'/api/v1/notebook/add/{vocabularyId}','2025-10-07 18:20:53.188745','','POST','Notebook','Access POST /api/v1/notebook/add/{vocabularyId}',NULL,NULL),(91,'/api/v1/payments/vnpay/create/{subscriptionId}','2025-10-07 18:20:53.191621','','POST','Payments','Access POST /api/v1/payments/vnpay/create/{subscriptionId}',NULL,NULL),(92,'/api/v1/admin/categories','2025-10-07 18:20:53.194380','','GET','Admin','Access GET /api/v1/admin/categories',NULL,NULL),(93,'/api/v1/admin/plans/{id}','2025-10-07 18:20:53.197413','','PUT','Admin','Access PUT /api/v1/admin/plans/{id}',NULL,NULL),(94,'/api/v1/vocabularies','2025-10-07 18:20:53.200964','','GET','Vocabularies','Access GET /api/v1/vocabularies',NULL,NULL),(95,'/api/v1/admin/videos/{id}','2025-10-07 18:20:53.204300','','DELETE','Admin','Access DELETE /api/v1/admin/videos/{id}',NULL,NULL),(96,'/api/v1/posts/{id}','2025-10-07 18:20:53.216601','','PUT','Posts','Access PUT /api/v1/posts/{id}',NULL,NULL),(97,'/api/v1/notifications/{id}/read','2025-10-07 18:20:53.220233','','POST','Notifications','Access POST /api/v1/notifications/{id}/read',NULL,NULL),(98,'/api/v1/admin/vocabularies','2025-10-07 18:20:53.223710','','GET','Admin','Access GET /api/v1/admin/vocabularies',NULL,NULL),(99,'/api/v1/admin/videos','2025-10-07 18:20:53.228032','','POST','Admin','Access POST /api/v1/admin/videos',NULL,NULL),(100,'/api/v1/grammars/{id}','2025-10-07 18:20:53.239606','','GET','Grammars','Access GET /api/v1/grammars/{id}',NULL,NULL),(101,'/api/v1/admin/dictations/{id}','2025-10-07 18:20:53.248681','','GET','Admin','Access GET /api/v1/admin/dictations/{id}',NULL,NULL),(102,'/api/v1/admin/vocabularies/bulk','2025-10-07 18:20:53.261280','','POST','Admin','Access POST /api/v1/admin/vocabularies/bulk',NULL,NULL),(103,'/api/v1/quizzes/{id}','2025-10-07 18:20:53.265050','','GET','Quizzes','Access GET /api/v1/quizzes/{id}',NULL,NULL),(104,'/api/v1/plans/{id}','2025-10-07 18:20:53.282705','','GET','Plans','Access GET /api/v1/plans/{id}',NULL,NULL),(105,'/api/v1/admin/articles','2025-10-07 18:20:53.300675','','GET','Admin','Access GET /api/v1/admin/articles',NULL,NULL),(106,'/api/v1/users/me/password','2025-10-07 18:20:53.308221','','PUT','Users','Access PUT /api/v1/users/me/password',NULL,NULL),(107,'/api/v1/admin/quizzes/{id}','2025-10-07 18:20:53.323831','','GET','Admin','Access GET /api/v1/admin/quizzes/{id}',NULL,NULL),(108,'/api/v1/vocabularies/review/generate-quiz','2025-10-07 18:20:53.327458','','POST','Vocabularies','Access POST /api/v1/vocabularies/review/generate-quiz',NULL,NULL),(109,'/api/v1/comments/{id}','2025-10-07 18:20:53.333317','','DELETE','Comments','Access DELETE /api/v1/comments/{id}',NULL,NULL),(110,'/api/v1/admin/users/{id}','2025-10-07 18:20:53.347498','','GET','Admin','Access GET /api/v1/admin/users/{id}',NULL,NULL),(111,'/api/v1/quizzes/submit','2025-10-07 18:20:53.362484','','POST','Quizzes','Access POST /api/v1/quizzes/submit',NULL,NULL),(112,'/api/v1/admin/roles','2025-10-07 18:20:53.367251','','POST','Admin','Access POST /api/v1/admin/roles',NULL,NULL),(113,'/api/v1/admin/vocabularies/{id}','2025-10-07 18:20:53.386564','','DELETE','Admin','Access DELETE /api/v1/admin/vocabularies/{id}',NULL,NULL),(114,'/api/v1/vocabularies/submit-review','2025-10-07 18:20:53.392993','','POST','Vocabularies','Access POST /api/v1/vocabularies/submit-review',NULL,NULL),(115,'/api/v1/admin/quizzes','2025-10-07 18:20:53.397692','','POST','Admin','Access POST /api/v1/admin/quizzes',NULL,NULL),(116,'/api/v1/vocabularies/review','2025-10-07 18:20:53.410403','','GET','Vocabularies','Access GET /api/v1/vocabularies/review',NULL,NULL),(117,'/api/v1/admin/subscriptions/confirm-payment/{subscriptionId}','2025-10-07 18:20:53.418650','','POST','Admin','Access POST /api/v1/admin/subscriptions/confirm-payment/{subscriptionId}',NULL,NULL),(118,'/api/v1/admin/statistics/revenue','2025-10-07 18:20:53.445264','','GET','Admin','Access GET /api/v1/admin/statistics/revenue',NULL,NULL),(119,'/api/v1/posts','2025-10-07 18:20:53.457395','','GET','Posts','Access GET /api/v1/posts',NULL,NULL),(120,'/api/v1/quizzes/{id}/start','2025-10-07 18:20:53.461565','','POST','Quizzes','Access POST /api/v1/quizzes/{id}/start',NULL,NULL),(121,'/api/v1/admin/plans/{id}','2025-10-07 18:20:53.476265','','DELETE','Admin','Access DELETE /api/v1/admin/plans/{id}',NULL,NULL),(122,'/api/v1/subscriptions','2025-10-07 18:20:53.446501','','POST','Subscriptions','Access POST /api/v1/subscriptions',NULL,NULL),(123,'/api/v1/posts/{id}','2025-10-07 18:20:53.450357','','DELETE','Posts','Access DELETE /api/v1/posts/{id}',NULL,NULL),(124,'/api/v1/notifications/unread-count','2025-10-07 18:20:53.466174','','GET','Notifications','Access GET /api/v1/notifications/unread-count',NULL,NULL),(125,'/api/v1/admin/subscriptions/{id}','2025-10-07 18:20:53.481364','','GET','Admin','Access GET /api/v1/admin/subscriptions/{id}',NULL,NULL),(126,'/api/v1/posts/{id}/like','2025-10-07 18:20:53.499429','','POST','Posts','Access POST /api/v1/posts/{id}/like',NULL,NULL),(127,'/api/v1/admin/articles/{id}','2025-10-07 18:20:53.503046','','PUT','Admin','Access PUT /api/v1/admin/articles/{id}',NULL,NULL),(128,'/api/v1/auth/reset-password','2025-10-07 18:20:53.518496','','POST','Auth','Access POST /api/v1/auth/reset-password',NULL,NULL),(129,'/api/v1/badges/{id}','2025-10-07 18:20:53.526442','','GET','Badges','Access GET /api/v1/badges/{id}',NULL,NULL),(130,'/api/v1/admin/roles/{id}','2025-10-07 18:20:53.545193','','PUT','Admin','Access PUT /api/v1/admin/roles/{id}',NULL,NULL),(131,'/api/v1/admin/grammars','2025-10-07 18:20:53.548806','','GET','Admin','Access GET /api/v1/admin/grammars',NULL,NULL),(132,'/api/v1/admin/badges/{id}','2025-10-07 18:20:53.563415','','PUT','Admin','Access PUT /api/v1/admin/badges/{id}',NULL,NULL),(133,'/api/v1/files/upload','2025-10-07 18:20:53.567124','','POST','Files','Access POST /api/v1/files/upload',NULL,NULL),(134,'/api/v1/admin/permissions/{id}','2025-10-07 18:20:53.572137','','PUT','Admin','Access PUT /api/v1/admin/permissions/{id}',NULL,NULL);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plans`
--

DROP TABLE IF EXISTS `plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plans` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `description` text,
  `duration_in_days` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKj2syv9y60858xbq169nbeg7ea` (`name`),
  CONSTRAINT `plans_chk_1` CHECK ((`duration_in_days` >= 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plans`
--

LOCK TABLES `plans` WRITE;
/*!40000 ALTER TABLE `plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_attachments`
--

DROP TABLE IF EXISTS `post_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_attachments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_type` enum('AUDIO','DOCUMENT','FILE','IMAGE','VIDEO') NOT NULL,
  `file_url` varchar(2048) NOT NULL,
  `original_file_name` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `post_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKdwocy2l1nlf11ebpfrax6sto1` (`post_id`),
  CONSTRAINT `FKdwocy2l1nlf11ebpfrax6sto1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_attachments`
--

LOCK TABLES `post_attachments` WRITE;
/*!40000 ALTER TABLE `post_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `caption` text,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDXpn7a4a2mjksl19jlm7k106m7x` (`user_id`),
  CONSTRAINT `FK5lidm6cqbc7u4xhqpxm898qme` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_choices`
--

DROP TABLE IF EXISTS `question_choices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_choices` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `image_url` varchar(2048) DEFAULT NULL,
  `is_correct` bit(1) NOT NULL,
  `question_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK77biojwg2xd8kc8a2odnx3ld4` (`question_id`),
  CONSTRAINT `FK77biojwg2xd8kc8a2odnx3ld4` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_choices`
--

LOCK TABLES `question_choices` WRITE;
/*!40000 ALTER TABLE `question_choices` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_choices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `audio_url` varchar(2048) DEFAULT NULL,
  `correct_sentence` text,
  `image_url` varchar(2048) DEFAULT NULL,
  `points` int NOT NULL,
  `prompt` text,
  `question_order` int NOT NULL,
  `question_type` enum('ARRANGE_WORDS','FILL_IN_BLANK','LISTENING_COMPREHENSION','LISTENING_TRANSCRIPTION','MULTIPLE_CHOICE_IMAGE','MULTIPLE_CHOICE_TEXT','SPEAKING_PRONUNCIATION','TRANSLATE_EN_TO_VI','TRANSLATE_VI_TO_EN') NOT NULL,
  `text_to_fill` text,
  `quiz_id` bigint NOT NULL,
  `vocabulary_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_question_quizid` (`quiz_id`),
  KEY `FK3no2os50fns3fvitolhr1cmo2` (`vocabulary_id`),
  CONSTRAINT `FK3no2os50fns3fvitolhr1cmo2` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabularies` (`id`),
  CONSTRAINT `FKn3gvco4b0kewxc0bywf1igfms` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` text,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `category_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_quiz_categoryid` (`category_id`),
  CONSTRAINT `FKpo9fnqd9hnnmg8qxiyue40cot` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,_binary '','2025-10-07 18:20:52.542705','','Quß║ún trß╗ï vi├¬n hß╗ç thß╗æng','ADMIN','2025-10-07 18:20:54.597104',''),(2,_binary '','2025-10-07 18:20:52.714563','','Ng╞░ß╗¥i d├╣ng trß║ú ph├¡','PREMIUM',NULL,NULL),(3,_binary '','2025-10-07 18:20:52.727036','','Ng╞░ß╗¥i d├╣ng th╞░ß╗¥ng','USER',NULL,NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `end_date` datetime(6) NOT NULL,
  `payment_status` enum('CANCELLED','FAILED','PAID','PENDING','REFUNDED') NOT NULL,
  `start_date` datetime(6) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `plan_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKhp3x02yf1gmraofbm317wyoyy` (`transaction_id`),
  KEY `idx_subscription_userid` (`user_id`),
  KEY `idx_subscription_planid` (`plan_id`),
  CONSTRAINT `FKb1uf5qnxi6uj95se8ykydntl1` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`),
  CONSTRAINT `FKhro52ohfqfbay9774bev0qinr` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_answers`
--

DROP TABLE IF EXISTS `user_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_answers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_correct` bit(1) NOT NULL,
  `points_awarded` int NOT NULL,
  `user_answer_text` text,
  `question_id` bigint NOT NULL,
  `selected_choice_id` bigint DEFAULT NULL,
  `user_quiz_attempt_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6b46l4bb7a6wfxvmn6l7ig8vo` (`question_id`),
  KEY `FKn8fytcgbow9en1uj8hhjup2xb` (`selected_choice_id`),
  KEY `FK9w36qx6umlv3f5ht5ix1aerp0` (`user_quiz_attempt_id`),
  CONSTRAINT `FK6b46l4bb7a6wfxvmn6l7ig8vo` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `FK9w36qx6umlv3f5ht5ix1aerp0` FOREIGN KEY (`user_quiz_attempt_id`) REFERENCES `user_quiz_attempts` (`id`),
  CONSTRAINT `FKn8fytcgbow9en1uj8hhjup2xb` FOREIGN KEY (`selected_choice_id`) REFERENCES `question_choices` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_answers`
--

LOCK TABLES `user_answers` WRITE;
/*!40000 ALTER TABLE `user_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_quiz_attempts`
--

DROP TABLE IF EXISTS `user_quiz_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_quiz_attempts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `completed_at` datetime(6) DEFAULT NULL,
  `score` int NOT NULL,
  `started_at` datetime(6) DEFAULT NULL,
  `status` enum('COMPLETED','IN_PROGRESS') DEFAULT NULL,
  `quiz_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKe0gejt22jfe63bqyxf0r0oij5` (`quiz_id`),
  KEY `FKoaw8nqmi8wi4tmqgxxncumv1v` (`user_id`),
  CONSTRAINT `FKe0gejt22jfe63bqyxf0r0oij5` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`),
  CONSTRAINT `FKoaw8nqmi8wi4tmqgxxncumv1v` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_quiz_attempts`
--

LOCK TABLES `user_quiz_attempts` WRITE;
/*!40000 ALTER TABLE `user_quiz_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_quiz_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_vocabularies`
--

DROP TABLE IF EXISTS `user_vocabularies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_vocabularies` (
  `created_at` datetime(6) NOT NULL,
  `ease_factor` double NOT NULL,
  `last_reviewed_at` datetime(6) DEFAULT NULL,
  `level` int NOT NULL,
  `next_review_at` datetime(6) DEFAULT NULL,
  `repetitions` int NOT NULL,
  `reivew_interval` int NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `vocabulary_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`,`vocabulary_id`),
  KEY `idx_uservocab_nextreview` (`next_review_at`),
  KEY `FKiwj9kwk84ksatdv7envivhjeq` (`vocabulary_id`),
  CONSTRAINT `FK1sok4p9rd5oxknfndtde2qhj7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKiwj9kwk84ksatdv7envivhjeq` FOREIGN KEY (`vocabulary_id`) REFERENCES `vocabularies` (`id`),
  CONSTRAINT `user_vocabularies_chk_1` CHECK (((`level` <= 5) and (`level` >= 1))),
  CONSTRAINT `user_vocabularies_chk_2` CHECK ((`repetitions` >= 0)),
  CONSTRAINT `user_vocabularies_chk_3` CHECK ((`reivew_interval` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_vocabularies`
--

LOCK TABLES `user_vocabularies` WRITE;
/*!40000 ALTER TABLE `user_vocabularies` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_vocabularies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `last_activity_date` date DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `point` int NOT NULL,
  `refresh_token` mediumtext,
  `streak_count` int DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `badge_id` bigint DEFAULT NULL,
  `role_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  KEY `FK4od1t4befwkxrjsx07s4v8bb2` (`badge_id`),
  KEY `FKp56c1712k691lhsyewcssf40f` (`role_id`),
  CONSTRAINT `FK4od1t4befwkxrjsx07s4v8bb2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`),
  CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `users_chk_1` CHECK ((`point` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,_binary '','2025-10-07 18:20:54.318353','','admin@gmail.com','2025-10-08','Admin','$2a$10$MRUYwqND63LNcL79iARz8.z479Dwd00mQ/tgJ2Rkm4IcUFk7bTKXq',0,NULL,1,'2025-10-08 10:28:33.581247','admin@gmail.com',NULL,1),(2,_binary '','2025-10-07 18:59:23.698272','anonymousUser','vunhatminh.vnw.03@gmail.com','2025-10-09','Vu Nhat Minh','$2a$10$QLN10SaBMdV2ptAMRAfYR.6mWy.mHUsHIUy4mlf1KGnu6qX7sat4G',0,'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ2dW5oYXRtaW5oLnZudy4wM0BnbWFpbC5jb20iLCJleHAiOjE3NjA1MjQxMzEsImlhdCI6MTc1OTkxOTMzMSwidXNlciI6eyJpZCI6MiwiZW1haWwiOiJ2dW5oYXRtaW5oLnZudy4wM0BnbWFpbC5jb20iLCJuYW1lIjoiVnUgTmhhdCBNaW5oIn19.uKEyA7TacrCQdnnGiR8Cp7M_hPcARwe3mg2uYU2LsZToKHdRHPyO3NHQarC2Kz81aTM355E26zgsBWGHyiG7rw',2,'2025-10-09 02:51:22.604559','',1,3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `videos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `description` text,
  `duration` varchar(20) DEFAULT NULL,
  `subtitle` text,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `url` varchar(2048) NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_video_categoryid` (`category_id`),
  CONSTRAINT `FK757y9y2j67t6nl4h5746si1rx` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vocabularies`
--

DROP TABLE IF EXISTS `vocabularies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vocabularies` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `audio` varchar(2048) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `definition_en` text,
  `example_en` text,
  `example_vi` text,
  `image` varchar(2048) DEFAULT NULL,
  `meaning_vi` text,
  `part_of_speech` varchar(50) DEFAULT NULL,
  `pronunciation` varchar(100) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `word` varchar(150) NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vocabulary_categoryid` (`category_id`),
  CONSTRAINT `FK8ri1fkftx79f8pxah1yq773fp` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vocabularies`
--

LOCK TABLES `vocabularies` WRITE;
/*!40000 ALTER TABLE `vocabularies` DISABLE KEYS */;
/*!40000 ALTER TABLE `vocabularies` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-12 16:43:37
