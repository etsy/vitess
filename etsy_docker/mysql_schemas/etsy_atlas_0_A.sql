CREATE DATABASE etsy_atlas_0_A;
USE etsy_atlas_0_A;

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

CREATE TABLE `actioning_type_configurations` (
  `actioning_type_configuration_id` bigint unsigned NOT NULL DEFAULT '0',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Easy to remmber mnemonic for querying',
  `configuration_description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `actioning_type_id` bigint unsigned NOT NULL COMMENT 'Associated_actioning_type (eg. MASS_CONVO)',
  `additional_param_keys` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT 'JSON optional argument keys maybe required for the configuration.',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`actioning_type_configuration_id`),
  UNIQUE KEY `mnemonic_idx` (`mnemonic`),
  KEY `actioning_type_id_mnemonic_idx` (`actioning_type_id`,`mnemonic`),
  KEY `create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `actioning_types` (
  `actioning_type_id` bigint unsigned NOT NULL DEFAULT '0',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Easy to remmber mnemonic for querying',
  `actioning_description` varchar(4095) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `actioning_class` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Name of class action type will call',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`actioning_type_id`),
  UNIQUE KEY `mnemonic_idx` (`mnemonic`),
  KEY `create_date_idx` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_badge_holders` (
  `admin_id` bigint unsigned NOT NULL,
  `badge_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`,`badge_id`),
  KEY `badge_id` (`badge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Map admin badges to people who have earned those badges';

CREATE TABLE `admin_badge_owners` (
  `admin_id` bigint unsigned NOT NULL,
  `badge_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`,`badge_id`),
  KEY `badge_id` (`badge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Map admin badges to people who can edit those badges';

CREATE TABLE `admin_badges` (
  `id` bigint unsigned NOT NULL,
  `badge_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `badge_alt` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `datafeed_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flavor_text` varchar(511) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Describe admin badges';

CREATE TABLE `admin_maker_craft_subtypes` (
  `id` bigint unsigned NOT NULL,
  `parent_type_id` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`,`parent_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_maker_craft_types` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_maker_skills` (
  `id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `office` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `craft_type_id` bigint unsigned NOT NULL,
  `craft_subtype_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_skill_level` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `can_teach` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`,`admin_id`,`craft_type_id`,`craft_subtype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_maker_tool_types` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_maker_tools` (
  `id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `office` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tool_type_id` bigint unsigned NOT NULL,
  `can_share` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`,`admin_id`,`tool_type_id`)
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

CREATE TABLE `agent_annotations_attributes` (
  `agent_annotations_attribute_id` bigint unsigned NOT NULL,
  `attribute_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'title, description, image, price...',
  `tool` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'takedown, witness, ...',
  `create_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_attribute_id`),
  UNIQUE KEY `attribute_tool_name` (`attribute_name`,`tool`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_categories` (
  `agent_annotations_category_id` bigint unsigned NOT NULL,
  `agent_annotations_scope_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.agent_annotations_scope.agent_annotations_scope_id',
  `parent_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_atlas.agent_annotations_categories.agent_annotations_category_id',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Louis Vuitton, LV, Gucci, ...',
  `category_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'primary' COMMENT 'primary, alias, ...',
  `create_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_category_id`),
  UNIQUE KEY `scope_category_idx` (`agent_annotations_scope_id`,`category_name`),
  KEY `agent_annotations_scope_idx` (`agent_annotations_scope_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_category_jobs` (
  `agent_annotations_category_job_id` bigint unsigned NOT NULL,
  `job_type` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'primary | alias | overwrite | ...',
  `agent_annotations_scope_id` bigint unsigned NOT NULL,
  `agent_annotations_category_id` bigint unsigned NOT NULL COMMENT 'target category',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'running | success | failure',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_category_job_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `scope_category_name_idx` (`agent_annotations_scope_id`,`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_contexts` (
  `agent_annotations_context_id` bigint unsigned NOT NULL,
  `tool` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'takedown' COMMENT 'takedown | flags | ... ',
  `tool_id` bigint unsigned DEFAULT '0',
  `context_data` text COLLATE utf8mb4_unicode_ci COMMENT 'JSON data',
  `scope` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `annotations_status` tinyint NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_context_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `tool_tool_id_idx` (`tool`,`tool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_datapoints` (
  `agent_annotations_datapoint_id` bigint unsigned NOT NULL,
  `agent_annotations_review_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.agent_annotations_review.agent_annotations_review_id',
  `attribute` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'title | description | image_path ... ',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `agent_annotations_label_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_atlas.agent_annotations_labels.agent_annotations_label_id',
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `agent_annotations_category_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_atlas.agent_annotations_categories.agent_annotations_category_id',
  `datapoint_index` int unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`agent_annotations_datapoint_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `agent_annotations_review_is_deleted_idx` (`agent_annotations_review_id`,`is_deleted`),
  KEY `agent_annotations_review_attr_index_idx` (`agent_annotations_review_id`,`attribute`,`datapoint_index`),
  KEY `agent_annotations_label_id_idx` (`agent_annotations_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_labels` (
  `agent_annotations_label_id` bigint unsigned NOT NULL,
  `agent_annotations_scope_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.agent_annotations_scope.agent_annotations_scope_id',
  `label_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_label_id`),
  UNIQUE KEY `scope_label_idx` (`agent_annotations_scope_id`,`label_value`),
  KEY `agent_annotations_scope_idx` (`agent_annotations_scope_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_labels_attributes` (
  `agent_annotations_label_attribute_id` bigint unsigned NOT NULL,
  `agent_annotations_label_id` bigint unsigned NOT NULL,
  `agent_annotations_attribute_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.agent_annotations_attributes.agent_annotations_attribute_id',
  `assessment` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_label_attribute_id`),
  UNIQUE KEY `label_attribute_idx` (`agent_annotations_label_id`,`agent_annotations_attribute_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_reviews` (
  `agent_annotations_review_id` bigint unsigned NOT NULL,
  `agent_annotations_context_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.agent_annotations_context.agent_annotations_context_id',
  `target_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'listing | shop | ... ',
  `target_id` bigint unsigned NOT NULL,
  `assessment` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'no_assessment, true_assessment, false_assessment, ...',
  `source_type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'flag | ... ',
  `source_id` bigint unsigned NOT NULL DEFAULT '0',
  `admin_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`agent_annotations_review_id`),
  KEY `agent_annotations_context_idx` (`agent_annotations_context_id`),
  KEY `target_type_id_idx` (`target_type`,`target_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_annotations_scopes` (
  `agent_annotations_scope_id` bigint unsigned NOT NULL,
  `scope_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `archive_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_aux.staff.id',
  PRIMARY KEY (`agent_annotations_scope_id`),
  UNIQUE KEY `scope_name_idx` (`scope_name`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_entity` (
  `agent_entity_id` bigint unsigned NOT NULL,
  `impl_type` varchar(50) NOT NULL COMMENT 'Apollo Task, Accertify Task etc.',
  `impl_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'FK to whichever implementation table',
  `impl_parent_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'FK to parent for whichever implementation table',
  `start_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'When this unit of work started',
  `completion_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'When this unit of work was completed (for good)',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`agent_entity_id`),
  UNIQUE KEY `impl_type_id_idx` (`impl_type`,`impl_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_event` (
  `agent_event_id` bigint unsigned NOT NULL,
  `agent_session_id` bigint unsigned NOT NULL COMMENT 'FK: agent_session.agent_session_id',
  `event_name` varchar(127) NOT NULL COMMENT 'Event name',
  `event_category` varchar(127) NOT NULL COMMENT 'Category of event, e.g "workflow_event", "general_event", "ui_event", "evaluation_event"',
  `agent_tool_id` bigint unsigned NOT NULL COMMENT 'FK: agent_tool.agent_tool_id',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `event_location` varchar(255) NOT NULL DEFAULT '' COMMENT 'Free text for metadata to the event, e.g a URL',
  `related_object_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: A related object to an event, e.g etsy_aux.flag.id',
  `related_object_type` varchar(127) NOT NULL DEFAULT '' COMMENT 'Type of the related object, e.g flag, task',
  PRIMARY KEY (`agent_event_id`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `agent_session_id` (`agent_session_id`),
  KEY `related_object_and_event_category` (`related_object_id`,`related_object_type`,`event_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_review_assist_recommendations` (
  `recommendation_id` bigint unsigned NOT NULL,
  `provider` varchar(127) NOT NULL COMMENT 'recommendation provider mnemonic',
  `prompt` varchar(127) NOT NULL COMMENT 'prompt mnemonic',
  `version` varchar(127) NOT NULL COMMENT 'prompt version',
  `object_type` varchar(127) NOT NULL COMMENT 'flag, listing...',
  `object_id` varchar(127) NOT NULL COMMENT 'id of the object',
  `raw_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'raw response',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`recommendation_id`),
  KEY `create_date` (`create_date`),
  KEY `recommendation_search` (`object_type`,`object_id`,`provider`,`prompt`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_session` (
  `agent_session_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `end_date` int unsigned NOT NULL DEFAULT '0',
  `agent_workflow_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: agent_workflow.agent_workflow_id',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`agent_session_id`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_session_entity` (
  `agent_session_entity_id` bigint unsigned NOT NULL,
  `agent_session_id` bigint unsigned NOT NULL COMMENT 'FK: agent_session.agent_session_id',
  `agent_entity_id` bigint unsigned NOT NULL COMMENT 'FK: agent_entity.agent_entity_id',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`agent_session_entity_id`),
  UNIQUE KEY `agent_session_entity_idx` (`agent_session_id`,`agent_entity_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_tool` (
  `agent_tool_id` bigint unsigned NOT NULL,
  `tool_name` varchar(255) NOT NULL,
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `parent_agent_tool_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: agent_tool.agent_tool_id',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`agent_tool_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `mnemonic` (`mnemonic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_workflow` (
  `agent_workflow_id` bigint unsigned NOT NULL,
  `workflow_name` varchar(127) NOT NULL COMMENT 'name of the workflow, e.g Seller Verification KYB',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `team_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'nullable, FK maybe to the RCDM team cats table, not sure yet',
  `entity_type` varchar(127) NOT NULL DEFAULT '' COMMENT 'agent entity: Agent_Entity_ApolloTask | ...',
  `agent_tool_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: agent_tool.agent_tool_id',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`agent_workflow_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `mnemonic` (`mnemonic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_workflow_apollo_task_queue` (
  `agent_workflow_apollo_task_queue_id` bigint unsigned NOT NULL,
  `agent_workflow_id` bigint unsigned NOT NULL COMMENT 'FK: agent_workflow.agent_workflow_id',
  `mnemonic` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`agent_workflow_apollo_task_queue_id`),
  UNIQUE KEY `agent_workflow_queue_idx` (`agent_workflow_id`,`mnemonic`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `agent_workflow_apollo_task_tag` (
  `agent_workflow_apollo_task_tag_id` bigint unsigned NOT NULL,
  `agent_workflow_id` bigint unsigned NOT NULL COMMENT 'FK: agent_workflow.agent_workflow_id',
  `tag_id` bigint unsigned NOT NULL COMMENT 'FK: apollo_tag.tag_id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`agent_workflow_apollo_task_tag_id`),
  UNIQUE KEY `agent_workflow_tag_idx` (`agent_workflow_id`,`tag_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `api_usage_checks` (
  `api_check_id` bigint unsigned NOT NULL,
  `endpoint_class` varchar(500) NOT NULL COMMENT 'The fqsen of an API endpoint',
  `reason` varchar(500) DEFAULT NULL COMMENT 'Reason we should not check this endpoint for a long time (or perhaps ever)',
  `skip_until` bigint unsigned DEFAULT NULL COMMENT 'The next date we should check this endpoint for usage',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`api_check_id`),
  UNIQUE KEY `endpoint_class_idx` (`endpoint_class`),
  KEY `skip_until_idx` (`skip_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `app_reviews` (
  `review_id` bigint unsigned NOT NULL,
  `author` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rating` int NOT NULL,
  `review_text` varchar(1024) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_id` int DEFAULT NULL,
  `app_version` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `platform` int NOT NULL,
  `external_id` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`review_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `review_app_version_platform_idx` (`review_id`,`app_version`,`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `architecture` (
  `architecture_id` bigint unsigned NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `faq` text COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`architecture_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `architecture_links` (
  `architecture_link_id` bigint unsigned NOT NULL,
  `architecture_id` bigint unsigned NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` int NOT NULL,
  `url` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`architecture_link_id`),
  KEY `architecture_id` (`architecture_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `architecture_members` (
  `architecture_member_id` bigint unsigned NOT NULL,
  `architecture_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`architecture_member_id`),
  KEY `architecture_id` (`architecture_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `architecture_timeline` (
  `architecture_timeline_id` bigint unsigned NOT NULL,
  `architecture_id` bigint unsigned NOT NULL,
  `date` int unsigned NOT NULL,
  `event` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`architecture_timeline_id`),
  KEY `architecture_artifact_id` (`architecture_id`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `atlas_consolidated_notes` (
  `user_id` bigint unsigned NOT NULL,
  `backfill_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bitrise_builds` (
  `bitrise_build_id` bigint unsigned NOT NULL,
  `app_slug` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Alphanumeric Bitrise identifier for the app',
  `build_slug` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Alphanumeric Bitrise identifier for the build',
  `build_state` tinyint unsigned NOT NULL DEFAULT '13' COMMENT 'Bitrise state enum for the build',
  `build_payload` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Stringified JSON response from the last build synchronization',
  `env_repository` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Environment var for Github repository',
  `env_branch` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Environment var for Github repository branch',
  `sync_state` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Etsy state enum for synchronization state for the build',
  `last_sync` bigint unsigned DEFAULT NULL COMMENT 'Timestamp for the last synchronization with Bitrise',
  `time_queued` bigint unsigned DEFAULT NULL COMMENT 'Timestamp for build queued for execution',
  `time_started` bigint unsigned DEFAULT NULL COMMENT 'Timestamp for build started by a worker',
  `time_setup` bigint unsigned DEFAULT NULL COMMENT 'Timestamp for build environment setup',
  `time_finished` bigint unsigned DEFAULT NULL COMMENT 'Timestamp for build finished',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  `error_code` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bitrise_build_id`),
  KEY `idx_app_build` (`app_slug`,`build_slug`),
  KEY `idx_repo_app` (`env_repository`,`app_slug`,`create_date`),
  KEY `idx_build` (`build_slug`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_campaigns` (
  `id` bigint unsigned NOT NULL,
  `braze_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `campaign_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `campaign_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'properties here and below are fetched in campaigns/details',
  `braze_created_at` bigint unsigned DEFAULT NULL,
  `braze_updated_at` bigint unsigned DEFAULT NULL,
  `archived` tinyint DEFAULT NULL,
  `draft` tinyint DEFAULT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_braze_id` (`braze_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_canvases` (
  `id` bigint unsigned NOT NULL,
  `braze_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `canvas_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `canvas_description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'properties here and below are fetched in canvases/details',
  `braze_created_at` bigint unsigned DEFAULT NULL,
  `braze_updated_at` bigint unsigned DEFAULT NULL,
  `archived` tinyint DEFAULT NULL,
  `draft` tinyint DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_braze_id` (`braze_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_canvassteps` (
  `id` bigint unsigned NOT NULL,
  `braze_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `canvas_id` bigint unsigned NOT NULL,
  `step_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_braze_id` (`braze_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_connectedcontentcalls` (
  `id` bigint unsigned NOT NULL,
  `message_id` bigint unsigned DEFAULT NULL,
  `contentblock_id` bigint unsigned DEFAULT NULL,
  `endpoint_id` bigint unsigned NOT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`message_id`,`contentblock_id`,`endpoint_id`),
  KEY `idx_message_id` (`message_id`),
  KEY `idx_contentblock_id` (`contentblock_id`),
  KEY `idx_endpoint_id` (`endpoint_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_content_blocks` (
  `braze_content_block_id` bigint NOT NULL,
  `braze_workspace_id` tinyint NOT NULL DEFAULT '1',
  `content_block_api_ident` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `body` longtext COLLATE utf8mb4_bin,
  `translation_state` tinyint DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`braze_content_block_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `braze_workspace_id_idx` (`braze_workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_contentblock_inclusions` (
  `parent_contentblock_id` bigint unsigned NOT NULL,
  `child_contentblock_id` bigint unsigned NOT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`parent_contentblock_id`,`child_contentblock_id`),
  KEY `idx_child_contentblock_id` (`child_contentblock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_contentblocks` (
  `id` bigint NOT NULL,
  `braze_workspace_id` tinyint NOT NULL DEFAULT '1',
  `braze_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `contentblock_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `contentblock_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_contentblock_name` (`contentblock_name`),
  KEY `idx_braze_id` (`braze_id`),
  KEY `braze_workspace_id_idx` (`braze_workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_endpoints` (
  `id` bigint unsigned NOT NULL,
  `endpoint_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `endpoint_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `rate_limit` int DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_path` (`endpoint_path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_messages` (
  `id` bigint unsigned NOT NULL,
  `braze_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `campaign_id` bigint unsigned DEFAULT NULL,
  `canvas_id` bigint unsigned DEFAULT NULL,
  `step_id` bigint unsigned DEFAULT NULL,
  `message_type` tinyint unsigned NOT NULL COMMENT 'adding message prefix as type is mysql keyword',
  `message_subject` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'adding message prefix as subject is mysql keyword',
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `alert` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'content for push messages',
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `message_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'adding message prefix as channel is mysql keyword',
  `extras` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `step_idx` (`step_id`),
  KEY `braze_idx` (`braze_id`),
  KEY `campaign_idx` (`campaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_messages_contentblocks` (
  `message_id` bigint unsigned NOT NULL,
  `contentblock_id` bigint unsigned NOT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  PRIMARY KEY (`message_id`,`contentblock_id`),
  KEY `contentblock_id` (`contentblock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `braze_templates` (
  `braze_template_id` bigint NOT NULL,
  `braze_workspace_id` tinyint NOT NULL DEFAULT '1',
  `template_api_ident` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `xtm_project_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `template_name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `email_subject` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `email_preheader` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `translation_state` tinyint DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  `translation_start_time` bigint DEFAULT NULL,
  `translation_update_time` bigint DEFAULT NULL,
  `translation_stop_time` bigint DEFAULT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `email_body` longtext COLLATE utf8mb4_bin,
  `translation_blocks_hashed` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`braze_template_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `braze_workspace_id_idx` (`braze_workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown` (
  `takedown_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delayed_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `started_date` int unsigned NOT NULL DEFAULT '0',
  `processed_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`),
  KEY `takedown_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_action` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `action_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`,`action_id`),
  KEY `takedown_action_type_status_idx` (`takedown_id`,`user_id`,`type`,`status`),
  KEY `takedown_action_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_action_batch` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `retry_count` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`),
  KEY `takedown_batch_update_date` (`update_date`),
  KEY `takedown_batch_status_idx` (`status`),
  KEY `takedown_batch_id_status_idx` (`takedown_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_delayed_action_batch` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `retry_count` int unsigned NOT NULL,
  `scheduled_execution_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`),
  KEY `takedown_batch_update_date` (`update_date`),
  KEY `takedown_batch_status_execution_idx` (`status`,`scheduled_execution_date`),
  KEY `takedown_batch_id_status_idx` (`takedown_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_item_source` (
  `bulk_takedown_item_source_id` bigint unsigned NOT NULL,
  `takedown_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.bulk_takedown.takedown_id',
  `target_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'listing | shop ',
  `target_id` bigint unsigned NOT NULL COMMENT 'listing_id | shop_id',
  `source` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'rtt | afq | member | agent | ... ',
  `source_id` bigint unsigned NOT NULL COMMENT 'control_id, user_id',
  `source_revision_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'control_revision_id for risk controls or 0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`bulk_takedown_item_source_id`),
  KEY `takedown_item_takedown_target_id_idx` (`takedown_id`,`target_type`,`target_id`),
  KEY `takedown_item_create_date_idx` (`create_date`),
  KEY `takedown_item_update_date_idx` (`update_date`),
  KEY `takedown_item_source_idx` (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_listing` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`user_id`,`listing_id`),
  KEY `takedown_listing_update_date_idx` (`update_date`),
  KEY `takedown_listing_status_idx` (`status`),
  KEY `shop_id_idx` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_metadata` (
  `takedown_id` bigint unsigned NOT NULL,
  `key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `json_value` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`takedown_id`,`key`),
  KEY `takedown_metadata_update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bulk_takedown_shop` (
  `takedown_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `decision` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `unshipped_order_amount` int unsigned NOT NULL DEFAULT '0',
  `undisbursed_funds` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`,`user_id`),
  KEY `takedown_shop_update_date_idx` (`update_date`),
  KEY `takedown_shop_status_idx` (`status`),
  KEY `takedown_shop_task_id_idx` (`task_id`),
  KEY `shop_id_idx` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_bcs_boundaries` (
  `boundary_id` bigint unsigned NOT NULL,
  `launch_id` bigint unsigned NOT NULL,
  `config_id` bigint NOT NULL,
  `start_epoch` int NOT NULL DEFAULT '0',
  `end_epoch` int NOT NULL DEFAULT '0',
  `is_active` tinyint NOT NULL DEFAULT '1',
  `is_partial_day_boundary` tinyint NOT NULL DEFAULT '0',
  `analysis_level` tinyint NOT NULL,
  PRIMARY KEY (`boundary_id`),
  KEY `is_active` (`is_active`,`start_epoch`),
  KEY `launch_id_idx` (`launch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_browser_event_data_rollup` (
  `catapult_browser_event_data_rollup_id` bigint unsigned NOT NULL DEFAULT '0',
  `run_date` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `epoch_s` int unsigned NOT NULL DEFAULT '0',
  `ab_test` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ab_variant` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `browsers_with_event` bigint unsigned NOT NULL DEFAULT '0',
  `total_browsers_in_variant` bigint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`catapult_browser_event_data_rollup_id`),
  KEY `event_idx` (`run_date`,`ab_test`(32),`ab_variant`(32)),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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

CREATE TABLE `catapult_config_boundary_reset_status` (
  `config_boundary_reset_status_id` bigint unsigned NOT NULL,
  `config_id` bigint unsigned NOT NULL,
  `boundary_reset_version` varchar(8) NOT NULL DEFAULT '',
  `boundary_reset_reason` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`config_boundary_reset_status_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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


CREATE TABLE `catapult_config_experiment_certification` (
  `experiment_certification_id` bigint unsigned NOT NULL COMMENT 'Synthetic id for this table',
  `config_id` bigint NOT NULL COMMENT 'Foreign key for the Config that this change is part of',
  `experiment_certification_version` varchar(32) NOT NULL DEFAULT '',
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`experiment_certification_id`),
  KEY `config_id_idx` (`config_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_experiment_restart_status` (
  `config_experiment_restart_status_id` bigint unsigned NOT NULL,
  `config_id` bigint NOT NULL,
  `experiment_restart_version` varchar(8) NOT NULL DEFAULT '',
  `experiment_restart_reason` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`config_experiment_restart_status_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_flag_event_filter` (
  `config_flag_event_filter_id` bigint unsigned NOT NULL,
  `config_flag` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `create_auth_username` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_date` int unsigned NOT NULL,
  `update_auth_username` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`config_flag_event_filter_id`),
  KEY `event_id_idx` (`event_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_config_flag_event_filter_history` (
  `run_date` int unsigned NOT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='To store existing config flag events filters for each day. To be used to retrieve past data';

CREATE TABLE `catapult_config_gradual_ramp` (
  `ramp_id` bigint unsigned NOT NULL COMMENT 'Synthetic id for this table',
  `config_id` bigint unsigned NOT NULL COMMENT 'Foreign key for the Config that this change is part of',
  `ramp_percentage` float NOT NULL COMMENT 'Programatic value that represents the stage of deployment until all the variants reached their configured value in FC::ENALED.',
  `create_date` bigint unsigned NOT NULL DEFAULT '0',
  `update_date` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ramp_id`),
  KEY `config_id_idx` (`config_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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
  `config_hash` varchar(6) NOT NULL DEFAULT '' COMMENT 'The hash value of essential information about a config stanza.',
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
  `sentry_tag` varchar(32) NOT NULL DEFAULT '' COMMENT 'Sentry tag associated with config',
  PRIMARY KEY (`config_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `config_flag_idx` (`config_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_dataset_association` (
  `id` bigint unsigned NOT NULL,
  `launch_id` bigint unsigned NOT NULL,
  `variant` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataset` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'NULL',
  PRIMARY KEY (`id`,`launch_id`,`variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_event_filter` (
  `boundary_id` bigint unsigned NOT NULL,
  `event_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`boundary_id`,`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_event_history` (
  `event_history_id` int unsigned NOT NULL,
  `run_date` int unsigned NOT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`event_history_id`),
  UNIQUE KEY `run_date` (`run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='To store existing events for each day. To be used to retrieve past data';

CREATE TABLE `catapult_events` (
  `event_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the event',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Human-readable description of event.',
  `is_primary` tinyint(1) NOT NULL COMMENT 'Is this a primary event',
  `create_date` int unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who created the event',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `custom_event_definition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_custom` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `name` (`name`),
  KEY `update_date_idx` (`update_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `primary_idx` (`is_primary`,`is_deleted`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_events_backup` (
  `event_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the event',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Human-readable description of event.',
  `is_primary` tinyint(1) NOT NULL COMMENT 'Is this a primary event',
  `create_date` int unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who created the event',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `custom_event_definition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `name` (`name`),
  KEY `update_date_idx` (`update_date`),
  KEY `create_date_idx` (`create_date`),
  KEY `primary_idx` (`is_primary`,`is_deleted`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_experiment_boundaries` (
  `launch_id` bigint unsigned NOT NULL,
  `config_id` bigint unsigned NOT NULL,
  `config_flag` varchar(255) NOT NULL,
  `variant_percent` float NOT NULL DEFAULT '0',
  `start_epoch` int NOT NULL DEFAULT '0',
  `end_epoch` int NOT NULL DEFAULT '0',
  `updated_by` varchar(80) NOT NULL,
  `reason` varchar(5000) NOT NULL,
  `updated_date` int NOT NULL,
  `active` tinyint NOT NULL DEFAULT '1',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `is_partial_day_boundary` tinyint(1) NOT NULL DEFAULT '0',
  `experiment_restart_version` varchar(8) NOT NULL DEFAULT '',
  `triggered_by_experiment_restart` tinyint NOT NULL DEFAULT '0',
  `boundary_reset_version` varchar(8) NOT NULL DEFAULT '',
  `triggered_by_boundary_reset` tinyint NOT NULL DEFAULT '0',
  `experiment_certification_version` varchar(32) NOT NULL DEFAULT '',
  `triggered_by_experiment_certification` tinyint NOT NULL DEFAULT '0',
  `analysis_level` varchar(20) DEFAULT '',
  `config_hash` varchar(6) NOT NULL DEFAULT '' COMMENT 'The hash value of essential information about a config stanza.',
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
  `is_success_criteria` tinyint NOT NULL DEFAULT '0' COMMENT 'Boolean indicating if this metric is the success criteria for the experiment launch',
  `success_metric_type` varchar(255) NOT NULL DEFAULT 'not_success_metric' COMMENT 'Enum indicating whether or which type of success metric this metric is for the launch.  Replaces is_success_criteria',
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

CREATE TABLE `catapult_gms_reports` (
  `gms_report_id` bigint NOT NULL COMMENT 'Synthetic id for this table',
  `staff_id` bigint NOT NULL COMMENT 'ID of the staff member who filed the gms report',
  `launch_id` bigint DEFAULT NULL COMMENT 'ID of the experiment this report is associated with. Experiments can have multiple gms reports. Null for non-catapult experiments',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `reviewed` tinyint(1) NOT NULL DEFAULT '0',
  `experiment_name` varchar(500) DEFAULT NULL,
  `config_flag` varchar(500) DEFAULT NULL,
  `ad_hoc_analysis_link` varchar(1000) DEFAULT NULL,
  `initiative` varchar(100) DEFAULT NULL,
  `subteam` varchar(100) DEFAULT NULL,
  `product_lead` varchar(250) DEFAULT NULL,
  `analyst_lead` varchar(250) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `learnings` varchar(1000) DEFAULT NULL,
  `ramp_down_reason` varchar(1000) DEFAULT NULL,
  `target_metric` varchar(250) DEFAULT NULL,
  `bug` tinyint(1) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `attribution_date` date DEFAULT NULL,
  `launch_date` date DEFAULT NULL,
  `report_year` int unsigned NOT NULL,
  `gms_coverage` float DEFAULT NULL,
  `conv_pct_change` float DEFAULT NULL,
  `log_acbv_pct_change` float DEFAULT NULL,
  `rev_coverage` float DEFAULT NULL,
  `prolist_pct_change` float DEFAULT NULL,
  `listing` tinyint(1) DEFAULT NULL,
  `home` tinyint(1) DEFAULT NULL,
  `shop_home` tinyint(1) DEFAULT NULL,
  `sold_out_listing` tinyint(1) DEFAULT NULL,
  `unavailable_listing` tinyint(1) DEFAULT NULL,
  `search` tinyint(1) DEFAULT NULL,
  `market` tinyint(1) DEFAULT NULL,
  `category` tinyint(1) DEFAULT NULL,
  `cart` tinyint(1) DEFAULT NULL,
  `checkout` tinyint(1) DEFAULT NULL,
  `other` tinyint(1) DEFAULT NULL,
  `audience` varchar(250) DEFAULT NULL,
  `platform` varchar(250) DEFAULT NULL,
  `final` tinyint(1) NOT NULL DEFAULT '0',
  `noncatapult` tinyint(1) NOT NULL DEFAULT '0',
  `is_long_term_holdout` tinyint(1) NOT NULL DEFAULT '0',
  `variant` varchar(180) NOT NULL DEFAULT '',
  `gms_roy` float DEFAULT NULL,
  `gms_ann` float DEFAULT NULL,
  `jan_gms` float DEFAULT NULL,
  `feb_gms` float DEFAULT NULL,
  `mar_gms` float DEFAULT NULL,
  `apr_gms` float DEFAULT NULL,
  `may_gms` float DEFAULT NULL,
  `jun_gms` float DEFAULT NULL,
  `jul_gms` float DEFAULT NULL,
  `aug_gms` float DEFAULT NULL,
  `sep_gms` float DEFAULT NULL,
  `oct_gms` float DEFAULT NULL,
  `nov_gms` float DEFAULT NULL,
  `dec_gms` float DEFAULT NULL,
  `rev_roy` float DEFAULT NULL,
  `rev_ann` float DEFAULT NULL,
  `jan_rev` float DEFAULT NULL,
  `feb_rev` float DEFAULT NULL,
  `mar_rev` float DEFAULT NULL,
  `apr_rev` float DEFAULT NULL,
  `may_rev` float DEFAULT NULL,
  `jun_rev` float DEFAULT NULL,
  `jul_rev` float DEFAULT NULL,
  `aug_rev` float DEFAULT NULL,
  `sep_rev` float DEFAULT NULL,
  `oct_rev` float DEFAULT NULL,
  `nov_rev` float DEFAULT NULL,
  `dec_rev` float DEFAULT NULL,
  `sitewide` tinyint(1) DEFAULT '0',
  `type` varchar(250) DEFAULT '',
  `gm` varchar(50) DEFAULT '',
  `is_dsml_experiment` tinyint(1) DEFAULT '0',
  `is_seo` tinyint(1) DEFAULT NULL,
  `winsorized_acbv_pct_change` float DEFAULT NULL,
  `visits_pct_change` float DEFAULT NULL,
  `type_id` bigint unsigned NOT NULL DEFAULT '0',
  `kr_metric_id` bigint unsigned NOT NULL DEFAULT '0',
  `kr_metric_name` varchar(250) DEFAULT NULL,
  `kr_metric_value` float DEFAULT NULL,
  `kr_metric_coverage` float DEFAULT NULL,
  `kr_metric_id_2` bigint unsigned NOT NULL DEFAULT '0',
  `kr_metric_name_2` varchar(250) DEFAULT NULL,
  `kr_metric_value_2` float DEFAULT NULL,
  `kr_metric_coverage_2` float DEFAULT NULL,
  `traffic_percent` varchar(50) DEFAULT NULL,
  `kpi_initiative_id` bigint unsigned NOT NULL DEFAULT '0',
  `kpi_initiative_name` varchar(250) DEFAULT NULL,
  `kpi_initiative_value` float DEFAULT NULL,
  `kpi_initiative_coverage` float DEFAULT NULL,
  `offsite_ads_rev_value` float DEFAULT NULL,
  `offsite_ads_rev_coverage` float DEFAULT NULL,
  `conv_rate_power` float DEFAULT NULL,
  `acbv_power` float DEFAULT NULL,
  PRIMARY KEY (`gms_report_id`),
  UNIQUE KEY `config_start_end_idx` (`config_flag`(255),`start_date`,`end_date`),
  KEY `launch_id` (`launch_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_kpi_initiatives` (
  `kpi_initiative_id` bigint unsigned NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`kpi_initiative_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_kpi_names` (
  `catapult_kpi_names_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`catapult_kpi_names_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_launch_initiatives` (
  `launch_initiative_id` bigint NOT NULL,
  `launch_initiative_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`launch_initiative_id`)
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
  `team` varchar(128) NOT NULL COMMENT 'The team responsible for the launch',
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
  `config_flag` varchar(255) DEFAULT NULL,
  `delete_date` int unsigned DEFAULT NULL COMMENT 'Time launch was deleted.',
  `deleted_staff_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'staff_id of admin who deleted the launch',
  `state` tinyint NOT NULL DEFAULT '0',
  `analyst_id` bigint unsigned DEFAULT NULL,
  `launch_group` varchar(50) DEFAULT NULL COMMENT 'Group launch: HMF, HMB, HMG, MESG, Fulfillment, Frequency',
  `outcome` varchar(255) DEFAULT NULL COMMENT 'Outcome or track of work the experiment maps to',
  `is_dsml` tinyint(1) DEFAULT '0',
  `meaningful_analysis` varchar(255) DEFAULT NULL COMMENT 'Whether or not meaningful analysis is required and why',
  `is_neutral` tinyint NOT NULL DEFAULT '0' COMMENT 'Whether or not neutral results are expected for this launch',
  `initiative` varchar(100) DEFAULT NULL,
  `audience` varchar(250) DEFAULT NULL,
  `layer_portion` varchar(50) DEFAULT NULL,
  `layer_start` float DEFAULT NULL,
  `layer_end` float DEFAULT NULL,
  `est_start_date` date DEFAULT NULL COMMENT 'User estimated start date.',
  `est_end_date` date DEFAULT NULL COMMENT 'User estimated end date.',
  PRIMARY KEY (`launch_id`),
  KEY `delete_date` (`delete_date`,`state`,`created_epoch`),
  KEY `created_epoch_idx` (`created_epoch`),
  KEY `updated_epoch_idx` (`updated_epoch`),
  KEY `team_idx` (`team`(16)),
  KEY `team_id` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Things that can be launched. Experiments, Rampups, and Communications. Slightly denormalized in that we store all three kinds of launches here even though some fields are only needed by certain kinds of launches.';

CREATE TABLE `catapult_launches_enabling_team` (
  `enabling_team_id` bigint unsigned NOT NULL,
  `enabling_team_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `launch_id` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`enabling_team_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_launches_expected_pages` (
  `expected_page_id` bigint unsigned NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `launch_id` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`expected_page_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_launches_expected_platforms` (
  `expected_platform_id` bigint unsigned NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `launch_id` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`expected_platform_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_metric_association` (
  `boundary_id` bigint NOT NULL COMMENT 'Catapult boundary foreign key.',
  `metric_id` bigint NOT NULL COMMENT 'Metric foreign key.',
  `direction` tinyint NOT NULL COMMENT 'Whether we expect treatments to increase, decrease, or leave unchanged, the metric.',
  `stats_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Stats specifications for the given metric.',
  `create_date` int unsigned NOT NULL COMMENT 'Epoch timestamp indicating when the association was created.',
  `created_by` bigint unsigned NOT NULL COMMENT 'staff_id of admin who created the association.',
  `update_date` int unsigned DEFAULT NULL COMMENT 'Epoch timestamp indicating when the association was updated.',
  PRIMARY KEY (`boundary_id`,`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_metric_bundle_definitions` (
  `bundle_id` bigint NOT NULL COMMENT 'Synthetic id for this table.',
  `bundle_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the metric bundle.',
  `bundle_description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Longer description.',
  `bundle_type` tinyint unsigned NOT NULL COMMENT 'The grouping criteria, e.g. key health metric, platform, etc.',
  `owner_ldap` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ldap of admin who owns the metric bundle definition.',
  `create_date` int unsigned NOT NULL COMMENT 'Epoch timestamp indicating when the metric bundle definition was created.',
  `update_date` int unsigned DEFAULT NULL COMMENT 'Epoch timestamp indicating when the metric bundle definition was updated.',
  PRIMARY KEY (`bundle_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `name_idx` (`bundle_name`(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_metric_bundles` (
  `bundle_id` bigint NOT NULL COMMENT 'Metric bundle foreign key.',
  `metric_id` bigint NOT NULL COMMENT 'Metric foreign key.',
  `create_date` int unsigned NOT NULL COMMENT 'Epoch timestamp indicating when the metric bundle entry was created.',
  `update_date` int unsigned DEFAULT NULL COMMENT 'Epoch timestamp indicating when the metric bundle was updated.',
  PRIMARY KEY (`bundle_id`,`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_metric_registry` (
  `metric_id` bigint NOT NULL COMMENT 'Synthetic id for this table.',
  `metric_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the metric.',
  `metric_description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Longer description.',
  `metric_type` tinyint unsigned NOT NULL COMMENT 'e.g. Proportion, mean, etc.',
  `metric_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The metric configuration.',
  `create_date` int unsigned NOT NULL COMMENT 'Epoch timestamp indicating when the metric entry was created.',
  `created_by` bigint unsigned NOT NULL COMMENT 'staff_id of admin who created the metric entry.',
  `update_date` int unsigned DEFAULT NULL COMMENT 'Epoch timestamp indicating when the metric entry was updated.',
  PRIMARY KEY (`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `name_idx` (`metric_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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
  `denominator_event` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`metric_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `name_idx` (`name`),
  KEY `is_key_health_metric_idx` (`is_key_health_metric`,`name`),
  KEY `event_idx` (`event`,`name`),
  KEY `by_key_fields_idx` (`numerator`,`denominator`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_notes` (
  `catapult_note_id` bigint unsigned NOT NULL DEFAULT '0',
  `launch_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`catapult_note_id`),
  KEY `launch_is_deleted_idx` (`launch_id`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_pdf_links` (
  `pdf_link_id` bigint unsigned NOT NULL,
  `title` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pdf_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `launch_id` bigint unsigned DEFAULT NULL,
  `ab_test` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `run_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pdf_link_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_actions` (
  `configuration_action_id` bigint NOT NULL,
  `configuration_id` bigint NOT NULL,
  `configuration_action_epoch` int unsigned NOT NULL,
  `configuration_action` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint NOT NULL,
  PRIMARY KEY (`configuration_action_id`),
  KEY `configuration_id_index` (`configuration_id`),
  KEY `configuration_action_epoch_index` (`configuration_action_epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_admin` (
  `id` bigint NOT NULL,
  `configuration_id` bigint NOT NULL,
  `variant` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `configuration_id` (`configuration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_enabled` (
  `id` bigint NOT NULL,
  `configuration_id` bigint NOT NULL,
  `enabled` tinyint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `configuration_id` (`configuration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_parts` (
  `configuration_part_id` bigint unsigned NOT NULL,
  `configuration_id` bigint unsigned NOT NULL,
  `setting_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`configuration_part_id`),
  KEY `configuration_index` (`configuration_id`,`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_states` (
  `configuration_state_id` bigint unsigned NOT NULL,
  `configuration_id` bigint unsigned NOT NULL,
  `configuration_state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `start_epoch` bigint unsigned NOT NULL,
  `end_epoch` bigint unsigned NOT NULL,
  PRIMARY KEY (`configuration_state_id`),
  KEY `configuration_index` (`configuration_id`,`start_epoch`),
  KEY `current_state_index` (`configuration_state`,`end_epoch`,`configuration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configuration_test_runs` (
  `test_run_id` bigint unsigned NOT NULL,
  `configuration_id` bigint unsigned NOT NULL,
  `job_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_id` bigint unsigned DEFAULT NULL,
  `start_epoch` bigint unsigned DEFAULT NULL,
  `end_epoch` bigint unsigned DEFAULT NULL,
  `result` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`test_run_id`),
  KEY `configuration_index` (`configuration_id`,`start_epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_configurations` (
  `configuration_id` bigint unsigned NOT NULL,
  `feature_id` bigint unsigned NOT NULL,
  `configuration_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rendered_configuration` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`configuration_id`),
  KEY `feature_index` (`feature_id`,`configuration_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_rcs_features` (
  `feature_id` bigint unsigned NOT NULL,
  `feature_flag` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `feature_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `team_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'The team responsible for the feature',
  `create_date` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Time feature was created.',
  `update_date` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Time feature was updated.',
  PRIMARY KEY (`feature_id`),
  UNIQUE KEY `feature_flag_index` (`feature_flag`),
  KEY `feature_status_index` (`feature_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_report_types` (
  `catapult_report_types_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` bit(1) NOT NULL DEFAULT b'0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`catapult_report_types_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_segment_associations` (
  `segment_association_id` bigint unsigned NOT NULL COMMENT 'Unique identifier of the segment association',
  `launch_id` bigint unsigned NOT NULL COMMENT 'Unique identifier of the experiment',
  `segmentation_id` bigint unsigned NOT NULL COMMENT 'Unique identification for the segmentation',
  `segmentation_version` int unsigned NOT NULL COMMENT 'Version of the segmentation, used for identification',
  `segments_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'MD5 hash of the segments for uniqueness check',
  `boundary_start_epoch_sec` int unsigned NOT NULL COMMENT 'Boundary start UNIX timestamp in seconds',
  `create_date` int unsigned NOT NULL COMMENT 'Creation UNIX timestamp in seconds',
  `segments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Comma-separated, alphanumerically sorted unique segments',
  PRIMARY KEY (`segment_association_id`),
  UNIQUE KEY `launch_id` (`launch_id`,`segmentation_id`,`segmentation_version`,`boundary_start_epoch_sec`,`segments_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores the relationship between an experiment and user-requested segment';

CREATE TABLE `catapult_segmentation_associations` (
  `segmentation_association_id` bigint unsigned NOT NULL COMMENT 'Unique identifier of the segmentation association',
  `launch_id` bigint unsigned NOT NULL COMMENT 'Unique identifier of the experiment',
  `segmentation_id` bigint unsigned NOT NULL COMMENT 'Unique identifer of the segmentation',
  `segmentation_version` int unsigned NOT NULL COMMENT 'Unique identifer of the segmentation',
  `boundary_start_epoch_sec` int unsigned NOT NULL COMMENT 'Boundary start UNIX timestamp in seconds',
  `create_date` int unsigned NOT NULL COMMENT 'Creation UNIX timestamp in seconds',
  PRIMARY KEY (`segmentation_association_id`),
  UNIQUE KEY `launch_id` (`launch_id`,`segmentation_id`,`segmentation_version`,`boundary_start_epoch_sec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores the relationship between an experiment and a segmentation definition';

CREATE TABLE `catapult_segmentations` (
  `segmentation_id` bigint unsigned NOT NULL COMMENT 'Numeric ID of the segment association',
  `segmentation_version` int unsigned NOT NULL COMMENT 'Version of the segmentation used as the identifier',
  `segmentation_name` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of the segmentation',
  `segmentation_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'MD5 hash to uniquely identify the segmentation_name',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description of the segmentation',
  `staff_id` bigint unsigned NOT NULL COMMENT 'Owner represented by Atlas staff ID',
  `team_id` bigint unsigned NOT NULL COMMENT 'Owner represented by Atlas team ID',
  `sql_definition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Freeform SQL logic which defines the segmentation',
  `join_keys` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Sorted comma-delimited list of join keys for joining user-provided segment data with our bucketing data',
  `default_segment_value` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Default segment value to handle the case where a bucketing ID does not have a matching join key in the user-provided segment data',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft' COMMENT 'State of the segmentation',
  `state_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Additional data related to the state as serialized JSON',
  `create_date` int unsigned NOT NULL COMMENT 'Creation UNIX timestamp in seconds',
  `update_date` int unsigned NOT NULL COMMENT 'Updated UNIX timestamp in seconds',
  PRIMARY KEY (`segmentation_id`,`segmentation_version`),
  UNIQUE KEY `segmentation_hash` (`segmentation_hash`,`segmentation_version`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Contains segmentation definitions';

CREATE TABLE `catapult_segments` (
  `segment_id` bigint unsigned NOT NULL COMMENT 'Synthetic id for this table',
  `segmentation_id` bigint unsigned NOT NULL,
  `segment_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_sequential_testing_browsers` (
  `launch_id` bigint NOT NULL DEFAULT '0',
  `metric_id` bigint NOT NULL DEFAULT '0',
  `variant_name` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `early_stopping_reached` tinyint(1) NOT NULL DEFAULT '0',
  `early_stopping_percent_change` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `early_stopping_reached_epoch` int unsigned NOT NULL DEFAULT '0',
  `early_stopping_boundary_start_epoch` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`launch_id`,`metric_id`,`variant_name`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_sequential_testing_visits` (
  `launch_id` bigint NOT NULL DEFAULT '0',
  `metric_id` bigint NOT NULL DEFAULT '0',
  `variant_name` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `early_stopping_reached` tinyint(1) NOT NULL DEFAULT '0',
  `early_stopping_percent_change` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `early_stopping_reached_epoch` int unsigned NOT NULL DEFAULT '0',
  `early_stopping_boundary_start_epoch` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`launch_id`,`metric_id`,`variant_name`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
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

CREATE TABLE `click_abuse_case` (
  `click_abuse_case_id` bigint unsigned NOT NULL COMMENT 'auto-generated id (Ticket id)',
  `query_space` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Targeted merch/shop',
  `start_date` int unsigned NOT NULL COMMENT 'Date case started',
  `end_date` int unsigned NOT NULL COMMENT 'Date case ended',
  `remediated_date` int unsigned NOT NULL COMMENT 'Date on which case was fully remediated',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`click_abuse_case_id`),
  UNIQUE KEY `query_start_end` (`query_space`,`start_date`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Ad-Delivery Click Abuse Case';

CREATE TABLE `click_abuse_charge_remediation` (
  `click_abuse_charge_remediation_id` bigint unsigned NOT NULL,
  `click_abuse_shop_remediation_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_ClickAbuse_ShopRemediation',
  `billing_date` int unsigned NOT NULL,
  `invalid_charge` int unsigned NOT NULL COMMENT 'usd in pennies',
  `refund_ledger_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_Ledger',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`click_abuse_charge_remediation_id`),
  UNIQUE KEY `click_abuse_shop_remediation_charge_date_idx` (`click_abuse_shop_remediation_id`,`billing_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Ad-Delivery Click Abuse Charge Remediation';

CREATE TABLE `click_abuse_shop_remediation` (
  `click_abuse_shop_remediation_id` bigint unsigned NOT NULL,
  `click_abuse_case_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_ClickAbuse_Case',
  `shop_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_Shop_Shop Model',
  `convo_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_UserConversation Model',
  `convo_user_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_UserConversation Model',
  `admin_note_id` bigint unsigned NOT NULL COMMENT 'foreign key to EtsyModel_Atlas_AdminNote',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`click_abuse_shop_remediation_id`),
  UNIQUE KEY `shop_id_click_abuse_case_id` (`shop_id`,`click_abuse_case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Ad-Delivery Click Abuse Shop Remediation';

CREATE TABLE `cluster_actioned_listing` (
  `listing_id` bigint unsigned NOT NULL,
  `decision` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`listing_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cluster_listing` (
  `cluster_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Primary key of etsy_atlas/listing_cluster_rankings table',
  `listing_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`cluster_id`,`listing_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_alert_batches` (
  `compliance_alert_batch_id` bigint unsigned NOT NULL,
  `import_request_data` longtext COLLATE utf8mb4_unicode_ci,
  `import_response_data` longtext COLLATE utf8mb4_unicode_ci,
  `status` int unsigned NOT NULL,
  `import_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_deleted` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `retry_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`compliance_alert_batch_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_alert_rules` (
  `compliance_rule_id` bigint unsigned NOT NULL,
  `compliance_alert_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`compliance_rule_id`,`compliance_alert_id`),
  KEY `compliance_alert_id` (`compliance_alert_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_alerts` (
  `compliance_alert_id` bigint unsigned NOT NULL,
  `compliance_alert_batch_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_id` bigint unsigned NOT NULL,
  `alert_type` int unsigned NOT NULL DEFAULT '0',
  `user_type` int unsigned NOT NULL DEFAULT '0',
  `source` int unsigned NOT NULL DEFAULT '0',
  `destination` int unsigned NOT NULL DEFAULT '0',
  `additional_info` longtext COLLATE utf8mb4_unicode_ci,
  `status` int unsigned NOT NULL DEFAULT '0',
  `retry_count` int unsigned NOT NULL DEFAULT '0',
  `report_id` bigint unsigned DEFAULT NULL,
  `review_period_start` int unsigned DEFAULT NULL,
  `review_period_end` int unsigned DEFAULT NULL,
  `aov` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_deleted` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`compliance_alert_id`),
  KEY `user_id` (`user_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_logs` (
  `compliance_log_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `event` int unsigned NOT NULL DEFAULT '0',
  `external_event_id` bigint unsigned NOT NULL,
  `external_event_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_date` int unsigned NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`compliance_log_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `user_id` (`user_id`),
  KEY `ext_event_type_id_idx` (`external_event_type`(16),`external_event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `compliance_rules` (
  `compliance_rule_id` bigint unsigned NOT NULL,
  `rule_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`compliance_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `csat_results` (
  `survey_context` tinyint unsigned NOT NULL COMMENT 'See Etsy\\Modules\\Catapult\\SubApps\\Csat\\Model\\Enum\\Context',
  `staff_id` bigint unsigned NOT NULL,
  `show_date` int unsigned NOT NULL,
  `survey_status` tinyint unsigned NOT NULL COMMENT 'See Etsy\\Modules\\Catapult\\SubApps\\Csat\\Model\\Enum\\Status',
  `close_date` int unsigned DEFAULT NULL,
  `submission_date` int unsigned DEFAULT NULL,
  `score` tinyint unsigned NOT NULL,
  PRIMARY KEY (`survey_context`,`staff_id`,`show_date`)
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

CREATE TABLE `dashboard` (
  `id` bigint unsigned NOT NULL,
  `team_id` bigint unsigned NOT NULL,
  `is_draft` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_private` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dashboard_admin` (
  `id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `dashboard_id` bigint unsigned NOT NULL,
  `role` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dashboard_chart` (
  `id` bigint unsigned NOT NULL,
  `dashboard_id` bigint unsigned NOT NULL,
  `position` int unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `superbit_report_id` bigint unsigned NOT NULL,
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `layout` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `refresh_rate` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dashboard_excluded_y_axis` (
  `chart_id` bigint unsigned NOT NULL,
  `excluded_column` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`chart_id`,`excluded_column`),
  KEY `update_date` (`update_date`)
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

CREATE TABLE `dataplatform_clusterstate` (
  `adhoc_cluster` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adhocs_enabled` tinyint unsigned NOT NULL DEFAULT '1',
  `message` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`adhoc_cluster`,`adhocs_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_spark_to_db` (
  `key_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `data` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int NOT NULL,
  `update_date` int NOT NULL,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`key_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `dl_asset_checkouts` (
  `staff_rfid_tag` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `asset_rfid_tag` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `checkout_date` int unsigned NOT NULL DEFAULT '0',
  `checkin_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_rfid_tag`,`asset_rfid_tag`,`checkout_date`),
  KEY `asset_rfid_tag` (`asset_rfid_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dl_devices` (
  `device_id` bigint NOT NULL,
  `rfid_tag_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `available_for_checkout` tinyint NOT NULL DEFAULT '1',
  `checkout_limit_days` int NOT NULL DEFAULT '30',
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `kind` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `os_type` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `version` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `screen_res` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `pixel_ratio` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `gets_mobile_template` tinyint DEFAULT '1',
  `default_mailapp` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `ip_address` varchar(45) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `checkouts` int unsigned NOT NULL DEFAULT '0',
  `cpu` int NOT NULL DEFAULT '0',
  `gpu` int NOT NULL DEFAULT '0',
  `ram` int NOT NULL DEFAULT '0',
  `location` varchar(16) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'brooklyn',
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dl_rfid_tags` (
  `rfid_tag_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type` enum('device','human','book') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'device',
  `checkouts` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rfid_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dl_staff_rfid_tags` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `rfid_tag_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `checkouts` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `rfid_tag_id` (`rfid_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `engineeringkarma_offer` (
  `offer_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `points` int unsigned NOT NULL,
  `stock` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`offer_id`),
  KEY `create_date` (`create_date`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `engineeringkarma_redeemed_offer` (
  `redeemed_id` bigint unsigned NOT NULL,
  `redeemed_by_staff_id` bigint unsigned NOT NULL,
  `offer_id` bigint unsigned NOT NULL,
  `is_complete` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`redeemed_id`),
  KEY `create_date` (`create_date`),
  KEY `redeemed_by_staff_id` (`redeemed_by_staff_id`),
  KEY `offer_id` (`offer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `engineeringkarma_user` (
  `staff_id` bigint unsigned NOT NULL,
  `accumulated_points` int unsigned NOT NULL,
  `points` int unsigned NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `et_people` (
  `people_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`people_id`),
  UNIQUE KEY `user_id_idx` (`user_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `et_process` (
  `process_id` bigint unsigned NOT NULL,
  `process_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `process_subtype` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `process_status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `process_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_team` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `removed` tinyint(1) NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`process_id`),
  KEY `process_type_idx` (`process_type`),
  KEY `process_status_idx` (`process_status`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_id_idx` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_contact_subscribers` (
  `event_id` bigint unsigned NOT NULL,
  `contact_id` bigint unsigned NOT NULL,
  `silence` tinyint NOT NULL DEFAULT '0' COMMENT 'Boolean field that allows EventHub custom contacts to silence validation alerts',
  PRIMARY KEY (`event_id`,`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Allows custom contacts to subscribe to events';

CREATE TABLE `event_hub_contacts` (
  `id` bigint unsigned NOT NULL,
  `contact_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of the contact as displayed in EventHub; preferably a Team Name',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Preferably a team email within the etsy domain',
  `slack` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'an Etsy slack channel for this team',
  `create_date` int NOT NULL COMMENT 'Unix timestamp',
  `update_date` int NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_contact_name` (`contact_name`),
  UNIQUE KEY `unique_contact_email` (`email`),
  UNIQUE KEY `unique_contact_slack` (`slack`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores contact information for teams that have registered events in EventHub';

CREATE TABLE `event_staff` (
  `event_id` bigint unsigned NOT NULL COMMENT 'FK to events.event_id',
  `staff_id` bigint unsigned NOT NULL COMMENT 'This is the Etsy employee id (aka Staff ID); This can be found on the employee staff page at go/staff',
  `silence` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Boolean field that allows EventHub users to silence validation alerts',
  PRIMARY KEY (`event_id`,`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Tracks which EventHub events are being watched by which Etsy admin';

CREATE TABLE `events` (
  `event_id` bigint unsigned NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name of the event in EventHub',
  `owner_id` bigint unsigned NOT NULL COMMENT 'FK to event_hub_contacts.id',
  `usage` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Originally meant to specify how this event would be used (e.g. experiemnt); As of Aug 2023, this columm is not in use',
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `alert_threshold_percentage` decimal(5,2) unsigned NOT NULL DEFAULT '0.00',
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'LDAP of the user who created this event in EventHub',
  `updated_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'LDAP of the user who last updated this event in EventHub',
  `is_kafe_event` tinyint NOT NULL DEFAULT '0' COMMENT 'boolean indicating if an event is from kafe',
  `create_date` int NOT NULL COMMENT 'Unix timestamp',
  `update_date` int NOT NULL COMMENT 'Unix timestamp',
  `delete_date` int NOT NULL DEFAULT '0' COMMENT 'Unix timestamp',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `unique_name_and_delete_index` (`name`,`delete_date`),
  KEY `fk_event_owners1_idx` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Stores metadata used by the EventHub application';

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

CREATE TABLE `internal_tools` (
  `tool_id` bigint unsigned NOT NULL,
  `tool_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tool_link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tool_type` char(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`tool_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_contact` (
  `contact_id` bigint unsigned NOT NULL,
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
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
  `property_id` bigint unsigned NOT NULL,
  `property_revision_id` bigint unsigned NOT NULL,
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `material_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `object_id_source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_object_state` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `takedown_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `counter_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `withdrawal_task_id` bigint unsigned NOT NULL DEFAULT '0',
  `reply_task_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`,`material_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_owner` (
  `owner_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
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
  `property_identifier` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`revision_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `property_identifier_idx` (`property_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown` (
  `takedown_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  `contact_id` bigint unsigned NOT NULL,
  `contact_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `ip_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `material_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ip_takedown_property` (
  `takedown_id` bigint unsigned NOT NULL,
  `property_revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`takedown_id`,`property_revision_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_email` (
  `iris_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_path` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `delivered_to` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `spf` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dkim` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auto_submitted` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `received_date` int NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`),
  UNIQUE KEY `hash_uq` (`hash`),
  KEY `update_date_idx` (`update_date`),
  KEY `status_idx` (`status`),
  KEY `job_status_idx` (`job_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_message` (
  `iris_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `user_email` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `to_email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `cc_email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `bcc_email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_id_header` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `references_header` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `in_reply_to_header` text COLLATE utf8mb4_unicode_ci,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_en` text COLLATE utf8mb4_unicode_ci,
  `body_html` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_plain` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_en` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_idx` (`task_id`),
  KEY `message_id_header_idx` (`message_id_header`),
  KEY `user_email_idx` (`user_email`),
  KEY `user_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `iris_message_attachment` (
  `iris_id` bigint unsigned NOT NULL,
  `attachment_id` bigint unsigned NOT NULL,
  `content_type` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_disposition` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
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

CREATE TABLE `iris_message_send` (
  `iris_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `retry_count` int unsigned NOT NULL,
  `queued_date` int unsigned NOT NULL,
  `scheduled_send_date` int unsigned NOT NULL,
  `sent_date` int unsigned NOT NULL,
  `confirmed_date` int unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `to_email` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_email` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cc_email` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bcc_email` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_id_header` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `references_header` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `in_reply_to_header` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `subject` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_html` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_plain` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `euid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `campaign` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `s3_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`iris_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_idx` (`task_id`),
  KEY `job_status_idx` (`job_status`),
  KEY `staff_queued_date_idx` (`staff_id`,`queued_date`),
  KEY `status_sent_idx` (`status`,`sent_date`),
  KEY `email_campaign_task_idx` (`to_email`(128),`campaign`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `jira_walkup_rfid_tags` (
  `rfid_tag_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rfid_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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

CREATE TABLE `listing_cluster_rankings` (
  `cluster_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Identifier for listing cluster',
  `cluster_rank` int unsigned NOT NULL COMMENT 'Position rank for this cluster',
  `is_violating` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Prediction of if this cluster violate policy',
  `probability` decimal(10,6) NOT NULL COMMENT 'Likelihood of prediction',
  `assigned_to` bigint unsigned DEFAULT NULL COMMENT 'Staff id',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'json data',
  `run_date` int unsigned NOT NULL COMMENT 'When these rankings were created',
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`cluster_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Rank data for clusters of similar listings';

CREATE TABLE `member_info_panel_settings` (
  `panel_settings_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `panel_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visible` int unsigned NOT NULL,
  `sort_order` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`panel_settings_id`),
  KEY `admin_id` (`admin_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_collection_staff` (
  `merch_collection_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`merch_collection_id`,`staff_id`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_non_branded_terms` (
  `term_id` bigint unsigned NOT NULL COMMENT 'Term id',
  `term` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Non branded term',
  `creator_staff_id` bigint unsigned NOT NULL COMMENT 'Staff id of admin who created non branded term',
  `allow_vintage` tinyint NOT NULL DEFAULT '1' COMMENT 'Vintage is allowed for term',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created date',
  PRIMARY KEY (`term_id`),
  UNIQUE KEY `term` (`term`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Merch stash non branded terms';

CREATE TABLE `merch_staged_listing_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`tag_id`,`listing_id`,`creator_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_staged_listings` (
  `staff_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`shop_id`,`listing_id`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_tag_rule` (
  `tag_rule_id` bigint unsigned NOT NULL,
  `tag_id` bigint unsigned NOT NULL,
  `type` tinyint NOT NULL,
  `value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` int unsigned DEFAULT NULL,
  `end_date` int unsigned DEFAULT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`tag_rule_id`),
  KEY `tag_id_enabled_idx` (`tag_id`,`is_deleted`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `parent_tag_id` bigint unsigned DEFAULT NULL,
  `creator_staff_id` bigint unsigned NOT NULL,
  `display` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` tinyint NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `display_description` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active_listing_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`tag_id`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `merch_trusted_shops` (
  `shop_id` bigint unsigned NOT NULL,
  `creator_staff_id` bigint unsigned NOT NULL COMMENT 'Staff id of admin who added trusted shop',
  `updater_staff_id` bigint unsigned DEFAULT NULL COMMENT 'Staff id of admin who last updated trusted shop',
  `create_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Created date',
  `update_date` int unsigned NOT NULL DEFAULT '0' COMMENT 'Updated date',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'If trusted shop has been removed',
  PRIMARY KEY (`creator_staff_id`,`shop_id`),
  KEY `create_date_index` (`create_date`),
  KEY `update_date_index` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Merch stash trusted shops';

CREATE TABLE `metrics` (
  `metric` varchar(128) NOT NULL,
  `b1` varchar(128) NOT NULL DEFAULT '',
  `b2` varchar(128) NOT NULL DEFAULT '',
  `b3` varchar(128) NOT NULL DEFAULT '',
  `b4` varchar(128) NOT NULL DEFAULT '',
  `rollup` varchar(12) NOT NULL,
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `value` float NOT NULL DEFAULT '0',
  `timezone` varchar(12) NOT NULL DEFAULT 'UTC',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`metric`,`b1`,`b2`,`b3`,`b4`,`rollup`,`start_date`,`timezone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `non_catapult_reports_expected_pages` (
  `expected_page_id` bigint unsigned NOT NULL,
  `expected_page_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gms_report_id` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`expected_page_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `non_catapult_reports_expected_platforms` (
  `expected_platform_id` bigint unsigned NOT NULL,
  `expected_platform_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gms_report_id` bigint DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`expected_platform_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `olf_force_syndication` (
  `force_syndication_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `submitted_by` bigint unsigned DEFAULT NULL,
  `created_at` int unsigned NOT NULL,
  `updated_at` int unsigned NOT NULL,
  PRIMARY KEY (`force_syndication_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `package` (
  `package_id` bigint unsigned NOT NULL,
  `package_type` tinyint unsigned NOT NULL,
  `from_staff_id` bigint unsigned NOT NULL,
  `owner_staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`package_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `palette_item_type` (
  `palette_item_type_id` int unsigned NOT NULL,
  `palette_item_type_name` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`palette_item_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `phound_callsites` (
  `ref` varchar(40) NOT NULL COMMENT 'The git sha of HEAD at the time of phound generation',
  `element` varchar(350) NOT NULL COMMENT 'FQSEN of class and property name of element',
  `reference_type` varchar(24) NOT NULL COMMENT 'What type of reference this is: prop, const, method, etc',
  `callsite` varchar(350) NOT NULL COMMENT 'The file and line number of the caller',
  PRIMARY KEY (`ref`,`element`,`reference_type`,`callsite`),
  KEY `ref_callsite_index` (`ref`,`callsite`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `phound_generations` (
  `ref` varchar(40) NOT NULL COMMENT 'The git sha of HEAD at the time of phound generation',
  `create_date` bigint unsigned NOT NULL,
  PRIMARY KEY (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `product_directory` (
  `product_id` bigint unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `product_description` varchar(140) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `product_link` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `owner_group` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `owner_business_line` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `owner_email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `owner_slack` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `product_feeds_syndication_requests` (
  `request_id` bigint unsigned NOT NULL,
  `vendor_id` tinyint unsigned NOT NULL,
  `request_handle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `last_checked_date` int unsigned NOT NULL DEFAULT '0',
  `checked_count` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `payload` longtext COLLATE utf8mb4_unicode_ci,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `next_check_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`request_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `requests_to_check_idx` (`status`,`vendor_id`,`next_check_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_answer_votes` (
  `answer_id` bigint unsigned NOT NULL,
  `voter_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`answer_id`,`voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_answers` (
  `answer_id` bigint unsigned NOT NULL,
  `question_id` bigint unsigned NOT NULL,
  `answerer_id` bigint unsigned NOT NULL,
  `last_editor_id` bigint unsigned NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `votes` int unsigned NOT NULL DEFAULT '0',
  `is_accepted` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`answer_id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_categories` (
  `category_id` bigint unsigned NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_question_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `question_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tag_id`,`question_id`),
  KEY `reverse_index` (`question_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_question_votes` (
  `question_id` bigint unsigned NOT NULL,
  `voter_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`question_id`,`voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_questions` (
  `question_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `asker_id` bigint unsigned NOT NULL,
  `last_editor_id` bigint unsigned NOT NULL,
  `title` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `votes` int unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `tag` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rate_limits` (
  `key` varchar(64) NOT NULL,
  `count` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL,
  `create_date` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `replication_nextgen_change_log` (
  `replication_log_id` bigint unsigned NOT NULL DEFAULT '0',
  `user_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `model_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `schema_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `table_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `event` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `incremental_schedule` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `full_schedule` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`replication_log_id`),
  KEY `model_name_idx` (`model_name`),
  KEY `create_idx` (`create_date`),
  KEY `update_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `robotnik_axe_failures` (
  `exp_axe_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `wpt_test_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Test id from WebPageTest for a given run',
  `rule` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Axe rule that had a failure in the test run',
  `impact` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Impact level of the axe rule',
  `num_nodes_failed` int unsigned NOT NULL COMMENT 'Number of DOM nodes that failed the rule in the test run',
  PRIMARY KEY (`exp_axe_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `wpt_test_id_start` (`wpt_test_id`(16)),
  KEY `rule_start` (`rule`(16))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Robotnik axe results for experiment runs by axe rule';

CREATE TABLE `robotnik_experiment_a11y` (
  `exp_result_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `wpt_test_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Test id from WebPageTest for a given run',
  `config_flag` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Experiment config flag used in test run',
  `variant` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Variant of the experiment for test run',
  `total_failures` int unsigned NOT NULL COMMENT 'Number of axe rules failed in test run',
  `total_passes` int unsigned NOT NULL COMMENT 'Number of axe rules passed in test run',
  `failure_diff_control` int NOT NULL COMMENT 'Difference from the control for number of failures',
  `lighthouse_score` int unsigned DEFAULT NULL COMMENT 'Lighthouse score for the test run',
  `lighthouse_diff_control` int DEFAULT NULL COMMENT 'Different from the control for Lighthouse score',
  PRIMARY KEY (`exp_result_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `wpt_test_id_start` (`wpt_test_id`(16))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Robotnik a11y results for experiment runs by variant';

CREATE TABLE `rtt_controls` (
  `rtt_control_id` bigint unsigned NOT NULL,
  `security_rule_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_index.security_rule.security_rule_id',
  `rtt_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_revisions.rtt_revision_id',
  `title` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `mode` tinyint NOT NULL DEFAULT '0',
  `creator_staff_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `updater_staff_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `archived` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rtt_control_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_groups` (
  `rtt_group_id` bigint unsigned NOT NULL,
  `rtt_control_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_controls.rtt_control_id',
  `rtt_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_revisions.rtt_revision_id',
  `parent_group_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_groups.rtt_group_id',
  `operator` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `index` tinyint unsigned NOT NULL,
  `is_negated` tinyint unsigned NOT NULL DEFAULT '0',
  `title` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `threshold` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_control_id`,`rtt_revision_id`,`rtt_group_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_reusable_lists` (
  `rtt_reusable_list_id` bigint unsigned NOT NULL,
  `rtt_reusable_list_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_reusable_lists_revisions.rtt_reusable_list_revision_id',
  `type` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_reusable_list_id`,`rtt_reusable_list_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_reusable_lists_revisions` (
  `rtt_reusable_list_revision_id` bigint unsigned NOT NULL,
  `rtt_reusable_list_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_reusable_lists.rtt_reusable_list_id',
  `title` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `value` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_reusable_list_id`,`rtt_reusable_list_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_revisions` (
  `rtt_revision_id` bigint unsigned NOT NULL,
  `rtt_control_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_controls.rtt_control_id',
  `previous_revision_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_atlas.rtt_revisions.rtt_revision_id',
  `title` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `mode` tinyint NOT NULL DEFAULT '0',
  `run_group_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'FK: etsy_atlas.rtt_groups.rtt_group_id',
  `trigger_group_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_groups.rtt_group_id',
  `action_group_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_groups.rtt_group_id',
  `staff_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `archived` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`rtt_control_id`,`rtt_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_rules` (
  `rtt_rule_id` bigint unsigned NOT NULL,
  `rtt_control_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_controls.rtt_control_id',
  `rtt_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_revisions.rtt_revision_id',
  `rtt_group_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_groups.rtt_group_id',
  `handler` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arguments` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON arguments to the handler method',
  `index` tinyint unsigned NOT NULL,
  `is_negated` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_control_id`,`rtt_revision_id`,`rtt_group_id`,`rtt_rule_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_run_type_event_attributes` (
  `rtt_run_type_event_attribute_id` bigint unsigned NOT NULL,
  `rtt_run_type_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_type_revisions.rtt_run_type_revision_id',
  `rtt_run_type_event_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_type_events.rtt_run_type_event_id',
  `attribute_from` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attribute_to` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_run_type_event_attribute_id`),
  KEY `rtt_run_type_revision_idx` (`rtt_run_type_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_run_type_events` (
  `rtt_run_type_event_id` bigint unsigned NOT NULL,
  `rtt_run_type_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_type_revisions.rtt_run_type_revision_id',
  `event_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_run_type_event_id`),
  KEY `rtt_run_type_revision_idx` (`rtt_run_type_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_run_type_handlers` (
  `rtt_run_type_handler_id` bigint unsigned NOT NULL,
  `rtt_run_type_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_type_revisions.rtt_run_type_revision_id',
  `rtt_handler_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'criteria | action',
  `rtt_handler_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'eg. shop | user | listing',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_run_type_handler_id`),
  KEY `rtt_run_type_revision_idx` (`rtt_run_type_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_run_type_revisions` (
  `rtt_run_type_revision_id` bigint unsigned NOT NULL,
  `rtt_run_type_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_types.rtt_run_type_id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `run_type_description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `run_type_mode` tinyint NOT NULL DEFAULT '0' COMMENT '0 for inactive, 1 for active',
  `is_sweep_allowed` tinyint NOT NULL DEFAULT '0',
  `is_translate_allowed` tinyint NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_run_type_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_run_types` (
  `rtt_run_type_id` bigint unsigned NOT NULL,
  `rtt_run_type_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_run_type_revisions.rtt_run_type_revision_id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `run_type_mode` tinyint NOT NULL DEFAULT '0' COMMENT '0 for inactive, 1 for active',
  `is_sweep_allowed` tinyint NOT NULL DEFAULT '0',
  `is_translate_allowed` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_run_type_id`),
  KEY `rtt_run_type_revision_idx` (`rtt_run_type_revision_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_runs` (
  `rtt_run_id` bigint unsigned NOT NULL,
  `rtt_control_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_controls.rtt_control_id',
  `rtt_revision_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_revisions.rtt_revision_id',
  `rtt_rule_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_rules.rtt_rule_id',
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'running, success, failure',
  `message` longtext COLLATE utf8mb4_unicode_ci COMMENT 'run message',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_control_id`,`rtt_revision_id`,`rtt_rule_id`,`rtt_run_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_sweeper` (
  `rtt_sweeper_id` bigint unsigned NOT NULL,
  `gearman_batch_id` bigint unsigned NOT NULL,
  `location` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'See etsy_index.security_rule.location',
  `security_rule_ids_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Array of security_rule_id as JSON blob',
  `staff_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_aux.staff.id',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_sweeper_id`),
  UNIQUE KEY `gearman_batch_location_idx` (`gearman_batch_id`,`location`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `rtt_sweeper_results` (
  `rtt_sweeper_id` bigint unsigned NOT NULL COMMENT 'FK: etsy_atlas.rtt_sweeper.rtt_sweeper_id',
  `target_type` tinyint unsigned NOT NULL COMMENT 'See EtsyModel_RTT_Enum_TargetType',
  `target_id` bigint unsigned NOT NULL,
  `state` tinyint unsigned NOT NULL COMMENT 'See EtsyModel_RTT_Enum_Sweeper_ResultState',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`rtt_sweeper_id`,`target_type`,`target_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `running_ab_tests` (
  `run_date` int unsigned NOT NULL,
  `ab_test` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`run_date`,`ab_test`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scheduler` (
  `schedule_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(255) NOT NULL DEFAULT '',
  `foreign_id` bigint unsigned NOT NULL DEFAULT '0',
  `min` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 59',
  `hour` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 23',
  `day_of_month` varchar(32) NOT NULL DEFAULT '' COMMENT '1 - 31',
  `month` varchar(32) NOT NULL DEFAULT '' COMMENT '1 - 12',
  `day_of_week` varchar(32) NOT NULL DEFAULT '' COMMENT '0 - 7; Sunday=0 or 7',
  `year` varchar(32) NOT NULL DEFAULT '' COMMENT 'optional',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`schedule_id`),
  KEY `time_idx` (`min`,`hour`,`day_of_month`,`month`,`day_of_week`,`year`),
  KEY `job_designation_idx` (`type`,`foreign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemanator_dummy_test` (
  `testid` bigint unsigned NOT NULL,
  `column1` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `mayhem` bigint DEFAULT '0',
  `column2` bigint NOT NULL DEFAULT '0',
  `column3` bigint DEFAULT '0',
  `column4` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  PRIMARY KEY (`testid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer` (
  `schemer_id` bigint unsigned NOT NULL DEFAULT '0',
  `db` varchar(64) NOT NULL DEFAULT '',
  `schema_name` varchar(128) NOT NULL DEFAULT '',
  `table` varchar(256) NOT NULL DEFAULT '',
  `schema` longtext NOT NULL,
  `model` varchar(256) NOT NULL DEFAULT '',
  `indexes` longtext NOT NULL,
  `create_table` longtext NOT NULL,
  `meta` longtext NOT NULL,
  `description` longtext NOT NULL,
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `is_view` tinyint NOT NULL DEFAULT '0',
  `datahub_urn` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`schemer_id`),
  UNIQUE KEY `datahub_urn` (`datahub_urn`),
  KEY `db_schema_name_table` (`db`,`schema_name`,`table`(255)),
  KEY `table_idx` (`table`(255)),
  KEY `model_idx` (`model`(255)),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_alerts` (
  `schemer_alert_id` bigint unsigned NOT NULL DEFAULT '0',
  `remote_route` varchar(1024) DEFAULT NULL,
  `db_whitelist` varchar(2048) DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`schemer_alert_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_columns_index` (
  `column_name` varchar(128) NOT NULL DEFAULT '',
  `schemer_ids` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`column_name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_contacts` (
  `schemer_contact_id` bigint unsigned NOT NULL DEFAULT '0',
  `schemer_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_email_address` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_owner` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`schemer_contact_id`),
  KEY `schemer_idx` (`schemer_id`),
  KEY `staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_favorites` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `schemer_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`staff_id`,`schemer_id`),
  KEY `schemer_id_idx` (`schemer_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_staff` (
  `schemer_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `favorites` longtext NOT NULL,
  `recently_viewed` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`schemer_staff_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_tags` (
  `schemer_tag_id` bigint unsigned NOT NULL DEFAULT '0',
  `schemer_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `tag` varchar(80) NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`schemer_tag_id`),
  KEY `schemer_id_idx` (`schemer_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `tag_idx` (`tag`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schemer_updates` (
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `schemer_id` bigint unsigned NOT NULL DEFAULT '0',
  `schema` longtext NOT NULL,
  `description` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `schemer_updates_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`schemer_updates_id`),
  KEY `schemer_id_idx` (`schemer_id`),
  KEY `staff_id_idx` (`staff_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schlep` (
  `schlep_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  `omit_columns` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destination_schema` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `full_schedule_id` bigint unsigned NOT NULL DEFAULT '0',
  `incremental_schedule_id` bigint unsigned NOT NULL DEFAULT '0',
  `last_full_update_date` int unsigned NOT NULL DEFAULT '0',
  `last_incremental_update_date` int unsigned NOT NULL DEFAULT '0',
  `enabled` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `last_record_insertion_date` int unsigned NOT NULL DEFAULT '0',
  `full_dump_start_date` int unsigned NOT NULL DEFAULT '0',
  `run_adhoc_full` int NOT NULL DEFAULT '0',
  `run_adhoc_incremental` int NOT NULL DEFAULT '0',
  `full_schedule` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `incremental_schedule` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_full_update_duration` int DEFAULT NULL,
  PRIMARY KEY (`schlep_id`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schlep_log_nextgen` (
  `schlep_log_id` bigint unsigned NOT NULL DEFAULT '0',
  `start_date` int unsigned NOT NULL DEFAULT '0',
  `end_date` int unsigned NOT NULL DEFAULT '0',
  `destination_schema` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_table` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `model_name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rows_added` bigint unsigned NOT NULL DEFAULT '0',
  `total_rows` bigint unsigned NOT NULL DEFAULT '0',
  `total_duration` int NOT NULL DEFAULT '0',
  `mysql_duration` int NOT NULL DEFAULT '0',
  `gcs_upload_duration` int NOT NULL DEFAULT '0',
  `bigquery_duration` int NOT NULL DEFAULT '0',
  `incremental` tinyint(1) NOT NULL DEFAULT '0',
  `incremental_start_date` int unsigned NOT NULL DEFAULT '0',
  `incremental_date_field` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_ceiling` int unsigned NOT NULL DEFAULT '0',
  `filesize` bigint unsigned NOT NULL DEFAULT '0',
  `logstash_token` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `qa_mode` tinyint(1) NOT NULL DEFAULT '0',
  `sql_mysql` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sql_bigquery` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `gcs_stage_duration` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`schlep_log_id`),
  KEY `create_idx` (`create_date`),
  KEY `update_idx` (`update_date`),
  KEY `model_token_idx` (`model_name`,`logstash_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `schlep_nextgen` (
  `schlep_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  `omit_columns` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `destination_schema` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_full_update_date` int unsigned NOT NULL DEFAULT '0',
  `last_incremental_update_date` int unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `last_record_insertion_date` int unsigned NOT NULL DEFAULT '0',
  `full_dump_start_date` int unsigned NOT NULL DEFAULT '0',
  `run_adhoc_full` int NOT NULL DEFAULT '0',
  `run_adhoc_incremental` int NOT NULL DEFAULT '0',
  `full_schedule` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `incremental_schedule` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_full_update_duration` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `owner_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `schema_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `table_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`schlep_id`),
  KEY `name_idx` (`name`),
  KEY `create_idx` (`create_date`),
  KEY `update_idx` (`update_date`),
  KEY `full_schedule_idx` (`full_schedule`),
  KEY `incremental_schedule_idx` (`incremental_schedule`)
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

CREATE TABLE `shop_shipping_label_usps_extracts` (
  `extract_id` bigint unsigned NOT NULL,
  `type` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `file_path` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `usps_filename` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state_ready_to_download_date` int unsigned NOT NULL DEFAULT '0',
  `state_downloading_date` int unsigned NOT NULL DEFAULT '0',
  `state_download_failed_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_date` int unsigned NOT NULL DEFAULT '0',
  `state_processing_failed_date` int unsigned NOT NULL DEFAULT '0',
  `state_processed_date` int unsigned NOT NULL DEFAULT '0',
  `state_unknown_extract_type_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`extract_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `state` (`state`),
  KEY `type_and_filename` (`type`,`usps_filename`)
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

CREATE TABLE `slack_bot_messages` (
  `message_id` bigint unsigned NOT NULL,
  `recipient_staff_id` bigint unsigned NOT NULL,
  `subject_staff_id` bigint unsigned DEFAULT NULL,
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`message_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spot_check` (
  `spot_check_id` bigint unsigned NOT NULL,
  `inquiry_item_id` bigint unsigned DEFAULT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `input_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `input_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`spot_check_id`),
  UNIQUE KEY `unique_inquiry_item_id` (`inquiry_item_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `input_type_input_id_create` (`input_type`(64),`input_id`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spot_check_result` (
  `spot_check_result_id` bigint unsigned NOT NULL,
  `spot_check_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `check_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `context` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`spot_check_result_id`),
  KEY `spot_check_id_idx` (`spot_check_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_entity_history` (
  `history_id` bigint unsigned NOT NULL,
  `entity_id` bigint unsigned NOT NULL,
  `action` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_context` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `json_details` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON blob',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`history_id`),
  KEY `entity_action_idx` (`entity_id`,`action`,`action_context`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_entity_shop_snapshot` (
  `spotlight_entity_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shop_geonameid` bigint unsigned NOT NULL,
  `shop_ship_from_country_codes` tinytext COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_markets_bits` int unsigned NOT NULL COMMENT 'A string of bits that tells us what markets a shop sells in',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`spotlight_entity_id`,`shop_id`),
  KEY `shop_id_index` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry` (
  `inquiry_id` bigint unsigned NOT NULL,
  `submitter_id` bigint unsigned NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `feature_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exposure` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `due_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `complete_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`inquiry_id`),
  KEY `submitter_id` (`submitter_id`),
  KEY `due_date` (`due_date`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `task_id` (`task_id`),
  KEY `complete_date` (`complete_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry_item` (
  `item_id` bigint unsigned NOT NULL,
  `entity_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `status_description` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `entity_id_idx` (`entity_id`),
  KEY `inquiry_id_idx` (`inquiry_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry_item_link` (
  `inquiry_item_id` bigint unsigned NOT NULL,
  `linked_id` bigint unsigned NOT NULL,
  `linked_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `entity_id` bigint unsigned DEFAULT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`inquiry_item_id`,`linked_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry_item_link_review` (
  `inquiry_item_link_review_id` bigint unsigned NOT NULL,
  `linked_id` bigint unsigned DEFAULT NULL,
  `inquiry_item_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `team` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`inquiry_item_link_review_id`),
  KEY `inquiry_item_link_idx` (`linked_id`),
  KEY `inquiry_item_idx` (`inquiry_item_id`),
  KEY `inquiry_idx` (`inquiry_id`),
  KEY `task_idx` (`task_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry_item_review` (
  `inquiry_item_review_id` bigint unsigned NOT NULL,
  `inquiry_item_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `task_id` bigint unsigned NOT NULL,
  `team` varchar(75) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` longtext COLLATE utf8mb4_unicode_ci,
  `staff_id` bigint unsigned DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`inquiry_item_review_id`),
  KEY `inquiry_item_idx` (`inquiry_item_id`),
  KEY `inquiry_idx` (`inquiry_id`),
  KEY `task_idx` (`task_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `spotlight_inquiry_item_review_reason` (
  `inquiry_item_review_reason_id` bigint unsigned NOT NULL,
  `inquiry_item_review_id` bigint unsigned NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason_code` int DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`inquiry_item_review_reason_id`),
  KEY `inquiry_item_review_idx` (`inquiry_item_review_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_animals` (
  `animal_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner1_id` bigint unsigned NOT NULL DEFAULT '0',
  `owner2_id` bigint unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL DEFAULT '',
  `enabled` int unsigned NOT NULL DEFAULT '0',
  `type` int unsigned NOT NULL DEFAULT '1',
  `notes` longtext NOT NULL,
  `images` longtext NOT NULL,
  `other` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`animal_id`),
  KEY `owner1_id_idx` (`owner1_id`),
  KEY `owner2_id_idx` (`owner2_id`),
  KEY `name_idx` (`name`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_counter` (
  `staff_id` bigint unsigned NOT NULL,
  `type` varchar(40) NOT NULL DEFAULT '',
  `count` bigint unsigned NOT NULL,
  `last_reset_date` int unsigned DEFAULT NULL,
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`staff_id`,`type`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Store miscellaneous, namespace stats about people';

CREATE TABLE `staff_flashcards_scoreboard` (
  `auth_username` varchar(128) NOT NULL DEFAULT '',
  `date` int unsigned NOT NULL DEFAULT '0',
  `correct` int unsigned NOT NULL DEFAULT '0',
  `attempts` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`auth_username`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_history` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `changing_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `target_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `field_name` varchar(255) NOT NULL DEFAULT '',
  `old_value` varchar(255) NOT NULL DEFAULT '',
  `new_value` varchar(255) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `target_staff_id_idx` (`target_staff_id`),
  KEY `changing_staff_id_idx` (`changing_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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

CREATE TABLE `staff_location` (
  `id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned DEFAULT NULL,
  `input` varchar(255) NOT NULL,
  `lat` varchar(32) NOT NULL,
  `lng` varchar(32) NOT NULL,
  `desk` varchar(32) DEFAULT NULL,
  `create_date` int unsigned DEFAULT NULL,
  `update_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `input` (`input`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Keep staff locations, either set by staff or otherwise';

CREATE TABLE `staff_recognition` (
  `recognition_id` bigint unsigned NOT NULL,
  `staff_recognized_id` bigint unsigned NOT NULL,
  `staff_recognizer_id` bigint unsigned NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `value` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`recognition_id`),
  KEY `create_date` (`create_date`),
  KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Recognition to and from staff';

CREATE TABLE `staff_sessions` (
  `app_context` tinyint unsigned NOT NULL COMMENT 'See Etsy\\Modules\\Catapult\\SubApps\\Csat\\Model\\Enum\\Context',
  `staff_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  PRIMARY KEY (`app_context`,`staff_id`,`start_date`)
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
  `team_irc_alert` varchar(128) DEFAULT NULL,
  `team_location` varchar(160) DEFAULT NULL,
  `team_type` varchar(32) DEFAULT NULL,
  `parent_team_id` bigint unsigned DEFAULT NULL,
  `team_slack_channel_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `team_slack_channel_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `github_team_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `team_slug` (`team_slug`),
  KEY `is_project` (`is_project`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `status` (`status`),
  KEY `team_name` (`team_name`(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Describe teams in the staff directory';

CREATE TABLE `staff_team_membership_emeritus` (
  `team_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`team_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `staff_id` (`staff_id`,`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Emeritus memberships for recognizing collaboration';

CREATE TABLE `staff_team_relationship` (
  `parent_team` bigint unsigned NOT NULL,
  `project_team` bigint unsigned NOT NULL,
  PRIMARY KEY (`parent_team`,`project_team`),
  KEY `project_team` (`project_team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Describe relationship between organizational teams and project teams in the staff directory';

CREATE TABLE `staff_teammembership` (
  `team_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned DEFAULT NULL,
  PRIMARY KEY (`team_id`,`staff_id`),
  KEY `create_date` (`create_date`),
  KEY `staff_id` (`staff_id`,`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Team memberships for staff';

CREATE TABLE `superbit_big_query_referenced_tables` (
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `referenced_tables` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`revision_id`),
  KEY `query_id_idx` (`query_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_bin` (
  `bin_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '',
  `notes` varchar(1024) NOT NULL DEFAULT '',
  `bin` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bin_id`),
  KEY `staff_idx` (`staff_id`),
  KEY `create_date_idx` (`create_date`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_defaults` (
  `staff_id` bigint unsigned NOT NULL,
  `title` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  `team` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_enabled_runhooks` (
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `runhooks` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`query_id`),
  KEY `update_date_idx` (`update_date`)
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
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `edited_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
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
  KEY `queryt_md5_idx` (`query_id`,`parameters_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_results` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `result` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_revisions` (
  `revision_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_parameters` longtext NOT NULL COMMENT 'user defined parameters',
  `formal_parameters` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`revision_id`),
  KEY `query_id_idx` (`query_id`),
  KEY `update_date_idx` (`update_date`),
  KEY `staff_id_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `superbit_runhook_results` (
  `runhook_results_id` bigint unsigned NOT NULL DEFAULT '0',
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `runhook_name` varchar(256) NOT NULL DEFAULT '' COMMENT 'ApolloEmail,HoldPayout',
  `runhook_result` longtext NOT NULL,
  `error_message` longtext NOT NULL,
  `runhook_status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `runtime` bigint unsigned NOT NULL DEFAULT '0',
  `result_count` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`runhook_results_id`),
  KEY `run_id_idx` (`run_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
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
  `is_protected` tinyint unsigned NOT NULL DEFAULT '0',
  `owning_team` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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

CREATE TABLE `swap_availability` (
  `availability_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `end_date` int unsigned NOT NULL,
  `max_days` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`availability_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `swap_listing` (
  `listing_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`listing_id`),
  UNIQUE KEY `staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `telegram_subscriptions` (
  `telegram_subscription_id` bigint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `alert_name` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`telegram_subscription_id`),
  KEY `admin_id_alert_name` (`admin_id`,`alert_name`(64)),
  KEY `alert_name` (`alert_name`(64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_collection_units` (
  `collection_id` bigint unsigned NOT NULL,
  `unit_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`collection_id`,`unit_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_collections` (
  `collection_id` bigint unsigned NOT NULL,
  `author_id` bigint unsigned NOT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visibility` int unsigned NOT NULL,
  `categories` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`collection_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_contributors` (
  `content_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `type` int unsigned DEFAULT NULL,
  PRIMARY KEY (`content_id`,`staff_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_course_collection` (
  `course_id` bigint unsigned NOT NULL,
  `collection_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`course_id`,`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_course_units` (
  `unit_order` int unsigned DEFAULT NULL,
  `course_id` bigint unsigned NOT NULL,
  `unit_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`course_id`,`unit_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_courses` (
  `id` bigint unsigned NOT NULL,
  `author_id` bigint unsigned NOT NULL,
  `badge_id` bigint unsigned DEFAULT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `info` longtext COLLATE utf8mb4_unicode_ci,
  `prereqs` longtext COLLATE utf8mb4_unicode_ci,
  `visibility` int unsigned NOT NULL,
  `categories` longtext COLLATE utf8mb4_unicode_ci,
  `intro_markdown` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_enrollment_courses` (
  `course_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `state` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`course_id`,`user_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_enrollment_units` (
  `user_id` bigint unsigned NOT NULL,
  `unit_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`unit_id`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `training_units` (
  `unit_id` bigint unsigned NOT NULL,
  `author_id` bigint unsigned NOT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categories` longtext COLLATE utf8mb4_unicode_ci,
  `video_source` longtext COLLATE utf8mb4_unicode_ci,
  `video_chapter_vtt` longtext COLLATE utf8mb4_unicode_ci,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `objectives` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `update_date` (`update_date`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_languages` (
  `language` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_msg_language_restrictions` (
  `translation_restriction_id` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_set` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `language_set` varchar(1023) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `disabled` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`translation_restriction_id`),
  KEY `msg_language_restrictions_name_index` (`name`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_priorities` (
  `priority_id` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_set` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `language_set` varchar(1023) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `priority` int unsigned DEFAULT NULL,
  `due_date` int unsigned DEFAULT NULL,
  `disabled` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`priority_id`),
  KEY `priorities_name_index` (`name`(191)),
  KEY `priorities_priority_index` (`priority`),
  KEY `priorities_duedate_index` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_qas` (
  `qa_id` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_set` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `language_set` varchar(1023) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `disabled` tinyint NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`qa_id`),
  KEY `qas_name_index` (`name`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_role_assignments` (
  `user_id` bigint NOT NULL,
  `role` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role`,`language`),
  KEY `assignment_language_index` (`language`),
  KEY `assignment_role_index` (`role`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_rule_cache` (
  `rule_type` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rule_id` bigint NOT NULL,
  `md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`rule_type`,`rule_id`,`md5`),
  KEY `rule_cache_id_index` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `usps_tracking_code_map` (
  `tracking_code` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `shipping_label_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tracking_code`),
  KEY `shop_id` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vto_opportunities` (
  `opportunity_id` bigint unsigned NOT NULL,
  `office` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `organization_name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `organization_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `organization_contact` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `badge_id` bigint unsigned NOT NULL,
  `skills` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_number_volunteers` smallint unsigned NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dates` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hours_per_day` smallint unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`opportunity_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vto_volunteers` (
  `opportunity_id` smallint unsigned NOT NULL,
  `admin_id` bigint unsigned NOT NULL,
  `is_organizer` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`opportunity_id`,`admin_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vwindex_dashboard_models_status` (
  `model_status_id` bigint unsigned NOT NULL,
  `model_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `claimed_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `claimed_date` int unsigned NOT NULL DEFAULT '0',
  `is_in_progress` tinyint unsigned NOT NULL DEFAULT '0',
  `is_blocked` tinyint unsigned NOT NULL DEFAULT '0',
  `blocked_reasons` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `is_complete` tinyint unsigned NOT NULL DEFAULT '0',
  `completed_date` int unsigned NOT NULL DEFAULT '0',
  `is_deleted` tinyint unsigned NOT NULL DEFAULT '0',
  `is_used_in_transaction` tinyint unsigned NOT NULL DEFAULT '0',
  `in_transaction_with` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `ramp_pct` tinyint unsigned NOT NULL DEFAULT '0',
  `shardifier_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `shardifying_model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `queries_per_second` int unsigned NOT NULL DEFAULT '0',
  `complexity` tinyint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `model_notes` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `renamed_to` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`model_status_id`),
  UNIQUE KEY `model_name_idx` (`model_name`),
  KEY `shardifier_id_idx` (`shardifier_id`),
  KEY `claimed_by_idx` (`claimed_by`),
  KEY `shardifying_model_idx` (`shardifying_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

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

CREATE TABLE `witness_logger` (
  `logger_id` bigint unsigned NOT NULL DEFAULT '0',
  `staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `ldap` varchar(32) NOT NULL DEFAULT '',
  `action` varchar(128) NOT NULL DEFAULT '',
  `page_name` varchar(32) NOT NULL DEFAULT '',
  `search_type` varchar(32) NOT NULL DEFAULT '',
  `search` varchar(1024) NOT NULL DEFAULT '',
  `page` int unsigned NOT NULL DEFAULT '0',
  `count` int unsigned NOT NULL DEFAULT '0',
  `superbit` varchar(512) NOT NULL DEFAULT '',
  `sb_query_id` bigint unsigned NOT NULL DEFAULT '0',
  `sb_report_id` bigint unsigned NOT NULL DEFAULT '0',
  `sb_run_id` bigint unsigned NOT NULL DEFAULT '0',
  `task_id` bigint unsigned NOT NULL DEFAULT '0',
  `id_type` varchar(32) NOT NULL DEFAULT '',
  `ids` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`logger_id`),
  KEY `staff_id_action_superbit_idx` (`staff_id`,`action`),
  KEY `update_date_idx` (`update_date`),
  KEY `task_id_idx` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

