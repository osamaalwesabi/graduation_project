-- phpMyAdmin SQL Dump
-- version 5.2.3deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 23, 2025 at 04:37 AM
-- Server version: 11.8.5-MariaDB-1 from Debian
-- PHP Version: 8.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `graduation_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `advertisements`
--

CREATE TABLE `advertisements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `position` enum('header','sidebar','footer','content','popup') NOT NULL DEFAULT 'sidebar',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('draft','active','expired','inactive') NOT NULL DEFAULT 'draft',
  `display_order` int(11) NOT NULL DEFAULT 0,
  `clicks_count` int(11) NOT NULL DEFAULT 0,
  `impressions_count` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Contents`
--

CREATE TABLE `Contents` (
  `id` int(11) NOT NULL,
  `page_id` int(11) DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `slug_en` varchar(100) DEFAULT NULL,
  `content_title` varchar(255) DEFAULT NULL,
  `content_description` varchar(1000) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `stats` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Contents`
--

INSERT INTO `Contents` (`id`, `page_id`, `slug`, `slug_en`, `content_title`, `content_description`, `created_at`, `updated_at`, `stats`) VALUES
(1, 2, 'من نحن', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(2, 2, 'الأسئلة الشائعة', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(3, 2, 'الشركاء', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(4, 2, 'الدراسات', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(5, 2, 'تواصل معنا', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(6, 5, 'فلاشات توعوية', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(7, 5, 'أخبار', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(8, 5, 'قصص نجاح', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(9, 5, 'حلقات إذاعية', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(10, 5, 'أناشيد', NULL, NULL, NULL, '2025-12-19 07:03:20', '0000-00-00 00:00:00', 1),
(11, 3, 'خدمات التدريب', NULL, NULL, 'تقدم الهيئة برامج تدريبية متخصصة تهدف إلى تطوير مهارات رواد الأعمال...', '2025-12-23 02:16:23', '0000-00-00 00:00:00', 1),
(12, 3, 'خدمات التمويل', NULL, NULL, 'تقدم الهيئة قروضاً بيضاء عبر الجمعيات الشريكة لدعم المشاريع...', '2025-12-23 02:17:15', '0000-00-00 00:00:00', 1),
(13, 3, 'خدمات الاستشارات', NULL, NULL, 'نقدم استشارات متخصصة تساعد أصحاب المشاريع على النمو...', '2025-12-23 02:17:30', '0000-00-00 00:00:00', 1),
(14, 3, 'خدمات التسويق', NULL, NULL, 'نسعى لتسويق منتجات المشاريع الصغيرة عبر المعارض والفعاليات...', '2025-12-23 02:17:03', '0000-00-00 00:00:00', 1),
(15, 4, 'مذكرة المواصفات والمقاييس ', NULL, NULL, 'تصدر الهيئة العامة لتنمية المشاريع الصغيرة والأصغر مذكرات رسمية موجهة إلى الجهات الحكومية ذات العلاقة، ومنها الهيئة اليمنية للمواصفات والمقاييس وضبط الجودة، وذلك لتسهيل إجراءات تسجيل وترخيص المشاريع الصغيرة والأصغر، وتمكينها من الحصول على الدعم اللوجستي والخدمات وفق الأنظمة المعتمدة. تمثل هذه المذكرات أداة هامة لدعم رواد الأعمال وتعزيز استدامة المشاريع الإنتاجية الصغيرة.', '2025-12-23 02:20:57', '0000-00-00 00:00:00', 1),
(16, 6, 'مشروع تدريب 16 إمرأة على خياطة القطنيات بطرق صناعية', NULL, NULL, NULL, '2025-12-20 17:03:37', '0000-00-00 00:00:00', 1),
(17, 6, 'مشروع تمكين المتدربات في صناعة الحقائب والأحزمة الجلدية', NULL, NULL, NULL, '2025-12-20 17:03:37', '0000-00-00 00:00:00', 1),
(18, 6, 'مشروع خياطة الجلديات لـ20 شاب من أبناء مديرية بني الحارث', NULL, NULL, NULL, '2025-12-20 17:03:37', '0000-00-00 00:00:00', 1),
(19, 7, 'فرصة تدريب جديدة', NULL, NULL, NULL, '2025-12-20 09:35:50', '0000-00-00 00:00:00', 1),
(20, 7, 'فرصة تطوع جديدة', NULL, NULL, NULL, '2025-12-20 09:35:50', '0000-00-00 00:00:00', 1),
(21, 7, 'فرصة تعاقد جديدة', NULL, NULL, NULL, '2025-12-20 09:35:50', '0000-00-00 00:00:00', 1),
(22, 8, 'منتجات يدوية تقليدية مصنوعة بأيدي محلية. نبيع سلات، مفارش وأعمال فنية.', NULL, NULL, NULL, '2025-12-20 09:36:25', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `Content_details`
--

CREATE TABLE `Content_details` (
  `id` int(11) NOT NULL,
  `content_info_id` int(11) DEFAULT NULL,
  `URL` text DEFAULT NULL,
  `additional_info` text DEFAULT NULL,
  `additional_info_en` text DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `desc` longtext DEFAULT NULL,
  `desc_en` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `stats` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Content_details`
--

INSERT INTO `Content_details` (`id`, `content_info_id`, `URL`, `additional_info`, `additional_info_en`, `link`, `desc`, `desc_en`, `created_at`, `updated_at`, `stats`) VALUES
(1, 1, '', 'تأسست الهيئة العامة لتنمية المشاريع الصغيرة والأصغر في مارس 2021 بهدف تنظيم وتنمية قطاع المشاريع الصغيرة... ', NULL, NULL, NULL, NULL, '2025-12-21 09:21:10', '0000-00-00 00:00:00', 1),
(2, 2, '', 'مجتمع منتج قادر على توظيف موارده بما يعزز الاقتصاد الوطني.', NULL, NULL, NULL, NULL, '2025-12-20 06:11:19', '0000-00-00 00:00:00', 1),
(3, 3, '', 'تنمية المشاريع الصغيرة والأصغر من خلال توفير البيئة الداعمة ونشر المعرفة وتوظيف الإمكانات المتاحة بطرق مبتكرة ومتكاملة.', NULL, NULL, NULL, NULL, '2025-12-20 06:11:19', '0000-00-00 00:00:00', 1),
(4, 4, '', '    توفير بيئة داعمة تساعد على تنمية المشاريع الصغيرة...\r\n    وضع الاستراتيجيات والسياسات الوطنية الداعمة...\r\n    نشر المعرفة بما يحقق الفاعلية والاستدامة...\r\n    دعم نفاذ منتجات المشاريع الصغيرة...', NULL, NULL, NULL, NULL, '2025-12-20 06:11:19', '0000-00-00 00:00:00', 1),
(5, 5, '', ' النزاهة :تنفيذ كافة المهام والالتزامات بأمانة وصدق والالتزام بكل ما هو أخلاقي. \r\nالشفافية :الإفصاح عن نتائج العمليات بشكل مستمر ومنتظم وتمكين الجميع من الحصول على المعلومات. \r\nالمرونة :القدرة على التكيّف مع المتغيرات لتحقيق أداء مستقر. \r\nالشمول :وصول الخدمات المالية وغير المالية لكل المناطق والمحافظات. \r\nالتكامل :توحيد جهود العاملين لتحقيق سلسلة أهداف متكاملة. \r\nالابتكار :تقديم حلول مبتكرة تدعم تطوير المشاريع الصغيرة والأصغر. ', NULL, NULL, NULL, NULL, '2025-12-20 06:11:19', '0000-00-00 00:00:00', 1),
(6, 6, NULL, 'نعم، الهيئة تقدم قروض بيضاء عبر الجمعيات الشريكة لها في المحافظات لأصحاب المشاريع الصغيرة في مجالات الثروة الحيواني، الصيد البحري، التربية الحيوانية التصنيع الغذائي، الخياطة، الحرف، التصنيع المنزلي.', NULL, NULL, NULL, NULL, '2025-12-20 06:15:02', '0000-00-00 00:00:00', 1),
(7, 7, NULL, 'تقدم الهيئة العامة لتنمية المشاريع الصغيرة والأصغر الدعم لقطاع المشاريع الصغيرة في اليمن والذي يضم آلاف المشاريع عبر عدة مستويات منها المساهمة في سن القوانيين التي توفر البيئة الداعمة لنمو وتطور المشاريع الصغيرة مثل قانون الاعفاء الضريبي للمشاريع الصغيرة وقانون الاستثمار الذي يعفي المشاريع التي تقل تكلفتها الاستثمارية عن 100 الف دولار من الرسوم الحكومية.\r\nكذلك تقدم الهيئة خدمات مالية مبتكرة للمشاريع لصغيرة ضمن سلاسل القيمة المعتمدة من قبل الحكومة، بهدف تمكين الفئات الأشد فقرًا وأصحاب المشاريع الإنتاجية من تحقيق الاكتفاء الذاتي وتحسين سبل العيش.\r\nفي المرحلة الحالية، توفر الهيئة قروضاً بيضاء متنوعة بتمويل من الهيئة العامة للزكاة، تهدف للتمكين الاقتصادي للشرائح الأكثر احتياجًا في ضوء كشوفات الزكاة، وكذلك تقدم الهيئة قروض ممولة من أمانة العاصمة صنعاء لأصحاب المشاريع الإنتاجية، مع التركيز على المشاريع في مجالات الثروة الحيوانية، الصيد البحري، التصنيع الغذائي، الخياطة، الحرف، التصنيع المنزلي.\r\nأيضاً الهيئة تقدم برامج تدريبية متخصصة في مجالات التصنيع الغذائي، الجلود الطبيعية، الخياطة، الحرف اليدوية، ريادة الأعمال، والتدريب المهني والمعرفي لأصحاب المشاريع الصغيرة وغيرهم، وذلك ضمن منهجية مبتكرة تقوم على \"تدريب – تمكين – تسويق\".\r\n', NULL, NULL, NULL, NULL, '2025-12-20 06:15:02', '0000-00-00 00:00:00', 1),
(8, 8, NULL, 'عبر متابعة إعلانات الهيئة عن الدورات التدريبية الجديدة في موقعها الإلكتروني ومنصات مواقع التواصل، الى جانب التسجيل في نموذج الراغبين بخدمة التدريب الموجودة في قسم خدمات التدريب\r\n', NULL, NULL, NULL, NULL, '2025-12-20 06:15:02', '0000-00-00 00:00:00', 1),
(9, 9, NULL, 'يمكن التقديم على قرض الى الجمعيات الشريكة للهيئة في المديريات المذكورة في قسم خدمات التمويل\r\n', NULL, NULL, NULL, NULL, '2025-12-20 06:15:02', '0000-00-00 00:00:00', 1),
(10, 10, NULL, 'قروض بيضاء ميسرة', NULL, NULL, NULL, NULL, '2025-12-20 06:15:02', '0000-00-00 00:00:00', 1),
(11, 39, NULL, 'هذا يعتمد على نوع المشروع الصغير وحالته', NULL, NULL, NULL, NULL, '2025-12-20 06:18:41', '0000-00-00 00:00:00', 1),
(12, 40, NULL, 'تبدأ بخمسين الف ريال يمني', NULL, NULL, NULL, NULL, '2025-12-20 06:18:41', '0000-00-00 00:00:00', 1),
(13, 41, NULL, 'عبر التسجيل في قواعد البيانات من زر سجل مشروعك', NULL, NULL, NULL, NULL, '2025-12-20 06:18:41', '0000-00-00 00:00:00', 1),
(19, 14, NULL, 'رقم التواصل: 780040072\nالعلاقات العامة: 780040073\nنافذة المقترحات: 783888781', NULL, NULL, NULL, NULL, '2025-12-23 00:49:46', '0000-00-00 00:00:00', 1),
(20, 15, NULL, 'السبت – الأربعاء \r\n 8:00  صباحاً – 1:00  مساءً', NULL, NULL, NULL, NULL, '2025-12-20 06:24:47', '0000-00-00 00:00:00', 1),
(21, 16, NULL, ' صنعاء – الدائري – جولة غزة (كنتاكي سابقاً) – عمارة المعقلي', NULL, NULL, NULL, NULL, '2025-12-20 06:24:47', '0000-00-00 00:00:00', 1),
(22, 17, NULL, 'https://www.facebook.com/share/1Lk2sKUtik/ https://youtube.com/channel/UCL-scONsm7whLMk2rc1aCaA?si=s4NDyRAX5bwcXQOg https://t.me/samea777 https://whatsapp.com/channel/0029Vadqi2xK0IBflHShbP1B https://x.com/Gasmed28Gasmed?t=MTnUmxS6FGUDzKghkLtP9A&s=09', NULL, NULL, NULL, NULL, '2025-12-23 00:45:56', '0000-00-00 00:00:00', 1),
(23, 18, NULL, ' info@gasmed.gov.ye', NULL, NULL, NULL, NULL, '2025-12-23 00:46:03', '0000-00-00 00:00:00', 1),
(24, 12, '/images/partner-ex-1.png', NULL, NULL, NULL, NULL, NULL, '2025-12-21 11:18:25', '0000-00-00 00:00:00', 1),
(25, 19, '/videos/cream-cheese.mp4', '{\"id\": 1, \"slug\": \"cream-cheese\", \"title\": \"إنتاج الجبن السائل (الكريمي) في البيت\", \"description\": \"فيديو تعليمي لإنتاج الجبن الكريمي في المنزل بطريقة آمنة وسهلة\", \"duration\": \"5:30\", \"views\": 1250}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(26, 19, '/videos/salty-cheese.mp4', '{\"id\": 2, \"slug\": \"salty-cheese\", \"title\": \"إنتاج الجبن المالح في البيت\", \"description\": \"تعلم طريقة صنع الجبن المالح التقليدي في المنزل\", \"duration\": \"6:15\", \"views\": 980}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(27, 19, '/videos/milk-powder.mp4', '{\"id\": 3, \"slug\": \"milk-powder\", \"title\": \"إنتاج الزبادي من الحليب البودرة في المنزل\", \"description\": \"كيفية تحضير الزبادي باستخدام الحليب البودرة\", \"duration\": \"4:45\", \"views\": 1560}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(28, 19, '/videos/apple-jam.mp4', '{\"id\": 4, \"slug\": \"apple-jam\", \"title\": \"إنتاج مربى التفاح الطبيعي في البيت\", \"description\": \"طريقة عمل مربى التفاح الطبيعي بدون مواد حافظة\", \"duration\": \"7:20\", \"views\": 890}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(29, 19, '/videos/strawberry-jam.mp4', '{\"id\": 5, \"slug\": \"strawberry-jam\", \"title\": \"إنتاج مربى الفراولة الطبيعي في البيت\", \"description\": \"تحضير مربى الفراولة الطازج في المنزل\", \"duration\": \"6:50\", \"views\": 1120}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(30, 19, '/videos/dry-tomato.mp4', '{\"id\": 6, \"slug\": \"dry-tomato\", \"title\": \"تجفيف الطماطم خلال مواسم الوفرة\", \"description\": \"تقنية تجفيف الطماطط للحفاظ عليها في غير موسمها\", \"duration\": \"8:10\", \"views\": 740}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(31, 20, '/videos/animal-health-1.mp4', '{\"id\": 1, \"slug\": \"msg-1\", \"title\": \"رسالة توعوية لمربي المواشي 1\", \"description\": \"رسالة توعوية حول الرعاية الأساسية للمواشي\", \"duration\": \"3:20\", \"views\": 2100}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(32, 20, '/videos/animal-health-2.mp4', '{\"id\": 2, \"slug\": \"msg-2\", \"title\": \"رسالة توعوية لمربي المواشي 2\", \"description\": \"نصائح للوقاية من أمراض المواشي الشائعة\", \"duration\": \"4:10\", \"views\": 1850}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(33, 20, '/videos/animal-health-3.mp4', '{\"id\": 3, \"slug\": \"msg-3\", \"title\": \"رسالة توعوية لمربي المواشي 3\", \"description\": \"إرشادات للتغذية السليمة للمواشي\", \"duration\": \"3:45\", \"views\": 1670}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(34, 21, '/videos/learn-minute-1.mp4', '{\"id\": 1, \"slug\": \"skill-1\", \"title\": \"مهارة 1: أساسيات التسويق الرقمي\", \"description\": \"تعلم أساسيات التسويق الرقمي في دقيقة\", \"duration\": \"1:00\", \"views\": 3200}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(35, 21, '/videos/learn-minute-2.mp4', '{\"id\": 2, \"slug\": \"skill-2\", \"title\": \"مهارة 2: إدارة الوقت للمشاريع الصغيرة\", \"description\": \"نصائح لإدارة الوقت بكفاءة\", \"duration\": \"1:00\", \"views\": 2850}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(36, 21, '/videos/learn-minute-3.mp4', '{\"id\": 3, \"slug\": \"skill-3\", \"title\": \"مهارة 3: كيفية حساب التكاليف\", \"description\": \"طريقة بسيطة لحساب تكاليف المشروع\", \"duration\": \"1:00\", \"views\": 2650}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(37, 21, '/videos/learn-minute-4.mp4', '{\"id\": 4, \"slug\": \"skill-4\", \"title\": \"مهارة 4: خدمة العملاء الأساسية\", \"description\": \"أساسيات خدمة العملاء للمشاريع الناشئة\", \"duration\": \"1:00\", \"views\": 2450}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(38, 21, '/videos/learn-minute-5.mp4', '{\"id\": 5, \"slug\": \"skill-5\", \"title\": \"مهارة 5: التغليف والتعبئة الجذابة\", \"description\": \"نصائح للتغليف الجذاب للمنتجات\", \"duration\": \"1:00\", \"views\": 2250}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1),
(39, 21, '/videos/learn-minute-6.mp4', '{\"id\": 6, \"slug\": \"skill-6\", \"title\": \"مهارة 6: التواصل الفعال مع الموردين\", \"description\": \"كيفية التواصل الفعال مع الموردين\", \"duration\": \"1:00\", \"views\": 2050}', NULL, NULL, NULL, NULL, '2025-12-23 03:52:17', '2025-12-23 03:52:17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `Content_info`
--

CREATE TABLE `Content_info` (
  `id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `content_en` text DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  `desc_en` varchar(255) DEFAULT NULL,
  `url` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `stats` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Content_info`
--

INSERT INTO `Content_info` (`id`, `content_id`, `content_type_id`, `content`, `content_en`, `desc`, `desc_en`, `url`, `created_at`, `updated_at`, `stats`) VALUES
(1, 1, 1, ' من نحن ', NULL, NULL, NULL, '', '2025-12-19 07:05:20', '0000-00-00 00:00:00', 1),
(2, 1, 1, ' الرؤية ', NULL, NULL, NULL, '', '2025-12-19 07:05:20', '0000-00-00 00:00:00', 1),
(3, 1, 1, ' الرسالة ', NULL, NULL, NULL, '', '2025-12-19 07:05:20', '0000-00-00 00:00:00', 1),
(4, 1, 1, ' الأهداف ', NULL, NULL, NULL, '', '2025-12-19 07:05:20', '0000-00-00 00:00:00', 1),
(5, 1, 1, ' قيمنا ', NULL, NULL, NULL, '', '2025-12-19 07:05:20', '0000-00-00 00:00:00', 1),
(6, 2, 1, 'هل الهيئة تمول؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1),
(7, 2, 1, 'كيف تخدمون المشاريع الصغيرة؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1),
(8, 2, 1, 'كيف أقدم على برامج الهيئة التدريبية؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1),
(9, 2, 1, 'كيف أقدم على قرض؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1),
(10, 2, 1, 'ما نوع التمويل المقدم من الهيئة؟', NULL, NULL, NULL, '', '2025-12-20 06:17:41', '0000-00-00 00:00:00', 1),
(11, 3, 1, 'الشركاء المنفذون', NULL, 'شركاؤنا المنفذون هم الذراع التنفيذية التي حولت الرؤى إلى واقع ملموس من خلال شراكات استراتيجية مبنية على الثقة والكفاءة.', NULL, '/partners/executors', '2025-12-23 00:25:34', '0000-00-00 00:00:00', 1),
(12, 3, 1, 'الشركاء الممولون ', NULL, 'نعتز بشركائنا الممولين الذين أسهموا في دعم وتمويل البرامج والمشاريع التنموية التي تخدم المجتمع وتدعم الاقتصاد المحلي.', NULL, '/partners/funders', '2025-12-23 00:25:39', '0000-00-00 00:00:00', 1),
(13, 4, 1, 'تحليل سلسلة قيمة إنتاج الملابس المحلية ', NULL, NULL, NULL, '', '2025-12-19 07:09:57', '0000-00-00 00:00:00', 1),
(14, 5, 1, 'اتصل بنا', NULL, NULL, NULL, '', '2025-12-23 01:08:49', '0000-00-00 00:00:00', 1),
(15, 5, 1, 'نموذج تواصل ', NULL, NULL, NULL, '', '2025-12-19 07:09:57', '0000-00-00 00:00:00', 1),
(16, 5, 1, 'العنوان', NULL, NULL, NULL, '', '2025-12-19 07:09:57', '0000-00-00 00:00:00', 1),
(17, 5, 1, 'وسائل التواصل الاجتماعي', NULL, NULL, NULL, '', '2025-12-19 07:09:57', '0000-00-00 00:00:00', 1),
(18, 5, 1, 'البريد الإلكتروني', NULL, NULL, NULL, '', '2025-12-19 07:09:57', '0000-00-00 00:00:00', 1),
(19, 6, 1, 'فيديوهات توعوية (الصناعات المنزلية)', NULL, NULL, NULL, '/media/flashes/home-industry', '2025-12-23 03:04:39', '0000-00-00 00:00:00', 1),
(20, 6, 1, 'فلاشات توعوية (الصحة الحيوانية)', NULL, NULL, NULL, '/media/flashes/animal-health', '2025-12-23 03:04:30', '0000-00-00 00:00:00', 1),
(21, 6, 1, 'سلسلة تعلّم في دقيقة', NULL, NULL, NULL, '/media/flashes/learn-in-a-minute', '2025-12-23 03:04:47', '0000-00-00 00:00:00', 1),
(22, 7, 1, 'الهيئة تختتم أسبوع التمويل بمشاركة أكثر من 60 جهة ممولة', NULL, NULL, NULL, '', '2025-12-19 07:40:36', '0000-00-00 00:00:00', 1),
(23, 7, 1, 'إطلاق برنامج دعم رواد الأعمال في المحافظات', NULL, NULL, NULL, '', '2025-12-19 07:40:36', '0000-00-00 00:00:00', 1),
(24, 9, 1, 'حلقة 1: نكتفي لنرتقي', NULL, NULL, NULL, '', '2025-12-19 07:41:26', '0000-00-00 00:00:00', 1),
(25, 9, 1, 'حلقة 2: طريق النجاح', NULL, NULL, NULL, '', '2025-12-19 07:41:26', '0000-00-00 00:00:00', 1),
(26, 9, 1, 'حلقة 3: وطن ينتج', NULL, NULL, NULL, '', '2025-12-19 07:41:26', '0000-00-00 00:00:00', 1),
(27, 8, 1, 'قصة أثر', NULL, NULL, NULL, '', '2025-12-19 07:42:56', '0000-00-00 00:00:00', 1),
(28, 8, 1, 'قصة ملهم', NULL, NULL, NULL, '', '2025-12-19 07:42:56', '0000-00-00 00:00:00', 1),
(29, 8, 1, 'مبادرة برايد كميونتي', NULL, NULL, NULL, '', '2025-12-19 07:42:56', '0000-00-00 00:00:00', 1),
(30, 10, 1, 'كليب ربيعك يا طه (المولد النبوي الشريف)', NULL, NULL, NULL, '', '2025-12-19 07:43:25', '0000-00-00 00:00:00', 1),
(39, 2, 1, 'كم سقف القرض الذي تقدمه الجمعيات التي تعمل الهيئة عبرها؟', NULL, NULL, NULL, '', '2025-12-20 06:17:14', '0000-00-00 00:00:00', 1),
(40, 2, 1, 'كم الحد الأدنى للقروض؟', NULL, NULL, NULL, '', '2025-12-20 06:17:14', '0000-00-00 00:00:00', 1),
(41, 2, 1, 'كيف أسجل مشروعي مع الهيئة؟', NULL, NULL, NULL, '', '2025-12-20 06:17:14', '0000-00-00 00:00:00', 1),
(42, 11, 1, 'تقدم الهيئة العامة لتنمية المشاريع الصغيرة والأصغر برامج تدريبية متخصصة ضمن سلاسل القيمة المعتمدة من قبل الحكومة، في مجالات التصنيع الغذائي، الجلود الطبيعية، الخياطة، الحرف اليدوية، ريادة الأعمال، والتدريب المهني والمعرفي لأصحاب المشاريع الصغيرة، وذلك ضمن منهجية مبتكرة تقوم على \"تدريب – تمكين – تسويق\"، بهدف تزويد المستفيدين بالمهارات اللازمة لتحويل أفكارهم ومشاريعهم إلى فرص اقتصادية حقيقية ودائمة، مع توفير الدعم عبر مشاريع حاضنات الأعمال.', NULL, NULL, NULL, '', '2025-12-20 09:41:28', '0000-00-00 00:00:00', 1),
(43, 12, 1, '\r\nتقدم الهيئة العامة لتنمية المشاريع الصغيرة والأصغر خدمات مالية مبتكرة ضمن سلاسل القيمة المعتمدة من قبل الحكومة، بهدف تمكين الفئات الأشد فقرًا وأصحاب المشاريع الإنتاجية من تحقيق الاكتفاء الذاتي وتحسين سبل العيش.\r\nفي المرحلة الحالية، توفر الهيئة قروضاً بيضاء متنوعة بتمويل من الهيئة العامة للزكاة، تهدف للتمكين الاقتصادي للشرائح الأكثر احتياجًا في ضوء كشوفات الزكاة، مع التركيز على المشاريع في مجالات الثروة الحيوانية، الصيد البحري. وكذلك تقدم الهيئة قروض بيضاء ممولة من وحدة تمويل المشاريع والمبادرات الزراعية والسمكية بأمانة العاصمة لأصحاب المشاريع الإنتاجية، التصنيع الغذائي، الخياطة، الحرف اليدوية، التصنيع المنزلي.\r\nيتم تنفيذ هذه الخدمات عبر مؤسسات المجتمع المدني التالية:\r\nأمانة العاصمة صنعاء:\r\nمؤسسة خيرات العطاء التنموية – مديرية الثورة\r\nنوع القرض (تصنيع غذائي، معجنات، نسيج، كيماويات، بيع تجزئة)\r\nجمعية بني الحارث التعاونية متعددة الأغراض – مديرية بني الحارث\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة)\r\nجمعية بني الحارث التعاونية متعددة الأغراض - جدر – مديرية بني الحارث\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة)\r\nجمعية بني الحارث التعاونية متعددة الأغراض – الحمى – مديرية بني الحارث\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة)\r\nجمعية بني الحارث التعاونية متعددة الأغراض – الطيران – مديرية بني الحارث\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة)\r\nجمعية بني الحارث التعاونية متعددة الأغراض – الروضة – مديرية بني الحارث\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة)\r\nجمعية عزلة غظران التنموية – مديرية بني حشيش\r\nنوع القروض (تصنيع غذائي، نسيج، كيماويات، بيع تجزئة، بخور وعطور)\r\nمؤسسة اليتيم التنموية – (للأيتام بشكل عام)\r\nنوع القرض:(خدمات، تصنيع غذائي، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية، بخور وعطور، نسيج وخياطة، جلديات واكسسوارات)\r\n\r\n\r\n\r\n\r\nمحافظة الحديدة:\r\nجمعية ساحل تهامة التعاونية السمكية\r\nنوع القرض:(تمويل رحلات صيد شهرية، تمويل رحلات صيد أسبوعية، صيانة قوارب)\r\nجمعية الدريهمي التعاونية الزراعية متعددة الإقراض – مديرية الدريهمي\r\nنوع القرض:(ثروة حيوانية أبقار).\r\nجمعية السخنة التعاونية الزراعية متعددة الإقراض – مديرية السخنة\r\nنوع القرض:(ثروة حيوانية أبقار).\r\nجمعية الاكتفاء التعاونية الزراعية متعددة الإقراض – مديرية المراوعة\r\nنوع القرض:(ثروة حيوانية أبقار).\r\n\r\nمحافظة إب:\r\nجمعية حزم العدين التعاونية – مديرية حزم العدين\r\nنوع القرض:(ثروة حيوانية ماعز).\r\n\r\nمحافظة حجة:\r\nجمعية عبس التعاونية متعددة الأغراض – مديرية عبس\r\nنوع القرض :(تربية نحل، زراعي منظومات ري، خدمي، حرف يدوية، معجنات، بيع تجزئة، كيماويات، ثروة حيوانية أبقار- أغنام – دواجن، تطريز وزخرفة، بخور وعطور، نسيج).\r\n\r\nمحافظة ذمار:\r\nاللجنة الوطنية للمرأة – ذمار\r\nنوع القرض (خدمي، ثروة حيوانية، زراعي، تصنيع غذائي، معجنات، نسيج، كيماويات، بيع تجزئة)\r\n\r\n\r\nمعاً… نمكّن المجتمعات ونبني اقتصاداً مستداماً.\r\n', NULL, NULL, NULL, '', '2025-12-20 09:41:28', '0000-00-00 00:00:00', 1),
(44, 13, 1, 'تقدّم الهيئة العامة لتنمية المشاريع الصغيرة والأصغر استشارات متخصصة تهدف إلى تمكين أصحاب المشاريع من اتخاذ قرارات صائبة وتطوير أعمالهم بكفاءة.\r\nوتوفّر الهيئة عبر برامج حاضنات المشاريع دعماً عملياً في مجالات التخطيط، الإدارة، الإنتاج، والتسويق، لمساعدة المشاريع على تحسين أدائها وزيادة إنتاجيتها. كما تقدّم الهيئة توجيهاً حول أفضل حلول التمويل، إدارة الموارد، والاستفادة من برامج الدعم المتاحة في القطاع لضمان نمو المشاريع بشكل مستدام.\r\nكذلك، توفر الهيئة قريباً أدوات رقمية حديثة ومنصات إلكترونية تتيح لأصحاب المشاريع الوصول إلى استشارات متخصصة مجانية عن بعد، ومتابعة تقدم مشاريعهم بكفاءة ومرونة.\r\n\r\nهدفنا:\r\nتمكين المشاريع الصغيرة والأصغر من تطوير أعمالها بذكاء واحترافية، وتحقيق أثر اقتصادي واجتماعي مستدام في المجتمع.\r\n', NULL, NULL, NULL, '', '2025-12-20 09:41:28', '0000-00-00 00:00:00', 1),
(45, 14, 1, 'تسعى الهيئة العامة لتنمية المشاريع الصغيرة والأصغر إلى تمكين المشاريع الصغيرة، خاصة الإنتاجية منها، من الوصول إلى جمهور أوسع وزيادة فرص نجاحها عبر دعم تسويقي متكامل. تشمل خدمات التسويق التي تقدمها الهيئة:\r\nالاستفادة من برامج حضانات المشاريع: حيث توفر الهيئة للمشاريع المشاركة دعم مستمر لتطوير منتجاتها وأفكارها التسويقية.\r\nالمشاركة في المعارض والمهرجانات: تتيح الهيئة للمشاريع الصغيرة والأصغر التواجد في المعارض والمهرجانات الحكومية والخاصة، مع تولّي جميع جوانب الترويج والتسويق بشكل مجاني، مما يفتح أمامها فرصًا للتواصل المباشر مع العملاء والمستثمرين.\r\nالحلول الرقمية الحديثة: تعمل الهيئة على إطلاق منصات تسويق رقمية بالتعاون مع مؤسسات وشركاء متخصصين في دعم المشاريع الصغيرة، لتمكين أصحاب المشاريع من تسويق منتجاتهم وخدماتهم عبر قنوات رقمية مبتكرة تصل إلى جمهور أوسع، وتواكب أحدث الاتجاهات في السوق.\r\n', NULL, NULL, NULL, '', '2025-12-20 09:41:28', '0000-00-00 00:00:00', 1),
(46, 16, 1, 'مشروع يهدف إلى تأهيل النساء اليمنيات وتحويلهنّ من متعلّمات إلى مؤثرات في سوق العمل، من خلال تدريبهنّ على مهارات إنتاج القطنيات بطرق صناعية، وتأهيلهنّ لتصبح مدربات قادرات على نقل المهارة لمتدربات جدد.\r\nمخرجات المشروع:\r\n16 مدربة جديدة في إنتاج القطنيات تم تكريمهن بعد إتمام التدريب بنجاح.\r\nأثر المشروع:\r\nتمكين المدربات من تدريب عشرات النساء في البرامج القادمة، وتعزيز مسار الاكتفاء الذاتي والتمكين الاقتصادي للمجتمع المحلي.\r\nتنفيذ: الهيئة العامة لتنمية المشاريع الصغيرة والأصغر.\r\nتمويل: وحدة تمويل المشاريع والمبادرات الزراعية والسمكية بأمانة العاصمة صنعاء.\r\nشريك تنفيذي: معمل قطنيات سبأ.\r\n', NULL, NULL, NULL, '', '2025-12-20 17:05:42', '0000-00-00 00:00:00', 1),
(47, 17, 1, ' حقيبة تمكين لـ21 متدربة\r\nوزّعت الهيئة العامة لتنمية المشاريع الصغيرة والأصغر حقائب تمكين على 21 متدربة في أمانة العاصمة، بعد مشاركتهن في برنامج تدريبي متخصص في صناعة الحقائب والأحزمة الجلدية.\r\nمميزات التدريب:\r\nالاعتماد على أحدث الممارسات العصرية في الحرفة.\r\nتطبيق تقنيات مبتكرة في التصميم والإنتاج.\r\nالتدريب من دون استخدام مكينة الخياطة، بما يفتح آفاقًا جديدة في الصناعة اليدوية.\r\nالشراكات:\r\nأُقيمت الدورة بالتعاون مع مركز الزهراء الخيري في إطار تعزيز التمكين الاقتصادي للنساء.\r\n', NULL, NULL, NULL, '', '2025-12-20 17:05:42', '0000-00-00 00:00:00', 1),
(48, 18, 1, 'مشروع خياطة الجلديات يهدف إلى تمكين الشباب من أبناء مديرية بني الحارث، عبر تعليمهم مهارات فنية وتسويقية تؤهلهم لإطلاق مشاريعهم الخاصة بثقة وكفاءة.\r\n مكونات المشروع:\r\nالتدريب الفني: تعليم أسرار الحرفة ودقة التفاصيل في خياطة الجلديات.\r\nالتسويق الاحترافي: تعريف المشاركين بمفاتيح الوصول إلى الأسواق وكيفية ترويج منتجاتهم بفعالية.\r\nحقيبة التمكين: أدوات إنتاج بقيمة 90 ألف ريال لكل مشارك.\r\n', NULL, NULL, NULL, '', '2025-12-20 17:05:42', '0000-00-00 00:00:00', 1),
(49, 19, 1, ' تفاصيل البرنامج:\n\nبرنامج تدريبي متخصص يستهدف الشباب في مجال التصنيع الغذائي...\nمزايا البرنامج:\n\n    شهادة معتمدة\n    جلسات تدريبية عملية\n    ترشيح المشاريع المميزة\n\nشروط الالتحاق:\n\n    وجود مشروع أو فكرة واضحة\n    الالتزام بالحضور الكامل\n\nطريقة التسجيل:\n\n    التسجيل عبر الموقع الرسمي\n    متابعة البريد الإلكتروني للتأكيد', NULL, NULL, NULL, '', '2025-12-22 05:43:59', '0000-00-00 00:00:00', 1),
(50, 20, 1, ' تفاصيل البرنامج:\r\n\r\nتعلن الهيئة عن فتح باب التطوع في عدد من البرامج والفعاليات...\r\nمزايا البرنامج:\r\n\r\n    خبرة ميدانية\r\n    شهادة تطوع من الهيئة\r\n\r\nشروط الالتحاق:\r\n\r\n    القدرة على الالتزام بالفترة المحددة\r\n    الالتزام بسلوكيات العمل التطوعي\r\n\r\nطريقة التسجيل:\r\n\r\n    التسجيل عبر نموذج التطوع في الموقع', NULL, NULL, NULL, '', '2025-12-20 17:07:17', '0000-00-00 00:00:00', 1),
(51, 21, 1, ' تفاصيل البرنامج:\r\n\r\nترغب الهيئة في التعاقد مع جهات مختصة لتنفيذ مشاريع تنموية...\r\nشروط الالتحاق:\r\n\r\n    تقديم عرض فني ومالي مفصل\r\n    توفر خبرة سابقة في نفس المجال\r\n\r\nطريقة التسجيل:\r\n\r\n    إرسال العرض عبر البريد الرسمي للهيئة', NULL, NULL, NULL, '', '2025-12-20 17:07:17', '0000-00-00 00:00:00', 1),
(52, 22, 1, 'الجهة / المالك:أم يوسف\r\n\r\nالتصنيف:تسويق\r\n\r\nروابط التواصل:@@@@@@s\r\n\r\nالتاريخ:08 أغسطس 2025', NULL, NULL, NULL, '', '2025-12-20 17:09:44', '0000-00-00 00:00:00', 1),
(53, 2, 1, 'كيف تخدمون المشاريع الصغيرة؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1),
(54, 2, 1, 'كيف أقدم على برامج الهيئة التدريبية؟', NULL, NULL, NULL, '', '2025-12-19 07:07:01', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `content_types`
--

CREATE TABLE `content_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `type_en` varchar(100) DEFAULT NULL,
  `stats` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `content_types`
--

INSERT INTO `content_types` (`id`, `type`, `type_en`, `stats`, `created_at`, `updated_at`) VALUES
(1, 'نصوص', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15'),
(2, 'صور ', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15'),
(3, 'فيديوهات', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15'),
(4, 'صوتيات', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15'),
(5, 'ملفات', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15'),
(6, 'روابط', NULL, 1, '2025-12-03 05:35:25', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `government_facilities`
--

CREATE TABLE `government_facilities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `title_en` varchar(255) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `short_description_en` text DEFAULT NULL,
  `full_description` longtext DEFAULT NULL,
  `full_description_en` longtext DEFAULT NULL,
  `providing_authority` varchar(255) DEFAULT NULL,
  `providing_authority_en` varchar(255) DEFAULT NULL,
  `facility_type` varchar(100) DEFAULT NULL,
  `facility_type_en` varchar(100) DEFAULT NULL,
  `requirements` longtext DEFAULT NULL,
  `requirements_en` longtext DEFAULT NULL,
  `benefits` longtext DEFAULT NULL,
  `benefits_en` longtext DEFAULT NULL,
  `application_link` varchar(255) DEFAULT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `document_file` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `slug_en` varchar(255) DEFAULT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_12_17_195628_add_role_and_is_active_to_users_table', 1),
(6, '2025_12_17_201320_create_request_categorys_table', 1),
(7, '2025_12_17_201330_create_request_types_table', 1),
(8, '2025_12_17_201336_create_request_status_types_table', 1),
(9, '2025_12_17_201343_create_requests_table', 1),
(10, '2025_12_17_201349_create_request_details_table', 1),
(11, '2025_12_17_201354_create_request_details_values_table', 1),
(12, '2025_12_17_202942_create_project_statuses_table', 1),
(13, '2025_12_17_202948_create_project_categories_table', 1),
(14, '2025_12_17_204451_create_projects_table', 1),
(15, '2025_12_17_210339_create_news_categories_table', 1),
(16, '2025_12_17_210345_create_news_table', 1),
(17, '2025_12_17_210351_create_advertisements_table', 1),
(18, '2025_12_17_210505_create_pages_table', 1),
(19, '2025_12_17_210519_create_content_types_table', 1),
(20, '2025_12_17_210527_create_contents_table', 1),
(21, '2025_12_17_210535_create_content_info_table', 1),
(22, '2025_12_17_210545_create_content_details_table', 1),
(23, '2025_12_17_211649_create_service_categories_table', 1),
(24, '2025_12_17_211655_create_services_table', 1),
(25, '2025_12_17_215133_update_content_info_table_charset_to_utf8mb4', 1),
(26, '2025_12_17_215200_update_all_content_tables_charset_to_utf8mb4', 1),
(27, '2025_12_17_231643_create_government_facilities_table', 1),
(28, '2025_12_17_232700_create_partners_table', 1),
(29, '2025_12_19_195237_add_file_fields_to_content_info_table', 1),
(30, '2025_12_19_195259_add_file_fields_to_content_details_table', 1),
(31, '2025_12_19_202209_create_roles_table', 1),
(32, '2025_12_19_202224_update_users_table_for_roles_system', 1);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `excerpt` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `author_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `slug` varchar(255) DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `news_categories`
--

CREATE TABLE `news_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `news_categories`
--

INSERT INTO `news_categories` (`id`, `name`, `name_en`, `description`, `slug`, `created_at`, `updated_at`) VALUES
(1, 'أخبار الهيئة', 'Authority News', 'أخبار ومستجدات الهيئة العامة للمشاريع الصغيرة', 'akhbar-alhyy', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'مشاريع ناجحة', 'Success Stories', 'قصص نجاح المشاريع الصغيرة', 'msharyaa-nagh', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'فرص تمويل', 'Funding Opportunities', 'فرص التمويل المتاحة للمشاريع', 'frs-tmoyl', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'ورش عمل', 'Workshops', 'ورش العمل والدورات التدريبية', 'orsh-aaml', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'إعلانات', 'Announcements', 'الإعلانات الرسمية', 'aaalanat', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'أحداث', 'Events', 'الفعاليات والأحداث القادمة', 'ahdath', '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `Pages`
--

CREATE TABLE `Pages` (
  `id` int(11) NOT NULL,
  `page_name` varchar(100) DEFAULT NULL,
  `page_name_en` varchar(100) DEFAULT NULL,
  `header` tinyint(4) NOT NULL DEFAULT 1,
  `has_children` tinyint(4) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `stats` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Pages`
--

INSERT INTO `Pages` (`id`, `page_name`, `page_name_en`, `header`, `has_children`, `created_at`, `updated_at`, `stats`) VALUES
(1, 'الصفحة الرئيسية', NULL, 0, 1, '2025-12-21 08:26:07', '0000-00-00 00:00:00', 1),
(2, 'عن الهيئة', NULL, 0, 0, '2025-12-21 08:26:12', '0000-00-00 00:00:00', 1),
(3, 'الخدمات', NULL, 0, 1, '2025-12-21 09:15:24', '0000-00-00 00:00:00', 1),
(4, 'التسهيلات الحكومية', NULL, 0, 1, '2025-12-21 08:26:07', '0000-00-00 00:00:00', 1),
(5, 'قسم الإعلام والتوعية', NULL, 0, 0, '2025-12-21 08:55:07', '0000-00-00 00:00:00', 1),
(6, 'المشاريع', NULL, 0, 1, '2025-12-21 08:26:07', '0000-00-00 00:00:00', 1),
(7, 'الإعلانات', NULL, 0, 1, '2025-12-21 08:26:07', '0000-00-00 00:00:00', 1),
(8, 'روج لمشروعك', NULL, 0, 1, '2025-12-21 08:26:07', '0000-00-00 00:00:00', 1),
(9, 'سجل مشروعك ', NULL, 1, 1, '2025-12-21 08:26:44', '0000-00-00 00:00:00', 1),
(10, 'الصفحة الشخصية', NULL, 1, 1, '2025-12-21 08:26:48', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `partners`
--

CREATE TABLE `partners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `description_en` text DEFAULT NULL,
  `partner_type` varchar(100) DEFAULT NULL,
  `partner_type_en` varchar(100) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `address_en` text DEFAULT NULL,
  `partnership_start_date` date DEFAULT NULL,
  `partnership_details` text DEFAULT NULL,
  `partnership_details_en` text DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `contact_person_en` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `slug_en` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `request_id` bigint(20) UNSIGNED DEFAULT NULL,
  `required_capital` decimal(15,2) DEFAULT NULL,
  `available_capital` decimal(15,2) NOT NULL DEFAULT 0.00,
  `funding_needed` decimal(15,2) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `expected_end_date` date DEFAULT NULL,
  `actual_end_date` date DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_categories`
--

CREATE TABLE `project_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `project_categories`
--

INSERT INTO `project_categories` (`id`, `name`, `name_en`, `description`, `created_at`, `updated_at`) VALUES
(1, 'مشاريع تجارية', 'Commercial Projects', 'المشاريع التجارية والتجارة', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'مشاريع صناعية', 'Industrial Projects', 'المشاريع الصناعية والتصنيع', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'مشاريع خدمية', 'Service Projects', 'المشاريع الخدمية', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'مشاريع تقنية', 'Technology Projects', 'المشاريع التقنية والبرمجية', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'مشاريع زراعية', 'Agricultural Projects', 'المشاريع الزراعية', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'مشاريع سياحية', 'Tourism Projects', 'المشاريع السياحية والترفيهية', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(7, 'مشاريع تعليمية', 'Educational Projects', 'المشاريع التعليمية والتدريبية', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(8, 'مشاريع صحية', 'Health Projects', 'المشاريع الصحية والطبية', '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `project_statuses`
--

CREATE TABLE `project_statuses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `color` varchar(255) NOT NULL DEFAULT 'secondary',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `project_statuses`
--

INSERT INTO `project_statuses` (`id`, `name`, `name_en`, `color`, `created_at`, `updated_at`) VALUES
(1, 'قيد التخطيط', 'Planning', 'info', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'قيد التنفيذ', 'In Progress', 'primary', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'قيد المراجعة', 'Under Review', 'warning', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'مكتمل', 'Completed', 'success', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'متوقف', 'On Hold', 'secondary', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'ملغي', 'Cancelled', 'danger', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(7, 'قيد التمويل', 'Funding', 'info', '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `Request_Status_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `Request_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `stats` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request_categorys`
--

CREATE TABLE `request_categorys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Request_type` varchar(100) DEFAULT NULL,
  `Request_type_en` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_categorys`
--

INSERT INTO `request_categorys` (`id`, `Request_type`, `Request_type_en`, `created_at`, `updated_at`) VALUES
(1, 'سجل مشروعك', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'روج مشروعك', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'خدمات', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'إعلانات', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'تسهيلات حكومية', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'اتصل بنا', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `request_details`
--

CREATE TABLE `request_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Request_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `request_name` text DEFAULT NULL,
  `request_name_en` text DEFAULT NULL,
  `selected` enum('question','answer','alert') NOT NULL DEFAULT 'question',
  `selected_en` enum('question','answer','alert') NOT NULL DEFAULT 'question',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request_details_values`
--

CREATE TABLE `request_details_values` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `Request_Details_id` bigint(20) UNSIGNED DEFAULT NULL,
  `value_ar` text DEFAULT NULL,
  `value_en` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request_status_types`
--

CREATE TABLE `request_status_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `status_name` text DEFAULT NULL,
  `status_name_en` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_status_types`
--

INSERT INTO `request_status_types` (`id`, `status_name`, `status_name_en`, `created_at`, `updated_at`) VALUES
(1, 'قيد المراجعة', 'Pending', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'قيد التنفيذ', 'In Progress', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'مكتمل', 'Completed', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'موافق عليه', 'Approved', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'تعذر اعتماد الطلب', 'Unable to Approve', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'مُعاد للمستخدم', 'Returned', '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(7, 'ملغي ', 'Canceled', '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `request_types`
--

CREATE TABLE `request_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `request_name` text DEFAULT NULL,
  `request_name_en` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `request_types`
--

INSERT INTO `request_types` (`id`, `category_id`, `request_name`, `request_name_en`, `created_at`, `updated_at`) VALUES
(1, 1, 'سجل مشروعك', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 2, 'سجل الآن لروج مشروعك', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 3, 'خدمات التدريب', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 3, 'خدمات التمويل', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 3, 'خدمات الاستشارات', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 3, 'خدمات التسويق', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(7, 4, 'إعلان عن فرصة تعاقد', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(8, 4, 'إعلان عن فرصة تطوع', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(9, 4, 'إعلان عن فرصة تدريب', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'user',
  `permissions` enum('all','view','update','delete','insert') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'all', '2025-12-20 16:53:14', '2025-12-20 16:53:14'),
(2, 'User', 'view', '2025-12-20 16:53:14', '2025-12-20 16:53:14'),
(3, 'Employee', 'insert', '2025-12-20 16:53:14', '2025-12-20 16:53:14');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `full_description` text DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `service_type` enum('free','paid','subscription') NOT NULL DEFAULT 'free',
  `price` decimal(10,2) DEFAULT NULL,
  `duration` varchar(255) DEFAULT NULL,
  `requirements` text DEFAULT NULL,
  `benefits` text DEFAULT NULL,
  `external_link` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive','coming_soon') NOT NULL DEFAULT 'active',
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `requests_count` int(11) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `slug` varchar(255) DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_categories`
--

CREATE TABLE `service_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `service_categories`
--

INSERT INTO `service_categories` (`id`, `name`, `name_en`, `description`, `icon`, `slug`, `display_order`, `created_at`, `updated_at`) VALUES
(1, 'خدمات التمويل', 'Funding Services', 'خدمات التمويل والقروض للمشاريع الصغيرة', 'bi-cash-coin', 'khdmat-altmoyl', 1, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(2, 'خدمات التدريب', 'Training Services', 'برامج التدريب وورش العمل', 'bi-book', 'khdmat-altdryb', 2, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(3, 'خدمات الاستشارات', 'Consulting Services', 'الاستشارات الإدارية والتقنية', 'bi-lightbulb', 'khdmat-alastsharat', 3, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(4, 'خدمات التسويق', 'Marketing Services', 'خدمات التسويق والترويج', 'bi-megaphone', 'khdmat-altsoyk', 4, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(5, 'خدمات التكنولوجيا', 'Technology Services', 'خدمات التكنولوجيا والبرمجيات', 'bi-laptop', 'khdmat-altknologya', 5, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(6, 'خدمات الترخيص', 'Licensing Services', 'خدمات الترخيص والتسجيل', 'bi-file-earmark-check', 'khdmat-altrkhys', 6, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(7, 'خدمات الشبكات', 'Networking Services', 'خدمات التواصل وبناء الشبكات', 'bi-people', 'khdmat-alshbkat', 7, '2025-12-20 16:53:15', '2025-12-20 16:53:15'),
(8, 'خدمات أخرى', 'Other Services', 'خدمات متنوعة أخرى', 'bi-grid', 'khdmat-akhr', 8, '2025-12-20 16:53:15', '2025-12-20 16:53:15');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `token_id` varchar(100) DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `stats` tinyint(4) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `token_id`, `role_id`, `name`, `email`, `phone`, `stats`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, NULL, 1, 'مدير النظام', 'admin@admin.com', NULL, 1, '2025-12-20 16:53:14', '$2y$12$JIoI1u8JKTRfkj7Qocd5sOol.rJWiKtbxDHa8itcZPfVzY0YPi8l6', NULL, '2025-12-20 16:53:14', '2025-12-20 16:53:14'),
(2, NULL, 3, 'موظف', 'employee@admin.com', NULL, 1, '2025-12-20 16:53:14', '$2y$12$X3YocdpeW8osi35Gx33jpuIg.nAuY1IIac.N5oZUXuPSGSV8D4pWC', NULL, '2025-12-20 16:53:14', '2025-12-20 16:53:14'),
(3, NULL, 2, 'مستخدم عادي', 'user@admin.com', NULL, 1, '2025-12-20 16:53:15', '$2y$12$n4ji0dms6oJTAdr69F/yTuiG4wBoNs/iygvpgswGSxji7XcA4/0RK', NULL, '2025-12-20 16:53:15', '2025-12-20 16:53:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Contents`
--
ALTER TABLE `Contents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `page_id` (`page_id`);

--
-- Indexes for table `Content_details`
--
ALTER TABLE `Content_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `content_info_id` (`content_info_id`);

--
-- Indexes for table `Content_info`
--
ALTER TABLE `Content_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `content_id` (`content_id`),
  ADD KEY `content_type_id` (`content_type_id`);

--
-- Indexes for table `content_types`
--
ALTER TABLE `content_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `government_facilities`
--
ALTER TABLE `government_facilities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `government_facilities_slug_unique` (`slug`),
  ADD UNIQUE KEY `government_facilities_slug_en_unique` (`slug_en`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `news_slug_unique` (`slug`),
  ADD KEY `news_category_id_foreign` (`category_id`),
  ADD KEY `news_author_id_foreign` (`author_id`);

--
-- Indexes for table `news_categories`
--
ALTER TABLE `news_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `news_categories_slug_unique` (`slug`);

--
-- Indexes for table `Pages`
--
ALTER TABLE `Pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `partners`
--
ALTER TABLE `partners`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `partners_slug_unique` (`slug`),
  ADD UNIQUE KEY `partners_slug_en_unique` (`slug_en`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `projects_owner_id_foreign` (`owner_id`),
  ADD KEY `projects_category_id_foreign` (`category_id`),
  ADD KEY `projects_status_id_foreign` (`status_id`),
  ADD KEY `projects_request_id_foreign` (`request_id`);

--
-- Indexes for table `project_categories`
--
ALTER TABLE `project_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `project_statuses`
--
ALTER TABLE `project_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requests_user_id_foreign` (`user_id`),
  ADD KEY `requests_request_status_type_id_foreign` (`Request_Status_type_id`),
  ADD KEY `requests_request_type_id_foreign` (`Request_type_id`);

--
-- Indexes for table `request_categorys`
--
ALTER TABLE `request_categorys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `request_details`
--
ALTER TABLE `request_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_details_request_type_id_foreign` (`Request_type_id`);

--
-- Indexes for table `request_details_values`
--
ALTER TABLE `request_details_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_details_values_request_details_id_foreign` (`Request_Details_id`);

--
-- Indexes for table `request_status_types`
--
ALTER TABLE `request_status_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `request_types`
--
ALTER TABLE `request_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `request_types_category_id_foreign` (`category_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `services_slug_unique` (`slug`),
  ADD KEY `services_category_id_foreign` (`category_id`);

--
-- Indexes for table `service_categories`
--
ALTER TABLE `service_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `service_categories_slug_unique` (`slug`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Contents`
--
ALTER TABLE `Contents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `Content_details`
--
ALTER TABLE `Content_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `Content_info`
--
ALTER TABLE `Content_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `content_types`
--
ALTER TABLE `content_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `government_facilities`
--
ALTER TABLE `government_facilities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `news_categories`
--
ALTER TABLE `news_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Pages`
--
ALTER TABLE `Pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `partners`
--
ALTER TABLE `partners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_categories`
--
ALTER TABLE `project_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `project_statuses`
--
ALTER TABLE `project_statuses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request_categorys`
--
ALTER TABLE `request_categorys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `request_details`
--
ALTER TABLE `request_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request_details_values`
--
ALTER TABLE `request_details_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request_status_types`
--
ALTER TABLE `request_status_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `request_types`
--
ALTER TABLE `request_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_categories`
--
ALTER TABLE `service_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `news_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `news_categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `project_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `projects_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `projects_request_id_foreign` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `projects_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `project_statuses` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_request_status_type_id_foreign` FOREIGN KEY (`Request_Status_type_id`) REFERENCES `request_status_types` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `requests_request_type_id_foreign` FOREIGN KEY (`Request_type_id`) REFERENCES `request_types` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `request_details`
--
ALTER TABLE `request_details`
  ADD CONSTRAINT `request_details_request_type_id_foreign` FOREIGN KEY (`Request_type_id`) REFERENCES `request_types` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `request_details_values`
--
ALTER TABLE `request_details_values`
  ADD CONSTRAINT `request_details_values_request_details_id_foreign` FOREIGN KEY (`Request_Details_id`) REFERENCES `request_details` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `request_types`
--
ALTER TABLE `request_types`
  ADD CONSTRAINT `request_types_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `request_categorys` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `services_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `service_categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
