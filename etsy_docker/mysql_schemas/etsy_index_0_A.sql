CREATE DATABASE etsy_index_0_A;
USE etsy_index_0_A;

CREATE TABLE `abuse_case` (
  `case_id` bigint unsigned NOT NULL DEFAULT '0',
  `flagged_object_id` bigint unsigned NOT NULL DEFAULT '0',
  `flagged_object_type_id` smallint NOT NULL COMMENT 'the type of object this case refers to',
  `admin_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `reason` text NOT NULL COMMENT 'reason provided by the admin',
  `first_flag_date` int NOT NULL COMMENT 'the create_date of the first flag this case addresses',
  `last_flag_date` int NOT NULL COMMENT 'the create_date of the last flag this case addresses',
  `create_date` int NOT NULL COMMENT 'when this case was created',
  PRIMARY KEY (`case_id`),
  KEY `flagged_object_type_id` (`flagged_object_type_id`,`flagged_object_id`),
  KEY `admin_user_id` (`admin_user_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table used for grouping abuse flags together into cases';

CREATE TABLE `abuse_flags` (
  `flag_id` bigint unsigned NOT NULL,
  `flagged_object_id` int NOT NULL COMMENT 'the id of the object being flagged',
  `flagged_object_type_id` smallint NOT NULL COMMENT 'the type of the object being flagged see: Activity_ObjectType',
  `reporter_user_id` bigint unsigned NOT NULL COMMENT 'user who reported this',
  `reason` text NOT NULL COMMENT 'reason provided by the user',
  `status` varchar(255) DEFAULT NULL COMMENT 'can be used to indicate closed flags etc',
  `create_date` int NOT NULL COMMENT 'when this flag was created',
  `update_date` int NOT NULL COMMENT 'when this flag was updated',
  PRIMARY KEY (`flag_id`),
  KEY `flagged_object_type_id` (`flagged_object_type_id`,`flagged_object_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `status` (`status`(15))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='table used for tracing things that have been flagged as inap';

CREATE TABLE `activity_external_reference` (
  `reference_id` bigint unsigned NOT NULL DEFAULT '0',
  `external_id` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`reference_id`),
  KEY `external_id` (`external_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_owner_queue` (
  `activity_owner_id` bigint NOT NULL,
  `activity_owner_type_id` int NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`activity_owner_id`,`activity_owner_type_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `affiliate_campaigns` (
  `campaign_id` bigint unsigned NOT NULL,
  `campaign_shard` int unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `external_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `external_title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `external_description` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `status` tinyint unsigned NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `type_external_id_idx` (`type`,`external_id`(191)),
  KEY `status_idx` (`status`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `affiliate_publishers` (
  `publisher_id` bigint unsigned NOT NULL,
  `publisher_shard` int unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `external_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `status` tinyint unsigned NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`publisher_id`),
  KEY `type_external_id_idx` (`type`,`external_id`(191)),
  KEY `status_idx` (`status`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `api_keys_index` (
  `api_key_id` bigint unsigned NOT NULL,
  `api_key_shard` bigint unsigned NOT NULL DEFAULT '0',
  `keystring` varchar(128) NOT NULL DEFAULT '',
  `app_id` bigint unsigned NOT NULL DEFAULT '0',
  `app_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_platform` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `app_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `service_name` varchar(32) NOT NULL DEFAULT '',
  `shared_secret` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `is_restricted` tinyint NOT NULL DEFAULT '0',
  `limit_qps` int NOT NULL DEFAULT '0',
  `limit_qpd` int NOT NULL DEFAULT '0',
  `limit_qps_auth` int NOT NULL DEFAULT '0',
  `limit_qpd_auth` int NOT NULL DEFAULT '0',
  `referral_tag` varchar(128) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`api_key_id`),
  UNIQUE KEY `svc_keystr` (`service_name`,`keystring`),
  KEY `app_id` (`app_id`),
  KEY `create_date` (`create_date`),
  KEY `keystring` (`keystring`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `application_index` (
  `application_id` bigint unsigned NOT NULL,
  `application_shard` int NOT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `approved` tinyint(1) NOT NULL,
  `categories` bigint NOT NULL,
  `state` int NOT NULL,
  `slug` varchar(255) NOT NULL,
  `launch_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `popularity_score` float NOT NULL DEFAULT '0',
  `limit_qps` int NOT NULL DEFAULT '0',
  `limit_qpd` int NOT NULL DEFAULT '0',
  `is_seller_owned` tinyint unsigned NOT NULL DEFAULT '0',
  `prev_approved` tinyint(1) DEFAULT NULL,
  `groups` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`application_id`),
  KEY `aprv_slug` (`approved`,`slug`(15)),
  KEY `aprv_launch_date` (`approved`,`launch_date`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `shard_id_idx` (`application_shard`,`application_id`),
  KEY `aprv_popularity_score` (`approved`,`popularity_score`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `arbitrary_key_index` (
  `hash_bucket` int NOT NULL,
  `shard` int NOT NULL,
  `creation_time` int NOT NULL,
  `update_time` int NOT NULL,
  `migration_lock` int NOT NULL,
  `old_shard` int NOT NULL,
  PRIMARY KEY (`hash_bucket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `campaign_index` (
  `campaign_id` bigint unsigned NOT NULL,
  `campaign_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `shop_id` (`shop_id`),
  KEY `campaign_index_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `campaign_index_dark` (
  `campaign_id` bigint unsigned NOT NULL,
  `campaign_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `shop_id` (`shop_id`),
  KEY `campaign_index_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `carts_index` (
  `cart_id` bigint NOT NULL,
  `type_id` smallint NOT NULL COMMENT 'type of cart',
  `type_owner_id` varchar(28) NOT NULL COMMENT 'PK to owner of cart based on type',
  `shard` int NOT NULL,
  `shop_id` bigint NOT NULL COMMENT 'PK of shop',
  `listings_count` int NOT NULL DEFAULT '0' COMMENT 'count of listings',
  `state` smallint NOT NULL DEFAULT '1' COMMENT 'state of cart default to active',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `last_access_date` int NOT NULL DEFAULT '0' COMMENT 'last access type of cart',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `total_quantity` int NOT NULL DEFAULT '0' COMMENT 'sum of quantities of listings in cart',
  PRIMARY KEY (`cart_id`),
  KEY `type_owner_id_state_idx` (`type_id`,`type_owner_id`,`state`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `abandoned_cart_idx` (`type_owner_id`,`type_id`,`state`,`last_access_date`),
  KEY `abandoned_cart_idx_shop_id` (`type_owner_id`,`shop_id`,`type_id`,`state`,`last_access_date`),
  KEY `type_state_last_access_date_idx` (`type_id`,`state`,`last_access_date`),
  KEY `shop_state_type_update_idx` (`shop_id`,`state`,`type_id`,`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `categories` (
  `category_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(45) DEFAULT NULL,
  `meta_title` text,
  `meta_keywords` text,
  `meta_description` text,
  `page_description` text,
  `page_title` text,
  `listing_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `browsing_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `path` varchar(128) DEFAULT NULL,
  `num_children` int DEFAULT NULL,
  `created` int unsigned NOT NULL,
  `modified` int unsigned NOT NULL,
  PRIMARY KEY (`category_id`),
  KEY `listing_enabled` (`listing_enabled`),
  KEY `browsing_enabled` (`browsing_enabled`),
  KEY `path` (`path`),
  KEY `created_idx` (`created`),
  KEY `modified_idx` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `categories_hierarchy` (
  `categories_category_id` bigint unsigned NOT NULL DEFAULT '0',
  `parent_category_id` bigint unsigned DEFAULT NULL,
  `child_category_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`categories_category_id`),
  KEY `parent_category_id_index` (`parent_category_id`),
  KEY `child_category_id_index` (`child_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `categories_properties` (
  `categories_property_id` int NOT NULL,
  `category_id` int unsigned DEFAULT NULL,
  `property_id` int unsigned DEFAULT NULL,
  `created` int unsigned NOT NULL,
  `modified` int unsigned NOT NULL,
  PRIMARY KEY (`categories_property_id`),
  KEY `category_id_index` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `checkout_audit` (
  `checkout_audit_id` bigint NOT NULL,
  `shard` int NOT NULL,
  `cart_id` bigint NOT NULL,
  `receipt_id` bigint NOT NULL DEFAULT '0',
  `user_id` bigint NOT NULL COMMENT 'PK to buyer',
  `guest_user_id` bigint NOT NULL DEFAULT '0',
  `shop_id` bigint NOT NULL COMMENT 'PK of shop',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `latest_child_add_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`checkout_audit_id`),
  KEY `cart_id` (`cart_id`),
  KEY `receipt_id` (`receipt_id`),
  KEY `user_id` (`user_id`),
  KEY `shop_id` (`shop_id`),
  KEY `latest_child_add_date` (`latest_child_add_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `guest_user_id` (`guest_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='audit trail for checkout';

CREATE TABLE `checksum` (
  `db` char(64) NOT NULL,
  `tbl` char(64) NOT NULL,
  `chunk` int NOT NULL,
  `boundaries` char(100) NOT NULL,
  `this_crc` char(40) NOT NULL,
  `this_cnt` int NOT NULL,
  `master_crc` char(40) DEFAULT NULL,
  `master_cnt` int DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`db`,`tbl`,`chunk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `claimed_receipts` (
  `user_id` bigint unsigned NOT NULL,
  `guest_user_id` bigint unsigned NOT NULL,
  `receipt_id` bigint unsigned NOT NULL,
  `receipt_group_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `retry_count` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `claim_origin` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNKNOWN',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'if an admin initiated the claiming event staff_id of that admin',
  PRIMARY KEY (`user_id`,`guest_user_id`,`receipt_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `claimed_receipts_status_idx` (`status`),
  KEY `claimed_receipts_guest_user_id_receipt_id_idx` (`guest_user_id`,`receipt_id`),
  KEY `receipt_id_idx` (`receipt_id`),
  KEY `receipt_group_id_idx` (`receipt_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `community_event` (
  `community_event_id` bigint NOT NULL,
  `title` varchar(128) NOT NULL,
  `event_url` varchar(512) NOT NULL,
  `event_link_text` varchar(128) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `summary` varchar(512) NOT NULL,
  `host` varchar(255) NOT NULL,
  `host_url` varchar(512) NOT NULL,
  `read_more` varchar(255) NOT NULL,
  `read_more_url` varchar(512) NOT NULL,
  `special_event` tinyint(1) NOT NULL,
  `address_first_line` varchar(255) NOT NULL,
  `address_second_line` varchar(255) DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `zip` varchar(255) NOT NULL,
  `country_id` int NOT NULL,
  `event_start_date` int NOT NULL DEFAULT '0',
  `event_end_date` int NOT NULL DEFAULT '0',
  `event_timezone` varchar(255) NOT NULL DEFAULT 'America/New_York',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `photo_credit` varchar(255) DEFAULT NULL,
  `photo_credit_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`community_event_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `composed_page_config` (
  `composed_page_config_id` bigint unsigned NOT NULL,
  `page_name` varchar(255) NOT NULL,
  `start_date` int unsigned DEFAULT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `config` text NOT NULL,
  PRIMARY KEY (`composed_page_config_id`),
  KEY `page_name_idx` (`page_name`),
  KEY `start_date_idx` (`start_date`),
  KEY `end_date_idx` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `contentful_index` (
  `content_type_id` bigint unsigned NOT NULL,
  `contentful_content_type_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_shard` int unsigned NOT NULL,
  `migration_lock` int unsigned NOT NULL,
  `old_shard` int unsigned NOT NULL,
  PRIMARY KEY (`content_type_id`),
  KEY `contentful_content_type_id` (`contentful_content_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `convos_index` (
  `conversation_id` bigint NOT NULL,
  `context_id` bigint NOT NULL,
  `context_type_id` int NOT NULL,
  `update_date` int NOT NULL,
  `create_date` int NOT NULL,
  PRIMARY KEY (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `craft_content_index` (
  `craft_content_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `author_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `publish_date` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` bigint unsigned NOT NULL DEFAULT '0',
  `update_date` bigint unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`craft_content_id`),
  UNIQUE KEY `user_id` (`user_id`,`craft_content_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_property_name_translations` (
  `property_name_id` bigint unsigned NOT NULL,
  `language` tinyint unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_dirty` tinyint(1) NOT NULL DEFAULT '0',
  `translation_system_id` smallint unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`property_name_id`,`language`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_property_names` (
  `property_name_id` bigint unsigned NOT NULL,
  `name` varbinary(255) NOT NULL,
  `language` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`property_name_id`),
  KEY `name_idx` (`name`,`language`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_shops_domain_index` (
  `shop_id` bigint unsigned NOT NULL,
  `domain_id` bigint unsigned NOT NULL,
  `domain_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` tinyint unsigned NOT NULL COMMENT 'Defines if the domain was auto-assigned, mapped or purchased.',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`,`domain_id`),
  UNIQUE KEY `domain_name` (`domain_name`(191)),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custshop_index` (
  `shop_id` bigint unsigned NOT NULL,
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `domain` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `trial_start_date` bigint unsigned NOT NULL DEFAULT '0',
  `domain_id` bigint unsigned NOT NULL DEFAULT '0',
  `expire_date` int unsigned NOT NULL DEFAULT '0',
  `state_meta` bigint NOT NULL DEFAULT '0',
  `in_transition` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`,`domain_id`),
  KEY `domain_index` (`domain`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`),
  KEY `trial_start_date_index` (`trial_start_date`),
  KEY `expire_date_index` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custshop_template_library` (
  `theme_id` bigint unsigned NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `contents` text NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`theme_id`,`file_path`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custshop_theme` (
  `theme_id` bigint unsigned NOT NULL,
  `theme_name` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `theme_version` smallint DEFAULT NULL,
  PRIMARY KEY (`theme_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `device` (
  `device_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `device_udid` varchar(128) NOT NULL DEFAULT '',
  `notification_token` varchar(4096) DEFAULT NULL,
  `device_type_id` tinyint unsigned NOT NULL DEFAULT '0',
  `environment_id` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `version` varchar(32) NOT NULL DEFAULT '',
  `display_badge` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `notification_display_settings` tinyint unsigned NOT NULL DEFAULT '0',
  `can_receive_notifications` tinyint NOT NULL DEFAULT '1',
  `prev_rejected_notif_token` varchar(4096) DEFAULT NULL,
  `ios_fcm_notification_token` longtext,
  PRIMARY KEY (`device_id`),
  KEY `user_id` (`user_id`),
  KEY `notification_token` (`notification_token`(255)),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `device_udid_status` (`device_udid`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `direct_checkout_sellers` (
  `user_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `invited_by` varchar(32) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `invited_by` (`invited_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_addresses` (
  `email_id` bigint NOT NULL,
  `email` varchar(256) NOT NULL,
  `email_shard` int NOT NULL,
  `user_id` bigint NOT NULL DEFAULT '0',
  `verification_code` varchar(32) NOT NULL,
  `verification_state` varchar(256) NOT NULL,
  `reliability_state` varchar(256) NOT NULL,
  `external_verification_state` tinyint(1) DEFAULT NULL,
  `ip_address` varchar(256) DEFAULT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email` (`email`(255)),
  KEY `user_id` (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_optout` (
  `email_hash` char(28) NOT NULL COMMENT 'A base64 encoded sha1 hash of the email being opted-out',
  `sender_user_id` bigint unsigned NOT NULL COMMENT 'The user who sent the invitation',
  `email_type` smallint unsigned NOT NULL COMMENT 'The type of email being opted out of',
  `creation_time` int unsigned NOT NULL COMMENT 'The time at which the user opted out',
  PRIMARY KEY (`email_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores whether a non-member wants to opt out of a type of em';

CREATE TABLE `email_redirect_service` (
  `email_redirect_service_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL,
  `redirect_key` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect_target` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`email_redirect_service_id`),
  UNIQUE KEY `target_key` (`redirect_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `et_interaction` (
  `interaction_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `process_id` bigint unsigned NOT NULL,
  `migration_lock` int NOT NULL,
  `old_shard` int NOT NULL,
  `interaction_shard` int NOT NULL,
  `interaction_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_team` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`interaction_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `shop_id_idx` (`shop_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_id_idx` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `external_accounts` (
  `external_account_id` varchar(50) NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  `owner_type_id` smallint unsigned NOT NULL,
  `external_account_type` tinyint unsigned NOT NULL,
  `external_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `external_user_key` varchar(255) NOT NULL DEFAULT '',
  `external_username` varchar(255) NOT NULL DEFAULT '',
  `external_email` varchar(255) NOT NULL DEFAULT '',
  `oauth_token` varchar(1024) NOT NULL DEFAULT '',
  `oauth_token_secret` varchar(1024) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `flags` bigint unsigned NOT NULL DEFAULT '0',
  `share_flags` bigint unsigned NOT NULL DEFAULT '0',
  `oauth_refresh_token` varchar(1024) NOT NULL DEFAULT '',
  PRIMARY KEY (`external_account_id`),
  KEY `update_date` (`update_date`),
  KEY `owner_id` (`owner_id`,`owner_type_id`,`deleted`,`external_account_type`),
  KEY `owner_id_2` (`owner_id`,`owner_type_id`,`create_date`),
  KEY `external_account_type_3` (`external_account_type`,`external_user_key`,`deleted`),
  KEY `external_mail` (`external_email`),
  KEY `external_username_idx` (`external_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores links between an Etsy account and accounts on other s';

CREATE TABLE `facebook_accounts_index` (
  `facebook_account_id` bigint unsigned NOT NULL,
  `facebook_account_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`facebook_account_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `featured_collections` (
  `collection_id` bigint unsigned NOT NULL,
  `admin_user_id` bigint unsigned NOT NULL,
  `creator_id` bigint unsigned NOT NULL,
  `status` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`collection_id`),
  KEY `status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `featured_treasury` (
  `treasury_id` bigint unsigned NOT NULL,
  `treasury_owner_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `active_date` int NOT NULL DEFAULT '0',
  `curator` varchar(32) NOT NULL,
  `region` char(3) NOT NULL DEFAULT 'EN',
  `admin_user_id` bigint unsigned NOT NULL,
  `intl_home_page_content_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`treasury_id`,`treasury_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `featured_treasury_listing` (
  `treasury_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `listing_order` int NOT NULL,
  PRIMARY KEY (`treasury_id`,`listing_id`),
  KEY `listing_id` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `finds_page` (
  `finds_page_id` bigint unsigned NOT NULL,
  `shard` int NOT NULL,
  `title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `publish_date` int unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL DEFAULT '0',
  `state` tinyint NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `language_id` tinyint unsigned NOT NULL DEFAULT '0',
  `merch_vertical_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `merch_taxonomy_id` bigint unsigned NOT NULL DEFAULT '0',
  `seo_title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `seo_description` longtext COLLATE utf8mb4_unicode_ci,
  `merch_page_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `most_recent_publish_date` int unsigned DEFAULT NULL,
  `merch_priority` tinyint unsigned DEFAULT '10',
  `previous_slug` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `exclude_video_prioritization` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`finds_page_id`),
  KEY `publish_date` (`publish_date`),
  KEY `update_date` (`update_date`),
  KEY `slug` (`slug`),
  KEY `state` (`state`,`publish_date`),
  KEY `type_and_state` (`type`,`state`,`publish_date`),
  KEY `previous_slug` (`previous_slug`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `finds_page_category_nav` (
  `finds_page_featured_schedule_id` bigint unsigned NOT NULL,
  `taxonomy_id` int unsigned NOT NULL,
  `finds_page_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`finds_page_featured_schedule_id`,`taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `finds_page_featured_page` (
  `finds_page_featured_schedule_id` bigint unsigned NOT NULL,
  `finds_page_id` bigint unsigned NOT NULL,
  `feature_order` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`finds_page_featured_schedule_id`,`feature_order`),
  KEY `finds_page_id` (`finds_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `finds_page_featured_schedule` (
  `finds_page_featured_schedule_id` bigint unsigned NOT NULL,
  `language_id` smallint unsigned NOT NULL,
  `region` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`finds_page_featured_schedule_id`),
  KEY `language_region_status_start` (`language_id`,`region`,`status`,`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `finds_page_region` (
  `finds_page_id` bigint unsigned NOT NULL,
  `region` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`finds_page_id`,`region`),
  KEY `region` (`region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fm_shops_index` (
  `shop_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`shop_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

CREATE TABLE `forum_posts_by_thread_index` (
  `forum_thread_id` bigint NOT NULL,
  `thread_shard` int NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `forum_id` bigint DEFAULT NULL,
  PRIMARY KEY (`forum_thread_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `forum_tag` (
  `forum_tag_id` bigint unsigned NOT NULL,
  `shard` int NOT NULL,
  `old_shard` int NOT NULL,
  `migration_lock` int NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `owner_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `update_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`forum_tag_id`),
  UNIQUE KEY `type_group_owner_name_idx` (`type`,`group_id`,`owner_user_id`,`name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `forums_index` (
  `forum_id` bigint NOT NULL,
  `forum_shard` int NOT NULL,
  `group_id` bigint NOT NULL DEFAULT '0',
  `display_order` int NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `active_thread_count` int DEFAULT NULL,
  `parent_type_id` int NOT NULL DEFAULT '0',
  `parent_id` bigint NOT NULL DEFAULT '0',
  `creator_user_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`forum_id`),
  KEY `group_forum_order` (`group_id`,`display_order`),
  KEY `title_start` (`title`(10)),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `parent_object` (`parent_type_id`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fundraise_events_index` (
  `fundraise_event_id` bigint unsigned NOT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `banner_image_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `event_start_date` int NOT NULL,
  `event_end_date` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`fundraise_event_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fundraise_events_nonprofits_link` (
  `fundraise_event_id` bigint unsigned NOT NULL,
  `nonprofit_id` bigint unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`fundraise_event_id`,`nonprofit_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `giving_nonprofits_index` (
  `nonprofit_id` bigint unsigned NOT NULL,
  `group_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '1',
  `brand_name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tax_id` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mission` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `logo_image_id` int unsigned NOT NULL DEFAULT '0',
  `nonprofits_shard` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `page_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`nonprofit_id`),
  UNIQUE KEY `tax_id` (`tax_id`),
  KEY `brand_name` (`brand_name`(191)),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `googleads_etsy_adgroup` (
  `adwords_adgroup_id` bigint unsigned NOT NULL,
  `adwords_campaign_id` bigint unsigned NOT NULL,
  `adwords_mcc_id` bigint unsigned NOT NULL,
  `adwords_account_id` bigint unsigned NOT NULL,
  `taxonomy_id` bigint unsigned NOT NULL,
  `price_tier` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `market` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '0',
  `adwords_root_criterion_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`adwords_adgroup_id`),
  UNIQUE KEY `ix_taxo_price_tier` (`taxonomy_id`,`price_tier`,`market`),
  KEY `ix_status` (`status`),
  KEY `idx_adwords_campaign_id` (`adwords_campaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `googleads_etsy_campaign` (
  `adwords_campaign_id` bigint unsigned NOT NULL,
  `adwords_mcc_id` bigint unsigned NOT NULL,
  `adwords_account_id` bigint unsigned NOT NULL,
  `adwords_budget_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `budget` int unsigned NOT NULL DEFAULT '100' COMMENT 'USD in pennies',
  `shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`adwords_campaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `group_members_badges` (
  `group_id` int NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `badge_id` bigint unsigned NOT NULL,
  `start_date` int NOT NULL DEFAULT '0',
  `end_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`group_id`,`badge_id`,`start_date`),
  KEY `range` (`start_date`,`end_date`),
  KEY `group` (`group_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `groups_avatars` (
  `avatar_id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `marked_for_death` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`avatar_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `marked_for_death` (`marked_for_death`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `groups_banners` (
  `banner_id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `marked_for_death` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`banner_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `marked_for_death` (`marked_for_death`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `groups_index` (
  `group_id` bigint unsigned NOT NULL,
  `group_shard` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `activity_score` int NOT NULL DEFAULT '0',
  `activity_score_last_updated` int NOT NULL DEFAULT '0',
  `group_type` varchar(32) NOT NULL DEFAULT 'NORMAL',
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `group_name_unique` (`name`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `groups_group_shard_index` (`group_shard`,`group_id`),
  KEY `activity_score_index` (`activity_score`),
  KEY `activity_score_last_updated_index` (`activity_score_last_updated`),
  KEY `status` (`status`(16),`group_type`(16))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `groups_values` (
  `group_id` bigint unsigned NOT NULL,
  `key` int NOT NULL,
  `value` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`,`key`),
  KEY `groups_with_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `guest_pass_index` (
  `guestpass_hash` varchar(144) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`guestpass_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `guest_users_index` (
  `guest_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `guest_user_shard` int NOT NULL DEFAULT '0',
  `guest_user_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_email_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email_address_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `user_state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`guest_user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `primary_email_create_date_idx` (`primary_email`(50),`create_date`),
  KEY `primary_email_hash` (`primary_email_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Index for Guest Users';

CREATE TABLE `help_group` (
  `group_id` bigint unsigned NOT NULL DEFAULT '0',
  `locales` varchar(128) NOT NULL,
  `member_type` varchar(15) NOT NULL,
  `topics` varchar(512) NOT NULL,
  `enabled` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `help_group_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `help_topic` (
  `topic_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `heading` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kb_articles` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailbox` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `help_topic_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `human_tasks_index` (
  `human_task_id` bigint unsigned NOT NULL,
  `author_user_id` bigint unsigned NOT NULL,
  `shard` int NOT NULL,
  `state` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `budget_int` bigint unsigned NOT NULL DEFAULT '0',
  `promotion_id` bigint unsigned DEFAULT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `read_ready` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `group_id` bigint unsigned NOT NULL DEFAULT '10452',
  PRIMARY KEY (`human_task_id`),
  KEY `author_user_id` (`author_user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `human_translation_memory` (
  `source_content_md5` binary(32) NOT NULL,
  `source_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_language` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `translated_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `translated_language` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`source_content_md5`,`source_language`,`translated_language`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `imported_shop_ids` (
  `imported_shop_id` bigint unsigned NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`imported_shop_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `in_progress_listing_map` (
  `in_progress_listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`in_progress_listing_id`),
  UNIQUE KEY `shop_id` (`shop_id`,`in_progress_listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `intl_homepage_modules` (
  `content_id` bigint NOT NULL DEFAULT '0',
  `page_name` varchar(20) NOT NULL,
  `module_name` varchar(20) NOT NULL,
  `request_overrides` varchar(100) DEFAULT NULL,
  `start_date` int NOT NULL,
  `end_date` int NOT NULL,
  `data_provider_class` varchar(60) NOT NULL,
  `data_provider_data` text NOT NULL,
  `share_percent` tinyint DEFAULT '100',
  `pretranslated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`content_id`),
  KEY `start_date_index` (`page_name`,`start_date`),
  KEY `end_date_index` (`page_name`,`end_date`),
  KEY `cell_index` (`page_name`,`module_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `invoice` (
  `invoice_id` bigint unsigned NOT NULL,
  `invoice_uid` varchar(255) NOT NULL,
  `buyer_id` int DEFAULT NULL,
  `seller_id` int NOT NULL,
  `listing_ids` varchar(255) NOT NULL,
  `lat` float DEFAULT NULL,
  `lon` float DEFAULT NULL,
  `cart_id` bigint DEFAULT NULL,
  `contact_address` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `invoice_uid` (`invoice_uid`),
  KEY `cart_id` (`cart_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_batches` (
  `job_batch_id` bigint NOT NULL,
  `info` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `completed_jobs` int NOT NULL DEFAULT '0',
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'created',
  `errors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`job_batch_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_article` (
  `kb_article_group_id` bigint unsigned NOT NULL,
  `kb_article_id` bigint unsigned NOT NULL,
  `kb_topic_id` bigint unsigned NOT NULL,
  `kb_site` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shortcut` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `current_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `current_revision_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `language` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en-us',
  `media_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private',
  `related_terms` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `community_translation` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`kb_article_group_id`,`kb_article_id`),
  UNIQUE KEY `article_idx` (`kb_article_id`),
  KEY `shortcut_idx` (`shortcut`),
  KEY `site_idx` (`kb_site`),
  KEY `topic_shortcut_idx` (`kb_topic_id`,`shortcut`),
  KEY `group_language_type_idx` (`kb_article_group_id`,`language`,`media_type`),
  KEY `language_type_topic_status_idx` (`language`,`media_type`,`kb_topic_id`,`current_revision_status`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_article_group` (
  `kb_article_group_id` bigint unsigned NOT NULL,
  `shard` int NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `kb_topic_id` bigint unsigned NOT NULL,
  `kb_site` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shortcut` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`kb_article_group_id`),
  KEY `shortcut_idx` (`shortcut`),
  KEY `topic_shortcut_idx` (`kb_topic_id`,`shortcut`),
  KEY `site_idx` (`kb_site`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `kb_topic` (
  `kb_topic_id` bigint unsigned NOT NULL,
  `kb_site` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shortcut` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `weight` int unsigned NOT NULL DEFAULT '0',
  `mailbox` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`kb_topic_id`),
  KEY `shortcut_idx` (`shortcut`),
  KEY `mailbox_idx` (`mailbox`),
  KEY `site_weight_idx` (`kb_site`,`weight`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `language_index` (
  `lang_id` tinyint unsigned NOT NULL,
  `lang_code` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `is_machine_language` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`lang_id`),
  UNIQUE KEY `lang_code` (`lang_code`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_map` (
  `listing_id` bigint unsigned NOT NULL DEFAULT '0',
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`listing_id`),
  UNIQUE KEY `shop_id` (`shop_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_category_to_property` (
  `listing_option_category_to_property_id` bigint unsigned NOT NULL,
  `listing_option_property_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`listing_option_category_to_property_id`),
  UNIQUE KEY `category_id` (`category_id`,`listing_option_property_id`),
  KEY `listing_option_property_id` (`listing_option_property_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_characteristics` (
  `listing_option_characteristic_id` bigint unsigned NOT NULL,
  `characteristic_display_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `characteristic_type` int NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `old_property_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`listing_option_characteristic_id`),
  UNIQUE KEY `old_property_id_idx` (`old_property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_chracteristic_suggested_value` (
  `listing_option_characteristic_suggested_value_id` bigint unsigned NOT NULL,
  `listing_option_characteristic_id` bigint unsigned NOT NULL,
  `listing_option_property_id` bigint unsigned NOT NULL,
  `prior_characteristic_id` bigint unsigned NOT NULL,
  `prior_characteristic_suggested_value_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `display_value` varbinary(255) NOT NULL,
  `value` varbinary(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `position` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`listing_option_characteristic_suggested_value_id`),
  KEY `category_id` (`category_id`),
  KEY `listing_option_characteristic_id` (`listing_option_characteristic_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_properties` (
  `listing_option_property_id` bigint unsigned NOT NULL,
  `property_display_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `property_type` int NOT NULL DEFAULT '0',
  `max_children` int NOT NULL DEFAULT '2',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `old_property_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`listing_option_property_id`),
  UNIQUE KEY `old_property_id_idx` (`old_property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_property_to_listing_option_characteristic` (
  `listing_option_property_id` bigint unsigned NOT NULL,
  `listing_option_characteristic_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `position` int NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`listing_option_property_id`,`listing_option_characteristic_id`,`category_id`),
  UNIQUE KEY `listing_option_characteristic_id` (`listing_option_characteristic_id`,`listing_option_property_id`,`category_id`),
  UNIQUE KEY `listing_option_characteristic__2` (`listing_option_characteristic_id`,`category_id`,`listing_option_property_id`),
  UNIQUE KEY `listing_option_property_id` (`listing_option_property_id`,`category_id`,`listing_option_characteristic_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_option_suggested_value` (
  `listing_option_suggested_value_id` bigint unsigned NOT NULL,
  `listing_option_property_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `qualifying_characteristic_id` bigint unsigned NOT NULL,
  `characteristic_suggested_value_id` bigint unsigned NOT NULL,
  `display_value` varbinary(255) NOT NULL,
  `value` varbinary(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `position` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`listing_option_suggested_value_id`),
  KEY `category_id` (`category_id`),
  KEY `listing_option_property_id` (`listing_option_property_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_property_migrations` (
  `migration_id` bigint unsigned NOT NULL,
  `source_property_id` bigint unsigned NOT NULL,
  `source_value` varchar(4096) NOT NULL,
  `display_generator_class` varchar(100) NOT NULL,
  `display_generator_arguments_json` varchar(4096) NOT NULL,
  `transformer_class` varchar(100) NOT NULL,
  `transformer_arguments_json` varchar(4096) NOT NULL,
  `terminator_class` varchar(100) NOT NULL,
  `terminator_arguments_json` varchar(4096) NOT NULL,
  `export_job_batch_id` bigint NOT NULL,
  `transform_job_batch_id` bigint NOT NULL,
  `s3_bucket` varchar(128) NOT NULL,
  `s3_path` varchar(128) NOT NULL,
  `status` varchar(32) NOT NULL,
  `created` int unsigned NOT NULL,
  `modified` int unsigned NOT NULL,
  PRIMARY KEY (`migration_id`),
  UNIQUE KEY `export_job_batch_id` (`export_job_batch_id`),
  UNIQUE KEY `transform_job_batch_id` (`transform_job_batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_taxonomy_change` (
  `listing_taxonomy_change_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `original_taxonomy_id` bigint unsigned NOT NULL,
  `new_taxonomy_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`listing_taxonomy_change_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `livestream_sessions` (
  `livestream_session_id` bigint NOT NULL,
  `livestream_channel_name` varchar(32) NOT NULL,
  `start_date` int NOT NULL DEFAULT '0',
  `end_date` int NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT 'scheduled',
  `shard_id` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `metadata` text NOT NULL,
  `prompt` text NOT NULL,
  PRIMARY KEY (`livestream_session_id`),
  KEY `start_date` (`start_date`,`status`),
  KEY `end_date` (`end_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `local_market_index` (
  `local_market_id` bigint unsigned NOT NULL DEFAULT '0',
  `local_market_shard_id` int NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `creator_user_id` bigint unsigned NOT NULL,
  `market_type` tinyint unsigned NOT NULL DEFAULT '0',
  `market_status` tinyint unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zipcode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_id` int unsigned NOT NULL,
  `venue_foursquare_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wholesale_buyer_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `organizing_group_id` bigint unsigned DEFAULT NULL,
  `parent_local_market_id` bigint unsigned DEFAULT NULL,
  `attendance_count` int NOT NULL DEFAULT '0',
  `attendance_max` int NOT NULL DEFAULT '-1',
  `market_visibility` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`local_market_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `main_query_index` (`start_date`,`end_date`,`latitude`,`longitude`,`market_type`),
  KEY `creator_query_index` (`creator_user_id`,`start_date`,`end_date`),
  KEY `enddate` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `login_sessions` (
  `token` char(80) NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `active` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`token`),
  KEY `user_id_idx` (`user_id`),
  KEY `login_sessions_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mail_schedule` (
  `mail_schedule_id` bigint NOT NULL,
  `list_identifier` varchar(32) NOT NULL,
  `send_status` varchar(32) NOT NULL,
  `scheduled_send_date` int NOT NULL,
  `start_send_date` int NOT NULL,
  `schedule_type` varchar(64) DEFAULT NULL,
  `last_email_id` bigint NOT NULL,
  `template_path` varchar(256) NOT NULL,
  `template_data` text NOT NULL,
  `shard_id` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `priority` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mail_schedule_id`),
  KEY `list_identifier` (`list_identifier`),
  KEY `send_status` (`send_status`,`update_date`),
  KEY `scheduled_send_date` (`scheduled_send_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mailing_lists` (
  `mailing_list_id` bigint NOT NULL,
  `list_identifier` varchar(32) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `label` varchar(50) NOT NULL DEFAULT '',
  `shard_id` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`mailing_list_id`),
  UNIQUE KEY `list_identifier` (`list_identifier`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `type` (`type`),
  KEY `label` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `maker_faire_games` (
  `game_id` bigint unsigned NOT NULL,
  `game_shard` int NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`game_id`),
  KEY `status` (`status`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `manufacturer_application_index` (
  `manufacturer_application_id` bigint unsigned NOT NULL,
  `manufacturer_application_shard` int NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`manufacturer_application_id`),
  KEY `user_id` (`user_id`,`is_deleted`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `manufacturer_capability_hierarchy` (
  `manufacturer_capability_id` bigint unsigned NOT NULL,
  `is_custom` tinyint NOT NULL COMMENT 'if 0, is common for all users; if 1, is custom input for specific user',
  `industry` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Top level of fixed three-tier hierarchy: industry > specialization > capability',
  `specialization` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Category within industry: product, material, process',
  `capability_short_name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Shorthand ''enum'' notation describing the capability, ex.: ''fabric_printing''',
  `capability_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ex.: ''Fabric printing (inkjet, dye sublimation)''',
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `not_visible_to_buyers` tinyint NOT NULL DEFAULT '0' COMMENT 'renders capability invisible to buyers, but not to manufacturers, to allow us to add new fields for manufacturers first',
  PRIMARY KEY (`manufacturer_capability_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `idx_manufacturer_capability_hierarchy` (`is_deleted`,`is_custom`,`industry`,`specialization`) COMMENT 'For pulling all non-deleted non-custom capabilities within a given industry specialization'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Fixed three-tier hierarchy of capabilities used throughout manufacturing: industry > specialization > capability';

CREATE TABLE `manufacturer_contact_safelist` (
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_user_id` bigint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Entries in this table are allowed to contact manufacturers even if they have been identified as risky by the block-list rules computed in Api_Shop_MFG_ConvoRiskiness';

CREATE TABLE `manufacturer_index` (
  `manufacturer_id` bigint unsigned NOT NULL,
  `manufacturer_shard` int NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `manufacturer_url_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`manufacturer_id`),
  KEY `user_id` (`user_id`,`is_deleted`),
  KEY `shop_id` (`shop_id`,`is_deleted`),
  KEY `manufacturer_url_name` (`manufacturer_url_name`,`is_deleted`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mason_campaign` (
  `mason_campaign_id` bigint unsigned NOT NULL DEFAULT '0',
  `internal_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`mason_campaign_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mason_experience` (
  `mason_experience_id` bigint unsigned NOT NULL,
  `mason_campaign_id` bigint unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `start_time` int unsigned NOT NULL DEFAULT '0',
  `end_time` int unsigned NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`mason_experience_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mason_locale` (
  `mason_locale_id` bigint unsigned NOT NULL,
  `mason_campaign_id` bigint unsigned NOT NULL,
  `mason_experience_id` bigint unsigned NOT NULL,
  `is_active` tinyint unsigned NOT NULL DEFAULT '0',
  `locale_language` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `locale_region` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `locale_currency` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mason_locale_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`mason_locale_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `experience_locale_idx` (`mason_experience_id`,`locale_language`,`locale_region`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mason_path` (
  `mason_path_id` bigint unsigned NOT NULL,
  `mason_campaign_id` bigint unsigned NOT NULL,
  `url_path` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_active` tinyint unsigned NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`mason_path_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `url_path` (`url_path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `materials` (
  `material_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`material_id`),
  UNIQUE KEY `material_name_index` (`name`),
  KEY `material_create_index` (`create_date`),
  KEY `material_update_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='dictionary of all materials in listings';

CREATE TABLE `mc_businesses` (
  `mc_business_id` bigint unsigned NOT NULL,
  `channel_id` bigint unsigned NOT NULL,
  `channel_key` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `mc_business_shard` bigint unsigned NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`mc_business_id`,`channel_id`),
  KEY `channel_idx` (`channel_id`,`channel_key`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_collections` (
  `merch_collection_id` bigint unsigned NOT NULL,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `section_order` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `collection_shard` int NOT NULL,
  `old_shard` int unsigned NOT NULL DEFAULT '0',
  `migration_lock` int unsigned NOT NULL DEFAULT '0',
  `publish_date` int unsigned DEFAULT NULL,
  `last_export_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`merch_collection_id`),
  UNIQUE KEY `title` (`title`),
  KEY `update_date_index` (`update_date`),
  KEY `title_type_is_deleted_idx` (`title`(64),`type`(64),`is_deleted`),
  KEY `type_isdeleted` (`type`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_blog_featured_seller` (
  `shop_id` bigint NOT NULL,
  `merch_hub` varchar(16) DEFAULT NULL COMMENT 'If this is null, the seller hasn''t been placed into a merch hub',
  `blog_post_url` varchar(1024) NOT NULL,
  `featured_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`),
  KEY `idx_merch_hub_featured_date` (`merch_hub`,`featured_date`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_curated_listing` (
  `merch_hub_listing_set_id` bigint NOT NULL,
  `listing_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `is_sold` tinyint(1) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `is_flagged` tinyint(1) NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_listing_set_id`,`listing_id`),
  KEY `idx_featured_listing` (`listing_id`),
  KEY `idx_valid_listings_by_edition` (`merch_hub_listing_set_id`,`is_sold`,`is_flagged`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_edition` (
  `merch_hub_edition_id` bigint NOT NULL,
  `merch_hub` varchar(16) NOT NULL,
  `serialized_data` text NOT NULL COMMENT 'Serialized JSON data',
  `live_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_edition_id`),
  KEY `idx_merch_hub_live_date` (`merch_hub`,`live_date`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_featured_curator` (
  `merch_hub_edition_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `featured_listings` text NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_edition_id`,`user_id`),
  KEY `idx_featured_user` (`user_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_featured_listing_query` (
  `merch_hub_edition_id` bigint NOT NULL,
  `query` varchar(256) NOT NULL,
  `recipient` bigint DEFAULT NULL,
  `occasion` bigint DEFAULT NULL,
  `style` bigint DEFAULT NULL,
  `min_price` int DEFAULT NULL,
  `max_price` int DEFAULT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_edition_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_featured_seller` (
  `merch_hub_edition_id` bigint NOT NULL,
  `shop_id` bigint NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_edition_id`,`shop_id`),
  KEY `idx_featured_shop` (`shop_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_featured_treasury` (
  `merch_hub_edition_id` bigint NOT NULL,
  `treasury_key` varchar(128) NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `description` varchar(512) DEFAULT NULL,
  `link_url` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`merch_hub_edition_id`,`treasury_key`),
  KEY `idx_featured_treasury` (`treasury_key`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_listing_set` (
  `merch_hub_listing_set_id` bigint NOT NULL,
  `merch_hub_edition_id` bigint NOT NULL,
  `set_type` varchar(16) NOT NULL,
  `serialized_data` text NOT NULL COMMENT 'Serialized JSON data',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_listing_set_id`),
  KEY `idx_edition_id_set_type` (`merch_hub_edition_id`,`set_type`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_hub_removed_listing` (
  `merch_hub_listing_set_id` bigint NOT NULL,
  `listing_id` bigint NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_hub_listing_set_id`,`listing_id`),
  KEY `idx_removed_listing` (`listing_id`),
  KEY `idx_create_date` (`create_date`),
  KEY `idx_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merchandised_collections` (
  `merchandised_collection_id` bigint unsigned NOT NULL,
  `creator_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(2000) DEFAULT '',
  `status` smallint unsigned NOT NULL,
  `privacy_level` smallint DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `locale_id` smallint unsigned DEFAULT NULL,
  `metadata` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`merchandised_collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merchandised_collections_listings` (
  `collection_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`collection_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oracle_group` (
  `group_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `locales` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `member_type` varchar(16) COLLATE utf8mb4_general_ci NOT NULL,
  `enabled` tinyint NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `oracle_group_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oracle_lookup` (
  `lookup_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `relationship_type` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `id_1` bigint unsigned NOT NULL,
  `id_2` bigint unsigned NOT NULL,
  `priority` int unsigned NOT NULL,
  PRIMARY KEY (`lookup_id`),
  KEY `oracle_lookup_id_idx` (`id_1`,`id_2`),
  KEY `oracle_lookup_id_2_idx` (`id_2`),
  KEY `oracle_lookup_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oracle_question` (
  `question_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `content` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `mailbox` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `phone_support_flag_type` int unsigned NOT NULL DEFAULT '0',
  `parent_id` bigint unsigned NOT NULL,
  `priority` int unsigned NOT NULL,
  `checkbox_status` int unsigned NOT NULL DEFAULT '0',
  `phone_support_status` int unsigned NOT NULL DEFAULT '0',
  `open_case_status` int unsigned NOT NULL DEFAULT '0',
  `ask_for_order` int unsigned NOT NULL DEFAULT '0',
  `zendesk_tag` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`question_id`),
  KEY `oracle_question_parent_id_idx` (`parent_id`),
  KEY `oracle_question_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oracle_selfservicelink` (
  `link_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `link_url` varchar(255) NOT NULL,
  `link_text` varchar(255) NOT NULL,
  PRIMARY KEY (`link_id`),
  KEY `oracle_selfservicelink_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oracle_topic` (
  `topic_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `heading` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `priority` int unsigned NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `oracle_topic_group_id_idx` (`group_id`),
  KEY `oracle_topic_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_index` (
  `page_id` bigint unsigned NOT NULL DEFAULT '0',
  `page_shard` int NOT NULL,
  `page_slug` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Default: 1 = active',
  `type` tinyint unsigned NOT NULL DEFAULT '1',
  `category` tinyint unsigned NOT NULL DEFAULT '0',
  `is_official` tinyint unsigned NOT NULL DEFAULT '0',
  `group_id` bigint unsigned NOT NULL DEFAULT '0',
  `image_id` bigint unsigned DEFAULT NULL,
  `page_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creator_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `slug_idx` (`page_slug`),
  KEY `update_date_idx` (`update_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `group_idx` (`group_id`),
  KEY `status_type` (`status`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pinterest_top_terms_index` (
  `term` varchar(64) NOT NULL,
  `term_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`term`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `preferences` (
  `preference_id` int unsigned NOT NULL,
  `preference_name` varchar(100) NOT NULL,
  `preference_datatype` varchar(7) NOT NULL,
  `preference_default` varchar(100) DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`preference_name`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Table used for storing all types of user preferences';

CREATE TABLE `promotions_index` (
  `promotion_id` bigint unsigned NOT NULL,
  `promotion_code` varchar(50) NOT NULL,
  `promotion_type` smallint unsigned DEFAULT NULL,
  `promotion_status` smallint unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `is_internal` tinyint unsigned NOT NULL DEFAULT '0',
  `is_new_listing_only` tinyint unsigned NOT NULL DEFAULT '0',
  `eligible_country_ids` varchar(255) NOT NULL DEFAULT '',
  `start_date` int unsigned DEFAULT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `terms_link` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`promotion_id`),
  UNIQUE KEY `promotion_code_unique` (`promotion_code`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `promotion_status` (`promotion_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `promotions_listing_credits_data` (
  `promotion_id` bigint unsigned NOT NULL,
  `beginning_credits` int NOT NULL DEFAULT '20',
  `seller_status` tinyint unsigned NOT NULL DEFAULT '3',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`promotion_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `properties` (
  `property_id` bigint unsigned NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `solrType` varchar(45) NOT NULL,
  `created` int unsigned NOT NULL,
  `modified` int unsigned NOT NULL,
  `ott_attribute_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `created_idx` (`created`),
  KEY `modified_idx` (`modified`),
  KEY `ott_attribute_id` (`ott_attribute_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `property_option_input_translations` (
  `value_id` bigint unsigned NOT NULL,
  `language` tinyint unsigned NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_dirty` tinyint(1) NOT NULL DEFAULT '0',
  `translation_system_id` smallint unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`value_id`,`language`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `property_option_inputs` (
  `value_id` bigint unsigned NOT NULL,
  `property_id` bigint unsigned NOT NULL,
  `value` varbinary(255) NOT NULL,
  `order` int unsigned NOT NULL,
  `listing_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `suggested` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `language` tinyint unsigned DEFAULT '0',
  `ott_value_id` bigint unsigned NOT NULL DEFAULT '0',
  `ott_value_qualifier` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`value_id`),
  KEY `listing_enabled` (`listing_enabled`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `value_id_idx` (`property_id`,`value`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `property_options` (
  `property_option_id` bigint unsigned NOT NULL,
  `property_id` bigint unsigned NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `query_facet_rules` (
  `query_facet_rule_id` bigint NOT NULL AUTO_INCREMENT,
  `market` varchar(32) NOT NULL,
  `query` varchar(255) NOT NULL,
  `facet` varchar(128) NOT NULL,
  PRIMARY KEY (`query_facet_rule_id`),
  UNIQUE KEY `market_query` (`market`,`query`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `receipt_map` (
  `receipt_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`receipt_id`),
  UNIQUE KEY `shop_receipt_id` (`shop_id`,`receipt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scheduled_notification` (
  `scheduled_notification_id` bigint unsigned NOT NULL,
  `message` varchar(255) NOT NULL,
  `landing_page_data` varchar(255) DEFAULT NULL,
  `landing_page_id` int unsigned DEFAULT NULL,
  `notification_type` varchar(255) NOT NULL,
  `scheduled_send_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`scheduled_notification_id`),
  KEY `scheduled_send_date_idx` (`scheduled_send_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemanator_test` (
  `id` int NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT '',
  `is_active` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Test table created by schemanator';

CREATE TABLE `searchads_keywords` (
  `keyword` varchar(64) NOT NULL,
  `keyword_shard` int NOT NULL,
  `old_shard` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `cpm` double DEFAULT NULL,
  PRIMARY KEY (`keyword`),
  KEY `keyword` (`keyword`,`is_active`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_action` (
  `security_action_id` bigint unsigned NOT NULL,
  `nickname` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `expression` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `updater_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `context` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  PRIMARY KEY (`security_action_id`),
  KEY `rule_update_date_idx` (`update_date`),
  KEY `rule_create_date_idx` (`create_date`),
  KEY `rule_nickname_idx` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_action_audit` (
  `audit_id` bigint unsigned NOT NULL,
  `security_action_id` bigint unsigned NOT NULL,
  `context` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `nickname` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `expression` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `expire_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`security_action_id`,`audit_id`),
  UNIQUE KEY `audit_id_idx` (`audit_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_rule` (
  `security_rule_id` bigint unsigned NOT NULL,
  `context` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `expression` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mode` tinyint(1) NOT NULL DEFAULT '0',
  `rollout` tinyint NOT NULL DEFAULT '-1' COMMENT '0-100 integer representing rollout percentage of the rule',
  `creator_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `updater_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `expire_date` int NOT NULL DEFAULT '0',
  `archive_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`security_rule_id`),
  KEY `rule_update_date_idx` (`update_date`),
  KEY `rule_create_date_idx` (`create_date`),
  KEY `rule_expire_date_idx` (`expire_date`),
  KEY `rule_nickname_idx` (`nickname`),
  KEY `rule_location_mode_idx` (`location`,`mode`),
  KEY `rule_context_idx` (`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_rule_action` (
  `security_rule_id` bigint unsigned NOT NULL,
  `security_action_id` bigint unsigned NOT NULL,
  `index` int unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`security_rule_id`,`security_action_id`),
  KEY `rule_update_date_idx` (`update_date`),
  KEY `rule_create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `security_rule_audit` (
  `audit_id` bigint unsigned NOT NULL,
  `security_rule_id` bigint unsigned NOT NULL,
  `context` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
  `expression` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mode` tinyint(1) NOT NULL DEFAULT '0',
  `rollout` tinyint NOT NULL DEFAULT '-1' COMMENT '0-100 integer representing rollout percentage of the rule',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `expire_date` int NOT NULL DEFAULT '0',
  `archive_date` int NOT NULL DEFAULT '0',
  `actions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`security_rule_id`,`audit_id`),
  UNIQUE KEY `audit_id_idx` (`audit_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `segment_definitions` (
  `segment_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `query` text,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_scheduled` tinyint(1) NOT NULL DEFAULT '0',
  `schedule_frequency` bigint unsigned NOT NULL,
  `name` varchar(150) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`segment_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `segment_population_runs` (
  `segment_run_id` bigint unsigned NOT NULL,
  `segment_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`segment_id`,`segment_run_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipment_map` (
  `shipment_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_label_map` (
  `shipping_label_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`shipping_label_id`),
  UNIQUE KEY `shop_shipping_label_id` (`shop_id`,`shipping_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shipping_method` (
  `shipping_method_id` bigint unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `min_ship_days` tinyint unsigned NOT NULL,
  `max_ship_days` tinyint unsigned NOT NULL,
  `is_international` tinyint unsigned NOT NULL,
  `is_saturday_deliverable` tinyint unsigned NOT NULL,
  `is_visible` tinyint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`shipping_method_id`),
  KEY `shipping_method_is_visible_idx` (`is_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_post_map` (
  `post_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`post_id`),
  UNIQUE KEY `shop_post_id` (`shop_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_square_connection` (
  `shop_id` bigint unsigned NOT NULL,
  `access_token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_expiration_date` int unsigned NOT NULL,
  `refresh_token` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_synced_date` int unsigned DEFAULT NULL,
  `square_location_name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `square_location_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `square_shop_name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`shop_id`),
  KEY `square_location_id_idx` (`square_location_id`),
  KEY `access_token_expiration_date_idx` (`access_token_expiration_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `refresh_token_idx` (`refresh_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shops_index` (
  `shop_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_shard` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `listing_denormalized_update_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `read_ready` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`shop_id`),
  UNIQUE KEY `shop_name_unique` (`name`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `update_date` (`update_date`),
  KEY `status` (`status`),
  KEY `listing_denormalized_update_date` (`listing_denormalized_update_date`),
  KEY `create_date_index` (`create_date`),
  KEY `shop_shard_idx` (`shop_shard`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shops_index_temp` (
  `shop_id` bigint unsigned NOT NULL,
  `shop_shard` int NOT NULL,
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sniffd_heartbeats_index` (
  `heartbeats_id` bigint unsigned NOT NULL,
  `machine_id` bigint unsigned NOT NULL,
  `heartbeats` bigint unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`heartbeats_id`,`machine_id`),
  UNIQUE KEY `machine_id_idx` (`machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spell_corrected_terms` (
  `spell_corrected_terms_id` bigint NOT NULL,
  `word` varchar(255) NOT NULL,
  `correction` text NOT NULL,
  PRIMARY KEY (`spell_corrected_terms_id`),
  KEY `word` (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `stash_user_role` (
  `user_id` bigint unsigned NOT NULL,
  `role` tinyint unsigned NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `role_idx` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `temporary_weddings_emails` (
  `email_id` bigint unsigned NOT NULL,
  `wedding_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`email_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_searches` (
  `batch_id` bigint NOT NULL,
  `type` varchar(255) NOT NULL,
  `terms` text NOT NULL,
  `batch_date` int NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `batch_date` (`batch_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tracking_service_map` (
  `tracking_service_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipment_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_service_id`),
  KEY `shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `transaction_reporting_cases` (
  `case_id` bigint NOT NULL,
  `case_shard` bigint NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `receipt_id` bigint NOT NULL DEFAULT '0',
  `instigator` varchar(32) NOT NULL DEFAULT 'Not set',
  `admin_id` bigint NOT NULL DEFAULT '0',
  `buyer_user_id` bigint NOT NULL DEFAULT '0',
  `seller_user_id` bigint NOT NULL DEFAULT '0',
  `shopname` varchar(64) NOT NULL DEFAULT 'Not set',
  `current_state` varchar(2) NOT NULL DEFAULT 'A',
  `current_state_date` int NOT NULL DEFAULT '0',
  `receipt_create_date` int NOT NULL DEFAULT '0',
  `sent_pp_notice` tinyint(1) NOT NULL DEFAULT '0',
  `payment_type` varchar(16) NOT NULL DEFAULT 'unset',
  `case_type` varchar(20) NOT NULL DEFAULT 'NON_DELIVERY',
  PRIMARY KEY (`case_id`),
  KEY `admin_id` (`admin_id`),
  KEY `create_date` (`create_date`),
  KEY `buyer_user_id` (`buyer_user_id`),
  KEY `seller_user_id` (`seller_user_id`),
  KEY `current_state` (`current_state`),
  KEY `current_state_date` (`current_state_date`),
  KEY `receipt_create_date` (`receipt_create_date`),
  KEY `receipt_id` (`receipt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `transactions_index` (
  `transaction_id` bigint NOT NULL,
  `shop_id` int NOT NULL,
  `transaction_shard` int NOT NULL,
  `update_date` int NOT NULL,
  `create_date` int NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `receipt_id` bigint NOT NULL,
  `buyer_user_id` bigint unsigned NOT NULL,
  `order_date` int unsigned NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `shop_id` (`shop_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_competition_entries` (
  `competition_id` int NOT NULL,
  `shop_id` bigint NOT NULL,
  `create_time` int NOT NULL,
  PRIMARY KEY (`competition_id`,`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `treasury_comment_transition` (
  `mongo_id` char(25) NOT NULL COMMENT 'uniquely identifies the mongo treasury comment',
  `sql_id` bigint unsigned NOT NULL COMMENT 'uniquely identifies the sql forum post',
  `treasury_sql_id` bigint unsigned NOT NULL COMMENT 'uniquely identifies the mysql treasury',
  `treasury_owner_id` bigint unsigned NOT NULL COMMENT 'the user_id of the member that created the treasury',
  `create_date` int unsigned NOT NULL COMMENT 'creation date',
  PRIMARY KEY (`mongo_id`,`sql_id`),
  KEY `sql_id` (`sql_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='used to migrate comments from mongo to the shards';

CREATE TABLE `treasury_head` (
  `treasury_id` bigint unsigned NOT NULL COMMENT 'uniquely identifies the treasury',
  `title` varchar(127) DEFAULT NULL COMMENT 'the title of the treasury',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_id` bigint unsigned NOT NULL COMMENT 'the user_id of the member that created the treasury',
  `hotness` float NOT NULL COMMENT 'hotness value',
  `mature` smallint NOT NULL COMMENT '1 if it is mature, 0 if it is safe',
  `private` smallint NOT NULL COMMENT '1 if it is private, 0 if it is public',
  `create_date` int unsigned NOT NULL COMMENT 'creation date',
  `update_date` int unsigned NOT NULL COMMENT 'time treasury was last edited',
  `became_public_date` int unsigned NOT NULL COMMENT 'time treasury first switched from private to public',
  `owner_avatar_id` bigint NOT NULL COMMENT 'the avatar of owner_id',
  `owner_login_name` varchar(255) NOT NULL COMMENT 'username of the owner',
  `comment_count` int NOT NULL DEFAULT '0' COMMENT 'how many comments have been left on the treasury',
  `stat_count` int NOT NULL DEFAULT '0' COMMENT 'sum of clicks and views',
  `listing_image_id_1` bigint NOT NULL COMMENT 'image id for child listing',
  `listing_image_id_2` bigint NOT NULL COMMENT 'image id for child listing',
  `listing_image_id_3` bigint NOT NULL COMMENT 'image id for child listing',
  `listing_image_id_4` bigint NOT NULL COMMENT 'image id for child listing',
  `listing_image_key_1` varchar(127) NOT NULL DEFAULT '' COMMENT 'Image key for listing 1',
  `listing_image_key_2` varchar(127) NOT NULL DEFAULT '' COMMENT 'Image key for listing 2',
  `listing_image_key_3` varchar(127) NOT NULL DEFAULT '' COMMENT 'Image key for listing 3',
  `listing_image_key_4` varchar(127) NOT NULL DEFAULT '' COMMENT 'Image key for listing 4',
  PRIMARY KEY (`treasury_id`),
  KEY `private` (`private`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='holds the hottest treasuries, lots of turnover';

CREATE TABLE `treasury_normalized_tag` (
  `tag` varchar(127) NOT NULL COMMENT 'a tag containing no spaces',
  `normalized_tag` varchar(127) NOT NULL COMMENT 'normalized version of tag',
  PRIMARY KEY (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='maps a tag to its normalized version';

CREATE TABLE `treasury_tag_facet` (
  `tag` varchar(127) NOT NULL COMMENT 'a normalized tag containing no spaces',
  `facet` smallint NOT NULL COMMENT 'which facet or category this tag falls in',
  PRIMARY KEY (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='maps tags to their facet category';

CREATE TABLE `treasury_transition` (
  `mongo_id` char(25) NOT NULL COMMENT 'uniquely identifies the mongo treasury',
  `sql_id` bigint unsigned NOT NULL COMMENT 'uniquely identifies the sql treasury',
  `owner_id` bigint unsigned NOT NULL COMMENT 'the user_id of the member that created the treasury',
  `create_date` int unsigned NOT NULL COMMENT 'creation date',
  PRIMARY KEY (`mongo_id`,`sql_id`),
  KEY `sql_id` (`sql_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='used to migrate from mongo to the shards';

CREATE TABLE `treasury_trending_tag` (
  `count_date` int unsigned NOT NULL COMMENT 'date the tag data was recorded',
  `tag_count` int unsigned NOT NULL COMMENT 'how many times this tag was used on the given date',
  `tag_name` varchar(127) NOT NULL COMMENT 'the tag name',
  `facet` int NOT NULL COMMENT 'the facet the tag_name maps to',
  `trend` int NOT NULL COMMENT 'value representing the tags trend over the last ten days',
  `xy_avg` int NOT NULL COMMENT 'used to compute the trend',
  `y_avg` int NOT NULL COMMENT 'used to compute the trend',
  PRIMARY KEY (`count_date`,`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='tracks the treasury tag trends';

CREATE TABLE `tt_splash_listings` (
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` int unsigned NOT NULL,
  `bucket` int unsigned NOT NULL,
  `creation_time` int unsigned NOT NULL,
  `curator_user_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`listing_id`),
  KEY `tt_splash_listings_in_bucket` (`bucket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_case_content_template` (
  `user_case_content_template_id` bigint NOT NULL DEFAULT '0',
  `admin_id` bigint NOT NULL DEFAULT '0',
  `parent_id` bigint NOT NULL DEFAULT '0',
  `template_data` text NOT NULL,
  `label` varchar(32) NOT NULL DEFAULT '',
  `type` varchar(16) NOT NULL DEFAULT '',
  `state` int NOT NULL DEFAULT '0',
  `language` varchar(16) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_case_content_template_id`),
  KEY `admin_id` (`admin_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_case_index` (
  `user_case_id` bigint NOT NULL DEFAULT '0',
  `staff_id` bigint NOT NULL DEFAULT '0',
  `user_id` bigint NOT NULL DEFAULT '0',
  `instigator_id` bigint NOT NULL DEFAULT '0',
  `task_id` bigint NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '',
  `state` varchar(32) NOT NULL DEFAULT '',
  `label` varchar(32) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `user_case_shard` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `escalation_level` int unsigned NOT NULL DEFAULT '0',
  `escalation_date` int unsigned NOT NULL DEFAULT '0',
  `resolution_state` int unsigned NOT NULL DEFAULT '0',
  `receipt_id` bigint NOT NULL DEFAULT '0',
  `sent_pp_notice` tinyint(1) NOT NULL DEFAULT '0',
  `receipt_create_date` int unsigned NOT NULL DEFAULT '0',
  `payment_type` varchar(16) NOT NULL DEFAULT '',
  `refund_status` smallint NOT NULL DEFAULT '-1',
  `version` int NOT NULL DEFAULT '1',
  `refund_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_case_id`),
  KEY `staff_id` (`staff_id`),
  KEY `user_id` (`user_id`),
  KEY `task_id` (`task_id`),
  KEY `label` (`label`),
  KEY `receipt_id_idx` (`receipt_id`),
  KEY `instigator_id_idx` (`instigator_id`),
  KEY `update_date` (`update_date`),
  KEY `state_resolutionstate_escalationlevel_escalation_date` (`state`,`resolution_state`,`escalation_level`,`escalation_date`),
  KEY `sentppnotice_paymenttype_resolutionstate` (`sent_pp_notice`,`payment_type`,`resolution_state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_namechange_requests` (
  `namechange_request_id` bigint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `old_first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT '0',
  `deny_message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_origin` tinyint unsigned NOT NULL DEFAULT '0',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  `resolution_date` int unsigned NOT NULL DEFAULT '0',
  `admin_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_admin_note_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`namechange_request_id`),
  KEY `user_id` (`user_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `users_index` (
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_shard` int NOT NULL,
  `login_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `first_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'de-normalized from users table',
  `avatar_id` int unsigned DEFAULT NULL,
  `password_old` varchar(144) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password_migration_state` tinyint(1) NOT NULL DEFAULT '0',
  `password_reset_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `is_seller` tinyint(1) NOT NULL DEFAULT '0',
  `is_mute` tinyint(1) NOT NULL DEFAULT '0',
  `is_forum_mute` tinyint(1) NOT NULL DEFAULT '0',
  `is_frozen` tinyint(1) NOT NULL DEFAULT '0',
  `is_admin` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'de-normalized from users table',
  `is_name_withheld` tinyint(1) NOT NULL DEFAULT '0',
  `is_nipsa` tinyint(1) NOT NULL DEFAULT '0',
  `is_redacted` tinyint(1) NOT NULL DEFAULT '0',
  `lat` float(8,4) DEFAULT NULL,
  `lon` float(8,4) DEFAULT NULL,
  `user_state` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'active' COMMENT 'de-normalized from users table',
  `last_login_date` int NOT NULL DEFAULT '0',
  `location_update_date` int NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `can_receive_email` tinyint NOT NULL DEFAULT '0',
  `is_test_puppet` tinyint(1) NOT NULL DEFAULT '0',
  `pseudonym` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `muted_until` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `primary_email_unique` (`primary_email`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `login_name` (`login_name`),
  KEY `is_admin` (`is_admin`),
  KEY `user_state-user_id` (`user_state`,`user_id`),
  KEY `is_seller-update_date` (`is_seller`,`update_date`),
  KEY `location_update_date` (`location_update_date`),
  KEY `idx_users_index_password_migration_state` (`password_migration_state`),
  KEY `user_shard_idx` (`user_shard`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_tracking_index` (
  `tracking_code` varchar(34) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'present if epostage label',
  `shard` int unsigned NOT NULL,
  `old_shard` int unsigned NOT NULL DEFAULT '0',
  `migration_lock` int unsigned NOT NULL DEFAULT '0',
  `usps_transmission_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'time we transmitted tracking code to USPS for extracting',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `usps_filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'the usps filename of the manifest upload',
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'the s3 file path of the manifest upload',
  PRIMARY KEY (`tracking_code`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='lookup table for a usps tracking code supplied via mark as shipped or a shipping label';

CREATE TABLE `usps_transactions_index` (
  `transaction_date` int unsigned NOT NULL,
  `shard` int unsigned NOT NULL DEFAULT '0',
  `migration_lock` int unsigned NOT NULL DEFAULT '0',
  `old_shard` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`transaction_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `watchlist` (
  `context` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `term` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `expire_date` int NOT NULL DEFAULT '0',
  `notes` varchar(1023) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_admin` bigint unsigned NOT NULL DEFAULT '0',
  `update_admin` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`context`,`term`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `watchlist_expire_date_idx` (`expire_date`),
  KEY `context_create_term` (`context`,`create_date`,`term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `wholesale_buyers_index` (
  `buyer_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `state` tinyint NOT NULL DEFAULT '0',
  `buyer_shard` int NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`buyer_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `wholesale_curation` (
  `product_set_id` bigint unsigned NOT NULL,
  `products` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`product_set_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`),
  KEY `sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `wholesale_vendors_index` (
  `vendor_id` bigint unsigned NOT NULL,
  `business_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `vendor_shard` int NOT NULL,
  `vendor_state` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vendor_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `xylem_asset` (
  `asset_id` bigint unsigned NOT NULL,
  `asset_shard` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`asset_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `xylem_document` (
  `document_id` bigint unsigned NOT NULL,
  `document_shard` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `migration_lock` int NOT NULL DEFAULT '0',
  `old_shard` int NOT NULL DEFAULT '0',
  `application` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`document_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

