CREATE DATABASE etsy_apollo_0_A;
USE etsy_apollo_0_A;

CREATE TABLE `apollo_filter` (
  `filter_id` bigint unsigned NOT NULL,
  `owner_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `root_filter_rule_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `policy_id` bigint unsigned NOT NULL DEFAULT '0',
  `priority` tinyint unsigned NOT NULL DEFAULT '0',
  `reassign_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `job` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `suite` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `filter_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `filter_order` int unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `send_to_zendesk` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`filter_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `suite_status_idx` (`suite`,`status`),
  KEY `type_status_idx` (`type`,`status`),
  KEY `tag_idx` (`tag_id`),
  KEY `task_status_idx` (`task_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_filter_rule` (
  `filter_rule_id` bigint unsigned NOT NULL,
  `filter_id` bigint unsigned NOT NULL,
  `rule_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `params` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`filter_rule_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `filter_idx` (`filter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_preference` (
  `preference` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `suite` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`preference`,`staff_id`,`suite`,`queue`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_qa_category` (
  `apollo_qa_category_id` bigint unsigned NOT NULL,
  `enabled` tinyint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `criteria` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'JSON criteria',
  `grader_task_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Prefix for tag applied to grader tasks',
  `source_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue in the Flags suite we pull tasks from',
  `grader_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue for grader tasks',
  `sme_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue for SME tasks',
  `remediation_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Apollo queue for remediation tasks',
  `sample_rate_pct` int unsigned NOT NULL COMMENT 'Sample rate (0-100)',
  `sort_order` int unsigned NOT NULL COMMENT 'Sort order of this category (lowest checked first)',
  `sample_frequency` int unsigned NOT NULL DEFAULT '7' COMMENT 'Frequency of sampling (in days)',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_qa_category_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `enabled_source_queue_idx` (`enabled`,`source_queue`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_qa_category_audit` (
  `apollo_qa_category_audit_id` bigint unsigned NOT NULL,
  `apollo_qa_category_id` bigint unsigned NOT NULL,
  `enabled` tinyint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `criteria` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'JSON criteria',
  `grader_task_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Prefix for tag applied to grader tasks',
  `source_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue in the Flags suite we pull tasks from',
  `grader_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue for grader tasks',
  `sme_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Apollo queue for SME tasks',
  `remediation_queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Apollo queue for remediation tasks',
  `sample_rate_pct` int unsigned NOT NULL COMMENT 'Sample rate (0-100)',
  `sort_order` int unsigned NOT NULL COMMENT 'Sort order of this category (lowest checked first)',
  `sample_frequency` int unsigned NOT NULL DEFAULT '7' COMMENT 'Frequency of sampling (in days)',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `audit_staff_id` bigint unsigned NOT NULL,
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_qa_category_audit_id`),
  KEY `apollo_qa_category_idx` (`apollo_qa_category_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_qa_grade` (
  `apollo_qa_grade_id` bigint unsigned NOT NULL,
  `apollo_qa_review_id` bigint unsigned NOT NULL,
  `grader_task_id` bigint unsigned NOT NULL COMMENT 'Apollo Task assigned to the grader',
  `grader_label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Example: A, B, SME',
  `staff_id` bigint unsigned NOT NULL COMMENT 'Staff who submitted this grade',
  `accuracy` tinyint NOT NULL COMMENT '-1 = undecided, 0 = inacurate, 1 = accurate',
  `grade_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_qa_grade_id`),
  KEY `apollo_qa_review_idx` (`apollo_qa_review_id`),
  KEY `grader_task_idx` (`grader_task_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_qa_review` (
  `apollo_qa_review_id` bigint unsigned NOT NULL,
  `apollo_qa_category_id` bigint unsigned NOT NULL,
  `job_status` tinyint unsigned NOT NULL COMMENT '0 = submitted, 1 = accepted, 2 = discarded',
  `run_date` int unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Agent who completed the task',
  `task_actioned` tinyint unsigned NOT NULL COMMENT '0 = task not actioned, 1 = task actioned',
  `remediation_task_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Remedation tracking task, FK: apollo_task.task_id',
  `remediation_staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Staff who handled remediation, FK: staff.id',
  `remediation_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Date remediation was completed',
  `remediation_session_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'WFM session during which remediation was completed, FK: agent_session.agent_session_id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_qa_review_id`),
  KEY `category_status_run_date_idx` (`apollo_qa_category_id`,`job_status`,`run_date`),
  KEY `task_idx` (`task_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `remediation_task_idx` (`remediation_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_queue` (
  `queue_id` bigint unsigned NOT NULL,
  `default_policy_id` bigint unsigned NOT NULL DEFAULT '0',
  `suite` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mnemonic` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `task_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tool_class` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apollo_profile` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `enabled_at` int unsigned DEFAULT NULL,
  `fast_queue_enabled_at` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`queue_id`),
  UNIQUE KEY `mnemonic` (`mnemonic`),
  KEY `enabled_at` (`enabled_at`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `suite_task_type_profile_idx` (`suite`,`task_type`,`apollo_profile`),
  KEY `fast_queue_enabled_at` (`fast_queue_enabled_at`),
  KEY `queue_name` (`queue_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_queue_policy` (
  `queue_id` bigint unsigned NOT NULL,
  `policy_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`queue_id`,`policy_id`),
  KEY `policy_idx` (`policy_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_queue_restrictions` (
  `apollo_queue_restrictions_id` bigint unsigned NOT NULL,
  `queue_id` bigint unsigned NOT NULL,
  `restriction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_queue_restrictions_id`),
  UNIQUE KEY `queue_id` (`queue_id`,`restriction`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_queue_roles` (
  `apollo_queue_role_id` bigint unsigned NOT NULL,
  `queue_id` bigint unsigned NOT NULL,
  `category` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `role_action` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`apollo_queue_role_id`),
  UNIQUE KEY `queue_category_action_idx` (`queue_id`,`category`,`role_action`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_tag` (
  `tag_id` bigint unsigned NOT NULL,
  `owner_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `suite` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `color` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `suite_owner_type_name_idx` (`suite`,`owner_staff_id`,`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task` (
  `task_id` bigint unsigned NOT NULL,
  `parent_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `policy_id` bigint unsigned NOT NULL DEFAULT '0',
  `priority` tinyint NOT NULL DEFAULT '0',
  `views` bigint unsigned NOT NULL DEFAULT '0',
  `language` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lock` bigint unsigned NOT NULL DEFAULT '0',
  `reopen_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `sort_val` int NOT NULL DEFAULT '0',
  `zendesk_ticket_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`task_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `state_type_queue_priority_date_idx` (`state`,`type`,`queue`,`priority`,`create_date`),
  KEY `state_type_queue_staff_priority_date_idx` (`state`,`type`,`queue`,`staff_id`,`priority`,`create_date`),
  KEY `task_state_type_queue_priority_date_idx` (`task_id`,`state`,`type`,`queue`,`priority`,`create_date`),
  KEY `task_state_type_queue_staff_priority_date_idx` (`task_id`,`state`,`type`,`queue`,`staff_id`,`priority`,`create_date`),
  KEY `lock_idx` (`lock`),
  KEY `parent_task_idx` (`parent_task_id`),
  KEY `sort_val_idx` (`sort_val`),
  KEY `zendesk_ticket_id_idx` (`zendesk_ticket_id`),
  KEY `staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_audit` (
  `task_id` bigint unsigned NOT NULL,
  `task_audit_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `policy_id` bigint unsigned NOT NULL DEFAULT '0',
  `priority` int NOT NULL DEFAULT '0',
  `language` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reopen_date` int unsigned NOT NULL DEFAULT '0',
  `audit_action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `audit_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `audit_info` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `audit_data` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`task_audit_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `type_audit_staff_date_idx` (`type`,`audit_staff_id`,`create_date`),
  KEY `auditaction_staffid_task_id` (`audit_action`,`staff_id`,`task_id`),
  KEY `state_auditaction_createdate` (`state`,`audit_action`,`create_date`),
  KEY `type_audit_action_idx` (`type`,`audit_action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_kb_article` (
  `task_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `kb_article_group_id` bigint unsigned NOT NULL,
  `kb_article_id` bigint unsigned NOT NULL,
  `nova_article_id` bigint unsigned NOT NULL DEFAULT '0',
  `nova_article_language` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`object_id`,`kb_article_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_receipt` (
  `task_id` bigint unsigned NOT NULL,
  `receipt_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`receipt_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `receipt_idx` (`receipt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_session` (
  `task_id` bigint unsigned NOT NULL,
  `task_session_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `start_audit_id` bigint unsigned NOT NULL,
  `assign_date` int unsigned NOT NULL DEFAULT '0',
  `assign_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `view_date` int unsigned NOT NULL DEFAULT '0',
  `view_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `work_date` int unsigned NOT NULL DEFAULT '0',
  `work_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `end_date` int unsigned NOT NULL DEFAULT '0',
  `end_audit_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`task_session_id`),
  UNIQUE KEY `task_end_audit_idx` (`task_id`,`end_audit_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_tag` (
  `task_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  `owner_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`tag_id`,`owner_staff_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_owner_idx` (`task_id`,`owner_staff_id`),
  KEY `tag_owner_idx` (`tag_id`,`owner_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `apollo_task_user` (
  `task_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`task_id`,`user_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `user_date_idx` (`user_id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

