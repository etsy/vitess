CREATE DATABASE etsy_certs_0_A;
USE etsy_certs_0_A;

CREATE TABLE `ssl_certs` (
  `ssl_cert_id` bigint unsigned NOT NULL,
  `domain_certificate` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issuer_certificate` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `private_key` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `cert_issue_date` int NOT NULL,
  `cert_expiration_date` int NOT NULL,
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `private_key_encryption_key` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ssl_cert_id`),
  KEY `cert_expiration_date_idx` (`cert_expiration_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ssl_domains` (
  `ssl_domain_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unicode_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint unsigned NOT NULL,
  `additional_domain` tinyint(1) NOT NULL DEFAULT '0',
  `verification_payload` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `ssl_cert_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`ssl_domain_id`),
  UNIQUE KEY `name_ux` (`name`(191)),
  KEY `ssl_cert_id_idx` (`ssl_cert_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

