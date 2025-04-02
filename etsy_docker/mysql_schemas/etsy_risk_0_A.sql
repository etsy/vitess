CREATE DATABASE etsy_risk_0_A;
USE etsy_risk_0_A;

CREATE TABLE `fingerprints` (
  `fingerprint_id` bigint unsigned NOT NULL,
  `print_type` tinyint unsigned NOT NULL,
  `print_value` varchar(128) NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`fingerprint_id`,`create_date`),
  KEY `print_value` (`print_value`),
  KEY `fingerprints_print_type_idx` (`print_type`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='data that can be used to link separate user accounts';

CREATE TABLE `fingerprints_guest_user` (
  `guest_user_id` bigint unsigned NOT NULL,
  `fingerprint_id` bigint unsigned NOT NULL,
  `sources` tinyint unsigned DEFAULT '0',
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guest_user_id`,`fingerprint_id`,`create_date`),
  KEY `fingerprint_id` (`fingerprint_id`),
  KEY `fingerprints_guest_user_deleted_idx` (`deleted`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table connecting guest users to fingerprint values';

CREATE TABLE `fingerprints_user` (
  `user_id` bigint unsigned NOT NULL,
  `fingerprint_id` bigint unsigned NOT NULL,
  `sources` tinyint unsigned DEFAULT '0',
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`fingerprint_id`,`create_date`),
  KEY `fingerprint_id` (`fingerprint_id`),
  KEY `fingerprints_user_deleted_idx` (`deleted`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table connecting users to fingerprint values';

CREATE TABLE `gre_scores` (
  `gre_score_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `target_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_id` bigint unsigned NOT NULL DEFAULT '0',
  `assessment_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `key_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valid` tinyint unsigned NOT NULL,
  `invalid_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hostname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reasons` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `credentials_leaked` tinyint unsigned NOT NULL DEFAULT '0',
  `canonicalized_username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `assessment_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`gre_score_id`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `action_target` (`action`,`target_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `guest_checkout_session_detail` (
  `guest_checkout_session_id` bigint unsigned NOT NULL,
  `token` char(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `guest_user_id` bigint unsigned NOT NULL,
  `ip_addr` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `continent_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_code` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `region` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `city` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `postal_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `dma_code` int NOT NULL DEFAULT '0',
  `area_code` int NOT NULL DEFAULT '0',
  `type_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `isp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `org` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `is_proxy` tinyint(1) NOT NULL DEFAULT '0',
  `is_datacenter` tinyint(1) NOT NULL DEFAULT '0',
  `is_wireless` tinyint(1) NOT NULL DEFAULT '0',
  `is_mobile` tinyint(1) NOT NULL DEFAULT '0',
  `is_crawler` tinyint(1) NOT NULL DEFAULT '0',
  `post_signature` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `trace_cookie` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uaid` char(28) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `accept_lang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `other_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL DEFAULT '0',
  `source` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guest_checkout_session_id`,`create_date`),
  KEY `idx_guest_checkout_session_detail_tracer` (`trace_cookie`),
  KEY `idx_guest_checkout_session_detail_create_date` (`create_date`),
  KEY `idx_guest_checkout_session_detail_update_date` (`update_date`),
  KEY `idx_guest_checkout_session_detail_uid_create` (`guest_user_id`,`create_date`),
  KEY `idx_guest_checkout_session_detail_ip_addr_create` (`ip_addr`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_addr` (
  `ip_addr_id` bigint unsigned NOT NULL,
  `ip_addr` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip_version` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip_v4_class` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `net_id` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `host_id` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `continent_code` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `country_code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `region` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `city` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `postal_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `dma_code` int NOT NULL DEFAULT '0',
  `area_code` int NOT NULL DEFAULT '0',
  `type_code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `isp` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `org` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timezone_offset` tinyint DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`ip_addr_id`),
  UNIQUE KEY `idx_ip_addr_ip_addr` (`ip_addr`),
  KEY `idx_user_agent_create_date` (`create_date`),
  KEY `idx_user_agent_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `login_session_detail` (
  `login_session_id` bigint unsigned NOT NULL,
  `athena_session_id` bigint unsigned NOT NULL DEFAULT '0',
  `token` char(80) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `active` tinyint unsigned NOT NULL,
  `ip_addr` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `continent_code` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_code` char(2) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `region` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `city` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `postal_code` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `dma_code` int NOT NULL DEFAULT '0',
  `area_code` int NOT NULL DEFAULT '0',
  `type_code` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `user_agent` varchar(512) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `isp` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `org` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `is_mobile` tinyint(1) NOT NULL DEFAULT '0',
  `is_crawler` tinyint(1) NOT NULL DEFAULT '0',
  `is_email_login` tinyint(1) NOT NULL DEFAULT '0',
  `post_signature` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `trace_cookie` char(8) COLLATE utf8mb4_general_ci NOT NULL,
  `uaid` char(28) COLLATE utf8mb4_general_ci NOT NULL,
  `accept_lang` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type` tinyint unsigned NOT NULL DEFAULT '0',
  `source` tinyint unsigned NOT NULL DEFAULT '0',
  `api_key_id` bigint unsigned NOT NULL DEFAULT '0',
  `api_key_access_token_id` bigint unsigned NOT NULL DEFAULT '0',
  `device_id` bigint unsigned NOT NULL DEFAULT '0',
  `other_json` text COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `user_agent_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`login_session_id`,`create_date`),
  KEY `idx_login_session_detail_tracer` (`trace_cookie`),
  KEY `idx_login_session_detail_create_date` (`create_date`),
  KEY `idx_login_session_detail_update_date` (`update_date`),
  KEY `idx_login_session_detail_token` (`token`),
  KEY `idx_login_session_detail_uid_create` (`user_id`,`create_date`),
  KEY `idx_login_session_detail_uid_active` (`user_id`,`active`),
  KEY `idx_login_session_detail_api_key_access_token_id` (`api_key_access_token_id`),
  KEY `idx_login_session_detail_ip_addr_create` (`ip_addr`,`create_date`),
  KEY `idx_login_session_detail_uid_source_create` (`user_id`,`source`,`create_date`),
  KEY `idx_login_session_detail_user_agent_id` (`user_agent_id`),
  KEY `idx_login_session_detail_athena_session_id` (`athena_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `payload_comparison_journal` (
  `payload_comparison_journal_id` bigint unsigned NOT NULL,
  `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `diff` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT (_utf8mb4''),
  `success` tinyint DEFAULT NULL COMMENT 'boolean indicating if comparison passed',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`payload_comparison_journal_id`),
  KEY `reference_type_id` (`reference_type`,`reference_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemanator_dummy_test` (
  `testid` bigint unsigned NOT NULL,
  `column1` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mayhem` bigint DEFAULT NULL,
  `column2` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`testid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_agent` (
  `user_agent_id` bigint unsigned NOT NULL,
  `is_bot` tinyint(1) NOT NULL DEFAULT '0',
  `is_syndication` tinyint(1) NOT NULL DEFAULT '0',
  `is_ua_cv` tinyint(1) NOT NULL DEFAULT '0',
  `is_mobile` tinyint(1) NOT NULL DEFAULT '0',
  `is_robot` tinyint(1) NOT NULL DEFAULT '0',
  `original` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fingerprint` char(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ua_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ua_major` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ua_minor` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ua_url` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `os_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `os_major` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `os_minor` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_version_num` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_agent_id`,`create_date`),
  KEY `idx_user_agent_create_date` (`create_date`),
  KEY `idx_user_agent_update_date` (`update_date`),
  KEY `idx_user_agent_fingerprint` (`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_last_access` (
  `user_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vendor_event_trigger` (
  `vendor_event_id` bigint unsigned NOT NULL,
  `account_sid` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor account SID',
  `service_id` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor service ID',
  `vendor_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor name ex. Twilio',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`vendor_event_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Vendor event trigger table for monitoring usage thresholds of vendor services';

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

