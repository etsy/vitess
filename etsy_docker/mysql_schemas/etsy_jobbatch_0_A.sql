CREATE DATABASE etsy_jobbatch_0_A;
USE etsy_jobbatch_0_A;

CREATE TABLE `job_batches` (
  `job_batch_id` bigint unsigned NOT NULL,
  `info` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `completed_jobs` int NOT NULL DEFAULT '0',
  `status` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'created',
  `errors` text COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`job_batch_id`,`create_date`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

