CREATE DATABASE etsy_failover_shard_001_0_A;
USE etsy_failover_shard_001_0_A;

CREATE TABLE `dap_test` (
  `id` bigint unsigned NOT NULL,
  `shard_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `uniq_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `num` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`shard_id`,`id`),
  UNIQUE KEY `uniq_name` (`uniq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Intended for Data Access Platform testing';

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `jpm_test_costrem` (
  `jpm_item_id` bigint unsigned NOT NULL,
  `jpm_batch_id` bigint unsigned DEFAULT NULL COMMENT 'Only used for H2H file based transfers, no need to batch GMP API items',
  `disbursement_id` bigint unsigned NOT NULL,
  `end_to_end_id` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique Txn ID generated used for this disbursement (Max Char 15, Unique)',
  `jpm_account_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JPM account id that was used for the disbursement',
  `amount` int unsigned NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso_country_code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bank_account_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `seller_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `seller_address_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reference_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'JPM TXN Status code',
  `item_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `process_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `disbursement_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'DISBURSEMENT/PENNYTEST',
  `gateway_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'GMP/BATCH',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`jpm_item_id`),
  KEY `jpm_batch_idx` (`jpm_batch_id`),
  KEY `bank_account_idx` (`bank_account_id`),
  KEY `disbursement_idx` (`disbursement_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `reference_idx` (`reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `legacy_partition_test_biweekly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

CREATE TABLE `legacy_partition_test_daily` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

CREATE TABLE `legacy_partition_test_hourly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

CREATE TABLE `legacy_partition_test_monthly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

CREATE TABLE `legacy_partition_test_weekly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

CREATE TABLE `partition_test_biweekly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

/* PARTITION MAINTAINER CONFIG 
formula: biweekly
retention_window_size: 3 */;

CREATE TABLE `partition_test_daily` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

/* PARTITION MAINTAINER CONFIG 
formula: daily
retention_window_size: 5 */;

CREATE TABLE `partition_test_hourly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

/* PARTITION MAINTAINER CONFIG 
formula: hourly
retention_window_size: 5 */;

CREATE TABLE `partition_test_monthly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

/* PARTITION MAINTAINER CONFIG 
formula: monthly
retention_window_size: 2 */;

CREATE TABLE `partition_test_weekly` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='For use in DBRE testing';

/* PARTITION MAINTAINER CONFIG 
formula: weekly
retention_window_size: 3 */;

CREATE TABLE `shop_data` (
  `shop_id` bigint unsigned NOT NULL,
  `k` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `v` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`shop_id`,`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_data2` (
  `shop_id` bigint unsigned NOT NULL,
  `k` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `v` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `a` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `b` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`shop_id`,`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_data3` (
  `shop_id` bigint unsigned NOT NULL,
  `k` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `v` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`shop_id`,`k`),
  UNIQUE KEY `test_uniq` (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_data_ccronin` (
  `shop_id` bigint unsigned NOT NULL,
  `k` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `v` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `s` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `q` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `z` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`shop_id`,`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_key_val` (
  `k` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `v` bigint DEFAULT NULL,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

