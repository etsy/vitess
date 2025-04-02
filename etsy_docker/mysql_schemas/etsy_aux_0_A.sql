CREATE DATABASE etsy_aux_0_A;
USE etsy_aux_0_A;

CREATE TABLE `ab_click_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Day in epoch ms',
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `ref` varchar(255) NOT NULL COMMENT 'ref tag from the second event',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  PRIMARY KEY (`test`,`variant`,`event_type`,`ref`,`metric_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_event_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Day in epoch ms',
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `exits_from` bigint unsigned NOT NULL COMMENT 'Total exits from this event',
  PRIMARY KEY (`test`,`variant`,`event_type`,`metric_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_real_time_metrics` (
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Hour in epoch s',
  `visit_count` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, hour)',
  `visit_time` bigint unsigned NOT NULL COMMENT 'Sum of visit times (in seconds)',
  `apache_time` bigint unsigned NOT NULL COMMENT 'Total time spent in Apache (in microseconds)',
  `php_time` bigint unsigned NOT NULL COMMENT 'Total time spent in PHP (in microseconds)',
  `page_requests` bigint unsigned NOT NULL COMMENT 'Total requests',
  PRIMARY KEY (`test`,`variant`,`metric_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_variant_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  `visit_count` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `browser_count` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this A/B key value pair',
  PRIMARY KEY (`test`,`variant`,`metric_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `active_vat_verifications` (
  `active_vat_verification_id` bigint unsigned NOT NULL COMMENT 'Primary key for this table',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Foreign key for shop this verification is for',
  `vat_verification_attempt_id` bigint unsigned NOT NULL COMMENT 'Foreign key for attempt record for this verification',
  `grace_period_started_at` int unsigned DEFAULT NULL COMMENT 'epoch timestamp, set when we need to temporarily override a failure',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`active_vat_verification_id`),
  UNIQUE KEY `shop_id` (`shop_id`),
  KEY `grace_period_started_at` (`grace_period_started_at`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_action` (
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`admin_action_id`),
  UNIQUE KEY `mnemonic` (`mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_action_attribute` (
  `admin_action_attribute_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_action_attribute_id`),
  UNIQUE KEY `mnemonic` (`mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_action_attribute_audit` (
  `admin_action_attribute_audit_id` bigint unsigned NOT NULL,
  `admin_action_attribute_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_action_attribute_audit_id`),
  KEY `admin_action_attribute_idx` (`admin_action_attribute_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_action_attribute_team` (
  `admin_action_attribute_team_id` bigint unsigned NOT NULL,
  `admin_action_attribute_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.admin_action_attribute.admin_reason_id',
  `team_category_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.team_category.team_category_id',
  `type` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ban, unban, listing_freeze, listing_unfreeze, etc.',
  `create_staff_id` bigint unsigned NOT NULL,
  `update_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`admin_action_attribute_team_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_action_reason` (
  `admin_action_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_action_reason_id`),
  KEY `admin_action_idx` (`admin_action_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_logs` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_id` bigint unsigned NOT NULL DEFAULT '0',
  `action_id` bigint unsigned NOT NULL DEFAULT '0',
  `target_type` varchar(127) NOT NULL DEFAULT '',
  `target_id` bigint unsigned NOT NULL DEFAULT '0',
  `reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `legacy_reason_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.admin_reasons.id',
  `attribute_ids` varchar(255) NOT NULL DEFAULT '',
  `notes` varchar(4095) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `admin_logs_action_id_idx` (`action_id`),
  KEY `admin_logs_create_date_idx` (`create_date`),
  KEY `admin_logs_update_date_idx` (`update_date`),
  KEY `admin_logs_reason_id_idx` (`reason_id`),
  KEY `idx_admin_logs_flag_id` (`flag_id`),
  KEY `targetid_type_actionid_createdate` (`target_id`,`target_type`,`action_id`,`create_date`),
  KEY `staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_notes` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_thread_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_pinned` tinyint unsigned NOT NULL DEFAULT '0',
  `is_resolved` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `admin_notes_admin_thread_id_idx` (`admin_thread_id`),
  KEY `admin_notes_is_deleted_idx` (`is_deleted`),
  KEY `admin_notes_create_date_idx` (`create_date`),
  KEY `admin_notes_update_date_idx` (`update_date`),
  KEY `staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_reason` (
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zendesk_user_field_key` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Optional zendesk user field key that is synced to zendesk',
  `is_escheatment` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Boolean; 1 if funds are held for escheatment',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`admin_reason_id`),
  UNIQUE KEY `mnemonic` (`mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_reason_audit` (
  `admin_reason_audit_id` bigint unsigned NOT NULL,
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zendesk_user_field_key` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Optional zendesk user field key that is synced to zendesk',
  `is_escheatment` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Boolean; 1 if funds are held for escheatment',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`admin_reason_audit_id`),
  KEY `admin_reason_idx` (`admin_reason_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_reason_risk_tag` (
  `admin_reason_risk_tag_id` bigint unsigned NOT NULL,
  `admin_reason_id` bigint unsigned NOT NULL,
  `risk_tag_id` bigint unsigned NOT NULL,
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`admin_reason_risk_tag_id`),
  UNIQUE KEY `reason_tag_idx` (`admin_reason_id`,`risk_tag_id`),
  KEY `risk_tag_idx` (`risk_tag_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_reason_team` (
  `admin_reason_team_id` bigint unsigned NOT NULL,
  `admin_reason_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.admin_reason.admin_reason_id',
  `team_category_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.team_category.team_category_id',
  `type` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ban, unban, listing_freeze, listing_unfreeze, etc.',
  `create_staff_id` bigint unsigned NOT NULL,
  `update_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`admin_reason_team_id`),
  UNIQUE KEY `reason_team_type_idx` (`admin_reason_id`,`team_category_id`,`type`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_reasons` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `reason` varchar(4095) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `admin_reasons_create_date_idx` (`create_date`),
  KEY `admin_reasons_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_threads` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `reference_type_id` int unsigned NOT NULL DEFAULT '1',
  `reference_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(256) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `admin_threads_user_id_idx` (`user_id`),
  KEY `admin_threads_create_date_idx` (`create_date`),
  KEY `admin_threads_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_upvotes` (
  `user_id` bigint unsigned NOT NULL,
  `subject_type` tinyint unsigned NOT NULL,
  `subject_id` bigint unsigned NOT NULL,
  `polarity` tinyint NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`subject_type`,`subject_id`),
  KEY `admin_upvotes_create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `adobe_express_etsy_plus_url_audits` (
  `url_audit_id` bigint unsigned NOT NULL COMMENT 'Unique generated id',
  `url_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux/adobe_express_etsy_plus_urls.sql',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: EtsyModel_Shop_Shop - etsy_index/shops_index.sql - assigns ownership. 0 = not assigned',
  `adobe_express_url` varchar(255) NOT NULL COMMENT 'A unique url that can be used to redeem Adobe Express for free for the promotional period',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Soft delete field. 0 = not soft deleted',
  `assigned_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'The epoch date that the url was assigned to a shop. 0 = never assigned',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`url_audit_id`),
  KEY `url_id_idx` (`url_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_idx` (`shop_id`),
  KEY `is_deleted_idx` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `adobe_express_etsy_plus_urls` (
  `url_id` bigint unsigned NOT NULL COMMENT 'Unique generated id',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: EtsyModel_Shop_Shop - etsy_index/shops_index.sql - assigns ownership. 0 = not assigned',
  `adobe_express_url` varchar(255) NOT NULL COMMENT 'A unique url that can be used to redeem Adobe Express for free for the promotional period',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Soft delete field. 0 = not soft deleted',
  `assigned_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'The epoch date that the url was assigned to a shop. 0 = never assigned',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`url_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_idx` (`shop_id`),
  KEY `is_deleted_idx` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `advertising_campaigns` (
  `data_run_date` varchar(10) NOT NULL,
  `campaign_key` varchar(78) NOT NULL DEFAULT '',
  `data_date` int unsigned NOT NULL,
  `utm_source` varchar(26) DEFAULT NULL,
  `utm_medium` varchar(26) DEFAULT NULL,
  `utm_campaign` varchar(26) DEFAULT NULL,
  `visits` int unsigned DEFAULT NULL,
  `active2_visits` int unsigned DEFAULT NULL,
  `register` int unsigned DEFAULT NULL,
  `cart_payment` int unsigned DEFAULT NULL,
  `activity_feed_landing` int unsigned DEFAULT NULL,
  `search` int unsigned DEFAULT NULL,
  `favorite_item` int unsigned DEFAULT NULL,
  `favorite_shop` int unsigned DEFAULT NULL,
  `favorite_treasury` int unsigned DEFAULT NULL,
  `favorite` int unsigned DEFAULT NULL,
  `new_browser` int unsigned DEFAULT NULL,
  `returning_non_member` int unsigned DEFAULT NULL,
  `unauthenticated_buyer` int unsigned DEFAULT NULL,
  `unauthenticated_seller` int unsigned DEFAULT NULL,
  `unauthenticated_member` int unsigned DEFAULT NULL,
  `authenticated_buyer` int unsigned DEFAULT NULL,
  `authenticated_seller` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`campaign_key`,`data_date`),
  KEY `data_date` (`data_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Table that will hold advertising data from facebook and goog';

CREATE TABLE `answers_questions` (
  `answers_question_id` bigint unsigned NOT NULL,
  `author_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `state` int NOT NULL,
  `title` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinned_response_id` bigint unsigned NOT NULL,
  `upvote_count` int unsigned NOT NULL,
  PRIMARY KEY (`answers_question_id`),
  KEY `author_staff_id` (`author_staff_id`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_questions_responses` (
  `answers_question_response_id` bigint unsigned NOT NULL,
  `answers_question_id` bigint unsigned NOT NULL,
  `author_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `state` int NOT NULL,
  `type` int NOT NULL,
  `upvote_count` int unsigned NOT NULL,
  `response_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`answers_question_response_id`),
  KEY `author_staff_id` (`author_staff_id`,`create_date`),
  KEY `answers_question_id` (`answers_question_id`,`create_date`),
  KEY `type` (`type`,`create_date`),
  KEY `state` (`state`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_questions_responses_votes` (
  `answers_question_response_vote_id` bigint unsigned NOT NULL,
  `answers_question_response_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answers_question_response_vote_id`),
  UNIQUE KEY `response_staff` (`answers_question_response_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_questions_subscriptions` (
  `answers_question_subscription_id` bigint unsigned NOT NULL,
  `answers_question_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answers_question_subscription_id`),
  UNIQUE KEY `question_staff` (`answers_question_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_questions_votes` (
  `answers_question_vote_id` bigint unsigned NOT NULL,
  `answers_question_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answers_question_vote_id`),
  UNIQUE KEY `question_staff` (`answers_question_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_topics` (
  `answers_topic_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `topic` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`answers_topic_id`),
  UNIQUE KEY `topic` (`topic`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_topics_questions` (
  `answers_topic_question_id` bigint unsigned NOT NULL,
  `answers_topic_id` bigint unsigned NOT NULL,
  `answers_question_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answers_topic_question_id`),
  UNIQUE KEY `topic_question` (`answers_topic_id`,`answers_question_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `answers_topics_subscriptions` (
  `answers_topic_subscription_id` bigint unsigned NOT NULL,
  `answers_topic_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answers_topic_subscription_id`),
  UNIQUE KEY `topic_staff` (`answers_topic_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `app_builds` (
  `app_build_id` bigint unsigned NOT NULL,
  `version` varchar(20) NOT NULL,
  `platform_type` tinyint unsigned NOT NULL,
  `build_type` bigint unsigned NOT NULL,
  `build_notes` varchar(512) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `active` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`app_build_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `platform_build_idx` (`platform_type`,`build_type`),
  KEY `active_platform_builds_idx` (`platform_type`,`active`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appsflyer` (
  `appsflyer_pk` bigint NOT NULL,
  `device_id` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `appsflyer_id` varchar(191) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `ios_advertising_id` varchar(191) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `advertising_id` varchar(191) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `att_status` int NOT NULL DEFAULT '0',
  `aie_status` int NOT NULL DEFAULT '2',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`appsflyer_pk`),
  UNIQUE KEY `device_id` (`device_id`,`user_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `atlas_notes` (
  `atlas_note_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `subject_type` varchar(32) NOT NULL DEFAULT '',
  `subject_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_time` int unsigned NOT NULL DEFAULT '0',
  `update_time` int unsigned NOT NULL DEFAULT '0',
  `note` text NOT NULL,
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`atlas_note_id`),
  KEY `subject_id` (`subject_id`),
  KEY `create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Notes staff memebers can add to atlas';

CREATE TABLE `atlas_search_canon` (
  `id` bigint unsigned NOT NULL COMMENT 'primary key',
  `query` varchar(255) NOT NULL,
  `index` int unsigned NOT NULL,
  `url` varchar(2048) NOT NULL,
  `staff_id` bigint NOT NULL,
  `title` varchar(256) NOT NULL,
  `description` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `query` (`query`),
  KEY `staff_id` (`staff_id`),
  KEY `url` (`url`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Custom search entries for Atlas Search';

CREATE TABLE `atlas_tags` (
  `tag` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tag`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `atlas_task_history` (
  `atlas_task_history_id` bigint unsigned NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  PRIMARY KEY (`atlas_task_history_id`),
  KEY `task_id_index` (`task_id`),
  KEY `staff_id_index` (`staff_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `atlas_task_turnaround` (
  `id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT '',
  `label` varchar(24) NOT NULL DEFAULT '',
  `task_open_date` int unsigned NOT NULL,
  `task_assign_date` int unsigned NOT NULL,
  `task_close_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `task_idx` (`task_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `atlas_tasks` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `foreign_id` bigint unsigned NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT '',
  `state` varchar(50) NOT NULL DEFAULT '',
  `history` text NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `foreign_id_update_date` int unsigned NOT NULL DEFAULT '0',
  `child_count` int NOT NULL DEFAULT '1',
  `label` varchar(24) NOT NULL DEFAULT '',
  `is_archived` tinyint(1) NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL,
  `parent_id` bigint unsigned NOT NULL DEFAULT '0',
  `priority` tinyint NOT NULL DEFAULT '0',
  `tag` varchar(64) NOT NULL DEFAULT '',
  `reopen_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `staff_id_and_type_index` (`staff_id`,`type`),
  KEY `foreign_id_and_type_index` (`foreign_id`,`type`),
  KEY `atlas_tasks_create_date_idx` (`create_date`),
  KEY `atlas_tasks_update_date_idx` (`update_date`),
  KEY `user_id_index` (`user_id`),
  KEY `type_state_archived_idx` (`type`,`state`,`is_archived`),
  KEY `atlas_tasks_priority_idx` (`priority`),
  KEY `atlas_tasks_tag_index` (`tag`),
  KEY `staff_id_tag_index` (`staff_id`,`tag`),
  KEY `staff_id_label_index` (`staff_id`,`label`),
  KEY `staff_id_priority_index` (`staff_id`,`priority`),
  KEY `reopen_date_state_idx` (`reopen_date`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bastet_authapp_jwt` (
  `username` varchar(175) COLLATE utf8mb4_unicode_ci NOT NULL,
  `aud` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jti` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_expires` datetime NOT NULL,
  `updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`,`aud`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bin_data` (
  `bin_data_id` bigint unsigned NOT NULL,
  `bin` varchar(8) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'binbase' COMMENT 'Provider of the BIN data, will be from binbase or pagos',
  `card_brand` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `category` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_iso2_code` varchar(3) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_iso3_code` varchar(3) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_iso_name` varchar(80) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `country_iso_number` int NOT NULL DEFAULT '0',
  `is_regulated_bin` varchar(2) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `issuing_org` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `issuing_org_phone` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `issuing_org_url` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `pan_length` int NOT NULL DEFAULT '0',
  `personal_or_commercial_flag` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type_of_card` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'The card product name according to the card brand',
  `product_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'The card product code according to the card brand',
  `prepaid` tinyint(1) DEFAULT NULL COMMENT 'Whether the card is prepaid or not',
  `pagos_correlation_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'A unique Pagos ID that maps a BIN range to a specific network file; used for troubleshooting',
  `regulated_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'The name of the interchange regulation',
  `reloadable` tinyint(1) DEFAULT NULL COMMENT 'Indicator of reloadable or non-reloadable prepaid',
  `pan_or_token` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Indicator if the BIN is a PAN or a Network Token.',
  `account_updater` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Account Updater enabled',
  `alm` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Indicator of a BIN or Account Range participating in Account Level Management',
  `domestic_only` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Domestic-only BIN or Account Ranges',
  `gambling_blocked` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Indicator that this BIN is not permitted to be used for online gambling',
  `level2` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Indicator of Level 2 interchange rate eligibility',
  `level3` tinyint(1) DEFAULT NULL COMMENT '(Visa-only field) Indicator of Level 3 interchange rate eligibility',
  `issuer_currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'The currency that was issued to this BIN to transact in',
  `combo_card` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Indicator for a card that has combined card type capabilities',
  `bin_length` int NOT NULL DEFAULT '0' COMMENT '6 or 8 digit BIN',
  `authentication` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'If additional customer authentication is required, this json array will indicate the authentication_name; this field is hardcoded based on issuer country law',
  `cost` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Identifies associated costs by name and amount, embedded as JSON in the column',
  `card_brand_is_additional` tinyint(1) DEFAULT NULL COMMENT 'Set to false if the BIN range is associated with a primary card network and set to true if associated with a secondary network (e.g. Star, pulse, nyce); note that secondary network''s typically provide less in their BIN data. If multiple networks share a BIN range and all have card_brand_is_additional set to false, the primary network will be Visa, Mastercard, Discover, Amex, JCB, or UnionPay.',
  `issuer_supports_tokenization` tinyint(1) DEFAULT NULL COMMENT 'Set to true if the card brand data indicates the issuing bank supports network tokenization',
  `pagos_shared_bin` tinyint(1) DEFAULT NULL COMMENT 'Set to true if the card brand data indicates the issuing bank supports network tokenization',
  `billpay_enabled` tinyint(1) DEFAULT NULL COMMENT 'Set to true if BIN is shared by multiple issuers; more BIN digits may be required in order to get the most accurate BIN details',
  `ecom_enabled` tinyint(1) DEFAULT NULL COMMENT 'BIN has been enabled to make ecommerce purchases, or purchases over the internet',
  `virtual_card` tinyint(1) DEFAULT NULL COMMENT 'Set to true if the given BIN range supports virtual card creation. A null response indicates we do not know if there is support for virtual cards',
  `funding_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Indicates the funding source for a payment card, which is different from the type.',
  `load_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`bin_data_id`),
  KEY `bin_idx` (`bin`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `black_marks` (
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL,
  `mark_id` int unsigned NOT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`shop_id`,`mark_id`),
  KEY `black_marks_create_date_idx` (`create_date`),
  KEY `black_marks_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bughunt_cases` (
  `jira_key` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `app` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`jira_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bughunt_report` (
  `report_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` int unsigned NOT NULL DEFAULT '0',
  `platform_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `etsy_version` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jira_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `image01` bigint unsigned NOT NULL,
  `image02` bigint unsigned NOT NULL,
  `image03` bigint unsigned NOT NULL,
  `device_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`report_id`),
  KEY `task_idx` (`task_id`),
  KEY `user_idx` (`user_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_promise_price_suggestion` (
  `shop_id` bigint unsigned NOT NULL,
  `suggested_price` int unsigned NOT NULL,
  `suggestion_currency_code` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `free_shipping_order_count` int unsigned NOT NULL,
  `total_units_sold_under_threshold` int unsigned NOT NULL,
  `shipping_costs_for_under_threshold_items` int unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_promise_simulation_credit` (
  `buyer_promise_simulation_credit_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `receipt_id` bigint unsigned NOT NULL,
  `shipping_price_usd` int unsigned NOT NULL DEFAULT '0',
  `threshold_variant_key` smallint unsigned NOT NULL DEFAULT '0',
  `seller_reimbursement_credit_id` bigint unsigned NOT NULL DEFAULT '0',
  `credit_status` smallint unsigned NOT NULL DEFAULT '0',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  `credit_adjustment_usd` int unsigned NOT NULL DEFAULT '0',
  `adjustment_credit_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`buyer_promise_simulation_credit_id`),
  KEY `shop_receipt_idx` (`shop_id`,`receipt_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `threshold_variant_key_idx` (`threshold_variant_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_fsa_zone_map` (
  `version` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Canada Post Rate Version',
  `fsa` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_air` tinyint NOT NULL DEFAULT '0',
  `zone` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`version`,`fsa`,`is_air`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Maps Canada Post Domestic FSAs to zones. Replaces sqlite databases in /var/shipping. See `canada_post_zone_rate_code_map`';

CREATE TABLE `canada_post_fuel_surcharge` (
  `surcharge_date` int unsigned NOT NULL,
  `surcharge_key` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `surcharge_percent` decimal(10,6) NOT NULL,
  PRIMARY KEY (`surcharge_date`,`surcharge_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_invoice_item` (
  `invoice_number` bigint unsigned NOT NULL,
  `manifest_number` varchar(150) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `manifest_date` int unsigned NOT NULL DEFAULT '0',
  `line_item_type` varchar(40) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'charge',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `tracking_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `width` int unsigned NOT NULL DEFAULT '0',
  `height` int unsigned NOT NULL DEFAULT '0',
  `length` int unsigned NOT NULL DEFAULT '0',
  `dimension_units` varchar(4) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mm',
  `weight` int unsigned NOT NULL DEFAULT '0',
  `weight_units` varchar(4) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'g',
  `base_charge` int NOT NULL DEFAULT '0',
  `automation_discount` int NOT NULL DEFAULT '0',
  `revenue_share_discount` int NOT NULL DEFAULT '0',
  `insurance_fee` int NOT NULL DEFAULT '0',
  `signature_confirmation_fee` int NOT NULL DEFAULT '0',
  `mailing_tube_fee` int NOT NULL DEFAULT '0',
  `oversized_fee` int NOT NULL DEFAULT '0',
  `fuel_surcharge` int NOT NULL DEFAULT '0',
  `net_charge` int NOT NULL DEFAULT '0',
  `gst_total` int NOT NULL DEFAULT '0',
  `hst_total` int NOT NULL DEFAULT '0',
  `pst_total` int NOT NULL DEFAULT '0',
  `total_charge` int NOT NULL DEFAULT '0',
  `gst_hst_tax_status` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `provincial_tax_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `adjustment_issued` tinyint(1) NOT NULL DEFAULT '0',
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `invoice_due_date` int unsigned NOT NULL DEFAULT '0',
  `network_surcharge` int NOT NULL DEFAULT '0',
  `commission` int NOT NULL DEFAULT '0',
  `input_tax` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`invoice_number`,`manifest_number`,`line_item_type`),
  KEY `adjustment_issued_type` (`line_item_type`,`adjustment_issued`),
  KEY `shipping_label_id` (`shipping_label_id`),
  KEY `tracking_code` (`tracking_code`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invoice_date` (`invoice_date`),
  KEY `invoice_due_date` (`invoice_due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_invoices` (
  `invoice_number` bigint unsigned NOT NULL,
  `package_count` int unsigned NOT NULL DEFAULT '0',
  `base_charges` int NOT NULL DEFAULT '0',
  `automation_discount` int NOT NULL DEFAULT '0',
  `revenue_share_discount` int NOT NULL DEFAULT '0',
  `insurance_fees` int NOT NULL DEFAULT '0',
  `signature_confirmation_fees` int NOT NULL DEFAULT '0',
  `mailing_tube_fees` int NOT NULL DEFAULT '0',
  `oversized_fees` int NOT NULL DEFAULT '0',
  `fuel_surcharge` int NOT NULL DEFAULT '0',
  `net_charges` int NOT NULL DEFAULT '0',
  `gst_total` int NOT NULL DEFAULT '0',
  `hst_total` int NOT NULL DEFAULT '0',
  `pst_total` int NOT NULL DEFAULT '0',
  `total_charges` int NOT NULL DEFAULT '0',
  `invoice_date` int NOT NULL DEFAULT '0',
  `invoice_due_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `network_surcharge` int NOT NULL DEFAULT '0',
  `filename` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`invoice_number`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invoice_date` (`invoice_date`),
  KEY `invoice_due_date` (`invoice_due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_sfsb_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CAD',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_sfsb_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_number` bigint unsigned NOT NULL,
  `manifest_number` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_date` int unsigned NOT NULL DEFAULT '0',
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `invoice_due_date` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  `tracking_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `length` decimal(8,2) NOT NULL DEFAULT '0.00',
  `width` decimal(8,2) NOT NULL DEFAULT '0.00',
  `height` decimal(8,2) NOT NULL DEFAULT '0.00',
  `dimension_units` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `weight` int unsigned NOT NULL DEFAULT '0',
  `weight_units` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `article_number` smallint unsigned NOT NULL DEFAULT '0',
  `origin_postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_state` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_country_id` smallint unsigned NOT NULL DEFAULT '0',
  `rate_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `adjustment_reason` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `base_charge` int NOT NULL DEFAULT '0',
  `insurance_fee` int NOT NULL DEFAULT '0',
  `signature_confirmation_fee` int NOT NULL DEFAULT '0',
  `mailing_tube_fee` int NOT NULL DEFAULT '0',
  `oversized_fee` int NOT NULL DEFAULT '0',
  `fuel_surcharge` int NOT NULL DEFAULT '0',
  `network_surcharge` int NOT NULL DEFAULT '0',
  `commission` int NOT NULL DEFAULT '0',
  `transaction_fee` int NOT NULL DEFAULT '0',
  `input_tax` int NOT NULL DEFAULT '0',
  `net_charge` int NOT NULL DEFAULT '0',
  `gst_total` int NOT NULL DEFAULT '0',
  `hst_total` int NOT NULL DEFAULT '0',
  `pst_total` int NOT NULL DEFAULT '0',
  `total_charge` int NOT NULL DEFAULT '0',
  `expected_total_charge` int NOT NULL DEFAULT '0',
  `delta` int NOT NULL DEFAULT '0',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CAD',
  `gst_hst_tax_status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `provincial_tax_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_idx` (`state`),
  KEY `shipping_label_idx` (`shop_id`,`shipping_label_id`),
  KEY `tracking_code` (`tracking_code`),
  KEY `manifest_number` (`manifest_number`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shipping_label_id_idx` (`shipping_label_id`),
  KEY `invoice_number` (`invoice_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canada_post_zone_rate_code_map` (
  `version` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Canada Post Rate Version',
  `origin_zone` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_zone` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`version`,`origin_zone`,`destination_zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Maps Canada Post domestic zones to rate codes. Replaces sqlite databases in /var/shipping. See `canada_post_fsa_zone_map`';

CREATE TABLE `candidate_set_metadata` (
  `candidate_set_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dynamic_class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descriptive_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `long_description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `input_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `output_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`candidate_set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canvas_dynamic_targeting` (
  `canvas_dynamic_targeting_id` bigint unsigned NOT NULL DEFAULT '0',
  `canvas_template_id` bigint unsigned NOT NULL DEFAULT '0',
  `rule_set` longtext NOT NULL,
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`canvas_dynamic_targeting_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `canvas_template_id` (`canvas_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canvas_template` (
  `canvas_template_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(80) NOT NULL DEFAULT '',
  `email_campaign_id` bigint unsigned NOT NULL DEFAULT '0',
  `layout_path` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(512) DEFAULT NULL,
  `author_id` bigint unsigned NOT NULL DEFAULT '0',
  `plain_text` mediumtext,
  `preview_text` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `export_html` mediumtext,
  `layout_html` mediumtext,
  `export_date` int unsigned DEFAULT NULL,
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `copy_of_canvas_template_id` bigint unsigned DEFAULT NULL,
  `should_be_translated` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`canvas_template_id`),
  KEY `email_campaign_id_idx` (`email_campaign_id`),
  KEY `author_idx` (`author_id`),
  KEY `deleted_idx` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canvas_template_group` (
  `canvas_template_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `canvas_template_id` bigint unsigned NOT NULL DEFAULT '0',
  `html_element_id` varchar(80) NOT NULL DEFAULT '',
  `type` varchar(150) NOT NULL DEFAULT '',
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `listing_algorithm` smallint unsigned NOT NULL DEFAULT '0',
  `hide_algorithmic_listings` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`canvas_template_group_id`),
  UNIQUE KEY `canvas_template_html_element_id_idx` (`canvas_template_id`,`html_element_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canvas_template_module` (
  `canvas_template_module_id` bigint unsigned NOT NULL DEFAULT '0',
  `canvas_template_id` bigint unsigned NOT NULL DEFAULT '0',
  `html_element_id` varchar(80) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `type` varchar(80) NOT NULL DEFAULT '',
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`canvas_template_module_id`),
  UNIQUE KEY `canvas_template_html_element_id_idx` (`canvas_template_id`,`html_element_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `canvas_template_module_data` (
  `canvas_template_module_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(80) NOT NULL DEFAULT '',
  `value` mediumtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`canvas_template_module_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_conclusions` (
  `launch_id` bigint unsigned NOT NULL,
  `message` varchar(5000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The human-readable conclusion message',
  `experiment_start_date` int unsigned NOT NULL,
  `experiment_end_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who created the conclusion',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who edited the conclusion',
  `on_variant` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`launch_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_eligibilities` (
  `eligibility_id` bigint NOT NULL,
  `config_id` bigint NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`eligibility_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `config_id_idx` (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_groups` (
  `group_id` bigint NOT NULL COMMENT 'The id of a group that will see this variant.',
  `variant_id` bigint NOT NULL COMMENT 'The config variant to which this group is assigned.',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`variant_id`,`group_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_history` (
  `config_history_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `config_flag` varchar(255) NOT NULL COMMENT 'The fully qualified config flag that was touched.',
  `config_id` bigint NOT NULL COMMENT 'The config that was added or changed. 0 if config was deleted.',
  `config_style` varchar(255) NOT NULL COMMENT 'config, ab, or feature',
  `repo` varchar(255) NOT NULL COMMENT 'Where the commits can be found, e.g. Web or Etsyweb',
  `action` varchar(255) NOT NULL COMMENT 'added, modified, or deleted.',
  `author` varchar(255) NOT NULL COMMENT 'Author of the change.',
  `commit_sha1` char(40) NOT NULL COMMENT 'The sha1 of the git commit',
  `commit_epoch` int unsigned NOT NULL COMMENT 'Time the config was pushed to master, in unix seconds',
  `deployed_sha1` char(40) NOT NULL COMMENT 'The sha1 of the git commit that was deployed.',
  `deployed_epoch` int unsigned NOT NULL COMMENT 'Time the config was deployed, according to deployinator, in unix seconds',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`config_history_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `deployed_epoch_idx` (`deployed_epoch`),
  KEY `config_flag_idx` (`config_flag`),
  KEY `config_id_idx` (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_users` (
  `user_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `variant_id` bigint NOT NULL COMMENT 'The config variant to which this user is assigned.',
  `login_name` varchar(32) NOT NULL COMMENT 'The login name of a user who will see this variant.',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`variant_id`,`user_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_variants` (
  `variant_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `config_id` bigint NOT NULL COMMENT 'Config this variant is part of',
  `name` varchar(255) NOT NULL COMMENT 'The variant name',
  `percentage` float NOT NULL COMMENT 'Percentage of users to see this variant',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`config_id`,`variant_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_configs` (
  `config_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `launch_id` bigint NOT NULL COMMENT 'The launch this is a config for',
  `config_flag` varchar(255) NOT NULL COMMENT 'The fully qualified config flag for this experiment',
  `admin_variant` varchar(255) NOT NULL COMMENT 'Variant seen by admin users',
  `internal_variant` varchar(255) NOT NULL COMMENT 'Variant seen on internal requests',
  `public_url_override` tinyint unsigned NOT NULL COMMENT 'Can the url override be used on any request?',
  `bucketing` varchar(20) NOT NULL DEFAULT 'uaid' COMMENT 'Bucketing scheme for experiments.',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`config_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `config_flag_idx` (`config_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_events` (
  `event_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the event',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human-readable description of event.',
  `is_primary` tinyint(1) NOT NULL COMMENT 'Is this a primary event',
  `create_date` int unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who created the event',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `name` (`name`),
  KEY `update_date_idx` (`update_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `primary_idx` (`is_primary`,`is_deleted`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_experiment_boundaries` (
  `launch_id` bigint NOT NULL,
  `config_id` bigint NOT NULL,
  `config_flag` varchar(255) NOT NULL,
  `variant_percent` float NOT NULL DEFAULT '0',
  `start_epoch` int NOT NULL DEFAULT '0',
  `end_epoch` int NOT NULL DEFAULT '0',
  `updated_by` varchar(80) NOT NULL,
  `reason` varchar(5000) NOT NULL,
  `updated_date` int NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`launch_id`,`config_id`,`config_flag`,`start_epoch`,`end_epoch`),
  KEY `active` (`active`,`start_epoch`),
  KEY `create_date_idx` (`create_date`),
  KEY `updated_date_idx` (`updated_date`),
  KEY `config_flag_idx` (`config_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_experiment_metrics` (
  `launch_id` bigint NOT NULL COMMENT 'The launch the metric is associated with',
  `metric_id` bigint NOT NULL COMMENT 'The metric',
  `direction` tinyint NOT NULL COMMENT 'Whether we expect treatments to increase, decrease, or leave unchanged, the metric.',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `percent_lift` decimal(10,2) unsigned NOT NULL DEFAULT '1.00',
  PRIMARY KEY (`launch_id`,`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_favorites` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `launch_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`launch_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `launch_id_idx` (`launch_id`),
  KEY `create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_launch_screenshots` (
  `id` bigint unsigned NOT NULL,
  `launch_id` bigint NOT NULL,
  `variant_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_id` bigint NOT NULL,
  `caption` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `launch_id` (`launch_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_launch_urls` (
  `launch_id` bigint NOT NULL COMMENT 'Launch this is a url for',
  `kind` tinyint unsigned NOT NULL COMMENT 'What kind of URL is it?',
  `url` varchar(512) NOT NULL COMMENT 'The URL',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`launch_id`,`kind`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='What URLs are associated with a launch? E.g. wiki, pmm, etc.';

CREATE TABLE `catapult_launches` (
  `launch_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `name` varchar(1000) DEFAULT NULL,
  `description` varchar(5000) DEFAULT NULL,
  `hypothesis` varchar(5000) DEFAULT NULL,
  `team` varchar(50) NOT NULL COMMENT 'The team responsible for the launch',
  `team_id` bigint NOT NULL DEFAULT '0',
  `kind` varchar(50) NOT NULL COMMENT 'Kind of launch: experiment, rampup, communication',
  `impact` varchar(50) NOT NULL COMMENT 'Estimate of the impact on the site.',
  `config_id` bigint NOT NULL COMMENT 'Current configuration. Only needed for experiments and rampups.',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who created the launch',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who edited the launch',
  `created_epoch` int unsigned NOT NULL COMMENT 'Time launch was created.',
  `updated_epoch` int unsigned NOT NULL COMMENT 'Time launch was last updated.',
  `is_prototype` tinyint NOT NULL,
  `is_admin` tinyint NOT NULL,
  `is_approved` tinyint NOT NULL DEFAULT '1',
  `deployed_config_id` bigint NOT NULL,
  `last_deployed_epoch` bigint NOT NULL,
  `launch_percentage` float DEFAULT NULL,
  `config_flag` varchar(255) NOT NULL,
  `delete_date` int unsigned DEFAULT NULL COMMENT 'Time launch was deleted.',
  `deleted_staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who deleted the launch',
  `state` tinyint NOT NULL DEFAULT '0',
  `est_rampup_date` int unsigned DEFAULT NULL COMMENT 'Estimated rampup date',
  `analyst_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`launch_id`),
  KEY `team_idx` (`team`),
  KEY `delete_date` (`delete_date`,`state`,`created_epoch`),
  KEY `created_epoch_idx` (`created_epoch`),
  KEY `updated_epoch_idx` (`updated_epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Things that can be launched. Experiments, Rampups, and Communications. Slightly denormalized in that we store all three kinds of launches here even though some fields are only needed by certain kinds of launches.';

CREATE TABLE `catapult_metrics` (
  `metric_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(512) NOT NULL COMMENT 'Longer description.',
  `event` varchar(128) DEFAULT NULL,
  `kind` tinyint unsigned NOT NULL COMMENT 'Proportion of visits or mean per visit.',
  `is_key_health_metric` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Is this a key health metric that should be watched on all experiments.',
  `numerator` varchar(128) DEFAULT NULL,
  `denominator` varchar(128) DEFAULT NULL,
  `is_nonevent_site_metric` tinyint unsigned NOT NULL DEFAULT '0',
  `numerator_ss` varchar(128) DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `name_idx` (`name`),
  KEY `is_key_health_metric_idx` (`is_key_health_metric`,`name`),
  KEY `event_idx` (`event`,`name`),
  KEY `by_key_fields_idx` (`numerator`,`denominator`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `challenge_calendar` (
  `challenge_id` bigint unsigned NOT NULL,
  `hashtags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'String with an array of hashtags separated by comma.',
  `start_date` int unsigned NOT NULL COMMENT 'This is the start day of the challenge',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'The status could be active (1), draft (2) or inactive (3)',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`challenge_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `start_date` (`start_date`),
  KEY `challenge_status` (`challenge_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `challenge_calendar_detail` (
  `challenge_id` bigint unsigned NOT NULL,
  `boomerang_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fullscreen_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` smallint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`challenge_id`,`priority`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `channel_transaction_fee` (
  `channel_transaction_fee_id` bigint unsigned NOT NULL,
  `channel_id` bigint unsigned NOT NULL COMMENT 'Sales channel the rate applies to',
  `rate` float NOT NULL COMMENT 'The transaction fee rate that should be charged for the sales channel',
  `effective_date` bigint unsigned NOT NULL COMMENT 'First date after which the rate should be applied',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`channel_transaction_fee_id`),
  UNIQUE KEY `channel_id` (`channel_id`,`effective_date`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Transaction fee rates charged over time on etsy sales channels';

CREATE TABLE `channel_transaction_fee_overridden_receipt` (
  `receipt_id` bigint unsigned NOT NULL COMMENT 'Receipt for which the rate was overridden',
  `rate` float NOT NULL COMMENT 'The actual rate charged for the receipt',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`receipt_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Receipts for which we knowingly did not charge the rate described in channel_transaction_fee';

CREATE TABLE `chargeback` (
  `chargeback_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_admin_type` smallint NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `provider` varchar(16) NOT NULL,
  `provider_ref_num` varchar(25) NOT NULL,
  `provider_foreign_key` bigint unsigned NOT NULL DEFAULT '0',
  `processor` varchar(32) NOT NULL DEFAULT '',
  `processor_chargeback_type` varchar(32) NOT NULL DEFAULT '',
  `chargeback_type` varchar(10) NOT NULL,
  `request_type` varchar(25) NOT NULL DEFAULT '',
  `billing_status` int NOT NULL,
  `receipt_id` bigint unsigned NOT NULL DEFAULT '0',
  `target_type` varchar(32) NOT NULL DEFAULT '',
  `target_id` bigint unsigned NOT NULL DEFAULT '0',
  `mid_text` varchar(32) NOT NULL DEFAULT '',
  `due_date` int unsigned NOT NULL DEFAULT '0',
  `state` varchar(16) NOT NULL,
  `chargeback_reason` bigint unsigned NOT NULL,
  `is_fraud` tinyint(1) NOT NULL,
  `cb_amount` int NOT NULL,
  `cb_currency` smallint unsigned NOT NULL DEFAULT '0',
  `cb_date` int unsigned NOT NULL DEFAULT '0',
  `disputed_amt` int NOT NULL DEFAULT '0',
  `disputed_currency` smallint unsigned NOT NULL DEFAULT '0',
  `vendor_notes` text NOT NULL,
  `reporting_group` varchar(32) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `recommended_action` int NOT NULL,
  `seller_respond_by_date` int unsigned NOT NULL DEFAULT '0',
  `etsy_outcome` smallint NOT NULL DEFAULT '0',
  `etsy_outcome_reason` text NOT NULL,
  `etsy_account_action` int NOT NULL,
  `notes` text NOT NULL,
  `credit_card` varchar(16) NOT NULL,
  `credit_card_type` smallint NOT NULL,
  `buyer_id` bigint unsigned NOT NULL DEFAULT '0',
  `seller_id` bigint unsigned NOT NULL DEFAULT '0',
  `transaction_date` int unsigned NOT NULL,
  `provider_update_date` int unsigned NOT NULL,
  `load_date` int unsigned NOT NULL DEFAULT '0',
  `etsy_outcome_date` int unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`chargeback_id`),
  KEY `provider_provider_ref_num` (`provider`,`provider_ref_num`),
  KEY `provider_ref_num` (`provider_ref_num`),
  KEY `buyer_id` (`buyer_id`),
  KEY `seller_id` (`seller_id`),
  KEY `chargeback_create_date` (`create_date`),
  KEY `chargeback_request_type` (`request_type`),
  KEY `receipt_id_idx` (`receipt_id`),
  KEY `provider_provider_foreign_key` (`provider`,`provider_foreign_key`),
  KEY `target_id_target_type` (`target_id`,`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chargeback_hash` (
  `chargeback_hash_id` bigint unsigned NOT NULL,
  `provider` varchar(16) NOT NULL DEFAULT '',
  `file_type` varchar(16) NOT NULL DEFAULT '',
  `file_name` varchar(255) NOT NULL DEFAULT '',
  `file_hash` varchar(255) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`chargeback_hash_id`),
  KEY `chargeback_hash_file_hash` (`file_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chargeback_history` (
  `chargeback_history_id` bigint unsigned NOT NULL DEFAULT '0',
  `chargeback_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_admin_type` smallint NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `provider` varchar(16) NOT NULL DEFAULT '',
  `chargeback_type` varchar(10) NOT NULL DEFAULT '',
  `billing_status` int NOT NULL,
  `due_date` int unsigned NOT NULL DEFAULT '0',
  `state` varchar(16) NOT NULL,
  `chargeback_reason` bigint unsigned NOT NULL,
  `vendor_notes` text NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `recommended_action` int NOT NULL,
  `seller_respond_by_date` int unsigned NOT NULL DEFAULT '0',
  `etsy_outcome` int NOT NULL,
  `etsy_outcome_reason` text NOT NULL,
  `etsy_account_action` int NOT NULL,
  `notes` text NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`chargeback_history_id`),
  KEY `chargeback_id_update_date` (`chargeback_id`),
  KEY `chargeback_history_create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chargeback_reason` (
  `chargeback_reason_id` bigint unsigned NOT NULL,
  `provider` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `chargeback_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reason` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`chargeback_reason_id`),
  KEY `chargeback_reason_reason` (`reason`),
  KEY `chargeback_reason_provider_type` (`provider`,`chargeback_type`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chargeback_upload` (
  `chargeback_upload_id` bigint unsigned NOT NULL DEFAULT '0',
  `chargeback_id` bigint unsigned NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `upload_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`chargeback_upload_id`),
  KEY `chargeback_upload_chargeback_id` (`chargeback_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chargeback_vendor_data` (
  `chargeback_vendor_data_id` bigint unsigned NOT NULL,
  `data` varchar(8192) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`chargeback_vendor_data_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `chase_cc_logs` (
  `chase_cc_log_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'charge, auth or void',
  `create_date` int unsigned NOT NULL,
  `order_id` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tx_ref_num` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tx_ref_idx` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `proc_status` char(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approval_status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resp_code` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_resp_code` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cvv2_resp_code` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_code` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_message` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resp_message` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `host_resp_code` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `host_avs_resp_code` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `host_cvv_resp_code` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_ref_num` varchar(22) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_proc_status` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_profile_message` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resptime` char(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double NOT NULL,
  `message_type` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avs_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_address1` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_address2` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_city` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_state` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_zip` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_country_code` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_phone_number` char(14) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cc_last_four` char(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`chase_cc_log_id`),
  KEY `chase_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `checkout_banners` (
  `banner_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `is_banner_active` tinyint NOT NULL DEFAULT '0' COMMENT 'indicates if banner is active or disabled',
  `banner_message_type` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user selects which preset copy they will use',
  `custom_message` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_pages` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'json array of banner placement options',
  `is_universal_banner` tinyint NOT NULL DEFAULT '0' COMMENT 'indicates if banner is to be displayed to all Etsy regions or only a select subgroup',
  `banner_country_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'string array of country ids where banner will appear',
  `banner_zipcodes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'json array of relevant zipcodes for banner display',
  `banner_filter` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'indicates if user is to see banner based on shipping address, billing address or browsing country',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `publish_date` int unsigned DEFAULT NULL COMMENT 'date that banner will be set to active',
  `takedown_date` int unsigned DEFAULT NULL COMMENT 'date that banner will be disabled',
  PRIMARY KEY (`banner_id`),
  KEY `admin_id_idx` (`admin_id`),
  KEY `is_banner_active_idx` (`is_banner_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cm_audience` (
  `audience_id` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rollup_table` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_market` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_size` bigint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`audience_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cm_audience_vendor` (
  `audience_id` bigint unsigned NOT NULL,
  `vendor_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor_list_union` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `vendor_list_green` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `vendor_list_blue` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_touched_list` tinyint unsigned NOT NULL DEFAULT '0',
  `sync_enabled` tinyint unsigned NOT NULL DEFAULT '0',
  `last_upload` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`audience_id`,`vendor_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_blocklist_terms` (
  `blocklist_term_id` bigint unsigned NOT NULL,
  `term` varchar(255) NOT NULL,
  `context` varchar(255) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `notes` varchar(1023) NOT NULL DEFAULT '',
  `create_admin` bigint unsigned NOT NULL DEFAULT '0',
  `update_admin` bigint unsigned NOT NULL DEFAULT '0',
  `language` varchar(16) NOT NULL DEFAULT 'en-US' COMMENT 'Language code associated with the blocklisted term',
  `region` varchar(16) NOT NULL DEFAULT 'US' COMMENT 'ISO 3166-1 region code associated with the blocklisted term',
  `match_method` varchar(16) NOT NULL DEFAULT 'exact match',
  PRIMARY KEY (`blocklist_term_id`),
  UNIQUE KEY `unique_context_language_region_term` (`context`,`language`,`region`,`term`),
  KEY `term` (`term`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_blocklist_variants` (
  `context` varchar(255) NOT NULL COMMENT 'Blocklist context (reason)',
  `language` varchar(16) NOT NULL DEFAULT 'en-US' COMMENT 'Language code associated with the blocklisted variant',
  `region` varchar(16) NOT NULL DEFAULT 'US' COMMENT 'ISO 3166-1 region code associated with the blocklisted variant',
  `last_modified_date` int NOT NULL DEFAULT '0' COMMENT 'Epoch time the variant was last changed (including deletions)',
  `create_date` int NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`context`,`language`,`region`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `last_modified_date` (`last_modified_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_buyer_vat_einvoices` (
  `receipt_id` bigint unsigned NOT NULL,
  `buyer_user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `vat_invoice_id` bigint unsigned NOT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `buyer_vat_region` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_vat_region` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor_transaction_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_invoice_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`receipt_id`),
  KEY `vendor_transaction_key` (`vendor_transaction_key`),
  KEY `vendor_invoice_number` (`vendor_invoice_number`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_credit_note_einvoices` (
  `credit_note_id` bigint unsigned NOT NULL COMMENT 'Unique credit note id',
  `vat_invoice_id` bigint unsigned NOT NULL COMMENT 'Associated VAT invoice id',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Shop that this credit note belongs to',
  `refund_month` int unsigned NOT NULL COMMENT 'Refund month of the credit note',
  `refund_year` int unsigned NOT NULL COMMENT 'Refund year of the credit note',
  `charge_month` int unsigned NOT NULL COMMENT 'Charge month of the vat invoice',
  `charge_year` int unsigned NOT NULL COMMENT 'Charge year of the vat note',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT 'Status of the uploading process',
  `refund_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Refund note number given by the vendor',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`credit_note_id`),
  KEY `shop_id` (`shop_id`),
  KEY `charge_date_idx` (`charge_month`,`charge_year`),
  KEY `refund_date_idx` (`refund_month`,`refund_year`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_doc_check_evaluation` (
  `shop_id` bigint unsigned NOT NULL COMMENT 'Shop identifier that the evaluation belongs to',
  `verification_result` tinyint(1) NOT NULL COMMENT 'if the verification passed or failed',
  `vendor_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'How the vendor parsed the name',
  `etsy_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'How the vendor parsed the name',
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_vat_einvoices` (
  `vat_invoice_id` bigint unsigned NOT NULL COMMENT 'Parent VAT invoice',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Shop that the VAT invoice belongs to',
  `vat_region` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tax region for the VAT invoice',
  `month` int unsigned NOT NULL COMMENT 'Month of the VAT invoice',
  `year` int unsigned NOT NULL COMMENT 'Year of the VAT invoice',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT 'Status of the uploading process',
  `vendor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor providing the e-invoicing service',
  `transaction_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Transaction key generated by the vendor',
  `invoice_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Invoice number provided by the vendor',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`vat_invoice_id`),
  KEY `shop_id` (`shop_id`),
  KEY `transaction_key` (`transaction_key`),
  KEY `invoice_date_idx` (`month`,`year`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `concession_ticket_mapping` (
  `concession_ticket_mapping_id` bigint unsigned NOT NULL DEFAULT '0',
  `ticket_id` bigint unsigned NOT NULL,
  `ticket_type` int NOT NULL,
  `concession_id` bigint unsigned NOT NULL,
  `concession_type` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`concession_ticket_mapping_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `concession_idx` (`concession_id`,`concession_type`),
  KEY `ticket_idx` (`ticket_id`,`ticket_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `content_moderation_label` (
  `listing_id` bigint unsigned NOT NULL,
  `label` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `decision` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confirmations` int unsigned NOT NULL,
  `dataset` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `used_for` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `labeled_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Image, text, etc',
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `serialized_listing_data` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Denormalized listing data',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`listing_id`,`label`,`category`,`dataset`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `contentful_image` (
  `contentful_asset_image_id` bigint unsigned NOT NULL,
  `contentful_asset_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_id` bigint unsigned NOT NULL,
  `image_hash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`contentful_asset_image_id`),
  UNIQUE KEY `contentful_asset_id` (`contentful_asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `control` (
  `control_id` bigint unsigned NOT NULL DEFAULT '0',
  `impl_type` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `impl_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`control_id`),
  UNIQUE KEY `impl_type_id` (`impl_type`,`impl_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `control_revision` (
  `control_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `control_revision_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `control_revision_description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `control_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `impl_type` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `impl_id` bigint unsigned NOT NULL DEFAULT '0',
  `impl_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `override_admin_action_id` bigint unsigned NOT NULL DEFAULT '0',
  `override_admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `overide_nova_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `override_apollo_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `override_apollo_queue` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `end_date` int unsigned NOT NULL DEFAULT '0',
  `archived` tinyint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`control_revision_id`),
  UNIQUE KEY `flag_control_audit_id_unq` (`flag_type_id`,`control_id`,`impl_audit_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `control_risk_tag` (
  `control_risk_tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `control_id` bigint unsigned NOT NULL DEFAULT '0',
  `risk_tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`control_risk_tag_id`),
  KEY `control_idx` (`control_id`),
  KEY `risk_tag_idx` (`risk_tag_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `convo_auto_reply` (
  `user_id` bigint unsigned NOT NULL,
  `reply_type` tinyint NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `convos_email_reply` (
  `reply_id` bigint unsigned NOT NULL,
  `conversation_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_guest` tinyint unsigned NOT NULL DEFAULT '0',
  `receipt_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`reply_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `user_id_idx` (`user_id`),
  KEY `convo_id_user_id_receipt_id_idx` (`conversation_id`,`user_id`,`receipt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `credit_notes` (
  `credit_note_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `charge_month` tinyint unsigned NOT NULL DEFAULT '0',
  `charge_year` int unsigned NOT NULL DEFAULT '0',
  `refund_month` tinyint unsigned NOT NULL DEFAULT '0',
  `refund_year` int unsigned NOT NULL DEFAULT '0',
  `seller_business_name` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_name` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_address` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vat_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`credit_note_id`),
  KEY `shop_id_refund_date_idx` (`shop_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `refund_idx` (`refund_month`,`refund_year`),
  KEY `key_create_date` (`create_date`),
  KEY `key_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `currencies` (
  `currency_id` bigint unsigned NOT NULL,
  `code` varchar(3) NOT NULL,
  `name` varchar(100) NOT NULL,
  `number_precision` int NOT NULL DEFAULT '2',
  `symbol` varchar(5) NOT NULL,
  `listing_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `buyer_location_restricted` tinyint(1) NOT NULL DEFAULT '0',
  `rate_updates_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `browsing_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`currency_id`),
  KEY `code_idx` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `currency_exchange_rates` (
  `currency_rate_id` bigint unsigned NOT NULL,
  `buyer_rate` bigint unsigned NOT NULL,
  `market_rate` bigint unsigned DEFAULT NULL,
  `seller_rate` bigint unsigned DEFAULT NULL,
  `source_currency_id` bigint unsigned NOT NULL,
  `target_currency_id` bigint unsigned NOT NULL,
  `data_source` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`currency_rate_id`),
  KEY `source_currency_id` (`source_currency_id`,`target_currency_id`,`update_date`),
  KEY `source_currency_id_2` (`source_currency_id`,`target_currency_id`,`create_date`),
  KEY `target_currency_id` (`target_currency_id`,`update_date`),
  KEY `source_currency_id_3` (`source_currency_id`,`update_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `currency_rates` (
  `currency_rate_id` bigint unsigned NOT NULL,
  `rate` float NOT NULL,
  `source_currency_id` bigint unsigned NOT NULL,
  `target_currency_id` bigint unsigned NOT NULL,
  `data_source` varchar(20) DEFAULT NULL,
  `update_date` int unsigned DEFAULT '0',
  `create_date` int unsigned DEFAULT '0',
  `synthetic_market_rate` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`currency_rate_id`),
  KEY `target_currency_id` (`target_currency_id`),
  KEY `create_index` (`create_date`),
  KEY `update_index` (`update_date`),
  KEY `currencies_index_sorted` (`source_currency_id`,`target_currency_id`,`update_date` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_shops_help_hub_article_feedback` (
  `feedback_id` bigint unsigned NOT NULL,
  `article_id` bigint unsigned NOT NULL,
  `is_helpful` tinyint(1) NOT NULL DEFAULT '0',
  `comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`feedback_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `article_id` (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dai_post_invoice_items` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `origin_country_id` smallint unsigned NOT NULL DEFAULT '0',
  `destination_country_id` smallint unsigned NOT NULL DEFAULT '0',
  `mail_class` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'From Service field',
  `tracking_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'From Package ID field',
  `shop_id` bigint unsigned NOT NULL COMMENT 'From Customer Reference Number field',
  `shipping_label_id` bigint unsigned NOT NULL COMMENT 'From Customer Reference Number field',
  `weight` float(6,3) unsigned NOT NULL,
  `total_charge` int unsigned NOT NULL,
  `currency_code` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `manifest_date` int unsigned NOT NULL,
  `terminal` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_state` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `dai_post_invoice_items_create_date` (`create_date`),
  KEY `dai_post_invoice_items_update_date` (`update_date`),
  KEY `dai_post_invoice_items_shop_id_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `dai_post_invoice_items_manifest_date` (`manifest_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dai_post_invoices` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL COMMENT 'Date on file name',
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total` int NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'AUD',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `dai_post_invoices_invoice_date` (`invoice_date`),
  KEY `dai_post_invoices_create_date` (`create_date`),
  KEY `dai_post_invoices_update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `datalog` (
  `datalog_id` bigint unsigned NOT NULL DEFAULT '0',
  `body` longtext NOT NULL,
  `revisions` longtext NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`datalog_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_clustermapping` (
  `cluster_role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cluster_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`cluster_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_clusterstate` (
  `adhoc_cluster` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adhocs_enabled` tinyint unsigned NOT NULL DEFAULT '1',
  `message` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`adhoc_cluster`,`adhocs_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dawanda_consent_contacts` (
  `email_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_country_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dawanda_shop_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `etsy_shop_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consent_granted` int unsigned NOT NULL,
  `consent_revoked` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `language` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`email_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `disbursements_check_ins` (
  `id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `auth_username` varchar(255) DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `discount_campaign_configs` (
  `campaign_id` bigint unsigned NOT NULL,
  `audience_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promotion_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `promotion_amount` int NOT NULL,
  `promotion_mechanism` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration_days` int DEFAULT NULL,
  `start_time` int DEFAULT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `currency_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `regions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `audience_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `created_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `readable_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `minimum_spend_amount` int DEFAULT NULL,
  `maximum_discount_amount` int DEFAULT NULL,
  `maximum_use_count` int DEFAULT '1',
  `expiration_date` int DEFAULT NULL,
  `eligible_platform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'existing',
  `eligible_categories` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `discovery_themes_metadata` (
  `metadata_id` bigint unsigned NOT NULL,
  `slug` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_description` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_appearance` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`metadata_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dsa_statements_of_reason` (
  `decision_visibility` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_visibility_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_monetary` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_monetary_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_provision` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `account_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_facts` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_ground` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `decision_ground_reference_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `illegal_content_legal_ground` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `illegal_content_explanation` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `incompatible_content_ground` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `incompatible_content_explanation` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `incompatible_content_illegal` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_type_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `category` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `category_addition` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `category_specification` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `category_specification_other` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `territorial_scope` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_language` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_date` int unsigned NOT NULL DEFAULT '0',
  `application_date` int unsigned NOT NULL DEFAULT '0',
  `end_date_account_restriction` int unsigned NOT NULL DEFAULT '0',
  `end_date_monetary_restriction` int unsigned NOT NULL DEFAULT '0',
  `end_date_service_restriction` int unsigned NOT NULL DEFAULT '0',
  `end_date_visibility_restriction` int unsigned NOT NULL DEFAULT '0',
  `source_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `source_identity` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automated_detection` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automated_decision` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `puid` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_type` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_create_date` int unsigned NOT NULL,
  `uuid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `process_status` tinyint unsigned NOT NULL,
  `retry_count` tinyint unsigned NOT NULL,
  `run_date` int unsigned NOT NULL DEFAULT '0',
  `process_date` int unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`puid`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `efs_cc_logs` (
  `efs_cc_log_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'charge or auth',
  `create_date` int unsigned NOT NULL,
  `response_code` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result_code` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result_message` text COLLATE utf8mb4_unicode_ci,
  `efs_transaction_id` char(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avs_response_code` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cvv_response_code` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approval_number` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorization_number` char(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_time` char(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_number` char(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_number` char(19) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_amount` double DEFAULT NULL,
  PRIMARY KEY (`efs_cc_log_id`),
  KEY `efs_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_depot` (
  `email_depot_id` bigint unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `creation_time` int unsigned NOT NULL DEFAULT '0',
  `subject` text NOT NULL,
  `body` mediumtext NOT NULL,
  `headers` text NOT NULL,
  `inbound` tinyint unsigned NOT NULL DEFAULT '0',
  `mailbox` varchar(32) NOT NULL,
  `thread_id` bigint unsigned NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(16) NOT NULL DEFAULT '',
  `is_archived` tinyint unsigned NOT NULL DEFAULT '0',
  `is_slatered` tinyint(1) NOT NULL DEFAULT '0',
  `hash` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`email_depot_id`),
  KEY `email` (`email`),
  KEY `creation_time` (`creation_time`),
  KEY `task_id` (`task_id`),
  KEY `owner_id` (`owner_id`),
  KEY `user_id` (`user_id`),
  KEY `thread_id_idx` (`thread_id`),
  KEY `hash_idx` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Table that will hold consumed email messages';

CREATE TABLE `email_depot_attachment` (
  `email_depot_attachment_id` bigint NOT NULL AUTO_INCREMENT,
  `email_depot_id` bigint NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `content_type` varchar(255) NOT NULL DEFAULT '',
  `headers` text NOT NULL,
  `link_to_attachment` varchar(256) NOT NULL DEFAULT '',
  `link_to_export` varchar(256) NOT NULL DEFAULT '',
  `gdata_resource_id` varchar(128) NOT NULL DEFAULT '',
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`email_depot_attachment_id`),
  KEY `email_depot_id` (`email_depot_id`),
  KEY `email_depot_attachment_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Table that will hold attachments for the consumed messages';

CREATE TABLE `email_depot_kb_articles` (
  `email_depot_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT '',
  `kb_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `kb_article_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`email_depot_id`,`kb_article_id`,`status`),
  KEY `staff_id_index` (`staff_id`),
  KEY `kb_article_group_id_idx` (`kb_article_group_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `kb_article_id_idx` (`kb_article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_experiment_metrics` (
  `epoch` bigint unsigned NOT NULL,
  `hash` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `experiment_flag` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metric` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` bigint unsigned NOT NULL,
  PRIMARY KEY (`hash`),
  KEY `grouping` (`experiment_flag`(32),`variant`,`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_replies` (
  `email_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `input_email` longblob NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`email_id`),
  KEY `user_idx` (`user_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_material` (
  `emap_material_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `emap_report_id` bigint unsigned NOT NULL,
  `emap_property_group_id` bigint unsigned NOT NULL,
  `material_type` tinyint unsigned NOT NULL,
  `object_user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_material_id`),
  UNIQUE KEY `emap_report_id_object_id_idx` (`emap_report_id`,`object_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_notification` (
  `emap_notification_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_type` tinyint unsigned NOT NULL,
  `is_read` tinyint unsigned NOT NULL,
  `action_type` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_owner` (
  `emap_owner_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_owner_id`),
  UNIQUE KEY `user_id_name_idx` (`user_id`,`name`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_owner_loas` (
  `user_doc_check_file_upload_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`user_doc_check_file_upload_id`,`emap_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_property` (
  `emap_property_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_type` tinyint unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_property_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_property_details` (
  `emap_property_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `property_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `educational_sources` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `examples` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jurisdiction` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `classes` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail_type` tinyint unsigned NOT NULL DEFAULT '0',
  `legal_basis` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `year_first_used` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location_first_used` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_property_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_property_group` (
  `emap_property_group_id` bigint unsigned NOT NULL,
  `emap_report_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_property_group_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_property_group_properties` (
  `emap_property_group_id` bigint unsigned NOT NULL,
  `emap_property_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`emap_property_group_id`,`emap_property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_report` (
  `emap_report_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `emap_reporter_id` bigint unsigned NOT NULL,
  `parent_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_type` tinyint unsigned NOT NULL,
  `material_type` tinyint unsigned NOT NULL,
  `internal_ip_takedown_id` bigint unsigned NOT NULL,
  `ip_address` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `process_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_report_id`),
  UNIQUE KEY `user_id_name_idx` (`user_id`,`name`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_reporter` (
  `emap_reporter_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `is_primary` tinyint unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `organization` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `second_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` int unsigned NOT NULL,
  `email_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fax_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `reporter_type` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`emap_reporter_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_reporter_doc_uploads` (
  `user_doc_check_file_upload_id` bigint unsigned NOT NULL,
  `emap_reporter_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_doc_check_file_upload_id`,`emap_reporter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_requested_action` (
  `emap_requested_action_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_type` tinyint unsigned NOT NULL,
  `action_status` tinyint unsigned NOT NULL,
  `action_type` tinyint unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_requested_action_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emap_updates` (
  `emap_update_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_type` tinyint unsigned NOT NULL,
  `is_read` tinyint unsigned NOT NULL,
  `action_type` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`emap_update_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emcee_answer` (
  `question_id` bigint unsigned NOT NULL,
  `answer_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `answer_text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`question_id`,`answer_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emcee_meeting` (
  `meeting_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `meeting_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meeting_details` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `meeting_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meeting_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`meeting_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emcee_meeting_moderator` (
  `meeting_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`meeting_id`,`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emcee_question` (
  `question_id` bigint unsigned NOT NULL,
  `meeting_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `question_text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `meeting_id_idx` (`meeting_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `emcee_vote` (
  `question_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`question_id`,`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `etsy_ads_alert` (
  `alert_id` bigint unsigned NOT NULL,
  `admin_id` bigint NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '0',
  `alert_type` tinyint NOT NULL DEFAULT '0',
  `custom_message` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`alert_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `evri_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP',
  `invoice_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_invoice_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `evri_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'String as provided by EVRi',
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP',
  `parcel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Barcode, Tracking Code, Parcel ID',
  `invoice_trigger_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date in International file',
  `customer_reference_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_reference_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total_rate` int unsigned NOT NULL DEFAULT '0' COMMENT 'Rate (GBP) in International file',
  `dom_account_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_parent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_client` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_origin_of_parcel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_hermes_year_week` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_client_year_period` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `dom_weight_units` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `dom_destination_postcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_pshop_delivery_count` int unsigned NOT NULL DEFAULT '0',
  `dom_next_day_count` int unsigned NOT NULL DEFAULT '0',
  `dom_sunday_count` int unsigned NOT NULL DEFAULT '0',
  `dom_signature_count` int unsigned NOT NULL DEFAULT '0',
  `dom_household_signature_count` int unsigned NOT NULL DEFAULT '0',
  `dom_pin_count` int unsigned NOT NULL DEFAULT '0',
  `dom_volume` int unsigned NOT NULL DEFAULT '0',
  `dom_invoice_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_invoice_rate` int unsigned NOT NULL DEFAULT '0',
  `dom_surcharge_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dom_surcharge_rate` int unsigned NOT NULL DEFAULT '0',
  `intl_vat_rate` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_hub` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `intl_sub_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `intl_chargeable` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_declared` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_actual` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_volumetric` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_tariff` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `intl_version` smallint unsigned NOT NULL DEFAULT '0',
  `intl_service` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `intl_conditions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `intl_weight_break` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `intl_total_net` int unsigned NOT NULL DEFAULT '0',
  `intl_total_vat` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `shop_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `parcel_number` (`parcel_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `evri_invoice_revpro` (
  `invoice_id` bigint unsigned NOT NULL COMMENT 'invoice_id of the RevPro invoice file',
  `invoice_item_id` bigint unsigned NOT NULL COMMENT 'Unique ID for this RevPro entry',
  `original_invoice_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'invoice_id for the domestic or intl invoice item that this RevPro entry refers to',
  `original_invoice_item_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'invoice_item_id for the domestic or intl invoice item that this RevPro entry refers to',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `parcel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Header Parcel ID in CSV',
  `date_created` int unsigned NOT NULL DEFAULT '0',
  `service_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_paid_for` int unsigned NOT NULL DEFAULT '0',
  `service_rendered` int unsigned NOT NULL DEFAULT '0',
  `declared_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `actual_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `declared_length` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `declared_width` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `declared_height` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `actual_length` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `actual_width` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `actual_height` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `total_minus_toll` int NOT NULL DEFAULT '0',
  `revpro_week` tinyint unsigned NOT NULL DEFAULT '0',
  `revpro_admin` tinyint unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP' COMMENT 'Not an actual column, but this should facilitate auditing',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `original_invoice_id` (`original_invoice_id`,`original_invoice_item_id`),
  KEY `parcel_number` (`parcel_number`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `evri_invoice_undeliverable` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `original_invoice_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'invoice_id for the original dom/intl invoice item, if found',
  `original_invoice_item_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'invoice_item_id for the original dom/intl invoice item, if found',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Invoice Date column in CSV',
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP',
  `vat_rate` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `parcel_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Header Parcel ID in CSV',
  `hub` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_trigger_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date column in CSV',
  `undeliverable_date` int unsigned NOT NULL DEFAULT '0',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_reference_1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_reference_2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sub_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_ddp` tinyint unsigned NOT NULL DEFAULT '0',
  `description_of_goods` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `length` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `width` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `height` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `declared_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `actual_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `amount` int NOT NULL DEFAULT '0',
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_province_county` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `town_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `postal_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total_net` int NOT NULL DEFAULT '0',
  `total_vat` int NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `original_invoice_id` (`original_invoice_id`,`original_invoice_item_id`),
  KEY `parcel_number` (`parcel_number`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `explore_inspiration_feed` (
  `id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned DEFAULT NULL,
  `post_id` bigint unsigned DEFAULT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `video_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_url` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_id` (`shop_id`,`post_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `explore_marketing_module_content` (
  `marketing_module_content_id` bigint unsigned NOT NULL,
  `media_url` longtext COLLATE utf8mb4_unicode_ci,
  `media_type` tinyint unsigned NOT NULL COMMENT 'Type of media, such as video or image',
  `module_type` tinyint unsigned NOT NULL COMMENT 'Type of module, such as trends or challenges',
  `module_title` longtext COLLATE utf8mb4_unicode_ci,
  `module_subtitle` longtext COLLATE utf8mb4_unicode_ci,
  `button_text` longtext COLLATE utf8mb4_unicode_ci,
  `is_draft` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '0 = not_draft, 1 = draft. Only one module of each valid module_type should be live.',
  `has_seasonal_announcement` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0 = not seasonal, 1 = is seasonal. Will display a seasonal announcement for this module',
  `hashtag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `publish_date` int unsigned NOT NULL,
  `expire_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`marketing_module_content_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `publish_date` (`publish_date`),
  KEY `expire_date` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `explore_marketing_module_media` (
  `marketing_module_content_id` bigint unsigned NOT NULL,
  `boomerang_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fullscreen_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `media_type` tinyint unsigned NOT NULL COMMENT 'Type of media, such as video or image',
  `source_shop_id` bigint unsigned DEFAULT NULL,
  `post_id` bigint unsigned DEFAULT NULL,
  `is_etsy_created_content` tinyint unsigned NOT NULL DEFAULT '0',
  `priority` smallint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`marketing_module_content_id`,`priority`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `facebookads_account_daily_stats` (
  `date` int NOT NULL,
  `fb_account_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `spend` double NOT NULL,
  `reach` int unsigned NOT NULL,
  `unique_link_clicks` int unsigned NOT NULL,
  `link_clicks` int unsigned NOT NULL,
  `impressions` int unsigned NOT NULL,
  `cpm` double NOT NULL,
  `cost` double NOT NULL,
  `purchases` int unsigned NOT NULL,
  `cost_per_purchase` double NOT NULL,
  `purchases_conversion_value` double NOT NULL,
  `checkouts` int unsigned NOT NULL,
  `cost_per_checkout` double NOT NULL,
  `checkouts_conversion_value` double NOT NULL,
  `cost_per_website_action` double NOT NULL,
  `mobile_app_purchases` int unsigned NOT NULL,
  `cost_per_mobile_app_purchase` double NOT NULL,
  `mobile_app_purchases_conversion` double NOT NULL,
  `post_engagement` int unsigned NOT NULL,
  `post_likes` int unsigned NOT NULL,
  `post_shares` int unsigned NOT NULL,
  `post_comments` int unsigned NOT NULL,
  PRIMARY KEY (`fb_account_id`,`date`),
  KEY `update_date` (`update_date`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Pulled from the FB Marketing API.';

CREATE TABLE `fedex_invoice` (
  `invoice_id` bigint unsigned NOT NULL COMMENT 'Same as invoice_number column in invoice file',
  `invoice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Type column in invoice file',
  `invoice_file_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `settlement_option` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `master_edi_number` bigint unsigned NOT NULL,
  `total_invoice_charge` int NOT NULL,
  `total_invoice_transactions` int NOT NULL,
  `bill_to_account_number` bigint NOT NULL,
  `bill_to_country` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consolidated_account_number` bigint unsigned NOT NULL DEFAULT '0',
  `invoice_date` int unsigned NOT NULL,
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_remitting_date` int unsigned NOT NULL DEFAULT '0',
  `state_remitted_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_type`),
  KEY `state_idx` (`state`),
  KEY `invoice_date` (`invoice_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invoice_file_id` (`invoice_file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fedex_invoice_file` (
  `invoice_file_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL COMMENT 'Download date of invoice file',
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_file_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fedex_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL COMMENT 'Same as invoice_number in invoice file',
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'O' COMMENT 'Type column in invoice file',
  `invoice_file_id` bigint unsigned NOT NULL,
  `invoice_item_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `company_code` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_tracking_prefix` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tracking_number` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rebill_indicator` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `non_duplicate_tracking_number_indicator` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_date` int unsigned NOT NULL DEFAULT '0',
  `service_base` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_packaging` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_service_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `number_of_distribution_addresses` int unsigned NOT NULL DEFAULT '0',
  `tracking_number_message_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_1` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_2` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_3` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `store_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_po_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_department_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_invoice_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `returns_merchandise_authorization_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automation_device_number` int unsigned NOT NULL DEFAULT '0',
  `automation_device_name` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payor_type` tinyint unsigned NOT NULL DEFAULT '0',
  `net_charge` int NOT NULL DEFAULT '0',
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `charge_code_1` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `freight_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_2` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `volume_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_3` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `earned_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_4` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automation_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_5` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `performance_pricing_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_6` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fuel_surcharge_amount` int NOT NULL DEFAULT '0',
  `charge_code_7` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `residential_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_8` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_area_surcharge_amount` int NOT NULL DEFAULT '0',
  `charge_code_9` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `on_call_pickup_amount` int NOT NULL DEFAULT '0',
  `charge_code_10` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `declared_value_amount` int NOT NULL DEFAULT '0',
  `charge_code_11` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `signature_service_amount` int NOT NULL DEFAULT '0',
  `charge_code_12` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `saturday_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_13` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_handling_amount` int NOT NULL DEFAULT '0',
  `charge_code_14` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `address_correction_amount` int NOT NULL DEFAULT '0',
  `charge_code_15` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gst_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_16` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_duty_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_17` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duty_advancement_fee_charge` int NOT NULL DEFAULT '0',
  `charge_code_18` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_vat_amount` int NOT NULL DEFAULT '0',
  `charge_code_19` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_1_amount` int NOT NULL DEFAULT '0',
  `charge_code_20` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_2_amount` int NOT NULL DEFAULT '0',
  `charge_code_21` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_3_amount` int NOT NULL DEFAULT '0',
  `exchange_rate` float(18,9) NOT NULL DEFAULT '0.000000000',
  `origin_currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fuel_surcharge_factor` float(5,2) NOT NULL DEFAULT '0.00',
  `europe_first_surcharge_band` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_level_charge_count` smallint unsigned NOT NULL DEFAULT '0',
  `call_tag_access_code` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `declared_value` int unsigned NOT NULL DEFAULT '0',
  `customs_value` int unsigned NOT NULL DEFAULT '0',
  `customs_declared_value_currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customs_entry_number` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bundle_multiweight_id_number` int unsigned NOT NULL DEFAULT '0',
  `rate_scale` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `number_of_pieces` int unsigned NOT NULL DEFAULT '0',
  `billed_weight` float(6,1) NOT NULL DEFAULT '0.0',
  `original_weight` float(6,1) NOT NULL DEFAULT '0.0',
  `ground_multiweight_package_weight` float(6,2) NOT NULL DEFAULT '0.00',
  `weight_unit` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dim_length` int unsigned NOT NULL DEFAULT '0',
  `dim_width` int unsigned NOT NULL DEFAULT '0',
  `dim_height` int unsigned NOT NULL DEFAULT '0',
  `dim_unit` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dim_divisor` int unsigned NOT NULL DEFAULT '0',
  `ground_misc_description_1` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_misc_description_2` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_misc_description_3` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_name` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_company` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_dept` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_address_line_1` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_address_line_2` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_city` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_state_province` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_postal_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `us_region_origin_zip` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `region_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_name` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_company` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_address_line_1` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_address_line_2` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_city` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_state_province` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_postal_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_handling_code` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_date` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_final_disposition_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_exception_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_attempt_date` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_attempt_time` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_signature` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `us_delivery_schedule_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `cod_check_amount` int NOT NULL DEFAULT '0',
  `cod_cross_reference_tracking_number` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `past_due_indicator` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `past_due_invoice_number` bigint unsigned NOT NULL DEFAULT '0',
  `service_level_percentage` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `revenue_threshold_amount` int NOT NULL DEFAULT '0',
  `original_receipient_address_line_1` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_receipient_address_line_2` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_receipient_city` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_receipient_state_province` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_receipient_postal_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `eu_vat_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fedex_branch_registered_vat_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `cross_reference_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `international_ground_shipment_number` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `late_fee_original_invoice_number` bigint unsigned NOT NULL DEFAULT '0',
  `late_fee_original_invoice_date` int unsigned NOT NULL DEFAULT '0',
  `late_fee_original_invoice_amount` int unsigned NOT NULL DEFAULT '0',
  `late_fee_past_due_amount` int unsigned NOT NULL DEFAULT '0',
  `late_fee_rate` float(5,2) NOT NULL DEFAULT '0.00',
  `late_fee_date` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `id_parse_method` tinyint unsigned NOT NULL DEFAULT '0',
  `adjustment_issued` tinyint unsigned NOT NULL DEFAULT '0',
  `dispute_charge_reason` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dispute_charge_description` varchar(21) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_remitting_date` int unsigned NOT NULL DEFAULT '0',
  `state_remitted_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `state_disputed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_idx` (`state`),
  KEY `shop_id_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `tracking_number` (`tracking_number`),
  KEY `invoice_file_id` (`invoice_file_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invoice_id_type_state` (`invoice_id`,`invoice_type`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fedex_invoice_items` (
  `invoice_item_id` bigint unsigned NOT NULL,
  `invoice_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `invoice_number` int NOT NULL,
  `invoice_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `settlement_option` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ground_tracking_prefix` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tracking_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rebill_indicator` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `non_duplicate_tracking_number_indicator` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_base` smallint NOT NULL,
  `service_packaging` smallint NOT NULL,
  `ground_service_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `number_of_distribution_addresses` int NOT NULL DEFAULT '0',
  `tracking_number_message_code` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_1` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_2` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_3` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `store_number` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_po_number` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_department_number` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_invoice_number` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `returns_merchandise_authorization_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automation_device_number` int NOT NULL DEFAULT '0',
  `automation_device_name` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payor_type` tinyint(1) NOT NULL,
  `net_charge` int NOT NULL,
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `charge_code_1` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `freight_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_2` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `volume_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_3` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `earned_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_4` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `automation_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_5` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `performance_pricing_discount_amount` int NOT NULL DEFAULT '0',
  `charge_code_6` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fuel_surcharge_amount` int NOT NULL DEFAULT '0',
  `charge_code_7` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `residential_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_8` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_area_surcharge_amount` int NOT NULL DEFAULT '0',
  `charge_code_9` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `on_call_pickup_amount` int NOT NULL DEFAULT '0',
  `charge_code_10` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `declared_value_amount` int NOT NULL DEFAULT '0',
  `charge_code_11` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `signature_service_amount` int NOT NULL DEFAULT '0',
  `charge_code_12` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `saturday_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_13` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_handling_amount` int NOT NULL DEFAULT '0',
  `charge_code_14` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `address_correction_amount` int NOT NULL DEFAULT '0',
  `charge_code_15` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gst_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_16` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_duty_charge_amount` int NOT NULL DEFAULT '0',
  `charge_code_17` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duty_advancement_fee_charge` int NOT NULL DEFAULT '0',
  `charge_code_18` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_vat_amount` int NOT NULL DEFAULT '0',
  `charge_code_19` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_1_amount` int NOT NULL DEFAULT '0',
  `charge_code_20` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_2_amount` int NOT NULL DEFAULT '0',
  `charge_code_21` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `misc_charge_3_amount` int NOT NULL DEFAULT '0',
  `exchange_rate` float(9,5) NOT NULL DEFAULT '0.00000',
  `origin_currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fuel_surcharge_factor` int NOT NULL DEFAULT '0',
  `europe_first_surcharge_band` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customer_level_charge_count` int NOT NULL DEFAULT '0',
  `call_tag_access_code` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `declared_value` int NOT NULL DEFAULT '0',
  `customs_value` int NOT NULL DEFAULT '0',
  `customs_declared_value_currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `customs_entry_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bundle_multiweight_id_number` int NOT NULL DEFAULT '0',
  `rate_scale` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number_of_pieces` int NOT NULL,
  `billed_weight` float(6,1) NOT NULL DEFAULT '0.0',
  `original_weight` float(6,1) NOT NULL DEFAULT '0.0',
  `ground_multiweight_package_weight` float(6,2) NOT NULL DEFAULT '0.00',
  `weight_unit` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dim_length` int NOT NULL DEFAULT '0',
  `dim_width` int NOT NULL DEFAULT '0',
  `dim_height` int NOT NULL DEFAULT '0',
  `dim_unit` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dim_divisor` int NOT NULL DEFAULT '0',
  `ground_misc_description_1` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_misc_description_2` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ground_misc_description_3` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipper_company` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_dept` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_address_line_1` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipper_address_line_2` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_city` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipper_state_province` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipper_postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `us_region_origin_zip` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_country_code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_company` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_address_line_1` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_address_line_2` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `recipient_city` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_state_province` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient_country_code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_handling_code` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_time` int NOT NULL DEFAULT '0',
  `delivery_final_disposition_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `delivery_exception_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_attempt_time` int NOT NULL DEFAULT '0',
  `recipient_signature` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `us_delivery_schedule_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `cod_check_amount` int NOT NULL DEFAULT '0',
  `cod_cross_reference_tracking_number` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `past_due_indicator` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `past_due_invoice_number` int NOT NULL DEFAULT '0',
  `service_level_percentage` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `revenue_threshold_amount` int NOT NULL DEFAULT '0',
  `original_recipient_address_line_1` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_recipient_address_line_2` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_recipient_city` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_recipient_state_province` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_recipient_postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `eu_vat_number` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fedex_branch_registered_vat_number` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `cross_reference_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `international_ground_shipment_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `late_fee_original_invoice_number` int unsigned NOT NULL DEFAULT '0',
  `late_fee_original_invoice_date` int unsigned NOT NULL DEFAULT '0',
  `late_fee_original_invoice_amount` int unsigned NOT NULL DEFAULT '0',
  `late_fee_past_due_amount` int unsigned NOT NULL DEFAULT '0',
  `late_fee_rate` float(6,2) NOT NULL DEFAULT '0.00',
  `late_fee_date` int unsigned NOT NULL DEFAULT '0',
  `adjustment_issued` tinyint unsigned NOT NULL DEFAULT '0',
  `first_attempt_date` int unsigned NOT NULL,
  `ship_date` int unsigned NOT NULL,
  `delivery_date` int unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `line_item_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_remitted` tinyint unsigned NOT NULL DEFAULT '0',
  `can_be_remitted` tinyint unsigned NOT NULL DEFAULT '0',
  `is_disputed` tinyint unsigned NOT NULL DEFAULT '0',
  `dispute_charge_reason` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dispute_charge_description` varchar(21) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`invoice_item_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `invoice_number` (`invoice_number`),
  KEY `invoice_type` (`invoice_type`),
  KEY `shop_id` (`shop_id`),
  KEY `shipping_label_id` (`shipping_label_id`),
  KEY `tracking_number` (`tracking_number`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `line_item_type` (`line_item_type`),
  KEY `is_remitted` (`is_remitted`),
  KEY `is_deleted` (`invoice_item_id`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fedex_invoices` (
  `invoice_id` bigint unsigned NOT NULL,
  `master_edi_number` int NOT NULL,
  `total_invoice_charge` int NOT NULL DEFAULT '0',
  `total_invoice_transactions` int NOT NULL DEFAULT '0',
  `bill_to_account_number` int NOT NULL,
  `bill_to_country` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `consolidated_account_number` int NOT NULL DEFAULT '0',
  `invoice_date` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `is_remitted` tinyint(1) NOT NULL DEFAULT '0',
  `invoice_number` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`invoice_id`),
  KEY `invoice_date` (`invoice_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invoice_number` (`invoice_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fedex_tracking_code_map` (
  `tracking_code` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_code`),
  KEY `shop_id` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `flag` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `related_flag_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `reporter_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `target_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_id` bigint unsigned NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `ref_count` int unsigned NOT NULL DEFAULT '1',
  `is_auto_action` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `review_state` tinyint(1) NOT NULL DEFAULT '0',
  `review_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `control_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `control_id` bigint unsigned NOT NULL DEFAULT '0',
  `control_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`),
  KEY `flag_staff_id` (`staff_id`),
  KEY `flag_user_id_flag_type_id` (`user_id`,`flag_type_id`),
  KEY `task_id` (`task_id`),
  KEY `flag_related_flag_id` (`related_flag_id`),
  KEY `flag_type_id_and_review_state` (`flag_type_id`,`review_state`),
  KEY `reporter_user_id` (`reporter_user_id`),
  KEY `flag_control_type_id_revision` (`control_type`,`control_id`,`control_revision_id`),
  KEY `control_id_idx` (`control_id`),
  KEY `flag_target_type_target_id_control_revision` (`target_type`,`target_id`,`control_revision_id`),
  KEY `flag_type_create_date_task_idx` (`flag_type_id`,`create_date`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `flag_type` (
  `flag_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `risk_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `team_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `nova_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `internal_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `external_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zendesk_user_field_key` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Optional zendesk user field key that is synced to zendesk',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `roll_up_field` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_queue` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_skip_routing` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag to skip apollo routing filters',
  `apollo_closure_restriction_role_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If closing flags and tasks in apollo should be restricted to a role',
  `apollo_task_state` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_user_field` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reputation` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0',
  `delay_action` int unsigned NOT NULL DEFAULT '0',
  `days_pending` int unsigned NOT NULL DEFAULT '0' COMMENT 'If apollo task state pending, indicates number of days pending',
  `should_randomize_delay_action` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag for using a random timing range based on delay action time',
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `suppression_period` int unsigned NOT NULL DEFAULT '0',
  `roll_up_max_task_age` int unsigned NOT NULL DEFAULT '0',
  `check_admin` tinyint unsigned NOT NULL DEFAULT '0',
  `check_guest` tinyint unsigned NOT NULL DEFAULT '0',
  `check_internal` tinyint unsigned NOT NULL DEFAULT '0',
  `roll_up_allow_closed_task` tinyint unsigned NOT NULL DEFAULT '0',
  `is_public` tinyint unsigned NOT NULL DEFAULT '0',
  `is_user_submitted` tinyint unsigned NOT NULL DEFAULT '0',
  `is_disabled` tinyint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`flag_type_id`),
  UNIQUE KEY `mnemonic_idx` (`mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `flag_type_audit` (
  `flag_type_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `risk_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `team_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `nova_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `internal_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `external_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zendesk_user_field_key` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Optional zendesk user field key that is synced to zendesk',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `roll_up_field` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_queue` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_skip_routing` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag to skip apollo routing filters',
  `apollo_closure_restriction_role_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If closing flags and tasks in apollo should be restricted to a role',
  `apollo_task_state` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `apollo_user_field` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reputation` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0',
  `delay_action` int unsigned NOT NULL DEFAULT '0',
  `days_pending` int unsigned NOT NULL DEFAULT '0' COMMENT 'If apollo task state pending, indicates number of days pending',
  `should_randomize_delay_action` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag for using a random timing range based on delay action time',
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `suppression_period` int unsigned NOT NULL DEFAULT '0',
  `roll_up_max_task_age` int unsigned NOT NULL DEFAULT '0',
  `check_admin` tinyint unsigned NOT NULL DEFAULT '0',
  `check_guest` tinyint unsigned NOT NULL DEFAULT '0',
  `check_internal` tinyint unsigned NOT NULL DEFAULT '0',
  `roll_up_allow_closed_task` tinyint unsigned NOT NULL DEFAULT '0',
  `is_public` tinyint unsigned NOT NULL DEFAULT '0',
  `is_user_submitted` tinyint unsigned NOT NULL DEFAULT '0',
  `is_disabled` tinyint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`flag_type_id`,`flag_type_audit_id`),
  UNIQUE KEY `flag_type_audit_idx` (`flag_type_audit_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `flag_type_risk_tag` (
  `flag_type_risk_tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `risk_tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`flag_type_risk_tag_id`),
  UNIQUE KEY `flag_tag_idx` (`flag_type_id`,`risk_tag_id`),
  KEY `risk_tag_idx` (`risk_tag_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fm_admin_logs` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `flag_id` bigint unsigned NOT NULL DEFAULT '0',
  `action_id` bigint unsigned NOT NULL DEFAULT '0',
  `target_type` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `target_id` bigint unsigned NOT NULL DEFAULT '0',
  `reason_id` bigint unsigned NOT NULL DEFAULT '0',
  `attribute_ids` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `notes` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fm_admin_logs_action_id_idx` (`action_id`),
  KEY `fm_admin_logs_target_id_target_type_idx` (`target_id`,`target_type`),
  KEY `fm_admin_logs_create_date_idx` (`create_date`),
  KEY `fm_admin_logs_update_date_idx` (`update_date`),
  KEY `idx_fm_admin_logs_flag_id` (`flag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fm_staff` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `auth_username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fonoa_tax_id_verification_batch` (
  `batch_id` bigint unsigned NOT NULL COMMENT 'Generated key for a tax id verification batch',
  `batch_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Batch name',
  `batch_validation_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Batch validation id return by fonoa',
  `attempt_count` int NOT NULL DEFAULT '0' COMMENT 'no of submit attempts to fonoa',
  `batch_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the response',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`batch_id`),
  KEY `batch_validation_id_idx` (`batch_validation_id`),
  KEY `batch_status_idx` (`batch_status`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `forum_alerts` (
  `alert_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned DEFAULT NULL,
  `active` tinyint unsigned DEFAULT '1',
  `alert_data` text NOT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_extra_llm_context` (
  `gift_mode_extra_llm_context_id` bigint unsigned NOT NULL,
  `gift_mode_gift_idea_recs_id` bigint unsigned NOT NULL,
  `context_type` varchar(100) NOT NULL COMMENT 'gift idea name, persona title, or other indication of what kind of context this is',
  `context_value` text COMMENT 'The user-entered context',
  `context_order` int unsigned NOT NULL DEFAULT '0' COMMENT 'For repeated fields, an optional order',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`gift_mode_extra_llm_context_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_gift_idea_entity` (
  `gift_idea_id` bigint unsigned NOT NULL,
  `semaphore_uuid` varchar(100) NOT NULL COMMENT 'Retained because this is an existing table.',
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `slug` text,
  `state` varchar(100) NOT NULL DEFAULT '' COMMENT 'draft/published/deleted or some other future state',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy user id of the person who made the change. For use in the CMS UI',
  `staff_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy staff id of the person who made the change. For use in the CMS UI',
  `recs_context` text COMMENT 'A private title/description that may be more useful for recs, but be less suitable for buyer-facing use.',
  `primary_recs_key` varchar(100) NOT NULL DEFAULT '' COMMENT 'The recs_key that should be used when fetching user-facing recs for this gift idea',
  `search_queries` text COMMENT 'Search queries used to fetch recs for this idea',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`gift_idea_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `semaphore_uuid_idx` (`semaphore_uuid`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_gift_idea_recs` (
  `gift_mode_gift_idea_recs_id` bigint unsigned NOT NULL,
  `gift_idea_id` bigint unsigned NOT NULL,
  `other_id` bigint NOT NULL COMMENT 'id of the context object associated with this idea',
  `other_type` varchar(100) NOT NULL COMMENT 'persona, occasion, etc',
  `gift_idea_metadata_key` varchar(100) NOT NULL COMMENT 'An arbitrary key the recs pipeline will use to associate a gift idea with a set of recs metadata',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy user id of the person who made the change. For use in the CMS UI',
  `staff_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy staff id of the person who made the change. For use in the CMS UI',
  `state` varchar(100) NOT NULL DEFAULT '' COMMENT 'draft/published/deleted or some other future state. This is a placeholder for some way to indicate to recs pipeline that we''ll no longer need recs/metadata for this recs_key',
  `other_name` text COMMENT 'The internal name of the Gift Idea context object (i.e. persona or occasion) at the time of submission',
  `gift_idea_name` text COMMENT 'The internal name of the Gift Idea object at the time of submission',
  `full_idea_prompt` text COMMENT 'The full LLM prompt for metadata',
  `search_queries` text COMMENT 'Search queries used to fetch recs for this recs version',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`gift_mode_gift_idea_recs_id`),
  UNIQUE KEY `gift_idea_id` (`gift_idea_id`,`gift_idea_metadata_key`),
  KEY `user_id_idx` (`user_id`),
  KEY `state_idx` (`state`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_gift_idea_relation` (
  `gift_idea_id` bigint unsigned NOT NULL,
  `other_id` bigint NOT NULL COMMENT 'id of the context object associated with this idea',
  `other_type` varchar(100) NOT NULL COMMENT 'persona, occasion, etc',
  `manual_order` int NOT NULL DEFAULT '0' COMMENT 'A way to order gift ideas on the persona/occasion page',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`gift_idea_id`,`other_id`),
  KEY `unique_order_idx` (`other_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_occasion_dates` (
  `occasion_date_id` bigint unsigned NOT NULL,
  `occasion_id` bigint unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL COMMENT 'same as start_date if it is a single day occasion',
  `iso_region` char(2) DEFAULT NULL COMMENT 'when region is null, it means date is the global default',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`occasion_date_id`),
  UNIQUE KEY `occasion_date_region_idx` (`occasion_id`,`start_date`,`iso_region`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_occasion_entity` (
  `occasion_id` bigint unsigned NOT NULL,
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `slug` text,
  `state` varchar(100) NOT NULL DEFAULT '' COMMENT 'draft/published/deleted or some other future state',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy user id of the person who made the change. For use in the CMS UI',
  `staff_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy staff id of the person who made the change. For use in the CMS UI',
  `recs_context` text COMMENT 'A private title/description that may be more useful for recs, but be less suitable for buyer-facing use.',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `date_type` varchar(100) NOT NULL DEFAULT 'none' COMMENT 'fixed(ex: Christmas), custom (ex: birthday), window (ex: Springtime or Graduation), or none (ex: Just Because)',
  `is_recurring` tinyint NOT NULL DEFAULT '0' COMMENT 'Denotes whether this occasion recurs each year',
  PRIMARY KEY (`occasion_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_persona_entity` (
  `persona_entity_id` bigint unsigned NOT NULL,
  `semaphore_uuid` varchar(100) NOT NULL,
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `slug` text,
  `state` varchar(100) NOT NULL DEFAULT '' COMMENT 'draft/published/deleted or some other future state',
  `staff_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy staff id of the person who made the change. For use in the CMS UI',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy user id of the person who made the change. For use in the CMS UI',
  `recs_context` text COMMENT 'A private title/description that may be more useful for recs, but be less suitable for buyer-facing use.',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`persona_entity_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `semaphore_uuid_idx` (`semaphore_uuid`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_persona_relation` (
  `persona_relation_id` bigint unsigned NOT NULL,
  `persona_id` bigint unsigned NOT NULL,
  `other_id` bigint NOT NULL COMMENT 'id of the context object associated with this persona',
  `other_type` varchar(100) NOT NULL COMMENT 'recipient_group, persona, occasion, etc',
  `other_name` text COMMENT 'The internal name of the Gift Idea context object (i.e. recipient_group, persona or occasion) at the time of submission',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`persona_relation_id`),
  KEY `order_idx` (`other_id`),
  KEY `persona_idx` (`persona_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_quiz_answer_entity` (
  `quiz_answer_entity_id` bigint unsigned NOT NULL,
  `semaphore_uuid` varchar(100) NOT NULL,
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `slug` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`quiz_answer_entity_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `semaphore_uuid_idx` (`semaphore_uuid`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_quiz_question_entity` (
  `quiz_question_entity_id` bigint unsigned NOT NULL,
  `semaphore_uuid` varchar(100) NOT NULL,
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `slug` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`quiz_question_entity_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `semaphore_uuid_idx` (`semaphore_uuid`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gift_mode_recipient_group_entity` (
  `recipient_group_id` bigint unsigned NOT NULL,
  `contentful_content_id` bigint unsigned DEFAULT NULL,
  `recipient_group_name` text,
  `state` varchar(100) NOT NULL DEFAULT '' COMMENT 'draft/published/deleted or some other future state',
  `staff_id` bigint NOT NULL DEFAULT '0' COMMENT 'Set to the etsy staff id of the person who made the change. For use in the CMS UI',
  `slug` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`recipient_group_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `contentful_content_id_idx` (`contentful_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `giftcard_campaigns` (
  `campaign_id` bigint unsigned NOT NULL,
  `type` varchar(10) NOT NULL,
  `status` varchar(10) NOT NULL,
  `num_cards` int unsigned NOT NULL,
  `total_value` int unsigned NOT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'en-US',
  `exp_month` varchar(2) DEFAULT NULL,
  `exp_year` varchar(4) DEFAULT NULL,
  `creator_user_id` bigint unsigned DEFAULT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `approval_user_id` bigint unsigned DEFAULT NULL,
  `approver_staff_id` bigint unsigned DEFAULT NULL,
  `approval_reason` text,
  `title` varchar(255) NOT NULL,
  `description` text,
  `sender_name` varchar(255) DEFAULT NULL,
  `recipient_name` varchar(255) DEFAULT NULL,
  `message` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `claimable_after_date` int unsigned NOT NULL DEFAULT '0',
  `approve_date` int unsigned DEFAULT NULL,
  `denominations` mediumtext NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `create_date` (`create_date`),
  KEY `creator_user_id` (`creator_user_id`,`create_date`),
  KEY `creator_staff_id` (`creator_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `globegistics_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int unsigned NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `globegistics_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `tracking_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'charge',
  `service_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `facility_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` decimal(9,4) NOT NULL,
  `weight_units` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LB',
  `piece_charge` int unsigned NOT NULL,
  `weight_charge` int unsigned NOT NULL,
  `total_charge` int unsigned NOT NULL,
  `expected_charge` int unsigned NOT NULL DEFAULT '0',
  `delta` int NOT NULL DEFAULT '0',
  `scan_date` int unsigned NOT NULL DEFAULT '0',
  `ship_to_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ship_to_first_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to_second_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to_city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to_state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to_zip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to_country_id` int unsigned NOT NULL,
  `customer_tracking_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `anomaly_reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_label_id` (`shop_id`,`shipping_label_id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `globegistics_manifest` (
  `globegistics_manifest_id` bigint unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `s3_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_created_date` int unsigned NOT NULL DEFAULT '0',
  `state_ready_date` int unsigned NOT NULL DEFAULT '0',
  `state_uploading_date` int unsigned NOT NULL DEFAULT '0',
  `state_uploaded_date` int unsigned NOT NULL DEFAULT '0',
  `state_error_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`globegistics_manifest_id`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `google_auth_tokens` (
  `token_id` bigint unsigned NOT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `auth_token` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `api_version` tinyint unsigned NOT NULL DEFAULT '1',
  `market` varchar(8) NOT NULL DEFAULT 'enus',
  PRIMARY KEY (`token_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `google_id` (`google_id`,`api_version`,`token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table for GoogleLogin tokens';

CREATE TABLE `gsb_add` (
  `list_id` int NOT NULL,
  `add_chunk_num` int NOT NULL,
  `host_key` char(8) NOT NULL,
  `prefix` varchar(64) NOT NULL,
  PRIMARY KEY (`list_id`,`add_chunk_num`,`host_key`,`prefix`),
  KEY `add_host_key` (`host_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='add_chunks';

CREATE TABLE `gsb_fullhash` (
  `list_id` int NOT NULL,
  `add_chunk_num` int NOT NULL,
  `fullhash` char(64) NOT NULL,
  `create_ts` int unsigned NOT NULL,
  PRIMARY KEY (`list_id`,`add_chunk_num`,`fullhash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='full hashes';

CREATE TABLE `gsb_rfd` (
  `id` int NOT NULL,
  `next_attempt` int unsigned NOT NULL,
  `error_count` int unsigned NOT NULL,
  `last_attempt` int unsigned NOT NULL,
  `last_success` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='application state, single row';

CREATE TABLE `gsb_sub` (
  `list_id` int NOT NULL,
  `add_chunk_num` int NOT NULL,
  `sub_chunk_num` int NOT NULL,
  `host_key` char(8) NOT NULL,
  `prefix` varchar(64) NOT NULL,
  PRIMARY KEY (`list_id`,`add_chunk_num`,`host_key`,`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='sub_chunks';

CREATE TABLE `hacker_grants_outbound_emails` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `sender_name` varchar(50) DEFAULT NULL,
  `sender_email` varchar(50) DEFAULT NULL,
  `recipient_name` varchar(50) DEFAULT NULL,
  `recipient_email` varchar(50) DEFAULT NULL,
  `body` text,
  `is_public` tinyint DEFAULT NULL,
  `will_mentor` tinyint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `hdfs_importer_run` (
  `hdfs_path` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `importer_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `num_hdfs_tuples` bigint DEFAULT NULL,
  `num_db_rows` bigint DEFAULT NULL,
  `jobs_enqueued` int NOT NULL DEFAULT '0',
  `jobs_succeeded` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`hdfs_path`,`model_name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Runs of hdfs to shards data importer';

CREATE TABLE `htsg_csv_file_report` (
  `customer_id` bigint unsigned NOT NULL,
  `project_id` bigint unsigned NOT NULL,
  `job_id` bigint unsigned NOT NULL,
  `translator_id` bigint unsigned NOT NULL,
  `report_date` int unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `report_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_words` int NOT NULL,
  `payable_words` int NOT NULL,
  `words_saved` int NOT NULL,
  `cost` int NOT NULL,
  `currency` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_creation_date` int unsigned NOT NULL,
  `internal_due_date` int unsigned NOT NULL,
  `requestor_due_date` int unsigned NOT NULL,
  `requestor_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`customer_id`,`project_id`,`job_id`,`translator_id`,`report_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `htsg_file_language_metrics` (
  `job_id` bigint unsigned NOT NULL,
  `project_id` bigint unsigned NOT NULL,
  `filename` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_word_count` int unsigned NOT NULL,
  `word_to_be_done_count` int unsigned NOT NULL,
  `in_context_exact_match` int unsigned NOT NULL,
  `leveraged_match_100` int unsigned NOT NULL,
  `leveraged_match_99_to_75` int unsigned NOT NULL,
  `fuzzy_match_74_to_0` int unsigned NOT NULL,
  `non_translatable_words` int unsigned NOT NULL,
  `repetitions` int unsigned NOT NULL,
  `fuzzy_repetitions` int NOT NULL DEFAULT '0',
  `translator_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_translate_status` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`job_id`),
  KEY `project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `htsg_general_project_info` (
  `project_id` bigint unsigned NOT NULL,
  `project_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `customer_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `translation_project_manager` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_description` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `project_creation_date` int unsigned NOT NULL,
  `internal_due_date` int unsigned NOT NULL,
  `requestor_due_date` int unsigned NOT NULL,
  `requestor_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`project_id`),
  KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `htsg_operations_log` (
  `id` bigint unsigned NOT NULL,
  `namespace` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `txnid` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_op_txn` (`namespace`,`name`,`operation`,`txnid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `htsg_production_report` (
  `customer_id` int unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `total_words` int unsigned NOT NULL,
  `ice_match_words` int unsigned NOT NULL,
  `leveraged_words` int unsigned NOT NULL,
  `fuzzy_match_words` int unsigned NOT NULL,
  `repetition_words` int unsigned NOT NULL,
  `fuzzy_repetition_words` int unsigned NOT NULL,
  `non_translatable_words` int unsigned NOT NULL,
  `no_match_words` int unsigned NOT NULL,
  `rollup_type` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`customer_id`,`language`,`start_date`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `htsg_translation_metrics_snapshot` (
  `project_id` int unsigned NOT NULL,
  `project_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int unsigned NOT NULL,
  `customer_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_files` int NOT NULL DEFAULT '0',
  `words_total` int unsigned NOT NULL,
  `words_to_be_done` int unsigned NOT NULL,
  `data_fetch_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`project_id`,`language`),
  KEY `customer_idx` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `human_tasks_candidates` (
  `user_id` bigint unsigned NOT NULL,
  `state` int NOT NULL,
  `seller_type` int NOT NULL,
  `buyer_type` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `create_date_state` (`create_date`,`state`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `identity_name_change_requests` (
  `identity_name_change_request_id` bigint unsigned NOT NULL COMMENT 'Name change request identifier',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Shop identifier that this name change request belongs to',
  `previous_shop_identity_id` bigint unsigned DEFAULT NULL COMMENT 'previous shop identity identifier',
  `shop_identity_id` bigint unsigned NOT NULL COMMENT 'Shop identity identifier',
  `request_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the name change request',
  `reason_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Reason for the name change',
  `previous_year` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'Previous year to update name info',
  `create_date` int NOT NULL DEFAULT '0' COMMENT 'record creation date in epoch time',
  `update_date` int NOT NULL DEFAULT '0' COMMENT 'date record last updated in epoch time',
  PRIMARY KEY (`identity_name_change_request_id`),
  KEY `shop_idx` (`shop_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `identity_verification_events` (
  `identity_verification_event_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of a identity verification event',
  `shop_id` bigint unsigned DEFAULT NULL COMMENT 'Shop identifier that the identitiy verification event belongs to',
  `event_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Event id used by vendor',
  `inquiry_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Inquiry id used by vendor',
  `template_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Template id used by vendor',
  `vendor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'persona' COMMENT 'Vendor providing the verification event',
  `event_status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the event',
  `failure_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Reason for verification failure',
  `event_creation_date` int unsigned DEFAULT NULL COMMENT 'Event creation date',
  `verification_start_date` int unsigned DEFAULT NULL COMMENT 'Verification start date',
  `id_upload_date` int unsigned DEFAULT NULL COMMENT 'id upload date',
  `selfie_upload_date` int unsigned DEFAULT NULL COMMENT 'selfie upload date',
  `verification_end_date` int unsigned DEFAULT NULL COMMENT 'Verification end date',
  `device_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Device type',
  `event_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  `identity_verification_request_id` bigint unsigned DEFAULT NULL COMMENT 'Identify verification request associated to this transaction',
  PRIMARY KEY (`identity_verification_event_id`),
  KEY `event_id` (`event_id`),
  KEY `inquiry_id` (`inquiry_id`),
  KEY `shop_id` (`shop_id`),
  KEY `event_status` (`event_status`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `identity_verification_request_id` (`identity_verification_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `identity_verification_requests` (
  `identity_verification_request_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of a identity verification request',
  `correlation_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Identifier to group related verification requests together',
  `vendor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor providing the verification request',
  `method` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Method used for the verification request',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the request',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`identity_verification_request_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `correlation_id_idx` (`correlation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `identity_verification_responses` (
  `identity_verification_response_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of a identity verification response',
  `vendor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vendor providing the verification response',
  `vendor_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Response ID from the vendor',
  `request_id` bigint unsigned NOT NULL COMMENT 'ID of the Request the response belongs to from identity_verification_requests',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the response',
  `http_code` int DEFAULT NULL COMMENT 'Response code from the Vendor',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`identity_verification_response_id`),
  KEY `request_id` (`request_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `identity_verification_transactions` (
  `identity_verification_transaction_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of a identity verification transaction',
  `shop_id` bigint unsigned DEFAULT NULL COMMENT 'Shop identifier that the identitiy verification belongs to',
  `shop_payment_id` bigint unsigned DEFAULT NULL COMMENT 'Shop Payment identifier associated to this transaction',
  `vendor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'trulioo' COMMENT 'Vendor providing the verification request',
  `transaction_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Transaction ID used by the vendor',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'initialized' COMMENT 'Status of the transaction',
  `response_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Response identifier',
  `rejection_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Reason for rejecting the verification',
  `callback` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Callback function name',
  `callback_payload` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Serialized data for callback',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  `correlation_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tracing identifier',
  `identity_verification_request_id` bigint unsigned DEFAULT NULL COMMENT 'identify verification request associated to this transaction',
  PRIMARY KEY (`identity_verification_transaction_id`),
  KEY `transaction_id` (`transaction_id`),
  KEY `shop_id` (`shop_id`),
  KEY `status` (`status`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `identity_verification_request_id` (`identity_verification_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `image_detection_results` (
  `result_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `image_id` bigint unsigned NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'label requested for detection',
  `score` float NOT NULL COMMENT 'detection confidence score',
  `detected` tinyint(1) NOT NULL COMMENT 'boolean for whether the label was detected or not',
  `phash` bigint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`result_id`),
  UNIQUE KEY `image_id` (`image_id`,`label`),
  KEY `user_id` (`user_id`),
  KEY `phash` (`phash`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `image_fingerprint` (
  `image_id` bigint unsigned NOT NULL DEFAULT '0',
  `type_id` smallint NOT NULL DEFAULT '0',
  `listing_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `phash` bigint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`image_id`,`type_id`,`create_date`),
  KEY `image_fingerprint_phash_idx` (`phash`),
  KEY `image_fingerprint_create_date_idx` (`create_date`),
  KEY `image_fingerprint_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `image_recognition_domains` (
  `image_recognition_domain_id` bigint unsigned NOT NULL,
  `image_recognition_audit_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_shard.image_recognition_audit.image_recognition_audit_id',
  `hostname` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'www.example.co.uk, see: www.php.net/manual/en/function.parse-url.php',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`image_recognition_domain_id`),
  UNIQUE KEY `hostname_idx` (`hostname`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `image_recognition_labels` (
  `image_recognition_label_id` bigint unsigned NOT NULL,
  `image_recognition_audit_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_shard.image_recognition_audit.image_recognition_audit_id',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mid` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Machine-generated identifier (MID) corresponding to the entity Google Knowledge Graph entry',
  `is_image` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Flag to show if the label is used in image recognition',
  `is_video` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag to show if the label is used in video recognition',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`image_recognition_label_id`),
  UNIQUE KEY `name_mid_idx` (`name`,`mid`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `image_recognition_logos` (
  `image_recognition_logo_id` bigint unsigned NOT NULL,
  `image_recognition_audit_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_shard.image_recognition_audit.image_recognition_audit_id',
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mid` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Machine-generated identifier (MID) corresponding to the entity Google Knowledge Graph entry',
  `is_image` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Flag to show if the logo is used in image recognition',
  `is_video` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Flag to show if the logo is used in video recognition',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`image_recognition_logo_id`),
  UNIQUE KEY `name_mid_idx` (`name`,`mid`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `infringement_contacts` (
  `contact_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(20) NOT NULL DEFAULT '',
  `fax` varchar(20) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `additional_info` text,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postalcode` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`contact_id`),
  KEY `owner_id_idx` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `infringement_messages` (
  `message_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `text` text NOT NULL,
  `admin_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_note` text,
  `type` varchar(50) NOT NULL DEFAULT '',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `owner_id_idx` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `infringement_owner_note` (
  `owner_note_id` bigint unsigned NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  `note` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`owner_note_id`),
  KEY `owner_id` (`owner_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `infringement_owners` (
  `owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `infringement_takedowns` (
  `takedown_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `message_id` bigint unsigned NOT NULL DEFAULT '0',
  `listing_ids` text NOT NULL,
  `received_date` int unsigned NOT NULL DEFAULT '0',
  `received_medium` varchar(20) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(20) NOT NULL DEFAULT '',
  `emailed_offender_ids` text NOT NULL,
  `reported_material` mediumtext,
  `description_fields` mediumtext,
  `type` int DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  `contact_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`takedown_id`),
  KEY `owner_id_idx` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_question_levels` (
  `question_id` bigint unsigned NOT NULL,
  `level` tinyint unsigned NOT NULL,
  PRIMARY KEY (`question_id`,`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_question_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `question_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tag_id`,`question_id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_question_type` (
  `question_id` bigint unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_questions` (
  `question_id` bigint unsigned NOT NULL,
  `title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `eval_criteria` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `about` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `is_remote_friendly` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`question_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_staff_owners` (
  `question_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`question_id`,`staff_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `interview_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_contact` (
  `contact_id` bigint unsigned NOT NULL,
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `emap_reporter_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `organization` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8 NOT NULL,
  `first_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `second_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` int NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fax_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `ip_address` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`contact_id`,`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `email_idx` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_counter_user` (
  `counter_user_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` int NOT NULL,
  `first_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `second_line` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`counter_user_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_countered_material` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `counter_id` bigint unsigned NOT NULL,
  `material_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`,`counter_id`,`material_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_dmca_counter` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `counter_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `counter_user_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `processed_date` int unsigned NOT NULL,
  `eligible_for_unsuppression_date` int unsigned NOT NULL,
  `unsuppressed_date` int unsigned NOT NULL,
  `court_order_received_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`,`counter_id`),
  KEY `status_idx` (`status`),
  KEY `task_id_idx` (`task_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_image` (
  `takedown_id` bigint unsigned NOT NULL,
  `material_id` bigint unsigned NOT NULL,
  `image_id` bigint unsigned NOT NULL,
  `image_key` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cache_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`material_id`,`image_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_material` (
  `takedown_id` bigint unsigned NOT NULL,
  `material_id` bigint unsigned NOT NULL,
  `emap_report_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property came from the Portal, this is the corresponding emap_report_id',
  `emap_material_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property came from the Portal, this is the corresponding emap_material_id',
  `property_id` bigint unsigned NOT NULL,
  `property_revision_id` bigint unsigned NOT NULL,
  `emap_property_group_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property came from the Portal, this is the corresponding emap_property_group_id',
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `material_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_id_source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_object_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `takedown_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `counter_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `reply_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`,`material_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `takedown_id_user_id_idx` (`takedown_id`,`user_id`),
  KEY `user_id_material_type_object_id_idx` (`user_id`,`material_type`,`object_id`),
  KEY `counter_task_id_idx` (`counter_task_id`),
  KEY `emap_material_id_idx` (`emap_material_id`),
  KEY `propertyid_propertyrevisionid` (`property_id`,`property_revision_id`),
  KEY `user_create_date_status_idx` (`user_id`,`create_date`,`status`),
  KEY `emap_report_id_status_idx` (`emap_report_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_owner` (
  `owner_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `owner_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`owner_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_owner_contact` (
  `owner_id` bigint unsigned NOT NULL,
  `contact_id` bigint unsigned NOT NULL,
  `contact_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner_id`,`contact_id`,`contact_revision_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_owner_property` (
  `owner_id` bigint unsigned NOT NULL,
  `property_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner_id`,`property_revision_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_property` (
  `property_id` bigint unsigned NOT NULL,
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jurisdiction` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `property_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emap_property_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property came from the Portal, this is the corresponding emap_property_id',
  `is_group_parent` tinyint NOT NULL DEFAULT '0' COMMENT 'boolean indicating if property is the parent with children properties',
  `group_parent_property_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property is a child, this is the property_id of parent ip_property record',
  `emap_property_group_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If property came from the Portal, this is the corresponding emap_property_group_id',
  `emap_property_detail_type` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `property_identifier_idx` (`property_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown` (
  `takedown_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `support_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_owner_id',
  `contact_id` bigint unsigned NOT NULL,
  `contact_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `emap_report_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_report_id',
  `emap_reporter_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_reporter_id',
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `material_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `ip_address` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`takedown_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `status_idx` (`status`),
  KEY `user_id_idx` (`user_id`),
  KEY `contact_contact_revision_idx` (`contact_id`,`contact_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown_action` (
  `takedown_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `action_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `material_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`batch_id`,`action_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown_audit` (
  `takedown_id` bigint unsigned NOT NULL,
  `takedown_audit_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  `emap_owner_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_owner_id',
  `contact_id` bigint unsigned NOT NULL,
  `contact_revision_id` bigint unsigned NOT NULL,
  `emap_report_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_report_id',
  `emap_reporter_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'If takedown came from the Portal, this is the corresponding emap_reporter_id',
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `material_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `support_task_id` bigint unsigned NOT NULL,
  `processed_date` int unsigned NOT NULL,
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`takedown_audit_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown_batch` (
  `takedown_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `counter_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gearman_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `retry_count` smallint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`batch_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `gearman_status_idx` (`gearman_status`),
  KEY `takedown_id_type_batch_status_idx` (`takedown_id`,`type`,`batch_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown_property` (
  `takedown_id` bigint unsigned NOT NULL,
  `property_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`,`property_revision_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_help_request` (
  `iris_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailbox` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `email` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `status_idx` (`status`),
  KEY `job_status_idx` (`job_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_help_request_attachment` (
  `iris_id` bigint unsigned NOT NULL,
  `attachment_id` bigint unsigned NOT NULL,
  `content_type` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int unsigned NOT NULL,
  `s3_path` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`,`attachment_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_help_request_data` (
  `iris_id` bigint unsigned NOT NULL,
  `field` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`,`field`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_article_revisions` (
  `kb_article_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `kb_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `site` varchar(64) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT 'draft',
  `article` longtext NOT NULL,
  `admin_id` bigint NOT NULL DEFAULT '0',
  `update_admin_id` bigint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`kb_article_revision_id`),
  KEY `kb_article_id_idx` (`kb_article_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `admin_id_idx` (`admin_id`),
  KEY `site_idx` (`site`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_articles` (
  `kb_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `kb_article_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `current_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `current_revision_status` varchar(32) NOT NULL DEFAULT '',
  `language_code` varchar(6) NOT NULL DEFAULT 'en-us',
  `title` varchar(512) NOT NULL DEFAULT '',
  `title2` varchar(512) NOT NULL DEFAULT '',
  `media_type` varchar(100) NOT NULL DEFAULT 'private',
  `topic_id` bigint unsigned NOT NULL DEFAULT '0',
  `related_terms` varchar(64) NOT NULL DEFAULT '',
  `clicks` int unsigned NOT NULL DEFAULT '0',
  `featured` int unsigned NOT NULL DEFAULT '0',
  `shortcut` varchar(100) NOT NULL DEFAULT '',
  `site` varchar(64) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `community_translation` bigint NOT NULL DEFAULT '0',
  `for_buyers` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`kb_article_id`),
  KEY `topic_id_idx` (`topic_id`),
  KEY `kb_article_group_id_language_type_idx` (`kb_article_group_id`,`language_code`,`media_type`),
  KEY `clicks_language_topic_id_idx` (`clicks`,`language_code`,`topic_id`),
  KEY `shortcut_idx` (`shortcut`),
  KEY `site_idx` (`site`),
  KEY `language_type_topic_id_status_idx` (`language_code`,`media_type`,`topic_id`,`current_revision_status`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_articles_frequently_used` (
  `mailbox` varchar(32) NOT NULL DEFAULT '',
  `parent_mailbox` varchar(32) NOT NULL DEFAULT '',
  `kb_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mailbox`,`kb_article_id`),
  KEY `parent_mailbox_id` (`parent_mailbox`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_images` (
  `kb_image_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `storage_volume` smallint NOT NULL DEFAULT '0',
  `secret` varchar(20) NOT NULL DEFAULT '',
  `version` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`kb_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_links` (
  `key` varchar(64) NOT NULL DEFAULT '',
  `url_raw` varchar(512) NOT NULL DEFAULT '',
  `url_short` varchar(512) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_topics` (
  `kb_topic_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `weight` int unsigned NOT NULL DEFAULT '0',
  `site` varchar(64) NOT NULL DEFAULT '',
  `shortcut` varchar(100) NOT NULL DEFAULT '',
  `mailbox` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`kb_topic_id`),
  KEY `site_weight_idx` (`site`,`weight`),
  KEY `shortcut_idx` (`shortcut`),
  KEY `mailbox_idx` (`mailbox`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `laso_cron_runs` (
  `run_id` bigint unsigned NOT NULL,
  `parent_prefix` int unsigned NOT NULL,
  `model_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `is_dry_run` tinyint(1) NOT NULL DEFAULT '1',
  `columns_csv` text COLLATE utf8mb4_general_ci,
  `run_day` tinyint unsigned NOT NULL DEFAULT '0',
  `run_month` tinyint unsigned NOT NULL,
  `run_year` smallint unsigned NOT NULL,
  `end_day` tinyint unsigned NOT NULL DEFAULT '0',
  `end_month` tinyint unsigned NOT NULL DEFAULT '0',
  `end_year` smallint unsigned NOT NULL DEFAULT '0',
  `state` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `model_time` (`model_name`,`run_year`,`run_month`,`parent_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `laso_progress` (
  `run_id` bigint unsigned NOT NULL,
  `parent_prefix` int unsigned NOT NULL,
  `model_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_dry_run` tinyint(1) NOT NULL DEFAULT '1',
  `columns_csv` longtext COLLATE utf8mb4_unicode_ci,
  `run_day` tinyint unsigned NOT NULL DEFAULT '0',
  `run_month` tinyint unsigned NOT NULL,
  `run_year` smallint unsigned NOT NULL,
  `end_day` tinyint unsigned NOT NULL DEFAULT '0',
  `end_month` tinyint unsigned NOT NULL DEFAULT '0',
  `end_year` smallint unsigned NOT NULL DEFAULT '0',
  `state` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `model_time` (`model_name`,`run_year`,`run_month`,`parent_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `laso_step` (
  `step_id` bigint unsigned NOT NULL,
  `process_id` bigint unsigned NOT NULL,
  `run_id` bigint unsigned NOT NULL,
  `model_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `columns_csv` longtext COLLATE utf8mb4_unicode_ci,
  `run_day` tinyint unsigned NOT NULL DEFAULT '0',
  `run_month` tinyint unsigned NOT NULL,
  `run_year` smallint unsigned NOT NULL,
  `end_day` tinyint unsigned NOT NULL DEFAULT '0',
  `end_month` tinyint unsigned NOT NULL DEFAULT '0',
  `end_year` smallint unsigned NOT NULL DEFAULT '0',
  `state` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `used_bigquery_exporter` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`step_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `model_time` (`model_name`,`run_year`,`run_month`,`process_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `laso_tasks` (
  `task_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `model` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `diff` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `step_id` bigint unsigned NOT NULL,
  `diff_direction` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `staff_id` (`staff_id`),
  KEY `model` (`model`),
  KEY `status` (`status`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_2m` (
  `listing_id` bigint unsigned NOT NULL,
  `title` varchar(511) DEFAULT NULL,
  `description` text,
  `tags` varchar(511) DEFAULT NULL,
  `materials` varchar(511) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `shipping` float DEFAULT NULL,
  PRIMARY KEY (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_inferable_ids` (
  `inferable_id` int unsigned NOT NULL COMMENT 'The enum value assigned in PHP',
  `inferable_name` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The enum name assigned in PHP',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`inferable_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_recommender_featured_listing` (
  `listing_id` bigint NOT NULL,
  `bucket` varchar(16) NOT NULL,
  `bucket_seq` int NOT NULL COMMENT 'a sequence that begins anew for each bucket',
  `state` varchar(16) NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`listing_id`),
  KEY `idx_bucket_state_seq` (`bucket`,`state`,`bucket_seq`),
  KEY `idx_state` (`state`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `media_transcribed_moderation` (
  `text_moderation_id` bigint unsigned NOT NULL,
  `media_id` bigint unsigned NOT NULL,
  `media_type_id` int unsigned NOT NULL,
  `media_type` int unsigned NOT NULL DEFAULT '0' COMMENT 'video or audio',
  `gift_receipt_options_id` bigint unsigned DEFAULT NULL,
  `transcript_confidence` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `toxic` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `derogatory` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `violent` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `sexual` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `insult` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `profanity` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `death_harm_tragedy` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `firearms_weapons` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `public_safety` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `health` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `religion_belief` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `illicit_drugs` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `war_conflict` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `finance` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `politics` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `legal` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`text_moderation_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `member_story` (
  `user_id` bigint unsigned NOT NULL,
  `story_id` bigint unsigned NOT NULL,
  `story` longtext COLLATE utf8mb4_unicode_ci,
  `source_url` longtext COLLATE utf8mb4_unicode_ci,
  `created_by_staff_id` bigint unsigned NOT NULL,
  `story_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`story_id`),
  KEY `story_date` (`story_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Member stories';

CREATE TABLE `member_story_attachment` (
  `story_id` bigint unsigned NOT NULL,
  `attachment_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `aws_url` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `filetype` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Attachments for member stories';

CREATE TABLE `member_story_tag` (
  `user_id` bigint unsigned NOT NULL,
  `story_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`story_id`,`tag_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Tags for member stories';

CREATE TABLE `mobile_app` (
  `app_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bundle_id` varchar(128) NOT NULL,
  `variant` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(128) NOT NULL,
  `author_ldap` varchar(128) NOT NULL DEFAULT '',
  `icon_s3_path` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned DEFAULT NULL,
  `description` text NOT NULL,
  `platform_type` tinyint unsigned NOT NULL,
  `repository` varchar(128) NOT NULL,
  PRIMARY KEY (`app_id`),
  KEY `bundle_id_variant` (`bundle_id`,`variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Describe Mobile Apps in App Gallery';

CREATE TABLE `model_db` (
  `model_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'unique key for all predictive models',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'creation time for predictive models',
  `problem_name` varchar(200) NOT NULL COMMENT 'name of prediction task',
  `model_args` varchar(1000) DEFAULT '' COMMENT 'arguments used to create predictive model',
  `categories` varchar(1000) NOT NULL COMMENT 'possible output categories for predictive model',
  `model` mediumtext NOT NULL COMMENT 'json-serialized predictive model',
  PRIMARY KEY (`model_id`),
  KEY `epoch_problem_name` (`epoch_s`,`problem_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `not_shipped_compensation_promo` (
  `not_shipped_compensation_promo_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `receipt_id` bigint unsigned NOT NULL,
  `reimbursement_type` char(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email_sent_date` int unsigned NOT NULL DEFAULT '0',
  `requested_date` int unsigned NOT NULL DEFAULT '0',
  `compensation_usd` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`not_shipped_compensation_promo_id`),
  KEY `user_idx` (`user_id`),
  KEY `receipt_idx` (`receipt_id`),
  KEY `comp_user_receipt_idx` (`not_shipped_compensation_promo_id`,`user_id`,`receipt_id`),
  KEY `reimbursement_typex` (`reimbursement_type`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article` (
  `article_id` bigint unsigned NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shortcut` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `folder_id` bigint unsigned NOT NULL DEFAULT '0',
  `flags` tinyint unsigned NOT NULL DEFAULT '0',
  `pinned` tinyint unsigned NOT NULL DEFAULT '0',
  `excluding_regions` tinyint unsigned NOT NULL DEFAULT '0',
  `options` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hide_publish_date` tinyint unsigned NOT NULL DEFAULT '0',
  `publish_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `auto_publish_date` int unsigned NOT NULL DEFAULT '0',
  `auto_archive_date` int unsigned NOT NULL DEFAULT '0',
  `is_stale` tinyint unsigned NOT NULL DEFAULT '0',
  `stale_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `zendesk_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `zendesk_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `zendesk_type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`article_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `shortcut_type_idx` (`shortcut`,`type`),
  KEY `type_article_idx` (`type`,`article_id`),
  KEY `staff_idx` (`staff_id`),
  KEY `publish_date` (`publish_date`),
  KEY `archive_date` (`archive_date`),
  KEY `stale_date` (`stale_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_asset` (
  `article_id` bigint unsigned NOT NULL,
  `asset_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`asset_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_author` (
  `article_id` bigint unsigned NOT NULL,
  `author_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`author_id`),
  KEY `author_id` (`author_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Link Nova Authors to Nova Articles';

CREATE TABLE `nova_article_category` (
  `article_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`category_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_chunk` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revision_id` bigint unsigned NOT NULL,
  `chunk_num` int unsigned NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` varchar(8192) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`language`,`revision_id`,`chunk_num`),
  UNIQUE KEY `revision_id` (`revision_id`,`chunk_num`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_history` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `history_id` bigint unsigned NOT NULL,
  `shortcut` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `publish_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `is_stale` tinyint unsigned NOT NULL DEFAULT '0',
  `published_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `working_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `history_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `history_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `history_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `folder_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`article_id`,`language`,`revision_id`,`history_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_metadata` (
  `metadata_id` bigint unsigned NOT NULL,
  `article_id` bigint unsigned NOT NULL,
  `key` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT 'boolean indicating metadata is soft deleted',
  `delete_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`metadata_id`),
  KEY `article_id_idx` (`article_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_region` (
  `article_id` bigint unsigned NOT NULL,
  `nova_article_region_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` smallint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`country_id`,`nova_article_region_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_revision` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revision_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `translation_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL,
  `parent_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `subject` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body_md` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_html` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `excerpt` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `introduction` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`article_id`,`language`,`revision_id`),
  UNIQUE KEY `revision_id` (`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `article_language_parent_revision_idx` (`article_id`,`language`,`parent_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_tag` (
  `article_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_article_translation` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `published_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `working_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `final_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `is_published` tinyint unsigned NOT NULL DEFAULT '0',
  `translation_publish_date` int unsigned NOT NULL DEFAULT '0',
  `schedule_publish` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'boolean indicating whether the article should be published in this language',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`language`),
  KEY `update_date_idx` (`update_date`),
  KEY `published_revision_id_language_article_id_idx` (`published_revision_id`,`language`,`article_id`),
  KEY `article_language_final_revision_published_idx` (`article_id`,`language`,`final_revision_id`,`is_published`),
  KEY `article_language_working_revision_idx` (`article_id`,`language`,`working_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_asset` (
  `asset_id` bigint unsigned NOT NULL,
  `type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_group` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`asset_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_author` (
  `author_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `first_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bio` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`author_id`),
  KEY `user_id` (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Information about authors of Nova Articles';

CREATE TABLE `nova_category` (
  `category_id` bigint unsigned NOT NULL,
  `category_group` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Example: etsy_blog, code_as_craft, etc.',
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'xxx',
  `priority` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'This is in relation to the nav bar; 0 means inactive',
  `parent_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_group_name_idx` (`category_group`,`name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_category_region` (
  `category_id` bigint unsigned NOT NULL,
  `country_id` bigint unsigned NOT NULL,
  `priority` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'This is in relation to the nav bar; 0 means inactive',
  PRIMARY KEY (`category_id`,`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_event` (
  `article_id` bigint unsigned NOT NULL,
  `event_url` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `end_date` int unsigned NOT NULL DEFAULT '0',
  `location` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_folder` (
  `folder_id` bigint unsigned NOT NULL,
  `parent_folder_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`folder_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_preference` (
  `preference` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `article_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`preference`,`staff_id`,`article_type`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_related_article` (
  `article_id` bigint unsigned NOT NULL,
  `related_article_id` bigint unsigned NOT NULL,
  `order` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`related_article_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `related_article_idx` (`related_article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_revision_asset` (
  `asset_id` bigint unsigned NOT NULL,
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revision_id` bigint unsigned NOT NULL,
  `url` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_featured` tinyint unsigned NOT NULL DEFAULT '0',
  `metadata` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`asset_id`,`article_id`,`language`,`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `article_language_revision_idx` (`article_id`,`language`,`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_revision_author` (
  `author_id` bigint unsigned NOT NULL,
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revision_id` bigint unsigned NOT NULL,
  `author_first_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author_last_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author_bio` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`author_id`,`article_id`,`language`,`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `article_language_revision_idx` (`article_id`,`language`,`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_sox_article_revision` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revision_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `translation_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL,
  `parent_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `subject` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `author` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body_md` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_html` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `excerpt` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `title_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body_md_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body_html_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `excerpt_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `introduction_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `introduction` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`article_id`,`language`,`revision_id`),
  UNIQUE KEY `revision_id` (`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `article_language_parent_revision_idx` (`article_id`,`language`,`parent_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_sox_article_translation` (
  `article_id` bigint unsigned NOT NULL,
  `language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `published_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `working_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `final_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `is_published` tinyint unsigned NOT NULL DEFAULT '0',
  `translation_publish_date` int unsigned NOT NULL DEFAULT '0',
  `schedule_publish` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'boolean indicating whether the article should be published in this language',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`article_id`,`language`),
  KEY `update_date_idx` (`update_date`),
  KEY `published_revision_id_language_article_id_idx` (`published_revision_id`,`language`,`article_id`),
  KEY `article_language_final_revision_published_idx` (`article_id`,`language`,`final_revision_id`,`is_published`),
  KEY `article_language_working_revision_idx` (`article_id`,`language`,`working_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_subscription_email_address` (
  `subscription_email_address_id` bigint unsigned NOT NULL,
  `email_address` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_subscribed` tinyint unsigned NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`subscription_email_address_id`),
  UNIQUE KEY `subscription_group_name_idx` (`email_address`,`category_group`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nova_tag` (
  `tag_id` bigint unsigned NOT NULL,
  `tag_group` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_group_name_idx` (`tag_group`,`name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `offsite_ads_bing_token` (
  `token_id` bigint unsigned NOT NULL,
  `access_token` longtext COLLATE utf8mb4_unicode_ci,
  `refresh_token` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`token_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `offsite_ads_pinterest_token` (
  `token_id` bigint unsigned NOT NULL,
  `access_token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `refresh_token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`token_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ogm_enrollment_updates` (
  `transaction_record_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'trulioo id for ogm transaction',
  `enrollment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'enrollment id for trulioo ogm service',
  `watchlist_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'current watchlist state',
  `check_date` int unsigned NOT NULL COMMENT 'Date the check was performed, as provided by vendor',
  `callback_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'raw callback body from ogm service',
  `pep_task_id` bigint unsigned DEFAULT NULL COMMENT 'id of pep review apollo task if one is associated with the update',
  `pep_task_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'current status of the pep task if one exists',
  `sanctions_task_id` bigint unsigned DEFAULT NULL COMMENT 'id of sanctions review apollo task if one is associated with the update',
  `sanctions_task_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'current status of the sanctions task if one exists',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`transaction_record_id`),
  KEY `enrollment_id` (`enrollment_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ogm_enrollments` (
  `enrollment_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'enrollment id for trulioo ogm service',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Foreign key for shop this enrollment is for',
  `user_identity_id` bigint unsigned NOT NULL COMMENT 'Foreign key for user identity this enrollment is for',
  `identity_verification_request_id` bigint unsigned NOT NULL COMMENT 'id verification request id associated with the enrollment',
  `enrollment_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'status of enrollment',
  `vendor_context` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'context used to create enrollment.',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ogm_individual' COMMENT 'scope of the enrollment.',
  `deleted_date` int unsigned DEFAULT NULL COMMENT 'Date in epoch time that the enrollment was marked as deleted',
  `create_date` int unsigned NOT NULL COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL COMMENT 'Updated date in epoch time',
  PRIMARY KEY (`enrollment_id`),
  KEY `shop_id` (`shop_id`),
  KEY `user_identity_id` (`user_identity_id`),
  KEY `identity_verification_request_id` (`identity_verification_request_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_experiment_sql` (
  `experiment_id` bigint unsigned NOT NULL,
  `variant` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gcs_sql_filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`experiment_id`,`variant`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_experiments` (
  `experiment_id` bigint unsigned NOT NULL,
  `experiment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor_regex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_regex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `language_regex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `classification` tinyint unsigned NOT NULL DEFAULT '0',
  `experiment_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `experiment_learnings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `owner_ldap` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'LDAP of user who created the experiment',
  `num_buckets` tinyint unsigned NOT NULL,
  `experiment_status` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Status column for storing explicit experiment states that are non-dynamic based on start/end dates',
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `bucket_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date to track when bucketing was done',
  PRIMARY KEY (`experiment_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `vendor_country_language` (`vendor_regex`,`country_regex`,`language_regex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_passive_backfills` (
  `passive_backfill_id` bigint unsigned NOT NULL,
  `backfill_timestamp` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`passive_backfill_id`),
  KEY `backfill_timestamp` (`backfill_timestamp`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_attributes` (
  `feed_id` bigint unsigned NOT NULL,
  `attribute_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`,`attribute_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_audit` (
  `feed_id` bigint unsigned NOT NULL,
  `ssf_feed_audit_id` bigint unsigned NOT NULL,
  `count` bigint unsigned NOT NULL,
  `date_timestamp` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`ssf_feed_audit_id`),
  KEY `feed_id_idx` (`feed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_blocklist` (
  `feed_id` bigint unsigned NOT NULL,
  `blocklist_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`,`blocklist_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_categories` (
  `feed_id` bigint unsigned NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`,`category`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_credentials` (
  `id` bigint unsigned NOT NULL,
  `feed_id` bigint unsigned NOT NULL,
  `password_hashed` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `feed_password` (`feed_id`,`password_hashed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_custom_label` (
  `id` bigint unsigned NOT NULL,
  `feed_id` bigint unsigned NOT NULL,
  `custom_label_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feed_id` (`feed_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_feeds` (
  `feed_id` bigint unsigned NOT NULL,
  `vendor_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_vendor_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint unsigned NOT NULL,
  `security_poc_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `security_poc_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `maximum_listings` bigint unsigned NOT NULL,
  `is_refresh_api_enabled` tinyint NOT NULL DEFAULT '0',
  `feed_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` tinyint NOT NULL DEFAULT '0',
  `last_execution_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_filters` (
  `feed_id` bigint unsigned NOT NULL,
  `attribute_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comparator` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filter_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filter_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`,`attribute_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_self_serve_sorts` (
  `feed_id` bigint unsigned NOT NULL,
  `attribute_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int unsigned NOT NULL,
  `direction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`feed_id`,`attribute_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_seller_experiment_consent` (
  `shop_id` bigint unsigned NOT NULL,
  `opt_out_effective_date` int unsigned DEFAULT NULL COMMENT 'When the opt-out actually takes effect to allow for a cool-down period on their experiments',
  `opt_out_request_date` int unsigned DEFAULT NULL COMMENT 'When the seller requested to be opted out of experimentation',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `consent_type` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`,`consent_type`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Table storing seller consent (or their opt-out request) for OLF experimentation';

CREATE TABLE `pages_signups` (
  `signup_id` bigint unsigned NOT NULL,
  `brand_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Name of brand wishing to create a page',
  `brand_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'website where we can review the brand for a new page',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Name of the user applying for a page',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Title of applicant submitting for a new page',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'email to send confirmation to',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`signup_id`),
  KEY `email_idx` (`email`(191)),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_item_type` (
  `palette_item_type_id` bigint unsigned NOT NULL,
  `palette_item_type_name` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`palette_item_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_set` (
  `palette_set_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(60) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`palette_set_id`),
  KEY `staff_name` (`staff_id`,`name`),
  KEY `user_id_name` (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_set_visibility` (
  `palette_set_visibility_id` bigint unsigned NOT NULL DEFAULT '0',
  `palette_set_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `set_order` smallint NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`palette_set_visibility_id`),
  KEY `palette_set_visibility_idx` (`palette_set_id`,`staff_id`),
  KEY `palette_set_visibility_user_id` (`palette_set_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_tab` (
  `palette_tab_id` bigint unsigned NOT NULL DEFAULT '0',
  `palette_set_id` bigint unsigned NOT NULL DEFAULT '0',
  `tab_order` smallint NOT NULL DEFAULT '1',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(60) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`palette_tab_id`),
  UNIQUE KEY `name_set_idx` (`palette_set_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_tab_item` (
  `palette_tab_item_id` bigint unsigned NOT NULL DEFAULT '0',
  `palette_tab_id` bigint unsigned NOT NULL DEFAULT '0',
  `item_id` varchar(255) NOT NULL DEFAULT '' COMMENT 'This is a varchar so that we can include things like blog post slugs or URLs',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `item_type` varchar(60) NOT NULL DEFAULT '',
  `image_url` varchar(255) DEFAULT NULL,
  `order` smallint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`palette_tab_item_id`),
  KEY `palette_tab_item_idx` (`palette_tab_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `payments_disbursements_signoff` (
  `signoff_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `job` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`signoff_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `permissions_actions_roles` (
  `category` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `action` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `role_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`category`,`action`,`role_id`),
  KEY `role_id_idx` (`role_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `permissions_actions_roles_audit` (
  `category` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `audit_id` bigint unsigned NOT NULL,
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`category`,`action`,`role_id`,`audit_id`),
  KEY `role_category_action_idx` (`role_id`,`category`,`action`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `permissions_roles` (
  `role_id` bigint unsigned NOT NULL DEFAULT '0',
  `role` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `weight` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `description` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role` (`role`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `permissions_roles_audit` (
  `role_id` bigint unsigned NOT NULL,
  `audit_id` bigint unsigned NOT NULL,
  `role` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` int unsigned NOT NULL,
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`audit_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `phone_log` (
  `phone_log_id` bigint unsigned NOT NULL,
  `phone_log_type` varchar(15) NOT NULL DEFAULT '',
  `task_id` bigint unsigned NOT NULL,
  `call_id` bigint unsigned NOT NULL,
  `entered_queue` int unsigned NOT NULL,
  `time_answered` int unsigned NOT NULL,
  `time_disconnected` int unsigned NOT NULL,
  `agent_code` varchar(128) NOT NULL DEFAULT '',
  `direction` varchar(15) NOT NULL DEFAULT '',
  `ani` varchar(25) NOT NULL DEFAULT '',
  `wait_time` int unsigned NOT NULL,
  `talk_time` int unsigned NOT NULL,
  `data` text NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`phone_log_id`),
  KEY `phone_log_task_id` (`task_id`),
  KEY `phone_log_call_id` (`call_id`),
  KEY `phone_log_time_answered` (`time_answered`),
  KEY `phone_log_agent_code` (`agent_code`),
  KEY `phone_log_ani` (`ani`),
  KEY `phone_log_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pitney_bowes_exports` (
  `export_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `s3_filename` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The S3 object name',
  `s3_hash` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `filename` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(225) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_issuing_date` int unsigned NOT NULL DEFAULT '0',
  `state_issued_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`export_id`),
  KEY `state_idx` (`state`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `s3_filename` (`s3_filename`),
  KEY `filename` (`filename`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pitney_bowes_transactions` (
  `transaction_id` bigint unsigned NOT NULL,
  `export_id` bigint unsigned NOT NULL,
  `raw_transaction_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The raw transaction ID found in the invoice file. Shared across transaction types (not unique).',
  `transaction_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_date` int unsigned NOT NULL,
  `state` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the invoice item (processed, etc).',
  `amount` int unsigned NOT NULL COMMENT 'The amount of the charge or credit billed to Etsy. For purchases or refunds this is the full postage amount. For adjustments this is the difference between the original amount and the recalculated amount. This is the amount Etsy pays/credited.',
  `seller_amount` int unsigned NOT NULL DEFAULT '0' COMMENT 'The amount of the charge we calculated for the seller or the adjustment charge recalculated for the seller.',
  `expected_amount` int unsigned NOT NULL DEFAULT '0' COMMENT 'The amount Etsy calculated we should pay for this label (only available for purchases and refunds after processing).',
  `delta` int NOT NULL DEFAULT '0' COMMENT 'The different between what Etsy thinks we should have paid vs what Pitney Bowes charged us (only available for purchases and refunds after processing).',
  `currency_code` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `tracking_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mail_class` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The original or adjusted mail class.',
  `package_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The original or adjusted package type.',
  `weight` decimal(9,4) NOT NULL DEFAULT '0.0000' COMMENT 'The original or adjusted weight.',
  `weight_units` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'oz',
  `length` decimal(9,4) NOT NULL DEFAULT '0.0000' COMMENT 'The original or adjusted length.',
  `width` decimal(9,4) NOT NULL DEFAULT '0.0000' COMMENT 'The original or adjusted width.',
  `height` decimal(9,4) NOT NULL DEFAULT '0.0000' COMMENT 'The original or adjusted height.',
  `dimension_units` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in',
  `zone` int unsigned NOT NULL DEFAULT '0' COMMENT 'The original zone or adjusted zone. For adjustments this would be different than originally calculated if the seller dropped off at a different post office than they said.',
  `price_group` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The original or adjusted price group (international). This may be different for adjustments due to the same reasons outlined in zone.',
  `adjustment_reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The reason for the adjustment.',
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The adjustment status.',
  `anomaly_reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Reason for an anomaly.',
  `usps_revenue_assurance_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'USPS ID to dispute adjustment (known as external ID in PB responses).',
  `refund_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The status of the refund (approved, denied, received, etc).',
  `refund_denial_reason` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The reason the USPS denied the refund.',
  `refund_requestor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Who requested the refund (either the seller or auto-refund on the account).',
  `print_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The print status for scan-based returns.',
  `ship_from` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `origin_zip` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ship_to` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipment_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The unique USPS shipment ID',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `label_type` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'The type of label (0 = forward, 1 = return)',
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `raw_transaction_type_time_idx` (`raw_transaction_id`,`transaction_type`,`transaction_date`),
  KEY `export_id` (`export_id`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`),
  KEY `state_processed_date_idx` (`state_processed_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `policy` (
  `policy_id` bigint unsigned NOT NULL COMMENT 'Primary key for this policy',
  `parent_policy_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'This policies parent policy',
  `policy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human readable policy name',
  `display_name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human readable policy name for apollo policy buttons',
  `mnemonic` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Easy to remember mnemonic for querying',
  `admin_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Which admin note should be used on accounts that violate this policy',
  `strike_category_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which strike category applies to violations of this policy',
  `nova_article_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which email template is sent for violations of this policy',
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which admin action should be taken for violations of this policy',
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which admin reason should be associated with actions taken for this policy',
  `is_non_violating` tinyint NOT NULL DEFAULT '0' COMMENT 'Is this policy used to denote things that are non-violating?',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`policy_id`),
  KEY `nova_article_id` (`nova_article_id`),
  KEY `strike_category_id` (`strike_category_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `policy_audit` (
  `policy_audit_id` bigint unsigned NOT NULL,
  `policy_id` bigint unsigned NOT NULL,
  `parent_policy_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'This policies parent policy',
  `policy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human readable policy name',
  `display_name` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human readable policy name for apollo policy buttons',
  `mnemonic` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Easy to remember mnemonic for querying',
  `admin_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Which admin note should be used on accounts that violate this policy',
  `strike_category_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which strike category applies to violations of this policy',
  `nova_article_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which email template is sent for violations of this policy',
  `admin_action_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which admin action should be taken for violations of this policy',
  `admin_reason_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Which admin reason should be associated with actions taken for this policy',
  `is_non_violating` tinyint NOT NULL DEFAULT '0' COMMENT 'Is this policy used to denote things that are non-violating?',
  `apollo_queue_mnemonics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Comma separated string of queue mnemonics',
  `audit_action` varchar(32) NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`policy_audit_id`),
  KEY `policy_id` (`policy_id`),
  KEY `nova_article_id` (`nova_article_id`),
  KEY `strike_category_id` (`strike_category_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `prolist_buffer_audit` (
  `type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shard` int unsigned NOT NULL DEFAULT '0',
  `time_window` int unsigned NOT NULL DEFAULT '0',
  `audit_start_time` int unsigned NOT NULL DEFAULT '0',
  `audit_end_time` int unsigned NOT NULL DEFAULT '0',
  `errors` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `buffered_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`type`,`shard`,`time_window`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `property_options` (
  `property_option_id` int unsigned NOT NULL,
  `property_id` int unsigned NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `order` int unsigned NOT NULL,
  `listing_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`property_option_id`),
  KEY `listing_enabled` (`listing_enabled`),
  KEY `property_id` (`property_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `query_translation_phrases` (
  `id` bigint unsigned NOT NULL,
  `language` tinyint unsigned NOT NULL,
  `content` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `language` (`language`,`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `query_translation_translations` (
  `source_id` bigint unsigned NOT NULL,
  `source_language` tinyint unsigned NOT NULL,
  `target_id` bigint unsigned NOT NULL,
  `target_language` tinyint unsigned NOT NULL,
  `status` int NOT NULL,
  `translator_userid` int unsigned NOT NULL,
  `creation_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`source_id`,`target_id`,`translator_userid`,`status`),
  KEY `source_language` (`source_language`,`target_language`),
  KEY `target_language` (`target_language`,`source_language`),
  KEY `source_language_status` (`source_language`,`status`),
  KEY `target_language_status` (`target_language`,`status`),
  KEY `target_to_source_id` (`target_id`,`source_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `questionable_behavior` (
  `questionable_behavior_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `comments` text,
  `urls` text,
  `admin_id` bigint unsigned NOT NULL,
  `steps` tinyint unsigned NOT NULL DEFAULT '0',
  `votes` tinyint unsigned NOT NULL DEFAULT '0',
  `closed` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`questionable_behavior_id`),
  KEY `user_id` (`user_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Instances of questionable behaviour by members';

CREATE TABLE `questionable_behavior_users` (
  `user_id` bigint unsigned NOT NULL,
  `pending_steps` tinyint unsigned NOT NULL DEFAULT '0',
  `lifetime_steps` tinyint unsigned NOT NULL DEFAULT '0',
  `penalty_steps` tinyint unsigned NOT NULL DEFAULT '0',
  `parole_steps` tinyint unsigned NOT NULL DEFAULT '0',
  `parole_date` int unsigned NOT NULL,
  `is_mute` tinyint unsigned NOT NULL DEFAULT '0',
  `unmute_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='User step and mute status';

CREATE TABLE `questionable_behavior_votes` (
  `questionable_behavior_vote_id` bigint unsigned NOT NULL,
  `questionable_behavior_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `vote` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`questionable_behavior_vote_id`),
  KEY `questionable_behavior_id` (`questionable_behavior_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Votes on questionable behavior penalties';

CREATE TABLE `rank_delta_studies` (
  `rank_delta_study_id` bigint unsigned NOT NULL,
  `creator_user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `class_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` int NOT NULL,
  `mmx_variant_control` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mmx_variant_experiment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_params_control` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_params_experiment` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_params_general` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`rank_delta_study_id`),
  KEY `update_date` (`update_date`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rank_delta_study_data` (
  `rank_delta_study_id` bigint unsigned NOT NULL,
  `human_task_id` bigint DEFAULT NULL,
  `count_queries` int unsigned NOT NULL DEFAULT '0',
  `count_queries_changed` int unsigned NOT NULL DEFAULT '0',
  `sum_distance` int NOT NULL DEFAULT '0',
  `sum_cost_control` int unsigned NOT NULL DEFAULT '0',
  `sum_cost_experiment` int unsigned NOT NULL DEFAULT '0',
  `sum_distinct_shop_count_control` int unsigned NOT NULL DEFAULT '0',
  `sum_distinct_shop_count_experiment` int unsigned NOT NULL DEFAULT '0',
  `sum_result_count_control` int unsigned NOT NULL DEFAULT '0',
  `sum_result_count_experiment` int unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `sum_prolist_cost_control` int unsigned DEFAULT '0',
  `sum_prolist_cost_experiment` int unsigned DEFAULT '0',
  PRIMARY KEY (`rank_delta_study_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rank_delta_study_queries` (
  `rank_delta_study_query_id` bigint unsigned NOT NULL,
  `rank_delta_study_id` bigint unsigned NOT NULL,
  `query` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filters` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_ids_control` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_ids_experiment` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL,
  `distance` int NOT NULL,
  `sum_cost_control` int unsigned NOT NULL DEFAULT '0',
  `sum_cost_experiment` int unsigned NOT NULL DEFAULT '0',
  `result_count_control` int unsigned NOT NULL DEFAULT '0',
  `result_count_experiment` int unsigned NOT NULL DEFAULT '0',
  `distinct_shop_count_control` int unsigned NOT NULL DEFAULT '0',
  `distinct_shop_count_experiment` int unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `sum_prolist_cost_control` int unsigned DEFAULT '0',
  `sum_prolist_cost_experiment` int unsigned DEFAULT '0',
  PRIMARY KEY (`rank_delta_study_query_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rank_delta_study_query_metrics` (
  `metric_id` bigint unsigned NOT NULL,
  `rank_delta_study_query_id` bigint unsigned NOT NULL,
  `metric_group` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metric` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` float NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`metric_id`),
  KEY `update_date` (`update_date`),
  KEY `rank_delta_study_query_id` (`rank_delta_study_query_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rank_delta_study_query_pairwise_ratings` (
  `rank_delta_study_query_rating_id` bigint unsigned NOT NULL,
  `rank_delta_study_id` bigint unsigned NOT NULL,
  `rank_delta_study_query_id` bigint unsigned NOT NULL,
  `human_task_subject_id` bigint unsigned NOT NULL,
  `pair` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `winner` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int unsigned NOT NULL,
  `is_mock` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`rank_delta_study_query_rating_id`),
  KEY `rank_delta_study_id_query_id_subject_id` (`rank_delta_study_id`,`rank_delta_study_query_id`,`human_task_subject_id`,`is_mock`),
  KEY `rank_delta_study_id_subject_id` (`rank_delta_study_id`,`human_task_subject_id`,`is_mock`),
  KEY `rank_delta_study_id_pair` (`rank_delta_study_id`,`is_mock`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rank_delta_study_query_ratings` (
  `rank_delta_study_query_rating_id` bigint unsigned NOT NULL,
  `rank_delta_study_id` bigint unsigned NOT NULL,
  `rank_delta_study_query_id` bigint unsigned NOT NULL,
  `human_task_subject_id` bigint unsigned NOT NULL,
  `rating` int unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`rank_delta_study_query_rating_id`),
  KEY `rank_delta_study_id_query_id_subject_id` (`rank_delta_study_id`,`rank_delta_study_query_id`,`human_task_subject_id`),
  KEY `rank_delta_study_id_subject_id` (`rank_delta_study_id`,`human_task_subject_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ranker_metadata` (
  `ranker_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dynamic_class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descriptive_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `long_description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `output_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`ranker_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rate_limits` (
  `key` varchar(64) NOT NULL,
  `count` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL,
  `create_date` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `recruiting_candidates` (
  `candidate_id` char(32) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `req_id` char(32) NOT NULL,
  `date` int NOT NULL,
  `update_date` int NOT NULL,
  `source_type` varchar(255) NOT NULL,
  `referrer` varchar(255) NOT NULL,
  PRIMARY KEY (`candidate_id`,`req_id`,`date`),
  KEY `status_date_idx` (`status`,`date`),
  KEY `source_status_date_idx` (`source_type`,`status`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `recset_metadata` (
  `component_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `component_type` enum('ranker','cset','recset') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `component_description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `descriptive_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_input` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `optimized_for` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `trained_on` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `model_learning` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `users_covered` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `candidate_set_overview` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ranker_overview` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`component_name`,`component_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `reseller_title_word` (
  `word` varchar(64) NOT NULL,
  `weight` float NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='word weight for reseller title analysis';

CREATE TABLE `risk_category` (
  `risk_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `risk_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`risk_category_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `risk_category_audit` (
  `risk_category_audit_id` bigint unsigned NOT NULL,
  `risk_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `risk_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`risk_category_audit_id`),
  KEY `risk_category_idx` (`risk_category_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `risk_group` (
  `risk_group_id` bigint unsigned NOT NULL,
  `group_name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `group_description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`risk_group_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `risk_tag` (
  `risk_tag_id` bigint unsigned NOT NULL,
  `tag_name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tag_mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Defaults to the risk_tag_id so as not to violate uniqueness',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`risk_tag_id`),
  UNIQUE KEY `tag_name_idx` (`tag_name`),
  UNIQUE KEY `tag_mnemonic_idx` (`tag_mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `archive_date_idx` (`archive_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_issues` (
  `issue_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `failure_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `jira_ticket_key` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `commit_sha` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `review_key` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `failure_parameter` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `user` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `commit_repo_path` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `elk_key` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `commit_github` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `resolved_date` int unsigned NOT NULL DEFAULT '0',
  `message_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `comment_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`issue_id`),
  KEY `staff_id` (`staff_id`),
  KEY `status` (`status`),
  KEY `jira_ticket_key` (`jira_ticket_key`),
  KEY `commit_sha` (`commit_sha`),
  KEY `review_key` (`review_key`),
  KEY `create_date` (`create_date`),
  KEY `failure_type` (`failure_type`(191)),
  KEY `user` (`user`),
  KEY `commit_repo_path` (`commit_repo_path`),
  KEY `elk_key_idx` (`elk_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_managed_files_history_entry` (
  `id` bigint unsigned NOT NULL,
  `commit_sha` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `repo_path` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jira_ticket` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `committer` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_modified` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_rmfc_add_to_rodeo_entry` (
  `add_to_rodeo_entry_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `commit_id` bigint unsigned NOT NULL,
  `filename` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `repo_path` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_been_added` tinyint(1) NOT NULL,
  `delay_length` bigint NOT NULL,
  `date_to_remind_engineer` int NOT NULL,
  `orig_add_date` int NOT NULL,
  `last_notified` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`add_to_rodeo_entry_id`),
  KEY `task_id` (`task_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_rmfc_commit` (
  `commit_id` bigint unsigned NOT NULL,
  `commit_sha` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `repo_path` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `last_assigned` int NOT NULL DEFAULT '0',
  `last_reminded` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`commit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_rmfc_entry` (
  `entry_id` bigint unsigned NOT NULL,
  `eng_task_id` bigint unsigned NOT NULL,
  `ce_task_id` bigint unsigned NOT NULL,
  `commit_id` bigint unsigned NOT NULL DEFAULT '0',
  `filename` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `committer` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `repo_path` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `commit_sha` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `commit_msg` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `commit_date` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_managed` tinyint(1) NOT NULL,
  `is_invalid_ext` tinyint(1) NOT NULL,
  `is_sox_filename` tinyint(1) NOT NULL,
  `inc_by_patch_ref` tinyint(1) NOT NULL,
  `inc_by_commit_msg` tinyint(1) NOT NULL,
  `managed_file_refs` int NOT NULL,
  `ref_managed_files` int NOT NULL,
  `etsymodel_refs` int NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry_id`),
  KEY `task_id` (`eng_task_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_rmfc_response` (
  `response_id` bigint unsigned NOT NULL,
  `entry_id` bigint unsigned NOT NULL,
  `use_store_calcs_fm` tinyint NOT NULL DEFAULT '-1',
  `impact_other_file_uses` tinyint NOT NULL DEFAULT '-1',
  `support_sox_or_other_tools` tinyint NOT NULL DEFAULT '-1',
  `modify_access_inscope_gcp_proj` tinyint NOT NULL DEFAULT '-1',
  `modify_org_gcp_perm` tinyint NOT NULL DEFAULT '-1',
  `engineer_comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_tests` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `com_eng_comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `eng_question` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `delay_reason` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `responder_ldap` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_delayed` tinyint(1) NOT NULL DEFAULT '0',
  `ask_eng` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`response_id`),
  KEY `entry_id` (`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_role_assignments` (
  `user_id` bigint unsigned NOT NULL,
  `role` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role`,`target`),
  KEY `assignment_target_index` (`target`),
  KEY `assignment_role_index` (`role`,`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rodeo_soxalc_entry` (
  `id` bigint unsigned NOT NULL,
  `system_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `subsystem_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `entity` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `permission` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_baseline` tinyint(1) NOT NULL,
  `is_access_list_change` tinyint(1) NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `royal_mail_api_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `report_identifier` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Identifier used by Royal Mail to track generation of the invoice file',
  `start_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date used in requesting this invoice from the Royal Mail API',
  `end_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date used in requesting this invoice from the Royal Mail API',
  `api_status` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Last status received from the Royal Mail API',
  `api_status_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date when api_status was last checked',
  `url_expiry_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date when the url expires, provided by the Royal Mail API',
  `url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'URL to the invoice file',
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `state` (`state`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `royal_mail_api_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sender_first_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sender_last_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sender_postcode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sender_company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sender_email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_country_id` int unsigned NOT NULL DEFAULT '0',
  `label_printed_date` int unsigned NOT NULL DEFAULT '0',
  `total_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `vat_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `net_amount` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `spoilt_on` int unsigned NOT NULL DEFAULT '0',
  `spoil_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `spoil_initiator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `spoil_reference` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `indicia_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tracking_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `compensation_amount` int NOT NULL DEFAULT '0',
  `package_weight` int unsigned NOT NULL DEFAULT '0',
  `weight_units` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `shipment_guid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipment_reference` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `collection_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `shipment_guid` (`shipment_guid`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_id_shipping_label_id` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `royal_mail_invoice_items` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `transportation_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'From PackageLevel > TransportationMethodType',
  `tracking_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'FROM PackageLevel > Tracking Number. This may be an indicia_id',
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL COMMENT 'From PackageLevel > EtsyPackageTrackingNumber',
  `extra_cost` int NOT NULL COMMENT 'From PackageLevel > ExtraCost',
  `extra_cost_definition` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'From PackageLevel > ExtraCostDefinition',
  `spoil_state` tinyint unsigned NOT NULL COMMENT 'Tracks if this invoice item was auto-spoiled',
  `spoil_date` int unsigned NOT NULL,
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `royal_mail_invoices_create_date` (`create_date`),
  KEY `royal_mail_invoices_update_date` (`update_date`),
  KEY `royal_mail_invoice_items_shop_id_shipping_label_id` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `royal_mail_invoices` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_number` bigint unsigned NOT NULL COMMENT 'RM invoice number, From InvoiceNumber',
  `invoice_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Create or Spoil',
  `invoice_date` int unsigned NOT NULL COMMENT 'From InvoiceDate',
  `net_amount` int NOT NULL COMMENT 'From Summary > NetAmount',
  `total_monetary_summary` int NOT NULL COMMENT 'From Summary > TotalMonetarySummary',
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GBP',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `royal_mail_invoices_invoice_number_invoice_type` (`invoice_number`,`invoice_type`),
  KEY `royal_mail_invoices_create_date` (`create_date`),
  KEY `royal_mail_invoices_update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtbf_redactions_completed_by_user` (
  `user_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `visits` int unsigned NOT NULL DEFAULT '0',
  `beacons` int unsigned NOT NULL DEFAULT '0',
  `system_logs` int unsigned NOT NULL DEFAULT '0',
  `gci_pci` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `running_ab_tests` (
  `run_date` int unsigned NOT NULL,
  `ab_test` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`run_date`,`ab_test`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `salequickaction` (
  `sale_id` bigint unsigned NOT NULL,
  `sale_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sale_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sale_start_date` int unsigned NOT NULL DEFAULT '0',
  `sale_end_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `created_by` bigint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `adopted_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`sale_id`),
  UNIQUE KEY `sale_code` (`sale_code`),
  KEY `sale_dates_idx` (`sale_start_date`,`sale_end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sanction_resident` (
  `sanction_resident_id` bigint unsigned NOT NULL COMMENT 'Sanction resident identifier',
  `shop_id` bigint unsigned NOT NULL COMMENT 'Shop identifier that this sanction resident control belongs to',
  `review_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Status of the sanction resident control',
  `sanction_jurisdiction` int NOT NULL COMMENT 'Sanctioned jurisdiction where seller last resided',
  `last_sanction_residence_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Last date of residence in a sanctioned jurisdiction',
  `next_review_date` int NOT NULL DEFAULT '0' COMMENT 'Next review date of sanction resident control',
  `final_review_date` int NOT NULL DEFAULT '0' COMMENT 'Last review date of sanction resident control',
  `is_active` tinyint NOT NULL DEFAULT '1',
  `apollo_task_id` bigint unsigned DEFAULT NULL COMMENT 'id of sanction resident review apollo task',
  `apollo_task_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'current status of the sanction resident task if one exists',
  `create_date` int NOT NULL DEFAULT '0' COMMENT 'record creation date in epoch time',
  `update_date` int NOT NULL DEFAULT '0' COMMENT 'date record last updated in epoch time',
  PRIMARY KEY (`sanction_resident_id`),
  KEY `shop_id` (`shop_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sanctioned_bank_institutions` (
  `sanctioned_bank_institution_id` bigint unsigned NOT NULL,
  `bank_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Sanctioned Bank Institution name',
  `iso_country_code` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ISO 2-Digit Alpha Country Code',
  `swift` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'SWIFT number used to identify banks and financial institutions.',
  `bank_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Houses BSB codes and institution numbers.',
  `routing_number` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Routing number used to identify US banks and financial institutions.',
  `admin_staff_id` bigint unsigned NOT NULL COMMENT 'Maps to row in etsy_aux.staff',
  `csv_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_archived` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Set to 1 if this row is inactive and archived.',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'The date when we archived this row.',
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`sanctioned_bank_institution_id`),
  KEY `create_date` (`create_date`),
  KEY `cmp_data` (`swift`,`bank_code`,`routing_number`),
  KEY `swift_idx` (`swift`,`is_archived`),
  KEY `bank_code_idx` (`bank_code`,`is_archived`),
  KEY `routing_number_idx` (`routing_number`,`is_archived`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sanctioned_bank_institutions_post_csv_upload_jobs` (
  `sanctioned_bank_institution_post_csv_upload_job_id` bigint unsigned NOT NULL,
  `admin_staff_id` bigint unsigned NOT NULL COMMENT 'Maps to row in etsy_aux.staff',
  `status` varchar(20) CHARACTER SET utf8 NOT NULL,
  `scheduled_date` int unsigned NOT NULL COMMENT 'Earliest date this job should run at',
  `completed_date` int unsigned NOT NULL COMMENT 'Date job completed running',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`sanctioned_bank_institution_post_csv_upload_job_id`),
  KEY `status_scheduled_date` (`status`,`scheduled_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemanator_dummy_test` (
  `testid` bigint unsigned NOT NULL,
  `column1` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mayhem` bigint DEFAULT NULL,
  `column2` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`testid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `script_log` (
  `script_log_id` bigint unsigned NOT NULL DEFAULT '0',
  `script_name` varchar(255) NOT NULL DEFAULT '',
  `script_args` varchar(255) NOT NULL DEFAULT '',
  `start_time` int unsigned NOT NULL DEFAULT '0',
  `end_time` int unsigned NOT NULL DEFAULT '0',
  `runtime_seconds` int unsigned NOT NULL DEFAULT '0',
  `peak_memory_usage_bytes` bigint unsigned NOT NULL DEFAULT '0',
  `successful_exit` tinyint(1) NOT NULL DEFAULT '0',
  `var_int` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`script_log_id`),
  KEY `script_name_idx` (`script_name`,`end_time`),
  KEY `end_time_idx` (`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_ads_keyword_changes` (
  `keyword_change_id` bigint unsigned NOT NULL,
  `action` tinyint unsigned NOT NULL,
  `keyword` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_price` int unsigned DEFAULT '0',
  `new_price` int unsigned DEFAULT '0',
  `percent_change` double DEFAULT '0',
  `closest_shop_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shop_match_score` tinyint unsigned DEFAULT '0',
  `inverse_document_frequency` double unsigned DEFAULT '0',
  `create_date` int unsigned DEFAULT '0',
  `update_date` int unsigned DEFAULT '0',
  `old_price_per_click` int unsigned NOT NULL DEFAULT '0',
  `new_price_per_click` int unsigned NOT NULL DEFAULT '0',
  `per_click_percent_change` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`keyword_change_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_annotations_action_logs` (
  `search_annotations_action_log_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of an action log',
  `search_annotations_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to search_annotations_queries',
  `user_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to users',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `linked_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to search_annotations_queries',
  `search_annotations_listing_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to search_annotations_listings',
  `reason` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Reason for the action',
  `other_reason_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Freeform reason text',
  `action_taken` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Action taken on the query',
  `annotation` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Annotation of the listing',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Update date in epoch time',
  PRIMARY KEY (`search_annotations_action_log_id`),
  KEY `search_annotations_query_id` (`search_annotations_query_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_annotations_linked_queries` (
  `search_annotations_linked_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Generated primary key of a query',
  `search_annotations_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to search_annotations_queries',
  `linked_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key of a query linked to the search_annotations_query_id',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `last_update_admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `is_enabled` tinyint NOT NULL DEFAULT '0' COMMENT 'Flag to indicate if the linked query pair is enabled',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Update date in epoch time',
  PRIMARY KEY (`search_annotations_linked_query_id`),
  UNIQUE KEY `query_pair_idx` (`search_annotations_query_id`,`linked_query_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_annotations_listings` (
  `search_annotations_listing_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Generated primary key of a listing annotation',
  `search_annotations_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to search_annotations_queries',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to shops',
  `listing_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to listings',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `last_update_admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `annotation` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Annotation of the listing',
  `reason` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Reason for the annotation',
  `other_reason_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Freeform reason text',
  `is_enabled` tinyint NOT NULL DEFAULT '0' COMMENT 'Flag to indicate if the listing annotation is enabled',
  `is_approved` tinyint NOT NULL DEFAULT '0' COMMENT 'Flag to indicate if the listing annotation is approved',
  `approval_state` smallint unsigned NOT NULL DEFAULT '0' COMMENT 'Approval state for the annotation',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Update date in epoch time',
  PRIMARY KEY (`search_annotations_listing_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `listing_id_idx` (`listing_id`,`search_annotations_query_id`),
  KEY `query_id_annotation_approval_state_idx` (`search_annotations_query_id`,`annotation`,`approval_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_annotations_queries` (
  `search_annotations_query_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Generated primary key of a query',
  `query_string` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The query string',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `last_update_admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to admin',
  `is_enabled` tinyint NOT NULL DEFAULT '0' COMMENT 'Flag to indicate if the query is enabled',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Creation date in epoch time',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Update date in epoch time',
  PRIMARY KEY (`search_annotations_query_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_precision_experiment_queries` (
  `search_precision_query_id` bigint unsigned NOT NULL,
  `search_precision_experiment_id` bigint unsigned NOT NULL,
  `terms` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_path` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `listing_ids_csv` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`search_precision_query_id`),
  KEY `search_precision_experiment_id` (`search_precision_experiment_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_precision_experiments` (
  `search_precision_experiment_id` bigint unsigned NOT NULL,
  `author_staff_id` bigint unsigned NOT NULL,
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`search_precision_experiment_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_bounty` (
  `bounty_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `submitter_id` bigint unsigned NOT NULL DEFAULT '0',
  `submitter_email_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `issue_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_subject` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_message` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_impact` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_reproduction_steps` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_severity` int unsigned NOT NULL DEFAULT '0',
  `issue_public_note` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_flags` int unsigned NOT NULL DEFAULT '0',
  `issue_score` int unsigned NOT NULL DEFAULT '0',
  `payment_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_amount` int unsigned NOT NULL DEFAULT '0',
  `payment_date` int unsigned NOT NULL DEFAULT '0',
  `jira_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `make_public` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`bounty_id`),
  KEY `task_idx` (`task_id`),
  KEY `submitter_idx` (`submitter_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_bounty_audit` (
  `bounty_id` bigint unsigned NOT NULL,
  `audit_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `submitter_id` bigint unsigned NOT NULL DEFAULT '0',
  `submitter_email_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `issue_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_subject` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_message` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_impact` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_reproduction_steps` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_severity` int unsigned NOT NULL DEFAULT '0',
  `issue_public_note` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_flags` int unsigned NOT NULL DEFAULT '0',
  `issue_score` int unsigned NOT NULL DEFAULT '0',
  `payment_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_amount` int unsigned NOT NULL DEFAULT '0',
  `payment_date` int unsigned NOT NULL DEFAULT '0',
  `jira_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `make_public` tinyint NOT NULL DEFAULT '0',
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`bounty_id`,`audit_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_bounty_submitter` (
  `submitter_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `email_address` varchar(255) CHARACTER SET utf8 NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_public_note` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_private_note` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_flags` int unsigned NOT NULL DEFAULT '0',
  `tshirt_size` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tshirt_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payment_on_file` tinyint unsigned NOT NULL DEFAULT '0',
  `tshirt_date` int unsigned NOT NULL DEFAULT '0',
  `make_public` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`submitter_id`),
  UNIQUE KEY `email_address_idx` (`email_address`),
  KEY `update_date_idx` (`update_date`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `segment_audience_names` (
  `audience_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`audience_name`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `seller_advisors` (
  `user_id` bigint unsigned NOT NULL,
  `seller_advisor_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `advisor_type` varchar(32) NOT NULL DEFAULT 'SAM',
  PRIMARY KEY (`user_id`,`advisor_type`),
  KEY `sa_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shard_migration_log` (
  `log_id` bigint unsigned NOT NULL,
  `migration_type` varchar(50) NOT NULL DEFAULT '' COMMENT 'object, percent, delete',
  `success` tinyint unsigned NOT NULL DEFAULT '0',
  `error_type` varchar(50) NOT NULL DEFAULT '',
  `log` mediumtext NOT NULL,
  `source_shard` int NOT NULL DEFAULT '0',
  `target_shard` int NOT NULL DEFAULT '0',
  `object_type` varchar(50) NOT NULL DEFAULT '' COMMENT 'user, forum, shop, etc',
  `object_id` varchar(255) DEFAULT NULL,
  `percent` float unsigned NOT NULL DEFAULT '0' COMMENT 'only set on percentage migration',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table to log shard migrations';

CREATE TABLE `shardsloader__hdfs_copies` (
  `copy_id` bigint unsigned NOT NULL,
  `hdfs_path` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
  `local_path` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
  `shardifying_field` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `hostname` mediumtext COLLATE utf8mb4_general_ci NOT NULL,
  `state` tinyint(1) NOT NULL,
  `first_part_file` bigint unsigned NOT NULL,
  `last_part_file` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`copy_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shardsloader_load_shards` (
  `load_id` bigint unsigned NOT NULL,
  `shard_id` bigint unsigned NOT NULL,
  `file_size` bigint unsigned DEFAULT NULL,
  `file_offset` bigint unsigned DEFAULT NULL,
  `state` tinyint(1) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`load_id`,`shard_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shardsloader_loads` (
  `load_id` bigint unsigned NOT NULL,
  `copy_id` bigint unsigned NOT NULL,
  `model_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `sleep_useconds` bigint unsigned NOT NULL,
  `state` tinyint(1) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`load_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_app_staff` (
  `app_staff_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `subscription_state` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`app_id`,`app_staff_id`),
  KEY `staff_id` (`staff_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_apps` (
  `app_id` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform_type` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `long_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `store_url` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `app_icon` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `github_repo_owner` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Engineering',
  `github_repo_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apikey_app_id` bigint unsigned NOT NULL DEFAULT '0',
  `nightly_workflow_enabled` smallint unsigned NOT NULL DEFAULT '0' COMMENT '1 if nightly release schedule should be used instead of legacy',
  `nightly_workflow_schedule` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '21:00',
  PRIMARY KEY (`app_id`),
  KEY `name` (`name`),
  KEY `platform_type` (`platform_type`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_bitrise_artifacts` (
  `artifact_id` bigint unsigned NOT NULL,
  `nightly_build_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `bitrise_app_slug` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bitrise_build_slug` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bitrise_artifact_slug` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bitrise_artifact_title` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration_date` int unsigned NOT NULL,
  PRIMARY KEY (`artifact_id`),
  KEY `nightly_build_id` (`nightly_build_id`),
  KEY `create_date` (`create_date`),
  KEY `expiration_date` (`expiration_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_nightly_builds` (
  `build_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `git_sha` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `build_type` int NOT NULL,
  `build_version` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `build_status` int NOT NULL,
  PRIMARY KEY (`build_id`),
  KEY `app_id` (`app_id`),
  KEY `update_date` (`update_date`),
  KEY `build_type` (`build_type`),
  KEY `build_version` (`build_version`),
  KEY `build_status` (`build_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_audit_events` (
  `release_audit_event_id` bigint unsigned NOT NULL,
  `release_id` bigint unsigned NOT NULL,
  `state` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`release_audit_event_id`),
  KEY `release_id` (`release_id`),
  KEY `state` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_build_variants` (
  `build_id` bigint unsigned NOT NULL,
  `release_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `git_sha` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `build_status` int NOT NULL,
  `build_type` int NOT NULL,
  PRIMARY KEY (`build_id`),
  KEY `release_id` (`release_id`),
  KEY `app_id` (`app_id`),
  KEY `update_date` (`update_date`),
  KEY `build_version` (`build_version`),
  KEY `build_status` (`build_status`),
  KEY `build_type` (`build_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_image_diffs` (
  `release_image_diff_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `release_image_primary_id` bigint unsigned NOT NULL,
  `release_image_secondary_id` bigint unsigned NOT NULL,
  `primary_sha` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secondary_sha` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` int NOT NULL,
  `primary_build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secondary_build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`release_image_diff_id`),
  KEY `release_image_primary_id` (`release_image_primary_id`),
  KEY `release_image_secondary_id` (`release_image_secondary_id`),
  KEY `primary_sha` (`primary_sha`),
  KEY `secondary_sha` (`secondary_sha`),
  KEY `primary_build_version` (`primary_build_version`),
  KEY `secondary_build_version` (`secondary_build_version`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_images` (
  `release_id` bigint unsigned NOT NULL,
  `release_image_id` bigint unsigned NOT NULL,
  `git_sha` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` int NOT NULL,
  `os_version` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_landscape` int NOT NULL,
  `language` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `screenshot_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`release_id`,`release_image_id`),
  KEY `device` (`device`),
  KEY `platform` (`platform`),
  KEY `os_version` (`os_version`),
  KEY `is_landscape` (`is_landscape`),
  KEY `screenshot_name` (`screenshot_name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `build_version` (`build_version`),
  KEY `app_id` (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_staff` (
  `release_staff_id` bigint unsigned NOT NULL,
  `release_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `change_state` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `subscription` int NOT NULL,
  `onboard_sent_at` int unsigned NOT NULL DEFAULT '0',
  `last_subscription_change_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`app_id`,`release_id`,`release_staff_id`),
  UNIQUE KEY `staff_id_2` (`staff_id`,`release_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_release_staff_history` (
  `release_staff_history_id` bigint unsigned NOT NULL,
  `release_staff_id` bigint unsigned NOT NULL,
  `release_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `change_state` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `subscription` int NOT NULL,
  `onboard_sent_at` int unsigned NOT NULL DEFAULT '0',
  `last_subscription_change_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`app_id`,`release_id`,`release_staff_id`,`release_staff_history_id`),
  KEY `staff_id` (`staff_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_releases` (
  `release_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `parent_release_id` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `git_sha_start` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `git_branch_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` int NOT NULL,
  `freeze_date` int unsigned NOT NULL,
  `release_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `most_recent_release_build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `release_started_time` int NOT NULL DEFAULT '0',
  `crash_invite_sent_at` int NOT NULL DEFAULT '0',
  `driver_id` bigint unsigned NOT NULL DEFAULT '0',
  `automation_bitfield` int unsigned NOT NULL DEFAULT '0',
  `driver_state` int NOT NULL,
  `driver_state_update_date` int unsigned NOT NULL,
  `version_compare` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`app_id`,`release_id`),
  KEY `parent_release_id` (`parent_release_id`),
  KEY `freeze_date` (`freeze_date`),
  KEY `release_date` (`release_date`),
  KEY `update_date` (`update_date`),
  KEY `driver_state` (`driver_state`),
  KEY `driver_state_update_date` (`driver_state_update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ship_releases_history` (
  `release_history_id` bigint unsigned NOT NULL,
  `release_id` bigint unsigned NOT NULL,
  `app_id` bigint unsigned NOT NULL,
  `parent_release_id` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `git_sha_start` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `git_branch_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` int NOT NULL,
  `freeze_date` int unsigned NOT NULL,
  `release_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `most_recent_release_build_version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `release_started_time` int NOT NULL DEFAULT '0',
  `crash_invite_sent_at` int NOT NULL DEFAULT '0',
  `driver_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`app_id`,`release_id`,`release_history_id`),
  KEY `parent_release_id` (`parent_release_id`),
  KEY `freeze_date` (`freeze_date`),
  KEY `release_date` (`release_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_carrier_downtime` (
  `carrier_id` bigint unsigned NOT NULL,
  `downtime_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `message` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Message displayed to sellers on the site.',
  `note` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The internal notes.',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`carrier_id`,`downtime_id`),
  KEY `unexpired_idx` (`carrier_id`,`is_deleted`,`end_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_carrier_fuel_surcharge` (
  `carrier_fuel_surcharge_id` bigint unsigned NOT NULL,
  `carrier_id` smallint unsigned NOT NULL,
  `surcharge_date` int unsigned NOT NULL,
  `surcharge_key` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `surcharge_percent` decimal(10,6) NOT NULL,
  PRIMARY KEY (`carrier_fuel_surcharge_id`),
  KEY `carrier_surcharge` (`carrier_id`,`surcharge_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_carrier_suspended_countries` (
  `carrier_id` bigint unsigned NOT NULL,
  `country_id` bigint unsigned NOT NULL,
  `suspend_reason` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Key to suspend reason.',
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`carrier_id`,`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_daily_rollup` (
  `date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `labels` int NOT NULL DEFAULT '0',
  `total_express` int NOT NULL DEFAULT '0',
  `total_priority` int NOT NULL DEFAULT '0',
  `total_first_class` int NOT NULL DEFAULT '0',
  `total_parcel_post` int NOT NULL DEFAULT '0',
  `total_media_mail` int NOT NULL DEFAULT '0',
  `total_first_class_international` int NOT NULL DEFAULT '0',
  `total_priority_international` int NOT NULL DEFAULT '0',
  `total_express_international` int NOT NULL DEFAULT '0',
  `total_insured` int NOT NULL DEFAULT '0',
  `total_signature_confirmation` int NOT NULL DEFAULT '0',
  `total_postage_cost` int NOT NULL DEFAULT '0',
  `avg_postage_cost` float NOT NULL DEFAULT '0',
  `total_etsy_postage_cost` int NOT NULL DEFAULT '0',
  `avg_etsy_postage_cost` float NOT NULL DEFAULT '0',
  `total_insured_fee` int NOT NULL DEFAULT '0',
  `total_etsy_insured_fee` int NOT NULL DEFAULT '0',
  `avg_insured_fee` float NOT NULL DEFAULT '0',
  `total_postage_and_fees` int NOT NULL DEFAULT '0',
  `refund_submitted` int NOT NULL DEFAULT '0',
  `refund_applied` int NOT NULL DEFAULT '0',
  `refund_denied` int NOT NULL DEFAULT '0',
  `refund_submitted_postage` int NOT NULL DEFAULT '0',
  `refund_applied_postage` int NOT NULL DEFAULT '0',
  `refund_denied_postage` int NOT NULL DEFAULT '0',
  `shops_onboarded` int NOT NULL DEFAULT '0',
  `unique_shops` int NOT NULL DEFAULT '0',
  `delivered_shipments` int NOT NULL DEFAULT '0',
  `onboarded_shops_with_label` int NOT NULL DEFAULT '0',
  `ml_orders` int NOT NULL DEFAULT '0',
  `first_labels` int NOT NULL DEFAULT '0',
  `eligible_receipts` int NOT NULL DEFAULT '0',
  `total_first_class_16` int NOT NULL DEFAULT '0',
  `first_class_etsy_cost` int NOT NULL DEFAULT '0',
  `first_class_16_etsy_cost` int NOT NULL DEFAULT '0',
  `first_class_cost` int NOT NULL DEFAULT '0',
  `first_class_16_cost` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_daily_rollup_cp` (
  `date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `labels` int NOT NULL DEFAULT '0',
  `total_priority` int NOT NULL DEFAULT '0',
  `total_xpresspost` int NOT NULL DEFAULT '0',
  `total_expedited_parcel` int NOT NULL DEFAULT '0',
  `total_xpresspost_usa` int NOT NULL DEFAULT '0',
  `total_expedited_parcel_usa` int NOT NULL DEFAULT '0',
  `total_small_packet_usa` int NOT NULL DEFAULT '0',
  `total_tracked_packet_usa` int NOT NULL DEFAULT '0',
  `total_light_packet_usa` int NOT NULL DEFAULT '0',
  `total_xpresspost_international` int NOT NULL DEFAULT '0',
  `total_international_parcel_air` int NOT NULL DEFAULT '0',
  `total_international_parcel_surface` int NOT NULL DEFAULT '0',
  `total_small_packet_international_air` int NOT NULL DEFAULT '0',
  `total_small_packet_international_surface` int NOT NULL DEFAULT '0',
  `total_tracked_packet_international` int NOT NULL DEFAULT '0',
  `total_light_packet_international` int NOT NULL DEFAULT '0',
  `total_insured` int NOT NULL DEFAULT '0',
  `total_insured_fee` int NOT NULL DEFAULT '0',
  `total_postage` int NOT NULL DEFAULT '0',
  `total_fees` int NOT NULL DEFAULT '0',
  `total_taxes` int NOT NULL DEFAULT '0',
  `total_label_cost` int NOT NULL DEFAULT '0',
  `avg_label_cost` float NOT NULL DEFAULT '0',
  `total_etsy_label_cost` int NOT NULL DEFAULT '0',
  `avg_etsy_label_cost` float NOT NULL DEFAULT '0',
  `refund_submitted` int NOT NULL DEFAULT '0',
  `refund_applied` int NOT NULL DEFAULT '0',
  `refund_denied` int NOT NULL DEFAULT '0',
  `refund_submitted_postage` int NOT NULL DEFAULT '0',
  `refund_applied_postage` int NOT NULL DEFAULT '0',
  `refund_denied_postage` int NOT NULL DEFAULT '0',
  `shops_onboarded` int NOT NULL DEFAULT '0',
  `unique_shops` int NOT NULL DEFAULT '0',
  `delivered_shipments` int NOT NULL DEFAULT '0',
  `onboarded_shops_with_label` int NOT NULL DEFAULT '0',
  `ml_orders` int NOT NULL DEFAULT '0',
  `first_labels` int NOT NULL DEFAULT '0',
  `eligible_receipts` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_internal` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_order_tracking_stats` (
  `date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total_updated` int NOT NULL DEFAULT '0',
  `with_tracking` int NOT NULL DEFAULT '0',
  `without_tracking` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_provider_tracking_stats` (
  `date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `provider_id` bigint unsigned NOT NULL DEFAULT '0',
  `total_tracking_numbers` int NOT NULL DEFAULT '0',
  `international` int NOT NULL DEFAULT '0',
  `domestic` int NOT NULL DEFAULT '0',
  `has_events` int NOT NULL DEFAULT '0',
  `no_events` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`date`,`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_totals` (
  `metric` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_dashboard_totals_cp` (
  `metric` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_label_analysis_custom_rate_sets` (
  `custom_rate_set_id` bigint unsigned NOT NULL,
  `provider_id` smallint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`custom_rate_set_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `admin_id` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_label_analysis_reratings` (
  `rerating_id` bigint unsigned NOT NULL,
  `provider_id` smallint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_records` int unsigned NOT NULL DEFAULT '0',
  `rerated_records` int unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `run_start_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rerating_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `admin_id` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_label_seller_credit_campaigns` (
  `campaign_id` bigint unsigned NOT NULL,
  `campaign_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_id` int unsigned NOT NULL DEFAULT '0',
  `budget` int unsigned NOT NULL COMMENT 'the budget in USD',
  `spend` int unsigned NOT NULL DEFAULT '0' COMMENT 'the spend in USD',
  `credit_amount` int unsigned NOT NULL COMMENT 'the credit amount in credit_amount_currency_code',
  `credit_amount_currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD' COMMENT 'the currency code of the credit (may be different than budget and spend due to USD billing)',
  `start_date` int unsigned NOT NULL,
  `expiration_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `campaign_name` (`campaign_name`),
  KEY `carrier_start_expiration_idx` (`carrier_id`,`start_date`,`expiration_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_label_tracking_code_map` (
  `tracking_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_id` int unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_code`,`carrier_id`),
  KEY `shop_id` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_provider_downtime` (
  `provider_id` bigint unsigned NOT NULL,
  `downtime_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `message` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Message displayed to sellers on the site.',
  `note` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The internal notes.',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `is_unexpected_downtime` tinyint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`provider_id`,`downtime_id`),
  KEY `unexpired_idx` (`provider_id`,`is_deleted`,`end_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shippo_tracking_code_map` (
  `tracking_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_id` int unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_code`),
  KEY `shop_id` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shiprocket_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_url` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INR',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shiprocket_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_purchase_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'etsy supplied raw field from CSV file',
  `company_id` int unsigned NOT NULL DEFAULT '0',
  `awb_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'order_id raw field from CSV file',
  `invoice_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'invoice number raw field from CSV file',
  `courier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `billed_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `applied_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `charged_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `freight_cost` int unsigned NOT NULL DEFAULT '0',
  `gst` int unsigned NOT NULL DEFAULT '0',
  `billing_amount` int unsigned NOT NULL DEFAULT '0',
  `forward_charges` int unsigned NOT NULL DEFAULT '0',
  `rto_charges` int unsigned NOT NULL DEFAULT '0',
  `cod_charges` int unsigned NOT NULL DEFAULT '0',
  `cod_adjusted` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INR',
  `shipping_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_address_line_1` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_address_line_2` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_state` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_pincode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_country` int unsigned NOT NULL DEFAULT '0',
  `shipment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payment_method` tinyint unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `quantity` int unsigned NOT NULL DEFAULT '0',
  `original_awb_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_zone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_item_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `awb_assigned_date` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `order_id` bigint unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `shop_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `order_id` (`order_id`),
  KEY `awb_code` (`awb_code`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shiprocket_order_id_map` (
  `shiprocket_order_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`shiprocket_order_id`,`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_analytics_banner_options` (
  `banner_options_id` bigint unsigned NOT NULL,
  `msg_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `msg_source` smallint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`banner_options_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_analytics_current_banner` (
  `current_banner_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `banner_options_id` bigint unsigned DEFAULT NULL,
  `msg_variables` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `etsymodel_staff_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`current_banner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_analytics_latest_version_id` (
  `hdfs_path` varchar(190) NOT NULL,
  `model_name` varchar(190) NOT NULL,
  `version_id` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`model_name`(64),`version_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_identity_problems` (
  `shop_id` bigint unsigned NOT NULL COMMENT 'shop identifier of the shop this identity belongs to',
  `identity_problem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'the problem with the shops identity',
  `problem_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'the status of the identity problem',
  `create_date` int NOT NULL DEFAULT '0' COMMENT 'record creation date in epoch time',
  `update_date` int NOT NULL DEFAULT '0' COMMENT 'date record last updated in epoch time',
  PRIMARY KEY (`shop_id`,`identity_problem`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_id_idx` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_loi` (
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `unique_sale_months` int unsigned NOT NULL DEFAULT '0',
  `tenure_percentile` int unsigned NOT NULL DEFAULT '0',
  `loi` varchar(127) NOT NULL DEFAULT '',
  `tenure_attribute` varchar(127) NOT NULL DEFAULT '',
  `lifetime_gms_attribute` varchar(127) NOT NULL DEFAULT '',
  `last_year_gms_attribute` varchar(127) NOT NULL DEFAULT '',
  `calculation_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `loi_idx` (`loi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_metrics` (
  `run_date` int NOT NULL DEFAULT '0',
  `stat_date` int NOT NULL DEFAULT '0',
  `stat_name` varchar(255) NOT NULL DEFAULT '',
  `stat_value` float(20,2) NOT NULL DEFAULT '0.00',
  `facet_type` varchar(255) NOT NULL DEFAULT 'none',
  `facet_value` varchar(255) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`stat_name`,`stat_date`,`facet_type`,`facet_value`),
  KEY `stat_date` (`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_metrics_event` (
  `event_date` int NOT NULL DEFAULT '0',
  `event_name` varchar(255) NOT NULL DEFAULT '',
  `event_group` varchar(255) DEFAULT 'general',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_name`,`event_date`),
  KEY `event_date` (`event_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_namechange_request` (
  `shop_namechange_request_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `current_name` varchar(255) NOT NULL,
  `requested_name` varchar(255) NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `request_reason_id` int NOT NULL DEFAULT '0',
  `deny_reason_id` int NOT NULL DEFAULT '0',
  `user_notes` text,
  `admin_notes` text,
  `admin_id` bigint unsigned DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `resolution_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`,`shop_namechange_request_id`),
  UNIQUE KEY `shop_namechange_request_id_idx` (`shop_namechange_request_id`),
  KEY `idx_status_date` (`status`,`create_date`),
  KEY `idx_requested_name` (`requested_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_shipping_label_batch` (
  `batch_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `label_count` int unsigned NOT NULL,
  `success_count` int unsigned NOT NULL DEFAULT '0',
  `error_count` int unsigned NOT NULL DEFAULT '0',
  `state_created_date` int unsigned NOT NULL,
  `state_complete_date` int unsigned NOT NULL DEFAULT '0',
  `state_dismissed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `shop_id` (`shop_id`),
  KEY `state` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_shipping_queued_label` (
  `queued_label_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `batch_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `num_attempts` tinyint unsigned NOT NULL DEFAULT '0',
  `error_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `carrier_id` int unsigned NOT NULL,
  `receipt_id` bigint unsigned NOT NULL,
  `api_shipment_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_created_date` int unsigned NOT NULL,
  `state_pending_date` int unsigned NOT NULL DEFAULT '0',
  `state_running_date` int unsigned NOT NULL DEFAULT '0',
  `state_retry_date` int unsigned NOT NULL DEFAULT '0',
  `state_complete_date` int unsigned NOT NULL DEFAULT '0',
  `purchase_session_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Helps us group purchase failures together if needed',
  `request_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'eg Mobile, Web',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`queued_label_id`),
  KEY `shop_id` (`shop_id`),
  KEY `batch_id` (`batch_id`),
  KEY `receipt_id` (`receipt_id`),
  KEY `state_carrier_idx` (`state`,`carrier_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_shipping_yakit_merchant` (
  `shop_id` bigint unsigned NOT NULL,
  `merchant_id` int unsigned NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `portal_url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `docs_uploaded` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'enum indicating rough number of documents uploaded on Yakit portal',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`),
  UNIQUE KEY `merchant_id` (`merchant_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_backup_country` (
  `shop_id` bigint unsigned NOT NULL,
  `view_type` smallint NOT NULL,
  `view_id` bigint NOT NULL,
  `reference_timestamp` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `country_code` varchar(2) NOT NULL,
  `hit_count` int DEFAULT '0',
  `sales` int DEFAULT '0',
  `quantity` int DEFAULT '0',
  `revenue` int DEFAULT '0',
  `table_type` tinyint NOT NULL,
  `part_key` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`reference_timestamp`,`view_id`,`view_type`,`country_code`,`table_type`,`part_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_backup_domain` (
  `shop_id` bigint unsigned NOT NULL,
  `view_type` smallint NOT NULL,
  `view_id` int NOT NULL,
  `reference_timestamp` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `domain` varchar(255) NOT NULL,
  `domain_source` varchar(64) NOT NULL DEFAULT '',
  `hit_count` int DEFAULT '0',
  `table_type` tinyint NOT NULL,
  `part_key` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`reference_timestamp`,`domain`,`view_id`,`view_type`,`domain_source`,`table_type`,`part_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_backup_search_query` (
  `shop_id` bigint unsigned NOT NULL,
  `search_type` smallint NOT NULL,
  `view_id` int NOT NULL,
  `reference_timestamp` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `search_engine_domain` varchar(255) NOT NULL,
  `query_hash` varchar(32) NOT NULL,
  `hit_count` int DEFAULT '0',
  `table_type` tinyint NOT NULL,
  `part_key` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`reference_timestamp`,`search_engine_domain`,`query_hash`,`view_id`,`search_type`,`table_type`,`part_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_backup_syndication` (
  `shop_id` bigint unsigned NOT NULL,
  `view_type` smallint NOT NULL,
  `view_id` int NOT NULL,
  `reference_timestamp` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `syndication_source` varchar(255) NOT NULL,
  `syndication_source_type` smallint NOT NULL,
  `hit_count` int DEFAULT '0',
  `table_type` tinyint NOT NULL,
  `part_key` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`reference_timestamp`,`syndication_source`,`view_id`,`view_type`,`syndication_source_type`,`table_type`,`part_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_global_downtime` (
  `downtime_start` int NOT NULL,
  `downtime_duration` int NOT NULL,
  `status` smallint NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`downtime_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_migration_task_tracker` (
  `run_id` bigint NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `task_start_ts` int NOT NULL,
  `task_end_ts` int NOT NULL,
  `status` int NOT NULL,
  `row_count` int NOT NULL DEFAULT '0',
  `log` longtext,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`run_id`,`shop_id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_migration_tracker` (
  `run_id` bigint NOT NULL,
  `status` int NOT NULL,
  `source_shard` int NOT NULL,
  `partition_name` varchar(255) NOT NULL,
  `partition_description` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_s3_rebake_task_tracker` (
  `run_id` bigint NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `status` int NOT NULL,
  `log` longtext,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`run_id`,`shop_id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_s3_rebake_tracker` (
  `run_id` bigint NOT NULL,
  `status` int NOT NULL,
  `shard` int NOT NULL,
  `resolution` varchar(20) NOT NULL,
  `start_ts` int NOT NULL,
  `end_ts` int NOT NULL,
  `bake_description` longtext NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_stats_search_query_map` (
  `query_hash` varchar(32) NOT NULL,
  `raw_query` varchar(2048) NOT NULL,
  PRIMARY KEY (`query_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_suggestions` (
  `shop_suggestion_id` bigint unsigned NOT NULL,
  `next_shop_suggestion_id` bigint unsigned DEFAULT NULL,
  `next_shop_suggestion_delay` int unsigned NOT NULL DEFAULT '0',
  `segment_data_url` varchar(1024) NOT NULL,
  `segment_description` varchar(512) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL,
  `description` varchar(1024) NOT NULL DEFAULT '',
  `action_url` varchar(1024) NOT NULL,
  `action_text` varchar(32) NOT NULL,
  `category` tinyint unsigned NOT NULL DEFAULT '0',
  `priority` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned DEFAULT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `duration` int NOT NULL DEFAULT '-1',
  `type` int NOT NULL DEFAULT '0',
  `dismissal_duration` int NOT NULL DEFAULT '0',
  `image_url` varchar(1024) NOT NULL DEFAULT '',
  `image_url_2` varchar(1024) NOT NULL DEFAULT '',
  `target_platform` int unsigned NOT NULL DEFAULT '65535',
  `campaign` varchar(190) NOT NULL DEFAULT '',
  `last_extracted_hash` varchar(32) NOT NULL DEFAULT '',
  `duration_type` tinyint NOT NULL DEFAULT '1',
  `target_languages` varchar(64) NOT NULL DEFAULT '["en-GB","es","fr","it","nl","pl","ja","de","ru","pt"]',
  `zone` tinyint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_suggestion_id`),
  KEY `start_date_idx` (`start_date`),
  KEY `end_date_idx` (`end_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `type` (`type`,`create_date`),
  KEY `status_category_start_date_idx` (`status`,`category`,`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_suggestions_salequickaction_map` (
  `shop_suggestion_salequickaction_map_id` bigint unsigned NOT NULL,
  `shop_suggestion_id` bigint unsigned NOT NULL DEFAULT '0',
  `sale_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_suggestion_salequickaction_map_id`),
  KEY `ss_idx` (`shop_suggestion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='This table relates a salequickaction to a shop_suggestion';

CREATE TABLE `shop_task_types` (
  `task_type_id` bigint unsigned NOT NULL,
  `goal_type_id` tinyint unsigned NOT NULL COMMENT 'Uses php defined Enum GoalTypeId',
  `task_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `eligibility_source` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Column in rollup which determines if task is shown to shop',
  `priority` tinyint unsigned NOT NULL COMMENT 'Defines order in which tasks are shown',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_type_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sitemap_url_count` (
  `date_of_count` int unsigned NOT NULL,
  `sitemap_type` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Sitemap type e.g. local-listing, shop-local, etc.',
  `subdirectory` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Subdirectory/hreflang e.g. ca, uk, in-en, jp, etc.',
  `url_count` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Provides a way to soft delete entries',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`date_of_count`,`sitemap_type`,`subdirectory`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Compiles daily sitemap url count by type and subdirectory';

CREATE TABLE `sniffd_heartbeats_aux` (
  `heartbeats_id` bigint unsigned NOT NULL,
  `machine_id` bigint unsigned NOT NULL,
  `heartbeats` bigint unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`heartbeats_id`,`machine_id`),
  UNIQUE KEY `machine_id_idx` (`machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `social_marketing_hero_banner` (
  `hero_id` bigint unsigned NOT NULL,
  `title` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tip_body` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `suggested_post_text` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `suggested_post_hashtags` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_image_id` bigint unsigned NOT NULL,
  `utm_content` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `segment_data_url` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL,
  `segment_description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `priority` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `primary_image_url` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`hero_id`),
  KEY `start_date_idx` (`start_date`),
  KEY `end_date_idx` (`end_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `social_marketing_hero_banner_additional_images` (
  `hero_id` bigint unsigned NOT NULL,
  `image_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `image_url` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`hero_id`,`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `song_library` (
  `song_library_id` bigint unsigned NOT NULL,
  `artist` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `genre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `song_title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `album_title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`song_library_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `song_provider_mapping` (
  `song_mapping_id` bigint unsigned NOT NULL,
  `provider_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `song_identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `song_library_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`song_mapping_id`),
  KEY `provider_and_song_idx` (`provider_name`,`song_identifier`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `space_entity` (
  `space_id` bigint unsigned NOT NULL,
  `space_name` text,
  `slug` text,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `state` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'draft/published/deleted or some other future state',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`space_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `space_merch_collection` (
  `space_merch_collection_id` bigint unsigned NOT NULL,
  `space_id` bigint unsigned NOT NULL,
  `merch_collection_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`space_id`,`merch_collection_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_entity` (
  `entity_id` bigint unsigned NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_id` bigint unsigned NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `valid_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `parent_external_id` bigint DEFAULT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_id`),
  UNIQUE KEY `unique_external_id` (`type`,`external_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `auth_username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `prefix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `middle_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `nickname` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `suffix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `real_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pronouns` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gender` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `enabled` tinyint unsigned NOT NULL DEFAULT '0',
  `human` tinyint unsigned NOT NULL DEFAULT '1',
  `ambrose_employee_id` int unsigned NOT NULL DEFAULT '0',
  `department_id` int unsigned NOT NULL DEFAULT '0',
  `job_function_id` int unsigned NOT NULL DEFAULT '0',
  `job_level_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `employee_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `join_date` int unsigned NOT NULL DEFAULT '0',
  `fulltime_date` int unsigned NOT NULL DEFAULT '0',
  `original_hire_date` int unsigned NOT NULL DEFAULT '0',
  `temp_join_date` int unsigned NOT NULL DEFAULT '0',
  `manager_auth_username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `team` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `office` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `desk_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `cell_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `home_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `skype` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pager_email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `irc_nick` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `login_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shop_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `twitter` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `github` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `linkedin` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `message` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailinglists` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `superpowers` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `referrer` tinyint unsigned NOT NULL DEFAULT '0',
  `languages` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `skills` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `mac_address` varchar(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `t_shirt_size` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sweatshirt_size` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `should_display_awards` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'boolean; 1 = enabled and shows on profile, 0 = hidden',
  `scoreboard_optin` tinyint DEFAULT '0',
  `last_seen_at` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `default_image_key` bigint DEFAULT NULL,
  `birthday` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workday_employee_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `termination_date` int unsigned NOT NULL DEFAULT '0',
  `onboarded` tinyint NOT NULL DEFAULT '0',
  `org` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dept` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `workday_group` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slack_nick` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slack_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phonetic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zendesk_id` bigint unsigned DEFAULT '0',
  `workday_groups` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `workday_squads` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `workday_initiatives` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `jira_account_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_username` (`auth_username`),
  KEY `email_index` (`email`),
  KEY `manager_auth_username_index` (`manager_auth_username`),
  KEY `users_create_date_idx` (`create_date`),
  KEY `users_update_date_idx` (`update_date`),
  KEY `team_index` (`team`),
  KEY `enabled_human_idx` (`enabled`,`human`),
  KEY `zendesk_id_idx` (`zendesk_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `workday_employee_id_idx` (`workday_employee_id`),
  KEY `jira_account_id_idx` (`jira_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_images` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `image_url` varchar(127) DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `image_key` varchar(127) DEFAULT NULL,
  `type` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_preferences` (
  `staff_id` bigint NOT NULL,
  `namespace` varchar(32) NOT NULL DEFAULT '',
  `preference` varchar(32) NOT NULL DEFAULT '',
  `value` varchar(1024) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`namespace`,`preference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_roles` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `role_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`role_id`),
  KEY `role_id_idx` (`role_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_roles_audit` (
  `staff_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `audit_id` bigint unsigned NOT NULL,
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`staff_id`,`role_id`,`audit_id`),
  KEY `role_staff_idx` (`role_id`,`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_team` (
  `id` bigint unsigned NOT NULL,
  `team_slug` varchar(40) NOT NULL,
  `team_name` varchar(128) NOT NULL,
  `team_long_name` varchar(255) DEFAULT NULL,
  `is_project` tinyint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `creator_username` varchar(128) DEFAULT NULL,
  `description` text,
  `team_urls` text,
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  `team_email` varchar(128) DEFAULT NULL,
  `team_irc_channel` varchar(64) DEFAULT NULL,
  `team_irc_alert` varchar(32) DEFAULT NULL,
  `team_location` varchar(160) DEFAULT NULL,
  `team_type` varchar(32) DEFAULT NULL,
  `parent_team_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_slug` (`team_slug`),
  KEY `is_project` (`is_project`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Describe teams in the staff directory';

CREATE TABLE `staff_teammembership` (
  `team_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`team_id`,`staff_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Team memberships for staff';

CREATE TABLE `story_tag` (
  `tag_id` bigint unsigned NOT NULL,
  `tag_name` varchar(40) DEFAULT NULL,
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Tags for member stories';

CREATE TABLE `strike_categories` (
  `category_id` bigint unsigned NOT NULL,
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Main category for the strike, ie prohibited, counterfeit',
  `subcategory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Secondary category for the strike, ie drugs, amber',
  `point_value` int unsigned NOT NULL COMMENT 'How many points this strike is worth',
  `grace_period` int unsigned NOT NULL COMMENT 'Number of days before this strike will count',
  `active_days` int unsigned NOT NULL DEFAULT '365' COMMENT 'Number of days before strike will no longer count',
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_subcategory` (`category`,`subcategory`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Categories for user strikes';

CREATE TABLE `style` (
  `style_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(45) DEFAULT NULL,
  `order` int unsigned DEFAULT NULL,
  `suggested` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `language` tinyint DEFAULT '0',
  PRIMARY KEY (`style_id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `suggested` (`suggested`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `subtask` (
  `subtask_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `count` int unsigned NOT NULL DEFAULT '0',
  `task_data` text COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`subtask_id`),
  KEY `task_idx` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_favorites` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`report_id`),
  KEY `report_id_idx` (`report_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `query_id_idx` (`query_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_frequencies` (
  `frequency_id` bigint unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `min` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 59',
  `hour` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 23',
  `day_of_month` varchar(32) NOT NULL DEFAULT '' COMMENT '1 - 31',
  `month` varchar(32) NOT NULL DEFAULT '' COMMENT '1 - 12',
  `day_of_week` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 7; Sunday=0 or 7',
  `year` varchar(32) NOT NULL DEFAULT '' COMMENT 'optional',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`frequency_id`),
  KEY `rendered_id_idx` (`report_id`),
  KEY `time_idx` (`min`,`hour`,`day_of_month`,`month`,`day_of_week`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_queries` (
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `description` longtext NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext NOT NULL,
  `custom_parameters` longtext NOT NULL COMMENT 'user defined parameters',
  `formal_parameters` longtext NOT NULL COMMENT 'may not use, would hold the variables in the query',
  `last_run_id` bigint unsigned NOT NULL DEFAULT '0',
  `last_run_status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `last_run_date` int unsigned NOT NULL DEFAULT '0',
  `current_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `notes` longtext NOT NULL,
  `datafeed_enabled` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `flagged_stale` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`query_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `status_idx` (`status`),
  KEY `category_idx` (`category`),
  KEY `team_idx` (`team`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_reports` (
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `actual_parameters` longtext NOT NULL COMMENT 'json variable replacement',
  `parameters_md5` varchar(32) NOT NULL DEFAULT '' COMMENT 'params hash',
  `last_run_id` bigint unsigned NOT NULL DEFAULT '0',
  `last_run_status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failure',
  `last_run_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_id`),
  KEY `queryt_md5_idx` (`query_id`,`parameters_md5`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_results` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `result` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_revisions` (
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `description` longtext NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext NOT NULL,
  `custom_parameters` longtext NOT NULL COMMENT 'user defined parameters',
  `formal_parameters` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`revision_id`),
  KEY `query_id_idx` (`query_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_runs` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `runtime` bigint unsigned NOT NULL DEFAULT '0',
  `result_count` int unsigned NOT NULL DEFAULT '0',
  `results_md5` varchar(32) NOT NULL DEFAULT '',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'scheduled,adhoc',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`),
  KEY `report_id_idx` (`report_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `query_id_idx` (`query_id`),
  KEY `revision_id_idx` (`revision_id`),
  KEY `type_idx` (`type`),
  KEY `status_idx` (`status`),
  KEY `create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_subscriptions` (
  `subscription_id` bigint unsigned NOT NULL DEFAULT '0',
  `email_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `frequency_id` bigint unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `options` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`subscription_id`),
  KEY `report_id_idx` (`report_id`),
  KEY `frequency_id_idx` (`frequency_id`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_visualization_images` (
  `visualization_id` bigint unsigned NOT NULL DEFAULT '0',
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `image_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`visualization_id`,`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_visualizations` (
  `visualization_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `description` varchar(4096) NOT NULL DEFAULT '',
  `spec` varchar(16384) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`visualization_id`),
  KEY `query_id_idx` (`query_id`),
  KEY `report_id_idx` (`report_id`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `survey_responses` (
  `response_id` bigint unsigned NOT NULL,
  `survey_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `platform` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `response` longtext COLLATE utf8mb4_unicode_ci,
  `time_submitted` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`response_id`,`survey_id`,`platform`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `task` (
  `task_id` bigint unsigned NOT NULL,
  `task_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int unsigned NOT NULL,
  `task_data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `complete_count` int unsigned NOT NULL DEFAULT '0',
  `total_count` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `delete_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `delete_date_idx` (`delete_date`),
  KEY `status_idx` (`status`,`owner_type`,`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_feedback` (
  `taxonomy_feedback_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `taxonomy_id` bigint unsigned NOT NULL,
  `submitter_id` bigint unsigned NOT NULL,
  `proposal_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `proposed_term` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `proposed_reason` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `affected_items` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `proposal_state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jira_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emergency_flag` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`taxonomy_feedback_id`),
  KEY `task_idx` (`task_id`),
  KEY `tax_idx` (`taxonomy_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_category` (
  `team_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `short_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`team_category_id`),
  UNIQUE KEY `mnemonic` (`mnemonic`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_category_audit` (
  `team_category_audit_id` bigint unsigned NOT NULL,
  `team_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `short_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `archive_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Only for display purposes in go/rci',
  PRIMARY KEY (`team_category_audit_id`),
  KEY `team_category_idx` (`team_category_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_pages_applications` (
  `application_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `page_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `page_slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `how_used` text COLLATE utf8mb4_general_ci,
  `questions` text COLLATE utf8mb4_general_ci,
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `application_status` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`application_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `user_id` (`user_id`),
  KEY `idx_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_account_favorites` (
  `staff_id` bigint unsigned NOT NULL,
  `test_account_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`staff_id`,`test_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_accounts` (
  `test_account_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `is_seller` int unsigned NOT NULL,
  `user_state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_email` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `is_email_confirmed` int unsigned NOT NULL,
  `shop_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_suspended_payments_mandate` int unsigned DEFAULT NULL,
  `is_vacation` int unsigned DEFAULT NULL,
  `currency_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_methods` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_purpose` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'manual_testing',
  `buy_count_status` int unsigned DEFAULT '0',
  `sold_count_status` int unsigned DEFAULT '0',
  `case_initiated_status` int unsigned DEFAULT '0',
  `case_against_status` int unsigned DEFAULT '0',
  `is_shipping_labels_enabled` int unsigned DEFAULT NULL,
  `is_custom_shop` int unsigned DEFAULT NULL,
  `is_private` int unsigned NOT NULL DEFAULT '0',
  `is_promoted_listings` int unsigned DEFAULT NULL,
  `is_etsy_ads` int unsigned DEFAULT NULL,
  `is_tiered_seller` int unsigned DEFAULT NULL,
  `is_deleted` int unsigned DEFAULT NULL,
  `shop_listing_counts` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `shop_setting_location` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shop_card_location` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shop_bank_location` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shop_address_location` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `rank_score` float(10,8) NOT NULL DEFAULT '0.00000000',
  `osa_shop_status` int DEFAULT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`test_account_id`),
  KEY `is_seller_index` (`is_seller`),
  KEY `user_state_index` (`user_state`),
  KEY `is_email_confirmed_index` (`is_email_confirmed`),
  KEY `shop_status_index` (`shop_status`),
  KEY `is_suspended_payments_mandate_index` (`is_suspended_payments_mandate`),
  KEY `is_vacation_index` (`is_vacation`),
  KEY `currency_code_index` (`currency_code`),
  KEY `payment_methods_index` (`payment_methods`),
  KEY `is_shipping_labels_enabled_index` (`is_shipping_labels_enabled`),
  KEY `is_custom_shop_index` (`is_custom_shop`),
  KEY `is_private_index` (`is_private`),
  KEY `is_promoted_listings_index` (`is_promoted_listings`),
  KEY `is_etsy_ads_index` (`is_etsy_ads`),
  KEY `is_tiered_seller_index` (`is_tiered_seller`),
  KEY `is_deleted_index` (`is_deleted`),
  KEY `buy_count_status_index` (`buy_count_status`),
  KEY `sold_count_status_index` (`sold_count_status`),
  KEY `case_initiated_status_index` (`case_initiated_status`),
  KEY `case_against_status_index` (`case_against_status`),
  KEY `shop_setting_location_index` (`shop_setting_location`),
  KEY `shop_card_location_index` (`shop_card_location`),
  KEY `shop_bank_location_index` (`shop_bank_location`),
  KEY `shop_address_location_index` (`shop_address_location`),
  KEY `rank_score_index` (`rank_score`),
  KEY `account_purpose_index` (`account_purpose`),
  KEY `update_date` (`update_date`),
  KEY `osa_shop_status_index` (`osa_shop_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `topics` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `aml_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_2` (`name`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_custom_group_constraints` (
  `id` bigint unsigned NOT NULL,
  `custom_group_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_group_id_index` (`custom_group_id`),
  KEY `type_value_index` (`type`,`value`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_custom_groups` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `message_set` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `assignments_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_role_assignments` (
  `user_id` bigint NOT NULL,
  `role` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role`,`language`),
  KEY `assignment_language_index` (`language`),
  KEY `assignment_role_index` (`role`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_run_info` (
  `attribute` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translator_assignment_messages` (
  `assignment_id` bigint unsigned NOT NULL,
  `md5` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latest_revision` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`assignment_id`,`item_name`,`md5`),
  KEY `item_name` (`item_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `twilio_message_notes` (
  `twilio_sid` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone_number` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `note` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`twilio_sid`),
  KEY `phone_number` (`phone_number`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ups_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `account_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'First part of filename',
  `invoice_date` int unsigned NOT NULL COMMENT 'Second part of filename',
  `invoice_number` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Last part of filename',
  `invoice_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ups_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipper_country_id` int unsigned NOT NULL DEFAULT '0',
  `bill_to_account_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bill_to_account_country_id` int unsigned NOT NULL DEFAULT '0',
  `service_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `account_level_charge` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_ref_1` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_ref_2` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_ref_3` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_ref_4` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `package_ref_5` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_reference_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_date` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `total_cost` int NOT NULL DEFAULT '0',
  `freight_charge` int NOT NULL DEFAULT '0',
  `fuel_charge` int NOT NULL DEFAULT '0',
  `shipment_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `shipment_weight_unit` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipment_height` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `shipment_width` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `shipment_length` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `shipment_dimension_unit` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `key_entered_weight` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `key_entered_weight_unit` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `key_entered_height` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `key_entered_width` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `key_entered_length` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `key_entered_dimension_unit` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipping_zone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_1_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_1` int NOT NULL,
  `additional_charge_2_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_2` int NOT NULL,
  `additional_charge_3_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_3` int NOT NULL,
  `additional_charge_4_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_4` int NOT NULL,
  `additional_charge_5_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_5` int NOT NULL,
  `additional_charge_6_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_6` int NOT NULL,
  `other_additional_charges` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `other_additional_charges_amount` int NOT NULL DEFAULT '0',
  `vat` int NOT NULL DEFAULT '0',
  `tax` int NOT NULL DEFAULT '0',
  `duty` int NOT NULL DEFAULT '0',
  `brokerage` int NOT NULL DEFAULT '0',
  `additional_charge_1_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_2_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_3_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_4_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_5_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `additional_charge_6_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `shop_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `tracking_number` (`tracking_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `used_names` (
  `used_name_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `reason_id` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`used_name_id`),
  KEY `idx_shop_id` (`shop_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_doc_check_file_uploads` (
  `user_doc_check_file_upload_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of file when we receive it',
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'MIME type max length is 254 if you can believe it',
  `file_size` int NOT NULL,
  `upload_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Should be SUCCESS, FAILED, ARCHIVED, or DELETED',
  `user_comments` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Seller comments about document',
  `deleted_by_admin_id` bigint unsigned NOT NULL DEFAULT '0',
  `archived_by_admin_id` bigint unsigned NOT NULL DEFAULT '0',
  `archived_notes` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `archived_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `document_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_country_id` int unsigned DEFAULT NULL,
  `verification_program` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kyc' COMMENT 'For what verification program document was uploaded',
  `valid_until` int unsigned DEFAULT NULL,
  PRIMARY KEY (`user_doc_check_file_upload_id`,`create_date`),
  KEY `user_id_index` (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `verification_program_index` (`verification_program`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_city_state_data` (
  `zip` char(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `frequency` smallint unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`zip`,`city`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed` (
  `data_feed_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `feed_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filename` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0' COMMENT 'may be unused; included to fit in Shipping Invoicing framework',
  `item_count` int unsigned NOT NULL DEFAULT '0' COMMENT 'may be unused; included to fit in Shipping Invoicing framework',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD' COMMENT 'may be unused; included to fit in Shipping Invoicing framework',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`data_feed_id`),
  KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `feed_state` (`feed_type`,`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_census_attributes` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `eps_transaction_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `first_scan_date` int unsigned NOT NULL DEFAULT '0',
  `impb` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Intelligent Mail Package Barcode',
  `electronic_file_number` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scan_weight_source` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scan_dim_source` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_mail_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scan_mail_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_weight` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `scan_weight` decimal(9,4) NOT NULL DEFAULT '0.0000',
  `manifest_length` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `scan_length` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_height` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `scan_height` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_width` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `scan_width` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `first_scan_zip` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_destination_zip` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_entry_facility` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `claimed_postage` decimal(10,2) NOT NULL DEFAULT '0.00',
  `assessed_postage` decimal(10,2) NOT NULL DEFAULT '0.00',
  `postage_variance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `upc_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `packaging` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_nonstandard_fee_len_threshold_1` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_nonstandard_fee_len_threshold_2` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_nonstandard_fee_vol_threshold` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `scan_nonstandard_fee_len_threshold_1` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `scan_nonstandard_fee_len_threshold_2` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `scan_nonstandard_fee_vol_threshold` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `noncompliance_fee` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `destination_country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'International only; blank for Canada and USA.',
  `base_sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `assessed_zone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `price_group` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ach_withdrawal_id` int unsigned NOT NULL DEFAULT '0',
  `customer_reference_1` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Shipping Label ID we provide to USPS',
  `customer_reference_2` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Shop ID we provide to USPS',
  `etsy_calculated_rate_delta` int NOT NULL DEFAULT '0' COMMENT 'Internal use only. Calculated by us if there is a mismatch between expected and actual rates.',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_duplicate_package_outbound` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `eps_transaction_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `tracking_number` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `crid` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `earliest_scan_date` int unsigned NOT NULL DEFAULT '0',
  `origin_zip_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_zip_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mail_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifested_postage` decimal(9,4) NOT NULL DEFAULT '0.0000',
  `usps_calculated_postage` decimal(9,4) NOT NULL DEFAULT '0.0000',
  `notification_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_duplicate_package_return` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `pic` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Package Identification Code',
  `crid` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mail_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_timestamp_of_original_scan` int unsigned NOT NULL DEFAULT '0',
  `first_timestamp_of_duplicate_scan` int unsigned NOT NULL DEFAULT '0',
  `destination_zip_code_of_original_scan` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_zip_code_of_duplicate_scan` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_activity_zip_code_of_original_scan` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_activity_zip_code_of_duplicate_scan` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dimensions` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `weight` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `duplicate_postage` decimal(10,2) NOT NULL DEFAULT '0.00',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_pricing_notification` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `package_scan_grouping_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `impb` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Intelligent Mail Package Barcode',
  `pic` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Package Identification Code',
  `service_type_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `origin_zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `weight` decimal(6,2) NOT NULL DEFAULT '0.00',
  `dimensions` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `upc_barcode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pricing_scan_completion_date_time` int unsigned NOT NULL DEFAULT '0',
  `eps_account_number` bigint unsigned NOT NULL DEFAULT '0',
  `eps_account_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `base_sku` varchar(27) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `price_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `nsa_contract_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `base_price` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `total_postage` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `assessed_rate_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `assessed_mail_class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `assessed_zone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `assessed_piece_weight_value` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `assessed_piece_dimensions_length` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `assessed_piece_dimensions_height` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `assessed_piece_dimensions_width` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `assessed_warnings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `earliest_scan_date` int unsigned NOT NULL DEFAULT '0',
  `permit_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `permit_type` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `permit_finance_number` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_nonstandard_fee_len_threshold_1` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_nonstandard_fee_len_threshold_2` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_nonstandard_fee_vol_threshold` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `destination_country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'International only; blank for Canada and USA.',
  `etsy_calculated_rate_delta` int NOT NULL DEFAULT '0' COMMENT 'Internal use only. Calculated by us if there is a mismatch between expected and actual rates.',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `impb` (`impb`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_transaction_return` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `eps_transaction_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `mail_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sku` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pic` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Package Identification Code',
  `service_type_code` smallint unsigned NOT NULL DEFAULT '0',
  `dispute_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dispute_id` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `transaction_date_time` int unsigned NOT NULL DEFAULT '0',
  `business_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destinating_eps_account_for_transfer` bigint unsigned NOT NULL DEFAULT '0',
  `originating_eps_account_for_transfer` bigint unsigned NOT NULL DEFAULT '0',
  `eps_account_number` bigint unsigned NOT NULL DEFAULT '0',
  `transaction_type` varchar(23) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payment_method` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `transaction_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `deposit_source` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `transfer_withdrawal_correction_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `original_transaction_id` bigint unsigned NOT NULL DEFAULT '0',
  `transaction_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ach_withdrawal_id` int unsigned NOT NULL DEFAULT '0',
  `due_date` int unsigned NOT NULL DEFAULT '0',
  `available_balance` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `invoice_number` bigint unsigned NOT NULL DEFAULT '0',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_unmanifested_package` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `tracking_number` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `earliest_scan_date` int unsigned NOT NULL DEFAULT '0',
  `first_scan_zip_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_zip_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mail_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `postage` decimal(9,4) NOT NULL DEFAULT '0.0000',
  `notification_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_data_feed_item_unused_label` (
  `data_feed_id` bigint unsigned NOT NULL,
  `data_feed_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'The state of the data feed item (indexed, processed, etc).',
  `record_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mailer_id` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `usage_indicator` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pic` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Package Identification Code',
  `customer_reference_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `electronic_file_number` varchar(34) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_of_mailing` int unsigned NOT NULL DEFAULT '0',
  `package_scan_date` int unsigned NOT NULL DEFAULT '0',
  `manifest_destination_zip_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scan_zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_mail_class` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_processing_category` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_routing_bar_code` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `manifest_weight` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `manifest_rate_indicator` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `unused_label_refund_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_code_1` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_1_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_code_2` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_2_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_code_3` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_3_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_code_4` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_4_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `extra_service_code_5` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `extra_service_5_amount` decimal(11,4) NOT NULL DEFAULT '0.0000',
  `reject_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `anomaly_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Internal use only. Description of why the item is in an anomalous state, if relevant.',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy Shop ID of associated label, if any.',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Internal use only. Etsy shipping label ID that is associated with feed item, if any.',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_anomaly_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_feed_id`,`data_feed_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `shop_shipping_label_idx` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_manifest_uploads` (
  `usps_manifest_upload_id` bigint unsigned NOT NULL,
  `record_type` smallint unsigned NOT NULL DEFAULT '0',
  `filename` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `file_size_bytes` int unsigned NOT NULL DEFAULT '0',
  `manifest_count` int unsigned NOT NULL DEFAULT '0',
  `shop_count` int unsigned NOT NULL DEFAULT '0',
  `label_count` int unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Only set when the manifest upload is for a USPS SCAN Form',
  `shipping_label_scanform_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Only set when manifest upload is for a USPS SCAN Form',
  `state` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'complete',
  `state_pending_date` int unsigned NOT NULL DEFAULT '0',
  `state_uploading_date` int unsigned NOT NULL DEFAULT '0',
  `state_uploaded_date` int unsigned NOT NULL DEFAULT '0',
  `state_complete_date` int unsigned NOT NULL DEFAULT '0',
  `state_cancelled_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`usps_manifest_upload_id`),
  KEY `record_type_idx` (`record_type`),
  KEY `state` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_service_standards` (
  `origin_zip` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_zip` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_class_days` smallint unsigned NOT NULL,
  `priority_days` smallint unsigned NOT NULL,
  `package_services_days` smallint unsigned NOT NULL,
  PRIMARY KEY (`origin_zip`,`destination_zip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_tracking_code_map` (
  `tracking_code` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_code`),
  KEY `shop_id` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_zone_domestic` (
  `zone_date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'USPS Rate Version',
  `origin_zip` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_zip` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `zone` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`zone_date`,`origin_zip`,`destination_zip`),
  KEY `usps_zone_domestic_date_origin_zone` (`zone_date`,`origin_zip`,`zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Maps domestic USPS origin and destination zip codes to zones. Replaces sqlite database from /var/shipping.';

CREATE TABLE `usps_zone_domestic_exception` (
  `zone_date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `origin_zip_start` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `origin_zip_end` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_zip_start` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_zip_end` char(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zone` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`zone_date`,`origin_zip_start`,`origin_zip_end`,`destination_zip_start`,`destination_zip_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_zone_international` (
  `zone_date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'USPS Rate Version',
  `origin_zip` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `country_id` smallint unsigned NOT NULL DEFAULT '0',
  `zone` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`zone_date`,`origin_zip`,`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Maps international USPS origin zip and destination country_id to zones. Replaces sqlite database from /var/shipping.';

CREATE TABLE `vat_invoices` (
  `invoice_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `seller_business_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_address` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vat_id` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_rate` int unsigned NOT NULL DEFAULT '0',
  `exchange_rate` bigint unsigned NOT NULL DEFAULT '1',
  `vat_charged` int NOT NULL DEFAULT '0',
  `invoice_month` int unsigned NOT NULL DEFAULT '0',
  `invoice_year` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`invoice_id`),
  KEY `invoice_date_idx` (`invoice_month`,`invoice_year`),
  KEY `shop_id_idx` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vat_rate` (
  `region_code` char(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fee_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `rate` float NOT NULL,
  `start_month` tinyint unsigned NOT NULL,
  `start_year` smallint unsigned NOT NULL,
  `create_date` int DEFAULT '0',
  PRIMARY KEY (`region_code`,`fee_type`,`start_year`,`start_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vertex_tax_area_ids` (
  `pk_id` bigint unsigned NOT NULL,
  `tax_area_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Vertex-specific number that identifies a tax area',
  `etsy_country_id` bigint unsigned NOT NULL COMMENT 'country_id of EtsyModel_Country',
  `world_bank_country_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ISO3 country code of EtsyModel_Country',
  `postal_code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'postal or zip code',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pk_id`),
  KEY `etsy_country_id_postal_code` (`etsy_country_id`,`postal_code`,`create_date`),
  KEY `tax_area_id` (`tax_area_id`,`create_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vetting_blocklist_terms` (
  `vetting_term_id` bigint unsigned NOT NULL COMMENT 'Generated primary key of a vetting term',
  `term` varchar(255) NOT NULL COMMENT 'Generated primary key of a vetting term',
  `create_date` int NOT NULL COMMENT 'Create date in epoch time',
  `update_date` int NOT NULL COMMENT 'Update date in epoch time',
  `create_admin` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'ID of create admin',
  `update_admin` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'ID of update admin',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Soft delete flag where 0 is not deleted and 1 is deleted',
  PRIMARY KEY (`vetting_term_id`),
  UNIQUE KEY `unique_term` (`term`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Terms for filtering within Vetting';

CREATE TABLE `video_captions` (
  `video_token` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption_text` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`video_token`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `video_frame_safesearchannotation` (
  `id` bigint unsigned NOT NULL,
  `video_id` bigint unsigned NOT NULL,
  `video_type_id` int unsigned NOT NULL DEFAULT '0',
  `gift_receipt_options_id` bigint unsigned DEFAULT NULL,
  `frame_type` bigint unsigned NOT NULL COMMENT 'enum specifying frame type',
  `adult_likelihood` tinyint unsigned NOT NULL DEFAULT '0',
  `adult_score` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `spoof_likelihood` tinyint unsigned NOT NULL DEFAULT '0',
  `spoof_score` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `medical_likelihood` tinyint unsigned NOT NULL DEFAULT '0',
  `medical_score` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `violence_likelihood` tinyint unsigned NOT NULL DEFAULT '0',
  `violence_score` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `racy_likelihood` tinyint unsigned NOT NULL DEFAULT '0',
  `racy_score` decimal(20,19) unsigned NOT NULL DEFAULT '0.0000000000000000000' COMMENT 'ranges from 0 (no confidence) to 1 (very high confidence)',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `videos` (
  `video_id` bigint unsigned NOT NULL,
  `video_path` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `thumbnail_path` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tags` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `admin` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `related_content` longtext COLLATE utf8mb4_unicode_ci,
  `video_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`video_id`),
  KEY `video_date` (`video_date`),
  KEY `title` (`title`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `videos_staff` (
  `video_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`video_id`,`staff_id`),
  KEY `staff_idx` (`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `videos_tags` (
  `video_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`video_id`,`tag_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `withholding_tax_rates` (
  `rate_id` bigint NOT NULL COMMENT 'Synthetic id for this table.',
  `region_code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Two-character ISO Country Code, e.g. ''MX'', or Country Code with subdivision, e.g. ''CA-QC''',
  `tax_type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The type of withholding tax this rate is for, e.g. ''direct'' or ''indirect''. Maps to a Tax_Withholding_Type in Etsyweb.',
  `rate_name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of this specific rate, e.g. ''registered_domestic'', ''unregistered_domestic'', ''registered_export'', etc. This can be anything, so long as the calculators used for this region know how/when to apply this rate.',
  `rate` decimal(6,5) NOT NULL COMMENT 'The rate to apply to a receipt, e.g. 0.05 for 5%.',
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rate_id`),
  UNIQUE KEY `region_type_name_date_idx` (`region_code`,`tax_type`,`rate_name`,`start_date`),
  KEY `end_date_idx` (`end_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Withholding tax rates. Used when applying seller-paid withholding taxes to Receipts post-checkout.';

CREATE TABLE `witness_favorites` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT 'user',
  `user_name` varchar(32) NOT NULL DEFAULT '',
  `shop_name` varchar(32) NOT NULL DEFAULT '',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `listing_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(256) NOT NULL DEFAULT '',
  `decision` varchar(128) NOT NULL DEFAULT '',
  `notes` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`type`,`user_id`,`shop_id`,`listing_id`),
  KEY `staff_id_user_id_idx` (`staff_id`,`user_id`),
  KEY `staff_id_shop_id_idx` (`staff_id`,`shop_id`),
  KEY `staff_id_listing_idx` (`staff_id`,`listing_id`),
  KEY `staff_id_update_date_idx` (`staff_id`,`update_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `yakit_invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_date` int unsigned NOT NULL,
  `filename` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filesize_bytes` int unsigned NOT NULL DEFAULT '0',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `s3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_indexed_date` int unsigned NOT NULL DEFAULT '0',
  `state_recording_date` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `total` int NOT NULL DEFAULT '0',
  `item_count` int unsigned NOT NULL DEFAULT '0',
  `currency_code` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `invoice_start_date` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `invoice_end_date` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `filename` (`filename`),
  KEY `state_idx` (`state`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `file_md5` (`file_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `yakit_invoice_item` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_item_id` bigint unsigned NOT NULL,
  `state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'debit',
  `amount` int unsigned NOT NULL DEFAULT '0',
  `gst` int unsigned NOT NULL DEFAULT '0',
  `current_balance` int NOT NULL DEFAULT '0',
  `currency_code` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `process_date` int unsigned NOT NULL DEFAULT '0',
  `shipment_id` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tracking_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `weight` decimal(9,3) NOT NULL,
  `chargeable_weight` decimal(9,3) NOT NULL,
  `weight_units` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kg',
  `length` decimal(9,3) NOT NULL,
  `width` decimal(9,3) NOT NULL,
  `height` decimal(9,3) NOT NULL,
  `dimension_units` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cm',
  `postal_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `billed_weight` decimal(9,3) NOT NULL,
  `billed_amount` int unsigned NOT NULL DEFAULT '0',
  `billed_gst` int unsigned NOT NULL DEFAULT '0',
  `additional_charges` int unsigned NOT NULL DEFAULT '0',
  `message` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0',
  `merchant_id` int unsigned NOT NULL DEFAULT '0',
  `state_recorded_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_item_id`),
  KEY `state_processed_date` (`state_processed_date`),
  KEY `shop_shipping_label_id` (`shop_id`,`shipping_label_id`),
  KEY `shipment_id` (`shipment_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zd_job_status` (
  `id` bigint unsigned NOT NULL,
  `zendesk_job_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `progress` int DEFAULT NULL,
  `total` int DEFAULT NULL,
  `message` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int DEFAULT NULL,
  `update_date` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `zendesk_job_idx` (`zendesk_job_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zd_sync_user_job_result` (
  `id` bigint unsigned NOT NULL,
  `zendesk_job_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int DEFAULT NULL,
  `update_date` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `zendesk_job_id` (`zendesk_job_id`(32)),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zendesk_appeal_request_log` (
  `appeal_request_log_id` bigint unsigned NOT NULL,
  `request_timestamp` int NOT NULL,
  `etsy_user_id` bigint unsigned NOT NULL,
  `response_timestamp` int NOT NULL,
  `is_success` tinyint unsigned NOT NULL COMMENT 'Outcome of appeal request success-1 or failure-0',
  `zd_ticket_id` bigint unsigned DEFAULT NULL,
  `zd_error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`appeal_request_log_id`),
  KEY `etsy_user_id` (`etsy_user_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zendesk_callback_requests_log` (
  `zd_callback_request_id` bigint unsigned NOT NULL,
  `request_timestamp` int NOT NULL,
  `etsy_user_id` bigint unsigned NOT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `response_timestamp` int NOT NULL,
  `is_success` tinyint unsigned NOT NULL COMMENT 'Outcome of Callback request success-1 or failure-0',
  `zd_error_message` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`zd_callback_request_id`),
  KEY `etsy_user_id` (`etsy_user_id`),
  KEY `phone_number` (`phone_number`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zendesk_dynamic_content` (
  `id` bigint unsigned NOT NULL,
  `zd_item_id` bigint unsigned NOT NULL,
  `zd_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zd_placeholder` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zd_default_locale_id` int DEFAULT NULL,
  `zd_variant_id` bigint NOT NULL,
  `zd_variant_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `zd_variant_locale_id` int NOT NULL,
  `zd_variant_updated_at` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zd_placeholder_locale_idx` (`zd_placeholder`,`zd_variant_locale_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zendesk_translation_objects` (
  `zendesk_translation_object_id` bigint unsigned NOT NULL,
  `zendesk_translation_request_id` bigint unsigned NOT NULL,
  `zendesk_type` int unsigned NOT NULL,
  `zendesk_input_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Identifier input into the web form',
  `zendesk_id` bigint unsigned NOT NULL DEFAULT '0',
  `translation_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `preview_fields_json` longtext COLLATE utf8mb4_unicode_ci COMMENT 'JSON blob of object fields, used to render the document preview for translators',
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`zendesk_translation_object_id`),
  KEY `translation_status_idx` (`translation_status`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `request_filename_idx` (`zendesk_translation_request_id`,`filename`(16))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zendesk_translation_requests` (
  `zendesk_translation_request_id` bigint unsigned NOT NULL,
  `xtm_project_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Project ID from XTM',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Descriptive title for this change',
  `description` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Long description for this change',
  `xtm_project_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xtm_customer_id` bigint unsigned NOT NULL COMMENT 'XTM Customer ID',
  `xtm_template_id` bigint unsigned NOT NULL COMMENT 'XTM Template ID',
  `requested_due_date` bigint unsigned NOT NULL,
  `created_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Project creator staff ID',
  `translation_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`zendesk_translation_request_id`),
  KEY `xtm_project_id_idx` (`xtm_project_id`),
  KEY `translation_status_idx` (`translation_status`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zip3_to_zip3_edd_filter_region_map_creator_job_states` (
  `job_state_id` bigint unsigned NOT NULL,
  `edd_buffering_usps_version` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_batch_id` bigint unsigned NOT NULL,
  `state` smallint unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `finish_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`job_state_id`),
  KEY `edd_buffering_usps_version` (`edd_buffering_usps_version`),
  KEY `job_batch_id` (`job_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `zip3_to_zip3_edd_filter_region_maps` (
  `edd_buffering_usps_version` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_zip3` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `json_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON-encoded data containing a map of regions with info required for the search filter',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`edd_buffering_usps_version`,`destination_zip3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

