CREATE DATABASE schema_changes_0_A;
USE schema_changes_0_A;

CREATE TABLE `schemanator_locks` (
  `platform` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `owner` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `schemas_changing` text COLLATE utf8mb4_unicode_ci,
  `build_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Locks!';

