CREATE DATABASE etsy_analytics_0_A;
USE etsy_analytics_0_A;

CREATE TABLE `ab2_event_volume` (
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch seconds',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `event_type` varchar(255) NOT NULL COMMENT 'name of event',
  `visit_volume` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `event_volume` bigint unsigned NOT NULL COMMENT 'Total visits with the given event in this (test, variant, day)',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab2_is_new_visitor_event_volume` (
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch seconds',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `is_new_visitor` tinyint unsigned NOT NULL COMMENT 'If the visitor was a new visitor',
  `event_type` varchar(255) NOT NULL COMMENT 'name of event',
  `visit_volume` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `event_volume` bigint unsigned NOT NULL COMMENT 'Total visits with the given event in this (test, variant, day)',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`,`is_new_visitor`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab2_locale_region_event_volume` (
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch seconds',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `locale_region` varchar(4) NOT NULL COMMENT 'The users region',
  `event_type` varchar(255) NOT NULL COMMENT 'name of event',
  `visit_volume` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `event_volume` bigint unsigned NOT NULL COMMENT 'Total visits with the given event in this (test, variant, day)',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`,`locale_region`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_click_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Day in epoch ms',
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `ref_tag` varchar(255) NOT NULL COMMENT 'Ref Tag dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  KEY `epoch_s` (`epoch_s`,`ab_test`,`ab_variant`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_error_codes` (
  `epoch` bigint unsigned NOT NULL DEFAULT '0',
  `ab_test` varchar(255) NOT NULL,
  `ab_variant` varchar(255) NOT NULL,
  `error_code` varchar(255) NOT NULL,
  `error_count` bigint NOT NULL,
  `visit_count` bigint NOT NULL,
  PRIMARY KEY (`epoch`,`ab_test`,`ab_variant`,`error_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_event_cooccurrence` (
  `data_run_date` varchar(24) NOT NULL,
  `event_one` varchar(255) NOT NULL COMMENT 'first event in the pair',
  `event_two` varchar(255) NOT NULL COMMENT 'second event in the pair',
  `pair_count` bigint unsigned NOT NULL COMMENT 'total number of times these pairs co-occurred in the same visit',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`event_one`,`event_two`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_event_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `exits_from` bigint unsigned NOT NULL COMMENT 'Total exits from this event',
  `landings` bigint DEFAULT NULL COMMENT 'Total number of visits that started on this event',
  `bounces` bigint DEFAULT NULL COMMENT 'Total number of bounces (see a single page with no action and then leave) with this event',
  `load_time` bigint unsigned DEFAULT NULL COMMENT 'php load time',
  `load_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares for php load time',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  `event_count_ss` bigint unsigned DEFAULT NULL COMMENT 'Sum of Squares for total event count',
  PRIMARY KEY (`ab_test`,`ab_variant`,`event_type`,`epoch_s`),
  KEY `epoch_s_idx` (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_event_metrics_by_segment` (
  `data_run_date` varchar(24) NOT NULL,
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `exits_from` bigint unsigned NOT NULL COMMENT 'Total exits from this event',
  `landings` bigint DEFAULT NULL COMMENT 'Total number of visits that started on this event',
  `bounces` bigint DEFAULT NULL COMMENT 'Total number of bounces (see a single page with no action and then leave) with this event',
  `load_time` bigint unsigned DEFAULT NULL COMMENT 'php load time',
  `load_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares for php load time',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  `event_count_ss` bigint unsigned DEFAULT NULL COMMENT 'Sum of Squares for total event count',
  `segment_id` int NOT NULL COMMENT 'segment id',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`,`event_type`,`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_tests_per_event` (
  `data_run_date` varchar(24) NOT NULL,
  `event_type` varchar(255) NOT NULL COMMENT 'event type',
  `visit_count` bigint unsigned NOT NULL COMMENT 'Total visits with this event and test pair',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`event_type`,`ab_test`,`epoch_s`),
  KEY `k_epoch_s_ab_test` (`epoch_s`,`ab_test`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_variant_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `visit_count` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `browser_count` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this A/B key value pair',
  `bounce_count` bigint DEFAULT NULL COMMENT 'Total Bounces (see a single page with no action and then leave) with this A/B key value pair',
  `purchases` bigint unsigned DEFAULT NULL COMMENT 'total number of listings purchased per this A/B value pair',
  `purchases_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of listings purchased per this A/B value pair',
  `total_price` double DEFAULT NULL COMMENT 'total gms in usd of listings purchased per this A/B value pair',
  `total_price_ss` double DEFAULT NULL COMMENT 'sum of square total gms in usd of listings purchased per this A/B value pair',
  `page_count` bigint unsigned DEFAULT NULL COMMENT 'total number of pages seen per this A/B value pair',
  `page_count_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of pages seen per this A/B value pair',
  `visit_time` bigint unsigned DEFAULT NULL COMMENT 'total number of visit time (in seconds) seen per this A/B value pair',
  `visit_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of visit time (in seconds) seen per this A/B value pair',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`),
  KEY `epoch_s_idx` (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ab_variant_metrics_by_segment` (
  `data_run_date` varchar(24) NOT NULL,
  `visit_count` bigint unsigned NOT NULL COMMENT 'Total visits in this (test, variant, day)',
  `browser_count` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this A/B key value pair',
  `bounce_count` bigint DEFAULT NULL COMMENT 'Total Bounces (see a single page with no action and then leave) with this A/B key value pair',
  `purchases` bigint unsigned DEFAULT NULL COMMENT 'total number of listings purchased per this A/B value pair',
  `purchases_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of listings purchased per this A/B value pair',
  `total_price` double DEFAULT NULL COMMENT 'total gms in usd of listings purchased per this A/B value pair',
  `total_price_ss` double DEFAULT NULL COMMENT 'sum of square total gms in usd of listings purchased per this A/B value pair',
  `page_count` bigint unsigned DEFAULT NULL COMMENT 'total number of pages seen per this A/B value pair',
  `page_count_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of pages seen per this A/B value pair',
  `visit_time` bigint unsigned DEFAULT NULL COMMENT 'total number of visit time (in seconds) seen per this A/B value pair',
  `visit_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of visit time (in seconds) seen per this A/B value pair',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  `segment_id` int NOT NULL COMMENT 'segment id',
  `shops_per_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of shops per this A/B key value pair',
  `shops_per_visit_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of shops per this A/B key value pair',
  `max_listings_per_shop` bigint unsigned DEFAULT NULL COMMENT 'total of max listings per shop per this A/B key value pair',
  `max_listings_per_shop_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of max listings per shop per this A/B key value pair',
  `search_unique_shop_impressions` bigint unsigned DEFAULT NULL COMMENT 'total number of search unique shop impressions per this A/B key value pair',
  `search_unique_shop_impressions_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of search unique shop impressions per this A/B key value pair',
  `total_price_robust` bigint DEFAULT NULL,
  `total_price_robust_ss` bigint DEFAULT NULL,
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`,`segment_id`),
  KEY `epoch_s_idx` (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `access_by_platform` (
  `data_run_date` varchar(24) NOT NULL,
  `month` int unsigned NOT NULL DEFAULT '0' COMMENT 'month of visits',
  `year` int unsigned NOT NULL DEFAULT '0' COMMENT 'year of visits',
  `percent_mobile` int unsigned NOT NULL DEFAULT '0' COMMENT 'percent of visits per user on mobile devices',
  PRIMARY KEY (`month`,`year`,`percent_mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `accesses_by_platform` (
  `data_run_date` varchar(24) NOT NULL,
  `month` int unsigned NOT NULL DEFAULT '0' COMMENT 'month of visits',
  `year` int unsigned NOT NULL DEFAULT '0' COMMENT 'year of visits',
  `percent_mobile` int unsigned NOT NULL DEFAULT '0' COMMENT 'percent of visits per user on mobile devices',
  PRIMARY KEY (`month`,`year`,`percent_mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `active_visitors` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `visits` bigint NOT NULL COMMENT 'visits seen per day',
  `active_visits` bigint NOT NULL COMMENT 'visits that did not bounce - saw 2 pages or 1 page and an enagement action',
  `authenticated_visits` bigint NOT NULL COMMENT 'visits where the user was signed in',
  `authenticated_active_visits` bigint NOT NULL COMMENT 'visits that did not bounce and the user was signed in',
  `browsers` bigint NOT NULL COMMENT 'browsers seen per day - roughly equivalent to people',
  `active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one non-bouncing visit',
  `authenticated_browsers` bigint NOT NULL COMMENT 'browsers that were authenticated at least once',
  `authenticated_active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one visit that did not bounce and the user was signed in',
  `new_browsers` bigint DEFAULT NULL,
  KEY `event_type` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_browser_cohort` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_cohort_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_cohort_sitewide_visits` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `visit_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_cohort_visits_with_event` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_user_cohort` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `activity_feed_redesign_visits_with_event` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`is_seller`,`is_mobile`,`variant`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_toolbar_daily_visit_counts` (
  `run_date` bigint DEFAULT NULL,
  `visit_count` int DEFAULT NULL,
  KEY `i_run_date` (`run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `admin_toolbar_page_stats_rollup` (
  `run_date` bigint NOT NULL DEFAULT '0',
  `event_type` varchar(255) NOT NULL DEFAULT '',
  `total_views` int DEFAULT NULL,
  `total_visits` int DEFAULT NULL,
  `total_landings` int DEFAULT NULL,
  KEY `i_event_type` (`event_type`),
  KEY `i_run_date` (`run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ads_daily_keyword_rollup` (
  `keyword` varchar(255) NOT NULL COMMENT 'Stemmed keyword',
  `schedule_day` int unsigned NOT NULL COMMENT '12 UTC is the start of the day in question',
  `ads_impressions` int unsigned NOT NULL DEFAULT '0' COMMENT '# of impressions recorded by search ads',
  `shop_stats_impressions` int unsigned NOT NULL DEFAULT '0' COMMENT '# of impressions recorded by shop stats',
  `true_impressions` int unsigned NOT NULL DEFAULT '0' COMMENT '# of impressions recorded by access log',
  `price` int unsigned NOT NULL DEFAULT '0' COMMENT 'cost per impression, USD * 1e6',
  PRIMARY KEY (`keyword`,`schedule_day`),
  KEY `idx_day` (`schedule_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Daily rollups of ad impressions from various sources, used to measure discrpency';

CREATE TABLE `appstests_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `crypted_password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_devices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `display_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `os_version` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resolution` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_simulator` tinyint(1) DEFAULT '0',
  `appstests_platform_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appstests_platform_id` (`appstests_platform_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `job_date` int unsigned NOT NULL,
  `appstests_project_id` int NOT NULL,
  `hide` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `appstests_project_id` (`appstests_project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_platforms` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '	',
  `name` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_projects` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '	',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `app_name` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pass` tinyint NOT NULL DEFAULT '0',
  `identifier` varchar(250) COLLATE utf8mb4_general_ci NOT NULL,
  `appstests_job_id` int NOT NULL,
  `appstests_device_id` int NOT NULL,
  `appstests_test_id` int NOT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `appstests_job_id` (`appstests_job_id`),
  KEY `appstests_device_id` (`appstests_device_id`),
  KEY `appstests_test_id` (`appstests_test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `appstests_tests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `suite` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hide` tinyint(1) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `asset_trace_events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `epoch` bigint unsigned NOT NULL,
  `endpoint` varchar(1000) NOT NULL,
  `event_type` varchar(1000) NOT NULL,
  `is_primary` tinyint NOT NULL DEFAULT '0',
  `frequency` bigint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `asset_trace_files` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `epoch` bigint unsigned DEFAULT NULL,
  `endpoint` varchar(1000) NOT NULL,
  `asset_type` tinyint NOT NULL,
  `asset_path` varchar(1000) NOT NULL,
  `parent_template_path` varchar(1000) NOT NULL,
  `frequency` bigint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_integration` (
  `aviary_integration_id` bigint NOT NULL,
  `integration_name` varchar(255) NOT NULL DEFAULT '',
  `third_party_name` varchar(255) DEFAULT NULL,
  `description` longtext,
  `data_description` longtext,
  `technical_notes` longtext,
  `runbook_url` varchar(255) DEFAULT NULL,
  `external_login_url` varchar(255) DEFAULT NULL,
  `external_run_logs_url` varchar(255) DEFAULT NULL,
  `external_documentation_url` varchar(255) DEFAULT NULL,
  `external_credentials_information` longtext,
  `external_contact_information` longtext,
  `category` enum('Marketing','Research','Sales','Finance') DEFAULT NULL,
  `log_namespace` varchar(100) DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`aviary_integration_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_integration_contact` (
  `aviary_integration_contact_id` bigint NOT NULL,
  `aviary_integration_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL,
  `staff_email_address` varchar(128) NOT NULL DEFAULT '',
  `contact_type` enum('Owner','Watcher') NOT NULL DEFAULT 'Owner',
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`aviary_integration_contact_id`),
  KEY `fk_aviary_flow_idx` (`aviary_integration_id`),
  KEY `fk_staff_idx` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_integration_contact_contact_method` (
  `aviary_integration_contact_contact_method_id` bigint NOT NULL,
  `aviary_integration_contact_id` bigint NOT NULL,
  `contact_method` enum('None','Email','Nagios','PagerDuty') DEFAULT 'Email',
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`aviary_integration_contact_contact_method_id`),
  KEY `fk_aviary_flow_idx` (`aviary_integration_contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_integration_jira` (
  `aviary_integration_jira_id` bigint NOT NULL,
  `aviary_integration_id` bigint NOT NULL,
  `url_text` text NOT NULL,
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`aviary_integration_jira_id`),
  KEY `aviary_integration_idx` (`aviary_integration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_integration_note` (
  `aviary_integration_note_id` bigint NOT NULL,
  `aviary_integration_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL,
  `text` longtext NOT NULL,
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`aviary_integration_note_id`),
  KEY `aviary_flow_idx` (`aviary_integration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_job` (
  `aviary_job_id` bigint NOT NULL,
  `aviary_integration_id` bigint NOT NULL,
  `name` varchar(80) NOT NULL,
  `frequency` varchar(45) DEFAULT NULL,
  `data_direction` enum('Outbound','Bidirectional','Inbound') DEFAULT NULL,
  `github_code_url` text,
  `create_date` bigint DEFAULT NULL,
  `update_date` bigint NOT NULL,
  `script_name` varchar(100) NOT NULL DEFAULT '',
  `class_name` varchar(100) NOT NULL DEFAULT '',
  `file_path` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`aviary_job_id`),
  KEY `aviary_flow_idx` (`aviary_integration_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_job_run` (
  `aviary_job_run_id` bigint NOT NULL,
  `aviary_job_id` bigint NOT NULL,
  `status` enum('Started','Finished','Error') DEFAULT NULL,
  `runlog_path` varchar(45) DEFAULT NULL,
  `run_output` longtext,
  `start_ts` bigint NOT NULL,
  `stop_ts` bigint DEFAULT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint DEFAULT NULL,
  `job_executable_path` varchar(255) DEFAULT NULL,
  `host_run_on` varchar(100) DEFAULT NULL,
  `status_message` text,
  `etsy_request_uuid` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`aviary_job_run_id`),
  KEY `job_update_date` (`aviary_job_id`,`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_job_run_keyval` (
  `aviary_job_run_keyval_id` bigint NOT NULL,
  `aviary_integration_id` bigint NOT NULL,
  `aviary_job_run_id` bigint NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  `modifier` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`aviary_job_run_keyval_id`),
  KEY `aviary_job_run_idx` (`aviary_job_run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `aviary_queue` (
  `aviary_queue_id` bigint NOT NULL,
  `aviary_integration_name` varchar(255) NOT NULL DEFAULT '',
  `custom_parameter` varchar(55) NOT NULL DEFAULT '',
  `custom_date` varchar(55) NOT NULL DEFAULT '',
  `is_pending` tinyint NOT NULL DEFAULT '1',
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`aviary_queue_id`),
  KEY `aviary_integration_name_idx` (`aviary_integration_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `basecamp_data_group_persons` (
  `group_person_id` bigint unsigned NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `person_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`group_person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `basecamp_data_groups` (
  `group_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(5000) NOT NULL DEFAULT '',
  `created_staff_id` bigint unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'shows on front page',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `basecamp_data_persons` (
  `id` bigint unsigned NOT NULL COMMENT 'basecamp id',
  `name` varchar(255) NOT NULL COMMENT 'basecamp name',
  `email_address` varchar(255) NOT NULL COMMENT 'basecamp email_address',
  `admin` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp admin',
  `created_at` varchar(36) NOT NULL COMMENT 'basecamp created_at',
  `updated_at` varchar(36) NOT NULL COMMENT 'basecamp updated_at',
  `identity_id` bigint unsigned NOT NULL COMMENT 'basecamp identity_id',
  `avatar_url` varchar(255) NOT NULL COMMENT 'basecamp avatar_url',
  `fullsize_avatar_url` varchar(255) NOT NULL COMMENT 'basecamp fullsize_avatar_url',
  `url` varchar(255) NOT NULL COMMENT 'basecamp url',
  `updated` bigint unsigned NOT NULL COMMENT 'updated',
  `is_active` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'is_active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `basecamp_data_projects` (
  `id` bigint unsigned NOT NULL COMMENT 'basecamp id',
  `name` varchar(255) NOT NULL COMMENT 'basecamp name',
  `description` varchar(5000) NOT NULL DEFAULT '' COMMENT 'basecamp description',
  `archived` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp archived',
  `is_client_project` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp is_client_project',
  `created_at` varchar(36) NOT NULL COMMENT 'basecamp created_at',
  `updated_at` varchar(36) NOT NULL COMMENT 'basecamp updated_at',
  `draft` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp draft',
  `last_event_at` varchar(36) NOT NULL COMMENT 'basecamp last_event_at',
  `starred` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp starred',
  `url` varchar(255) NOT NULL COMMENT 'basecamp url',
  `updated` bigint unsigned NOT NULL COMMENT 'updated',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `basecamp_data_todos` (
  `id` bigint unsigned NOT NULL COMMENT 'basecamp id',
  `content` varchar(255) NOT NULL COMMENT 'basecamp content',
  `state` varchar(255) NOT NULL COMMENT 'basecamp state',
  `project_id` bigint unsigned NOT NULL COMMENT 'basecamp project id',
  `project_name` varchar(255) NOT NULL COMMENT 'basecamp project project name',
  `todolist_id` bigint unsigned NOT NULL COMMENT 'basecamp id',
  `todolist_name` varchar(255) NOT NULL COMMENT 'basecamp todolist name',
  `todolist_created_at` varchar(36) NOT NULL COMMENT 'basecamp todolist created_at',
  `position` int unsigned NOT NULL COMMENT 'basecamp position',
  `completed` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'basecamp completed',
  `created_at` varchar(36) NOT NULL COMMENT 'basecamp created_at',
  `updated_at` varchar(36) NOT NULL COMMENT 'basecamp updated_at',
  `comments_count` int unsigned NOT NULL COMMENT 'basecamp comments count',
  `due_on` varchar(36) NOT NULL COMMENT 'basecamp due_on',
  `due_at` varchar(36) NOT NULL COMMENT 'basecamp due_at',
  `completed_at` varchar(36) NOT NULL COMMENT 'basecamp completed at',
  `url` varchar(255) NOT NULL COMMENT 'basecamp url',
  `completer_id` bigint unsigned NOT NULL COMMENT 'basecamp completer id',
  `completer_name` varchar(255) NOT NULL COMMENT 'basecamp completer completer name',
  `creator_id` bigint unsigned NOT NULL COMMENT 'basecamp creator id',
  `creator_name` varchar(255) NOT NULL COMMENT 'basecamp creator creator name',
  `assignee_id` bigint unsigned NOT NULL COMMENT 'basecamp assignee id',
  `assignee_name` varchar(255) NOT NULL COMMENT 'basecamp assignee assignee name',
  `updated` bigint unsigned NOT NULL COMMENT 'updated',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bin_log_histories` (
  `run_id` bigint unsigned NOT NULL,
  `is_sharded` tinyint NOT NULL,
  `database_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `index_table_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shardifier` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `status` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bin_logs_row_stats` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `erroneous_row_count` bigint NOT NULL,
  `successful_row_count` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `table_row` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bin_logs_table_stats` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `table_name` varchar(256) NOT NULL,
  `row_type` varchar(32) NOT NULL,
  `count` bigint NOT NULL,
  `shard_name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `table_row` (`epoch`,`table_name`(255),`row_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `browse_promo_data` (
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `ref_tag` varchar(100) NOT NULL DEFAULT '' COMMENT 'ref tag on URL accessed in visit',
  `category` varchar(100) NOT NULL DEFAULT '' COMMENT 'browse category accessed in visit',
  `buy_status` int unsigned NOT NULL DEFAULT '0' COMMENT 'whether the visit resulted in a cart payment',
  `visit_start` int unsigned NOT NULL DEFAULT '0' COMMENT 'whether the visit started with a browse promo',
  `visit_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of visits',
  PRIMARY KEY (`data_run_date`,`ref_tag`,`category`,`buy_status`,`visit_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_conversion_metrics_by_country` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `buyer_country_code` varchar(2) NOT NULL COMMENT '2 letter country code of buyer',
  `seller_country_code` varchar(2) NOT NULL COMMENT '2 letter country code of seller',
  `listing_within_country` tinyint NOT NULL COMMENT 'boolean indicating whether seller is from the same country as the buyer',
  `total_listings_viewed` bigint unsigned DEFAULT NULL COMMENT 'listing views by UK users',
  `total_items_added` bigint unsigned DEFAULT NULL COMMENT 'cart additions by UK users',
  `total_items_purchased` bigint unsigned DEFAULT NULL COMMENT 'purchases by UK users',
  `added_to_cart_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of cart additions to listing views',
  `purchase_from_view_cart_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of purchases to cart additions',
  `overall_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of purchases to listing views',
  KEY `data_run_date` (`buyer_country_code`,`seller_country_code`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_adjusted_event_metrics` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `epoch_s` int unsigned NOT NULL,
  `ab_variant` varchar(60) NOT NULL,
  `event_type` varchar(60) NOT NULL,
  `n` int unsigned NOT NULL,
  PRIMARY KEY (`ab_variant`,`event_type`,`epoch_s`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_adjusted_visit_counts` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `epoch_s` int unsigned NOT NULL,
  `ab_variant` varchar(60) NOT NULL,
  `n` int unsigned NOT NULL,
  PRIMARY KEY (`ab_variant`,`epoch_s`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_adjusted_visit_metrics` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `epoch_s` int unsigned NOT NULL,
  `ab_variant` varchar(60) NOT NULL,
  `event_type` varchar(60) NOT NULL,
  `n` int unsigned NOT NULL,
  PRIMARY KEY (`ab_variant`,`event_type`,`epoch_s`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_cohort_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '0',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`completed_onboarding`,`saw_new_activity_feed`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_cohort_sitewide_visits` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '0',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `visit_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`completed_onboarding`,`saw_new_activity_feed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_cohort_visits_with_event` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `variant` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '0',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`is_seller`,`is_mobile`,`variant`,`completed_onboarding`,`saw_new_activity_feed`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `buyer_onboarding_funnel_1` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` int NOT NULL DEFAULT '0',
  `chose_buckets` int NOT NULL DEFAULT '0',
  `chose_tastemakers` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`is_mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `calendar_1` (
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'This is the primary key',
  `week_start_monday` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `week_end_sunday` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `week_start_sunday` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `week_end_saturday` timestamp NOT NULL DEFAULT '1970-01-01 00:00:01',
  `unix` int DEFAULT NULL,
  `week` int DEFAULT NULL,
  `day` int DEFAULT NULL,
  `year_week` int DEFAULT NULL,
  `calendar_month` int DEFAULT NULL,
  `calendar_year` int DEFAULT NULL,
  `calendar_quarter` int DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `campaign_daily_schedule` (
  `campaign_id` bigint unsigned NOT NULL,
  `start_date` int unsigned NOT NULL,
  `budget` int unsigned NOT NULL,
  `num_keywords` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `keywords` text,
  PRIMARY KEY (`campaign_id`,`start_date`),
  KEY `start_date` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_aggregated_new` (
  `flow_id` char(32) NOT NULL,
  `agg_json` text NOT NULL,
  `epoch_ms` bigint unsigned NOT NULL,
  PRIMARY KEY (`epoch_ms`,`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_edges` (
  `flow_id` char(32) NOT NULL,
  `src_stage` int NOT NULL,
  `dest_stage` int NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_edges_new` (
  `flow_id` char(32) NOT NULL,
  `src_stage` int NOT NULL,
  `dest_stage` int NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`flow_id`,`src_stage`,`dest_stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_flows` (
  `flow_id` char(32) NOT NULL,
  `flow_name` char(96) NOT NULL,
  `flow_status` char(32) NOT NULL,
  `flow_json` text NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_flows_new` (
  `flow_id` char(32) NOT NULL,
  `flow_name` char(96) NOT NULL,
  `flow_status` char(32) NOT NULL,
  `flow_json` text NOT NULL,
  `update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_steps` (
  `step_id` char(32) NOT NULL,
  `flow_id` char(32) NOT NULL,
  `step_json` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cascading_job_steps_new` (
  `step_id` char(32) NOT NULL,
  `flow_id` char(32) NOT NULL,
  `step_json` text,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`step_id`),
  KEY `flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_bootstrap_exp_stats` (
  `bootstrap_exp_stats_id` int NOT NULL,
  `experiment_id` bigint NOT NULL,
  `from_date` bigint NOT NULL,
  `to_date` bigint NOT NULL,
  `run_date` bigint NOT NULL,
  `run_id` varchar(41) NOT NULL,
  `variant` varchar(200) NOT NULL,
  `event_name` varchar(200) NOT NULL,
  `mean` float DEFAULT NULL,
  `percentile_2p5` float DEFAULT NULL,
  `percentile_97p5` float DEFAULT NULL,
  `significant` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`bootstrap_exp_stats_id`),
  KEY `exp_variant_event_index` (`experiment_id`,`variant`,`event_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_elasticsearch_cache` (
  `create_date` bigint NOT NULL,
  `cache_key` varchar(255) NOT NULL DEFAULT '',
  `result` text,
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `return_format` varchar(255) NOT NULL,
  `config_flag` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_nonevent_ab_metrics` (
  `epoch` bigint unsigned NOT NULL DEFAULT '0',
  `ab_test` varchar(255) NOT NULL,
  `ab_variant` varchar(255) NOT NULL,
  `metric` varchar(255) NOT NULL,
  `sum` double NOT NULL,
  `sum_of_squares` double NOT NULL,
  PRIMARY KEY (`epoch`,`ab_test`,`ab_variant`,`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_precalculated_segment_data` (
  `precalc_id` bigint NOT NULL,
  `config_flag` varchar(512) NOT NULL,
  `segmentation` varchar(100) NOT NULL,
  `segment` varchar(100) NOT NULL,
  `from_date` bigint NOT NULL,
  `to_date` bigint NOT NULL,
  `batch_unique_ident` varchar(100) NOT NULL DEFAULT '',
  `days` int NOT NULL DEFAULT '0',
  `query_time_secs` float NOT NULL,
  `source` varchar(100) NOT NULL,
  `create_date` bigint NOT NULL,
  `raw_event_data` longtext,
  `raw_variant_data` longtext,
  `visits_per_day` text,
  `segments_array` text,
  `visit_counts_by_segment` text,
  PRIMARY KEY (`precalc_id`),
  KEY `days_idx` (`days`),
  KEY `config_flag_idx` (`config_flag`(255)),
  KEY `batch_unique_ident_idx` (`batch_unique_ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `catapult_qa_drill_down` (
  `run_date` int DEFAULT NULL,
  `ab_test` varchar(250) DEFAULT NULL,
  `ab_variant` varchar(250) DEFAULT NULL,
  `is_mobile_supported` int DEFAULT NULL,
  `browser_platform` varchar(250) DEFAULT NULL,
  `count` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cha_test_selector_seen` (
  `epoch_s` bigint DEFAULT NULL,
  `sheet` varchar(255) DEFAULT NULL,
  `found` int DEFAULT NULL,
  `unique_count` int DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `selector` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cohort_metrics` (
  `cohort_key` varchar(255) NOT NULL,
  `cohort_date` varchar(60) NOT NULL,
  `day` int NOT NULL,
  `variant` varchar(64) NOT NULL,
  `metric_type` varchar(64) NOT NULL,
  `metric` varchar(64) NOT NULL,
  `visits_with_metric_count` bigint NOT NULL,
  `visits_with_metric_count_ss` bigint NOT NULL,
  PRIMARY KEY (`cohort_key`,`cohort_date`,`day`,`variant`,`metric_type`,`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cohort_metrics__gnav` (
  `cohort_key` varchar(255) NOT NULL,
  `cohort_date` varchar(60) NOT NULL,
  `day` int NOT NULL,
  `variant` varchar(64) NOT NULL,
  `metric_type` varchar(64) NOT NULL,
  `metric` varchar(64) NOT NULL,
  `visits_with_metric_count` bigint NOT NULL,
  `visits_with_metric_count_ss` bigint NOT NULL,
  PRIMARY KEY (`cohort_key`,`cohort_date`,`day`,`variant`,`metric_type`,`metric`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cohorts` (
  `cohort_key` varchar(255) NOT NULL,
  `cohort_type` varchar(64) NOT NULL,
  `cohort_name` varchar(128) NOT NULL,
  `person_key` varchar(64) NOT NULL,
  `cohort_start` varchar(60) NOT NULL,
  `cohort_end` varchar(60) NOT NULL,
  `n_days` int NOT NULL,
  `cohort_date` varchar(60) NOT NULL,
  `variant` varchar(64) NOT NULL,
  `size` bigint NOT NULL,
  PRIMARY KEY (`cohort_type`,`cohort_name`,`person_key`,`cohort_start`,`cohort_end`,`n_days`,`cohort_date`,`variant`),
  KEY `cohort_key` (`cohort_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cohorts__gnav` (
  `cohort_key` varchar(255) NOT NULL,
  `cohort_type` varchar(64) NOT NULL,
  `cohort_name` varchar(128) NOT NULL,
  `person_key` varchar(64) NOT NULL,
  `cohort_start` varchar(60) NOT NULL,
  `cohort_end` varchar(60) NOT NULL,
  `n_days` int NOT NULL,
  `cohort_date` varchar(60) NOT NULL,
  `variant` varchar(64) NOT NULL,
  `size` bigint NOT NULL,
  PRIMARY KEY (`cohort_type`,`cohort_name`,`person_key`,`cohort_start`,`cohort_end`,`n_days`,`cohort_date`,`variant`),
  KEY `cohort_key` (`cohort_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `common_event_attributes` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_attribute` varchar(100) NOT NULL COMMENT 'name of the event attribute',
  `distinct_attribute_count` bigint NOT NULL COMMENT 'number of events that have this attribute at least 5% of the time',
  `total_event_count` bigint NOT NULL COMMENT 'number of total events for this rollup',
  KEY `event_attribute` (`data_run_date`,`event_attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `conversion_metrics` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `conversions` bigint unsigned NOT NULL COMMENT 'visits that made a purchase',
  `beyond_cart_and_exits` bigint unsigned NOT NULL COMMENT 'visits that, from cart_view event, proceeded towards payment or exited',
  `conversion_rate` float unsigned NOT NULL COMMENT 'visits that made a purchase',
  `median_steps` int unsigned NOT NULL COMMENT 'median steps between last cart view and payment',
  `mean_orders` float unsigned NOT NULL COMMENT 'average orders per converted visit',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `countries` (
  `country_id` int DEFAULT NULL,
  `iso_country_code` varchar(2) DEFAULT NULL,
  `world_bank_country_code` varchar(3) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `lat` decimal(8,4) DEFAULT NULL,
  `lot` decimal(8,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `country_map` (
  `country_id` int DEFAULT NULL,
  `country_name` varchar(255) DEFAULT NULL,
  `country_name_not_unique` varchar(255) DEFAULT NULL,
  `region_3_name` varchar(255) DEFAULT NULL,
  `region_2_name` varchar(255) DEFAULT NULL,
  `region_1_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `country_mobile_visit_level_metrics` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `country` varchar(32) NOT NULL COMMENT 'the GeoIP derived country',
  `is_mobile_device` tinyint(1) NOT NULL COMMENT 'was this a mobile device? Based on User-Agent',
  `platform` varchar(32) NOT NULL COMMENT 'Operating system like Win7, Linux, etc. Based on User-Agent',
  `event_type` varchar(100) NOT NULL COMMENT 'the event_type from the Event logs',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `conversions_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `favorites_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one favorite',
  `conversions_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `favorites_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one favorite',
  KEY `group_key` (`country`,`is_mobile_device`,`platform`,`event_type`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_order_purchase_funnel` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `view_reserved_listing` int NOT NULL DEFAULT '0',
  `view_cart` int NOT NULL DEFAULT '0',
  `review_cart` int NOT NULL DEFAULT '0',
  `payment_cart` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `custom_order_request_funnel` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `view_custom_listing` int DEFAULT NULL,
  `convo_open` int NOT NULL DEFAULT '0',
  `convo_send` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `customer_service_stats_histogram` (
  `id` int NOT NULL AUTO_INCREMENT,
  `metric_name` varchar(100) NOT NULL,
  `bin` float DEFAULT NULL,
  `size` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `metric_bin_idx` (`metric_name`,`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `daily_search_queries` (
  `epoch` int NOT NULL,
  `query_sha` varchar(40) NOT NULL,
  `query` varchar(1000) NOT NULL,
  `visit_count` int NOT NULL,
  `visit_trend` float NOT NULL,
  `visit_history` blob,
  PRIMARY KEY (`epoch`,`query_sha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `daily_search_queries_days` (
  `epoch` int NOT NULL,
  `created` int NOT NULL,
  `count` int NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataintegrations_simpledatastore` (
  `datastore_id` bigint NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value_data` longtext,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `create_date` bigint NOT NULL DEFAULT '0',
  `update_date` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`datastore_id`),
  UNIQUE KEY `datastore_namespace_key_idx` (`namespace`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_job_flow_rollup` (
  `user` varchar(255) DEFAULT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `started_at` varchar(64) DEFAULT NULL,
  `duration_minutes` bigint DEFAULT NULL,
  `steps` bigint DEFAULT NULL,
  `mappers` bigint DEFAULT NULL,
  `reducers` bigint DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL,
  `priority` varchar(25) DEFAULT NULL,
  `ram_usage` decimal(10,0) DEFAULT NULL,
  `tuples_read` bigint DEFAULT NULL,
  `tuples_written` bigint DEFAULT NULL,
  `hdfs_bytes_read` bigint DEFAULT NULL,
  `hdfs_bytes_written` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_report_queries` (
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext NOT NULL,
  `query_parameters` longtext NOT NULL COMMENT 'user defined parameters',
  `last_run_id` bigint unsigned NOT NULL DEFAULT '0',
  `last_run_status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `last_run_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`query_id`),
  KEY `status_idx` (`status`),
  KEY `category_idx` (`category`),
  KEY `team_idx` (`team`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_report_result` (
  `dataplatform_report_result_id` int unsigned NOT NULL AUTO_INCREMENT,
  `report_name` varchar(255) NOT NULL,
  `json_query_results` text NOT NULL,
  `results_storage_datetime` datetime NOT NULL,
  PRIMARY KEY (`dataplatform_report_result_id`),
  UNIQUE KEY `report_name` (`report_name`,`results_storage_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_report_results_oldstyle` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `result` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dataplatform_report_runs` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `runtime` bigint unsigned NOT NULL DEFAULT '0',
  `result_count` int unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'scheduled,adhoc',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`),
  KEY `query_id_idx` (`query_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `debezium_signal` (
  `id` varchar(42) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='Used only to send signals to Debezium';

CREATE TABLE `dimension_1` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int unsigned NOT NULL DEFAULT '0',
  `event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count` int unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`variant`,`is_seller`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_2` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int unsigned NOT NULL DEFAULT '0',
  `event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count` int unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_3` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `visit_count` int unsigned NOT NULL DEFAULT '0',
  `visit_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`given_onboarding`,`completed_onboarding`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_4` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int unsigned NOT NULL DEFAULT '0',
  `event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count` int unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`completed_onboarding`,`saw_new_activity_feed`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_activity_feed_mobile_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`variant`,`is_seller`,`is_mobile`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_activity_feed_redesign_cohort_events` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  `event_count_by_user_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_by_user_ss` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`is_mobile`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_activity_feed_redesign_cohort_sitewide_visits` (
  `data_run_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `visit_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`is_mobile`,`given_onboarding`,`completed_onboarding`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_activity_feed_redesign_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `given_onboarding` tinyint NOT NULL DEFAULT '-1',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`variant`,`is_seller`,`is_mobile`,`given_onboarding`,`completed_onboarding`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_buyer_onboarding_cohort_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`is_mobile`,`completed_onboarding`,`saw_new_activity_feed`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_buyer_onboarding_cohort_sitewide_visits` (
  `data_run_date` varchar(128) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `completed_onboarding` tinyint NOT NULL DEFAULT '-1',
  `saw_new_activity_feed` tinyint NOT NULL DEFAULT '-1',
  `visit_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`is_mobile`,`completed_onboarding`,`saw_new_activity_feed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_cohorts` (
  `data_run_date` varchar(128) NOT NULL DEFAULT '',
  `cohort_type` varchar(128) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_type`,`cohort_date_path`,`variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dimension_fb_reg_cohort_events` (
  `data_run_date` varchar(30) NOT NULL DEFAULT '',
  `cohort_date_path` varchar(30) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint NOT NULL DEFAULT '0',
  `is_mobile` tinyint NOT NULL DEFAULT '0',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `event_count` int NOT NULL DEFAULT '0',
  `visits_with_event_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`cohort_date_path`,`variant`,`is_seller`,`is_mobile`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `direct_checkout_funnel_by_region` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `region` varchar(2) DEFAULT NULL COMMENT 'two-letter country code from IP address',
  `view_cart` bigint DEFAULT NULL COMMENT 'visits that triggered view_cart events accepting credit cards; step 1 of funnel',
  `cart_shipping` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_shipping events; step 2 of funnel',
  `cart_cc_select` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_cc_select events; step 3 of funnel',
  `cart_review` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_review events; step 4 of funnel',
  `cart_payment` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_payment events; step 5 of funnel',
  KEY `data_run_date` (`region`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dooperbit_queries` (
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(512) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'draft,published,archived,pending',
  `team` varchar(64) NOT NULL DEFAULT '',
  `category` varchar(64) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `database` varchar(256) NOT NULL DEFAULT '' COMMENT 'vertica,db_data',
  `query` longtext NOT NULL,
  `query_parameters` longtext NOT NULL COMMENT 'user defined parameters',
  `last_run_id` bigint unsigned NOT NULL DEFAULT '0',
  `last_run_status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `last_run_date` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`query_id`),
  KEY `status_idx` (`status`),
  KEY `category_idx` (`category`),
  KEY `team_idx` (`team`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dooperbit_results` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `result` longtext NOT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `dooperbit_runs` (
  `run_id` bigint unsigned NOT NULL DEFAULT '0',
  `query_id` bigint unsigned NOT NULL DEFAULT '0',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT 'success,failed',
  `runtime` bigint unsigned NOT NULL DEFAULT '0',
  `result_count` int unsigned NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'scheduled,adhoc',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`run_id`),
  KEY `query_id_idx` (`query_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_all_time_aggregates` (
  `utm_campaign` varchar(100) NOT NULL,
  `campaign_label` varchar(100) NOT NULL,
  `create_date` bigint unsigned NOT NULL,
  `update_date` bigint unsigned NOT NULL,
  `total_sends` bigint unsigned NOT NULL DEFAULT '0',
  `total_deliveries` bigint unsigned NOT NULL DEFAULT '0',
  `total_opens` bigint unsigned NOT NULL DEFAULT '0',
  `total_clicks` bigint unsigned NOT NULL DEFAULT '0',
  `unique_opens` bigint unsigned NOT NULL DEFAULT '0',
  `unique_clicks` bigint unsigned NOT NULL DEFAULT '0',
  `total_unsubs` bigint unsigned NOT NULL DEFAULT '0',
  `total_gms` bigint unsigned NOT NULL DEFAULT '0',
  `total_items_purchased` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`utm_campaign`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_audience_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_source` varchar(100) DEFAULT NULL,
  `audience_count` bigint DEFAULT NULL COMMENT 'audience size per utm_source/campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_campaign` (
  `email_campaign_id` bigint NOT NULL DEFAULT '0',
  `type` varchar(32) NOT NULL DEFAULT '',
  `status` varchar(16) NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `length` int NOT NULL DEFAULT '0',
  `frequency` int NOT NULL DEFAULT '0',
  `sending_mechanism` smallint NOT NULL DEFAULT '0',
  `name` varchar(120) NOT NULL COMMENT 'used by many queries to specify which campaign to operate on',
  `short_name` varchar(64) DEFAULT NULL COMMENT 'reserved for shortened display name in email header',
  `utm_source` varchar(64) NOT NULL DEFAULT '',
  `is_subscribed_on_signup` tinyint(1) NOT NULL DEFAULT '0',
  `is_subscribed_on_new_shop` tinyint(1) NOT NULL DEFAULT '0',
  `flow` varchar(16) NOT NULL DEFAULT '',
  `sender_name` varchar(64) NOT NULL DEFAULT '',
  `reply_to_address` varchar(256) NOT NULL DEFAULT '',
  `parent_id` bigint NOT NULL DEFAULT '0',
  `currency_code` varchar(3) DEFAULT 'USD',
  `campaign_label` varchar(64) NOT NULL DEFAULT '' COMMENT 'used for aggregrating stats',
  `canvas_footer_path` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`email_campaign_id`),
  UNIQUE KEY `email_campaign_name_idx` (`name`),
  KEY `is_subscribed_on_new_shop_idx` (`is_subscribed_on_new_shop`,`status`),
  KEY `is_subscribed_on_signup_idx` (`is_subscribed_on_signup`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8 COMMENT='used by many queries to specify which campaign to operate on';

CREATE TABLE `email_click_by_position_daily` (
  `data_run_date` varchar(10) DEFAULT NULL,
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `count_by_link_clicked` bigint NOT NULL COMMENT 'total number of clicks',
  `unique_count_by_link_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  `link_clicked` bigint NOT NULL COMMENT 'link position that was clicked',
  `loc` varchar(255) NOT NULL,
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`),
  KEY `click_metrics` (`loc`,`utm_campaign`,`campaign_label`,`utm_source`,`link_clicked`),
  KEY `campaign_link_loc` (`utm_campaign`,`link_clicked`,`loc`,`count_by_link_clicked`,`unique_count_by_link_clicked`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_by_position_daily_backup` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `count_by_link_clicked` bigint NOT NULL COMMENT 'total number of clicks',
  `unique_count_by_link_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  `link_clicked` bigint NOT NULL COMMENT 'link position that was clicked',
  `loc` varchar(255) NOT NULL,
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `links_clicked` bigint NOT NULL COMMENT 'total number of distinct links that were clicked',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_daily_new` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `count` bigint NOT NULL COMMENT 'total number of clicks',
  `unique_count` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_daily_new_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `count` bigint NOT NULL COMMENT 'total number of clicks',
  `unique_count` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_monthly_source` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `links_clicked` bigint NOT NULL COMMENT 'total number of distinct links that were clicked',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_click_weekly` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `links_clicked` bigint NOT NULL COMMENT 'total number of distinct links that were clicked',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_deliver_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  `campaign_label` varchar(100) DEFAULT NULL,
  `utm_source` varchar(100) DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_deliver_daily_new_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  `campaign_label` varchar(100) DEFAULT NULL,
  `utm_source` varchar(100) DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_delivered_daily_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  `campaign_label` varchar(100) DEFAULT NULL,
  `utm_source` varchar(100) DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_gms_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm campaign',
  `order_gms` bigint DEFAULT NULL COMMENT 'total order gms',
  `order_price` bigint DEFAULT NULL COMMENT 'total order price',
  `order_quantity` bigint DEFAULT NULL COMMENT 'total order price',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  `epoch_s` bigint unsigned DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_links_click_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicked_link` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_links_click_monthly_source` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicked_link` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_links_click_weekly` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicked_link` varchar(100) NOT NULL COMMENT 'utm medium',
  `clicks` bigint NOT NULL COMMENT 'total number of clicks',
  `users_clicked` bigint NOT NULL COMMENT 'total number of distinct users that clicked',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_new_subscribers_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_source` varchar(100) DEFAULT NULL,
  `subscriber_count` bigint DEFAULT NULL COMMENT 'new subscriber size per utm_source/campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_opened` bigint NOT NULL COMMENT 'total number of emails opened',
  `users_opened` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_daily_new` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `email_open_count` bigint NOT NULL COMMENT 'total number of emails opened',
  `unique_email_open_count` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  `percent_mobile` float DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_daily_new_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `email_open_count` bigint NOT NULL COMMENT 'total number of emails opened',
  `unique_email_open_count` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  `percent_mobile` float DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_daily_new_vverma` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) DEFAULT NULL,
  `email_open_count` bigint NOT NULL COMMENT 'total number of emails opened',
  `unique_email_open_count` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  `percent_mobile` float DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_monthly_source` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_opened` bigint NOT NULL COMMENT 'total number of emails opened',
  `users_opened` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_open_weekly` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_opened` bigint NOT NULL COMMENT 'total number of emails opened',
  `users_opened` bigint NOT NULL COMMENT 'total number of distinct users that opened this campaign/source/medium',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_referring_campaigns` (
  `visit_id` varchar(250) DEFAULT NULL,
  `utm_campaign` varchar(250) DEFAULT NULL,
  `utm_source` varchar(250) DEFAULT NULL,
  `utm_medium` varchar(250) DEFAULT NULL,
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `browser_id` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sent_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_sent` bigint NOT NULL COMMENT 'total number of emails sent',
  `users_sent` bigint NOT NULL COMMENT 'total number of distinct users that received this campaign/source/medium',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  `campaign_label` varchar(100) DEFAULT NULL,
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sent_daily_new` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `emails_sent` bigint NOT NULL COMMENT 'total number of emails sent',
  KEY `event_type` (`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sent_daily_new_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `emails_sent` bigint NOT NULL COMMENT 'total number of emails sent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sent_monthly_source` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_sent` bigint NOT NULL COMMENT 'total number of emails sent',
  `users_sent` bigint NOT NULL COMMENT 'total number of distinct users that received this campaign/source/medium',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sent_weekly` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm source',
  `utm_medium` varchar(100) NOT NULL COMMENT 'utm medium',
  `emails_sent` bigint NOT NULL COMMENT 'total number of emails sent',
  `users_sent` bigint NOT NULL COMMENT 'total number of distinct users that received this campaign/source/medium',
  `emails_delivered` bigint DEFAULT NULL COMMENT 'total number of successful deliveries from this campaign/source/medium',
  KEY `event_type` (`utm_campaign`,`utm_source`,`utm_medium`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_sub_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm campaign',
  `sub_count` bigint DEFAULT NULL COMMENT 'total number of subs from this campaign/source/medium',
  `location` varchar(100) NOT NULL COMMENT 'utm campaign',
  `referrer` varchar(100) NOT NULL COMMENT 'utm campaign',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_source`,`data_run_date`),
  KEY `event_info` (`utm_source`,`referrer`,`location`,`data_run_date`),
  KEY `event_type_idx` (`campaign_label`,`data_run_date`),
  KEY `event_info_idx` (`campaign_label`,`referrer`,`location`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_subscriptions_by_landing_page_utm_params` (
  `epoch` bigint NOT NULL,
  `campaign_label` varchar(250) NOT NULL DEFAULT '',
  `landing_page` varchar(250) NOT NULL DEFAULT '',
  `landing_page_utm_campaign` varchar(250) NOT NULL DEFAULT '',
  `landing_page_utm_source` varchar(250) NOT NULL DEFAULT '',
  `landing_page_utm_medium` varchar(250) NOT NULL DEFAULT '',
  `count` bigint unsigned NOT NULL,
  KEY `epoch_campaign_label_landing_page_index` (`epoch`,`campaign_label`,`landing_page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_unsub_daily` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm campaign',
  `unsub_count` bigint DEFAULT NULL COMMENT 'total number of unsubs from this campaign/source/medium',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `email_unsub_daily_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `utm_campaign` varchar(100) NOT NULL COMMENT 'utm campaign',
  `utm_source` varchar(100) NOT NULL COMMENT 'utm campaign',
  `unsub_count` bigint DEFAULT NULL COMMENT 'total number of unsubs from this campaign/source/medium',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `campaign_label` varchar(100) NOT NULL COMMENT 'campaign label',
  KEY `event_type` (`utm_campaign`,`utm_source`,`data_run_date`),
  KEY `event_type_idx` (`utm_campaign`,`campaign_label`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `embed_clicks` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `epoch_day` bigint unsigned NOT NULL,
  `eid` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `path` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `is_mobile` int NOT NULL,
  `region` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `n_embed_clicks` bigint unsigned NOT NULL,
  `n_embed_page_clicks` bigint unsigned NOT NULL,
  `n_embed_click_visitors` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `embed_views` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `epoch_day` bigint unsigned NOT NULL,
  `eid` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `is_mobile` int NOT NULL,
  `region` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `n_embed_impressions` bigint unsigned NOT NULL,
  `n_embed_page_impressions` bigint unsigned NOT NULL,
  `n_embed_visitors` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `erroneous_events` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the erroneous event',
  `event_count` bigint NOT NULL COMMENT 'number of events seen per day',
  KEY `event_type` (`event_type`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `erroneous_events_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the erroneous event',
  `event_count` bigint NOT NULL COMMENT 'number of events seen per day',
  KEY `event_type` (`event_type`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_attributes` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the event',
  `event_attribute` varchar(100) NOT NULL COMMENT 'name of the event attribute',
  `attribute_count` bigint NOT NULL COMMENT 'number of these event/attribute pairs for each day',
  KEY `event_type` (`data_run_date`,`event_type`,`event_attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_descriptions` (
  `event_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_type` varchar(255) NOT NULL,
  `event_description` varchar(255) NOT NULL DEFAULT '',
  `is_noise` tinyint(1) NOT NULL DEFAULT '0',
  `create_date` int NOT NULL DEFAULT '0',
  `update_date` int NOT NULL DEFAULT '0',
  `in_ab_analyzer` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_index_by_source` (
  `epoch` bigint NOT NULL COMMENT 'epoch time',
  `event_type` varchar(100) NOT NULL DEFAULT '' COMMENT 'event type',
  `event_source` varchar(100) NOT NULL DEFAULT '' COMMENT 'event source',
  `count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of events',
  `common_url` varchar(200) NOT NULL DEFAULT '' COMMENT 'longest common prefix of normalized .loc',
  KEY `epoch` (`epoch`),
  KEY `event_type` (`event_type`),
  KEY `event_source` (`event_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_metrics` (
  `epoch_s` bigint unsigned NOT NULL COMMENT 'epoch of log date',
  `event_source` varchar(100) NOT NULL COMMENT 'top level source of event (web, ios, android, api, etc)',
  `event_type` varchar(100) NOT NULL,
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'visits containing this event',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'browsers who saw this event',
  `converting_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `converting_browsers` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `favorites_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one favorite',
  KEY `source_type_epoch` (`event_source`,`event_type`,`epoch_s`),
  KEY `epoch_source_type` (`epoch_s`,`event_source`,`event_type`),
  KEY `type_epoch_source` (`event_type`,`epoch_s`,`event_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_reconciliation` (
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT 'event type or description',
  `date` varchar(100) NOT NULL DEFAULT '' COMMENT 'time of rollup in seconds',
  `frontend_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of frontend events',
  `backend_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of backend events',
  `db_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of db events',
  PRIMARY KEY (`title`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `event_trigrams` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `first_event` varchar(100) NOT NULL COMMENT 'first event in the trigram - also includes entrances',
  `second_event` varchar(100) NOT NULL COMMENT 'second event in the trigram',
  `third_event` varchar(100) NOT NULL COMMENT 'third event in the trigram - also includes exits',
  `trigram_count` bigint NOT NULL COMMENT 'total number this trigram was seen',
  `trigram_visit_count` bigint NOT NULL COMMENT 'total number of visits that saw this trigram at least once',
  `trigram_browser_count` bigint NOT NULL COMMENT 'total number of browsers that saw this trigram at least once',
  KEY `trigram` (`first_event`,`second_event`,`third_event`,`epoch_s`),
  KEY `date_trigram` (`epoch_s`,`first_event`,`second_event`,`third_event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `experiment_metrics` (
  `metric_id` int NOT NULL,
  `launch_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `event_id` int NOT NULL,
  `granularity` tinyint NOT NULL,
  `direction` tinyint NOT NULL DEFAULT '0',
  `change` decimal(5,2) NOT NULL,
  `created_epoch` bigint NOT NULL,
  `updated_epoch` bigint NOT NULL,
  PRIMARY KEY (`metric_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `experiment_pages_set` (
  `launch_id` int NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `created_epoch` bigint NOT NULL,
  PRIMARY KEY (`launch_id`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `experiment_variants` (
  `launch_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `ab_variant` varchar(255) NOT NULL,
  `percentage` decimal(5,2) NOT NULL,
  `created_epoch` bigint NOT NULL,
  `update_id` int NOT NULL DEFAULT '0',
  `is_control` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `experiments` (
  `launch_id` bigint NOT NULL DEFAULT '0',
  `launch_type` varchar(50) DEFAULT NULL,
  `launch_url` varchar(512) NOT NULL,
  `launch_description` varchar(200) NOT NULL,
  `launch_date` bigint NOT NULL,
  `end_date` bigint DEFAULT NULL,
  `launch_percentage` decimal(5,2) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `config_flag` varchar(100) NOT NULL DEFAULT '',
  `notes` text,
  `recap` text,
  `is_prototype` tinyint(1) NOT NULL DEFAULT '0',
  `team` varchar(50) DEFAULT NULL,
  `impact` varchar(6) NOT NULL,
  `reaction` varchar(10) NOT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  `created_epoch` bigint NOT NULL,
  `updated_epoch` bigint NOT NULL,
  `hypothesis` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`launch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `favorited_listings` (
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  KEY `listing_id` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `favorited_listings_bucketed` (
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  `bucket` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `feature_funnel` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `event_type` varchar(100) NOT NULL,
  `listing_ids` varchar(100) NOT NULL,
  `ab_test` varchar(100) NOT NULL DEFAULT '',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `group_name` varchar(100) NOT NULL DEFAULT '' COMMENT 'data is sliced by this group',
  `subgroup` varchar(100) NOT NULL DEFAULT '' COMMENT 'data partition - used in conjuction with group_name',
  `event_count` bigint unsigned DEFAULT NULL COMMENT 'total number of events',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `impressions` bigint unsigned DEFAULT NULL COMMENT 'total number of impressions',
  `impressions_visit` bigint unsigned DEFAULT NULL,
  `clicked` bigint unsigned DEFAULT NULL COMMENT 'total number of clicks',
  `clicked_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that clicked',
  `buy_item` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased from this feature',
  `buy_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one item',
  `fav_item` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `fav_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `view_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items viewed - not including the original item',
  `view_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that viewed at least one other shop item',
  `buy_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items purchased - not including the original item',
  `buy_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one other shop item',
  `buy_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for items directly purchased',
  `buy_oth_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for other shop items purchased - not including the original item',
  `ab_variant` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`data_run_date`,`event_type`,`listing_ids`,`ab_test`,`ab_variant`,`group_name`,`subgroup`),
  KEY `event_name` (`event_type`,`listing_ids`,`data_run_date`),
  KEY `group_index` (`event_type`,`listing_ids`,`epoch_s`,`group_name`,`subgroup`),
  KEY `epoch_s_plus` (`epoch_s`,`event_type`,`listing_ids`,`ab_test`,`group_name`,`subgroup`),
  KEY `datafeed_over_time` (`event_type`,`group_name`,`ab_test`,`epoch_s`) COMMENT 'Speeds up datafeeds queries like daily search CTR'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `feature_funnel_archive` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `event_type` varchar(100) NOT NULL,
  `listing_ids` varchar(100) NOT NULL,
  `ab_test` varchar(100) NOT NULL DEFAULT '',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `group_name` varchar(100) NOT NULL DEFAULT '' COMMENT 'data is sliced by this group',
  `subgroup` varchar(100) NOT NULL DEFAULT '' COMMENT 'data partition - used in conjuction with group_name',
  `event_count` bigint unsigned DEFAULT NULL COMMENT 'total number of events',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `impressions` bigint unsigned DEFAULT NULL COMMENT 'total number of impressions',
  `impressions_visit` bigint unsigned DEFAULT NULL,
  `clicked` bigint unsigned DEFAULT NULL COMMENT 'total number of clicks',
  `clicked_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that clicked',
  `buy_item` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased from this feature',
  `buy_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one item',
  `fav_item` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `fav_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `view_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items viewed - not including the original item',
  `view_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that viewed at least one other shop item',
  `buy_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items purchased - not including the original item',
  `buy_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one other shop item',
  `buy_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for items directly purchased',
  `buy_oth_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for other shop items purchased - not including the original item',
  `ab_variant` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`data_run_date`,`event_type`,`listing_ids`,`ab_test`,`ab_variant`,`group_name`,`subgroup`),
  KEY `event_name` (`event_type`,`listing_ids`,`data_run_date`),
  KEY `group_index` (`event_type`,`listing_ids`,`epoch_s`,`group_name`,`subgroup`),
  KEY `epoch_s_plus` (`epoch_s`,`event_type`,`listing_ids`,`ab_test`,`group_name`,`subgroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `feature_funnel_filters` (
  `event_type` varchar(100) NOT NULL,
  `listing_ids` varchar(100) NOT NULL,
  `ab_test` varchar(100) NOT NULL DEFAULT '',
  `epoch` varchar(100) NOT NULL DEFAULT '',
  `group_name` varchar(100) NOT NULL DEFAULT '' COMMENT 'data is sliced by this group',
  `subgroup` varchar(100) NOT NULL DEFAULT '' COMMENT 'data partition - used in conjuction with group_name',
  `event_count` bigint unsigned DEFAULT NULL COMMENT 'total number of events',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `impressions` bigint unsigned DEFAULT NULL COMMENT 'total number of impressions',
  `impressions_visit` bigint unsigned DEFAULT NULL,
  `clicked` bigint unsigned DEFAULT NULL COMMENT 'total number of clicks',
  `clicked_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that clicked',
  `buy_item` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased from this feature',
  `buy_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one item',
  `fav_item` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `fav_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of favorites',
  `view_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items viewed - not including the original item',
  `view_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that viewed at least one other shop item',
  `buy_oth_item` bigint unsigned DEFAULT NULL COMMENT 'total number of other shop items purchased - not including the original item',
  `buy_oth_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one other shop item',
  `buy_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for items directly purchased',
  `buy_oth_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for other shop items purchased - not including the original item',
  `ab_variant` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`event_type`,`listing_ids`,`ab_test`,`ab_variant`,`group_name`,`subgroup`,`epoch`),
  KEY `group_index` (`event_type`,`listing_ids`,`epoch`,`group_name`,`subgroup`),
  KEY `epoch_s_plus` (`epoch`,`event_type`,`listing_ids`,`ab_test`,`group_name`,`subgroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `feature_funnel_listings` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `event_type` varchar(100) NOT NULL,
  `listing_id` varchar(100) NOT NULL,
  `ab_test` varchar(100) NOT NULL DEFAULT '',
  `ab_variant` varchar(100) NOT NULL DEFAULT '',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `group_name` varchar(100) NOT NULL DEFAULT '' COMMENT 'data is sliced by this group',
  `subgroup` varchar(100) NOT NULL DEFAULT '' COMMENT 'data partition - used in conjuction with group_name',
  `event_count` bigint unsigned DEFAULT NULL COMMENT 'total number of events',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `added_to_cart` bigint unsigned DEFAULT NULL COMMENT 'total number of items added to cart',
  `added_to_cart_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that added to cart',
  `buy_item` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased from this feature',
  `buy_item_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits that purchased at least one item',
  `buy_item_gms` bigint unsigned DEFAULT NULL COMMENT 'total gms for items directly purchased',
  `buy_item_gms_ss` bigint unsigned DEFAULT NULL COMMENT 'total sum of squares gms for items directly purchased',
  PRIMARY KEY (`data_run_date`,`event_type`,`listing_id`,`ab_test`,`ab_variant`,`group_name`,`subgroup`),
  KEY `event_name` (`event_type`,`listing_id`,`data_run_date`),
  KEY `group_index` (`event_type`,`listing_id`,`epoch_s`,`group_name`,`subgroup`),
  KEY `idx_epoch_s` (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fsimage_hdfs_space_and_file_count_by_user` (
  `epoch` bigint NOT NULL DEFAULT '0',
  `user_name` varchar(48) NOT NULL DEFAULT '',
  `hdfs_tb_used` double DEFAULT NULL,
  `file_count` bigint DEFAULT NULL,
  PRIMARY KEY (`epoch`,`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `fsimage_past_ttl_space_and_file_count_by_user` (
  `epoch` bigint NOT NULL DEFAULT '0',
  `user_name` varchar(48) NOT NULL DEFAULT '',
  `hdfs_tb_used` double DEFAULT NULL,
  `file_count` bigint DEFAULT NULL,
  PRIMARY KEY (`epoch`,`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_cake` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `funnel_name` varchar(100) NOT NULL COMMENT 'name of the funnel',
  `step_name` varchar(100) NOT NULL COMMENT 'name of the step',
  `step_number` int NOT NULL COMMENT 'position of the step in the funnel',
  `step_count` bigint NOT NULL COMMENT 'number of times the step is attained',
  `visit_count` bigint NOT NULL COMMENT 'number of visits that have attained the step',
  `browser_count` bigint NOT NULL COMMENT 'number of browsers that have attained the step',
  `ab_test` varchar(64) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(64) NOT NULL COMMENT 'A/B variant name',
  `event_type` varchar(100) DEFAULT NULL COMMENT 'name of the event',
  `funnel_id` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`funnel_id`),
  UNIQUE KEY `data_run_date` (`data_run_date`,`funnel_name`,`step_number`,`ab_test`,`ab_variant`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_cake_steps` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `step_id` int unsigned NOT NULL AUTO_INCREMENT,
  `funnel_name` varchar(100) NOT NULL COMMENT 'name of the funnel',
  `step_name` varchar(100) NOT NULL COMMENT 'name of the step',
  `step_number` int NOT NULL COMMENT 'position of the step in the funnel',
  `event_type` varchar(100) DEFAULT NULL COMMENT 'name of the event',
  PRIMARY KEY (`step_id`),
  UNIQUE KEY `step_name` (`data_run_date`,`funnel_name`,`step_name`,`step_number`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_index` (
  `funnel_id` int unsigned NOT NULL AUTO_INCREMENT,
  `funnel_name` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`funnel_id`),
  UNIQUE KEY `funnel_name` (`funnel_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_rollups` (
  `data_run_date` varchar(120) DEFAULT NULL,
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `update_date` bigint DEFAULT '0' COMMENT 'most recent date on which this row was (over)written',
  `funnel_id` varchar(32) NOT NULL COMMENT 'position in funnels hash in big data job; starts at 1',
  `step_number` int NOT NULL COMMENT 'position of step in funnel',
  `ab_test` varchar(100) NOT NULL DEFAULT '' COMMENT 'name of ab_test',
  `ab_variant` varchar(100) NOT NULL DEFAULT '' COMMENT 'name of ab_test variant',
  `funnel_name` varchar(100) NOT NULL COMMENT 'funnel name from big data job',
  `step_name` varchar(100) NOT NULL COMMENT 'step name as specified in big data job',
  `browser_count` bigint NOT NULL COMMENT 'visitors on step',
  `visit_count` bigint NOT NULL COMMENT 'visits on step',
  `event_type` varchar(100) NOT NULL COMMENT 'php_event_name attribute of event',
  `category` varchar(100) DEFAULT NULL COMMENT 'category as specified in big data job',
  `title` varchar(100) DEFAULT NULL COMMENT 'category as specified in big data job',
  `rollup_resolution` int unsigned NOT NULL COMMENT 'day or hour in seconds',
  `active` tinyint DEFAULT '1',
  PRIMARY KEY (`funnel_id`,`step_number`,`epoch_s`,`ab_test`,`ab_variant`,`rollup_resolution`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_rollups_dev` (
  `data_run_date` varchar(120) DEFAULT NULL,
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `update_date` bigint DEFAULT '0' COMMENT 'most recent date on which this row was (over)written',
  `funnel_id` varchar(32) NOT NULL COMMENT 'position in funnels hash in big data job; starts at 1',
  `step_number` int NOT NULL COMMENT 'position of step in funnel',
  `ab_test` varchar(100) NOT NULL DEFAULT '' COMMENT 'name of ab_test',
  `ab_variant` varchar(100) NOT NULL DEFAULT '' COMMENT 'name of ab_test variant',
  `funnel_name` varchar(100) NOT NULL COMMENT 'funnel name from big data job',
  `step_name` varchar(100) NOT NULL COMMENT 'step name as specified in big data job',
  `browser_count` bigint NOT NULL COMMENT 'visitors on step',
  `visit_count` bigint NOT NULL COMMENT 'visits on step',
  `event_type` varchar(100) NOT NULL COMMENT 'php_event_name attribute of event',
  `category` varchar(100) DEFAULT NULL COMMENT 'category as specified in big data job',
  `title` varchar(100) DEFAULT NULL COMMENT 'category as specified in big data job',
  `rollup_resolution` int unsigned NOT NULL COMMENT 'day or hour in seconds',
  `active` tinyint DEFAULT '1',
  PRIMARY KEY (`funnel_id`,`step_number`,`epoch_s`,`ab_test`,`ab_variant`,`rollup_resolution`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_stats_rollups` (
  `funnel_id` int NOT NULL,
  `step_id` int unsigned NOT NULL,
  `rollup_resolution` int unsigned NOT NULL,
  `rollup_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `ab_name` varchar(128) NOT NULL,
  `step_count` int unsigned NOT NULL,
  PRIMARY KEY (`funnel_id`,`step_id`,`rollup_resolution`,`rollup_date`,`ab_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `funnel_step_index` (
  `step_id` int unsigned NOT NULL AUTO_INCREMENT,
  `step_name` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`step_id`),
  UNIQUE KEY `step_name` (`step_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `furniture_month_clusters` (
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(26) DEFAULT NULL,
  `month` varchar(14) DEFAULT NULL,
  `lat` varchar(26) DEFAULT NULL,
  `lon` varchar(26) DEFAULT NULL,
  `transactions` int DEFAULT NULL,
  `shipping_cost` int DEFAULT NULL,
  `total_price` int DEFAULT NULL,
  `no_shipping` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `furniture_total_clusters` (
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(26) DEFAULT NULL,
  `months` bigint NOT NULL DEFAULT '0',
  `transactions` decimal(32,0) DEFAULT NULL,
  `transactions_avg` decimal(14,4) DEFAULT NULL,
  `transactions_std` double(26,4) DEFAULT NULL,
  `transactions_percentage_std` double(25,8) DEFAULT NULL,
  `average_shipping_cost` decimal(36,4) DEFAULT NULL,
  `no_shipping` decimal(32,0) DEFAULT NULL,
  `average_price` decimal(36,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `furniture_totals_ny` (
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `lat` varchar(26) DEFAULT NULL,
  `lon` varchar(26) DEFAULT NULL,
  `transactions` int DEFAULT NULL,
  `total_shipping_cost` int DEFAULT NULL,
  `total_price` int DEFAULT NULL,
  `total_without_shipping` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gci_dc_onboarding_funnel` (
  `data_run_date` varchar(10) NOT NULL COMMENT 'key for loading',
  `gci_onboarding_tou_visits` bigint unsigned DEFAULT NULL COMMENT 'visits to Terms of Use page; step 1 of funnel',
  `gci_onboarding_address_visits` bigint unsigned DEFAULT NULL COMMENT 'visits to Address entry page; step 2 of funnel',
  `gci_onboarding_bank_visits` bigint unsigned DEFAULT NULL COMMENT 'visits to Bank Account entry page; step 3 of funnel',
  `seller_onboarding_shop_preview_visits` bigint unsigned DEFAULT NULL COMMENT 'visit to Shop preview; proxy for Bank Account completion; step 4 of funnel',
  `shop_opened_visits` bigint unsigned DEFAULT NULL COMMENT 'Shop opened; step 5 of funnel',
  `tou_to_address_rate` decimal(5,2) NOT NULL COMMENT 'the percentage of visits from tou that proceed to address page',
  `address_to_bank_rate` decimal(5,2) NOT NULL COMMENT 'the percentage of visits from address that proceed to bank account page',
  `bank_to_preview_rate` decimal(5,2) NOT NULL COMMENT 'the percentage of visits from bank account to preview state',
  `tou_to_shop_opened_rate` decimal(5,2) NOT NULL COMMENT 'the percentage of visits from tou that continue to open shop',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `a` int DEFAULT NULL,
  `b` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `gio_referrers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `ref` varchar(1000) DEFAULT NULL,
  `cnt` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `hdfs_receipt` (
  `hdfs_receipt_id` bigint NOT NULL AUTO_INCREMENT,
  `hdfs_receipt_run_id` int NOT NULL,
  `path` varchar(1024) NOT NULL COMMENT 'Path on HDFS',
  `last_modified` bigint DEFAULT NULL COMMENT 'Last Modified on HDFS',
  `last_accessed` bigint DEFAULT NULL COMMENT 'Last Accessed on HDFS',
  `owner` varchar(40) DEFAULT NULL COMMENT 'Owner on HDFS',
  `size` bigint DEFAULT NULL COMMENT 'Size on HDFS in Bytes',
  `source` enum('TTL','RedisTTL','Backup') NOT NULL COMMENT 'What is Generating the Receipt',
  `action` enum('Copy','Move','Remove') NOT NULL COMMENT 'What Action is Happening',
  `action_user` varchar(40) NOT NULL COMMENT 'User Running the Process Generating the Receipt',
  `action_timestamp` bigint NOT NULL COMMENT 'Time of Action',
  PRIMARY KEY (`hdfs_receipt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `hdfs_receipt_run` (
  `hdfs_receipt_run_id` int NOT NULL AUTO_INCREMENT,
  `started_at` bigint NOT NULL COMMENT 'Date / Time HDFS File Movent Job Was Started',
  `ended_at` bigint DEFAULT NULL COMMENT 'Date / Time HDFS File Movement Job Ended (if any)',
  PRIMARY KEY (`hdfs_receipt_run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `hierarchical_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `parent_tag` varchar(100) NOT NULL,
  `child_tag` varchar(100) NOT NULL,
  `parent_prob` float DEFAULT NULL,
  `child_prob` float DEFAULT NULL,
  `parent_count` bigint DEFAULT NULL,
  `child_count` bigint DEFAULT NULL,
  `intersection_size` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `index_events` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the event',
  `event_count` bigint NOT NULL COMMENT 'number of events seen per day',
  `primary_count` bigint NOT NULL COMMENT 'number of these events that were a primary event per day',
  `mobile_count` bigint NOT NULL COMMENT 'number of these events that were on a mobile device (includes ios)',
  `ios_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of these events that were on ios',
  `email_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of these events that were email events',
  KEY `event_type` (`event_type`,`data_run_date`),
  KEY `epoch_s_idx` (`epoch_s`),
  KEY `epoch_event_idx` (`event_type`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `index_events_test` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the event',
  `event_count` bigint NOT NULL COMMENT 'number of events seen per day',
  `primary_count` bigint NOT NULL COMMENT 'number of these events that were a primary event per day',
  `mobile_count` bigint NOT NULL COMMENT 'number of these events that were on a mobile device (includes ios)',
  `ios_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of these events that were on ios',
  `email_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of these events that were email events',
  KEY `event_type` (`event_type`,`data_run_date`),
  KEY `epoch_s_idx` (`epoch_s`),
  KEY `epoch_event_idx` (`event_type`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `international_event_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `exits_from` bigint unsigned NOT NULL COMMENT 'Total exits from this event',
  `landings` bigint DEFAULT NULL COMMENT 'Total number of visits that started on this event',
  `bounces` bigint DEFAULT NULL COMMENT 'Total number of bounces (see a single page with no action and then leave) with this event',
  `load_time` bigint unsigned DEFAULT NULL COMMENT 'php load time',
  `load_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares for php load time',
  `country` varchar(255) NOT NULL COMMENT 'country name (from ip)',
  `locale` varchar(255) NOT NULL COMMENT 'locale (from logs)',
  `language` varchar(255) NOT NULL DEFAULT '' COMMENT 'language extracted from first event in the visit',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`country`,`locale`,`language`,`event_type`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `international_orders_shipping` (
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'date of the orders',
  `ship_to_country_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'country_id the order was shipped to',
  `geo_ip_country_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'country_id the order was purchased from',
  `user_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of users for this date and country ids',
  `order_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of orders for this date and country ids',
  PRIMARY KEY (`epoch_s`,`ship_to_country_id`,`geo_ip_country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `international_visit_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `visit_count` bigint unsigned NOT NULL COMMENT 'total visits from country',
  `browser_count` bigint unsigned NOT NULL COMMENT 'total unique browsers from country',
  `bounce_count` bigint unsigned NOT NULL COMMENT 'Total number of bounces (see a single page with no action and then leave) with this language',
  `purchases` bigint unsigned DEFAULT NULL COMMENT 'total number of listings purchased per this country/language',
  `purchases_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of listings purchased per this country/language',
  `total_price` double DEFAULT NULL COMMENT 'total gms in usd of listings purchased per this country/language',
  `total_price_ss` double DEFAULT NULL COMMENT 'sum of square total gms in usd of listings purchased per this country/language',
  `page_count` bigint unsigned DEFAULT NULL COMMENT 'total number of pages seen per this country/language',
  `page_count_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of pages seen per this country/language',
  `visit_time` bigint unsigned DEFAULT NULL COMMENT 'total number of visit time (in seconds) seen per this country/language',
  `visit_time_ss` bigint unsigned DEFAULT NULL COMMENT 'sum of squares of visit time (in seconds) seen per this country/language',
  `country` varchar(255) NOT NULL COMMENT 'country name (from ip)',
  `locale` varchar(255) NOT NULL COMMENT 'locale (from logs)',
  `language` varchar(255) NOT NULL DEFAULT '' COMMENT 'language specified in first event in the visit',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`country`,`locale`,`language`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ios_gms` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `total` float unsigned NOT NULL COMMENT 'total gms in dollars',
  `orders` bigint unsigned DEFAULT NULL COMMENT 'Number of Orders',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'number of items purchased',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ios_metrics` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `conversions_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `authenticated_visits` bigint NOT NULL COMMENT 'visits where the user was signed in',
  `authenticated_browsers` bigint NOT NULL COMMENT 'browsers that were authenticated at least once',
  `authenticated_active_visits` bigint NOT NULL COMMENT 'visits that did not bounce and the user was signed in',
  `authenticated_active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one visit that did not bounce and the user was signed in',
  `active_visits` bigint NOT NULL COMMENT 'visits that did not bounce - saw 2 pages or 1 page and an enagement action',
  `active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one non-bouncing visit',
  `new_browsers` bigint DEFAULT NULL,
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_attempt_counters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `task_id` varchar(32) DEFAULT NULL,
  `task_attempt_id` varchar(32) DEFAULT NULL,
  `counter_id` int NOT NULL COMMENT 'counter id links up with job_history_counter_details for family, type, and name information',
  `counter_value` bigint DEFAULT NULL,
  `job_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_attempts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `job_id` varchar(32) DEFAULT NULL,
  `task_id` varchar(32) DEFAULT NULL,
  `flow_id` varchar(32) DEFAULT NULL,
  `task_type` varchar(16) DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  `task_attempt_id` varchar(50) DEFAULT NULL,
  `start_time` bigint DEFAULT NULL,
  `finish_time` bigint DEFAULT NULL,
  `shuffle_finished` bigint DEFAULT NULL,
  `sort_finished` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cascade_id_index` (`cascade_id`),
  KEY `job_id_index` (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_counter_details` (
  `counter_id` mediumint NOT NULL AUTO_INCREMENT,
  `counter_type` varchar(64) DEFAULT NULL COMMENT 'where on the logline this counter came from',
  `counter_family` varchar(128) DEFAULT NULL,
  `counter_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`counter_id`),
  UNIQUE KEY `counter_type` (`counter_type`,`counter_family`,`counter_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_job_counters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `job_name` varchar(64) DEFAULT NULL,
  `counter_type` varchar(64) DEFAULT NULL COMMENT 'where on the logline this counter came from',
  `counter_family` varchar(128) DEFAULT NULL,
  `counter_name` varchar(128) DEFAULT NULL,
  `counter_value` bigint DEFAULT NULL,
  `job_id` varchar(32) DEFAULT NULL,
  `counter_id` int NOT NULL COMMENT 'counter id links up with job_history_counter_details for family, type, and name information',
  PRIMARY KEY (`id`),
  KEY `counter_idx` (`cascade_id`,`counter_type`,`counter_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_step_details` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `job_id` varchar(32) DEFAULT NULL,
  `flow_id` varchar(32) DEFAULT NULL,
  `job_priority` varchar(24) DEFAULT NULL,
  `start_time` bigint DEFAULT NULL,
  `stop_time` bigint DEFAULT NULL,
  `total_maps` int unsigned DEFAULT NULL,
  `total_reduces` int unsigned DEFAULT NULL,
  `job_status` varchar(24) DEFAULT NULL,
  `finished_maps` int unsigned DEFAULT NULL,
  `finished_reduces` int unsigned DEFAULT NULL,
  `failed_maps` int unsigned DEFAULT NULL,
  `failed_reduces` int unsigned DEFAULT NULL,
  `killed_maps` int DEFAULT NULL,
  `killed_reduces` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cascade_id_idx` (`cascade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `job_id` varchar(32) DEFAULT NULL,
  `task_id` varchar(32) DEFAULT NULL,
  `flow_id` varchar(32) DEFAULT NULL,
  `task_type` varchar(16) DEFAULT NULL,
  `status` varchar(16) DEFAULT NULL,
  `task_attempt_id` varchar(50) DEFAULT NULL,
  `start_time` bigint DEFAULT NULL,
  `finish_time` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `job_id_index` (`job_id`),
  KEY `cascade_id_index` (`cascade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_history_tracker` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `cascade_id` varchar(32) DEFAULT NULL,
  `job_name` varchar(64) DEFAULT NULL,
  `flow_name` varchar(64) DEFAULT NULL,
  `user` varchar(32) DEFAULT NULL,
  `working_directory` varchar(128) DEFAULT NULL,
  `job_priority` varchar(24) DEFAULT NULL,
  `start_time` bigint DEFAULT NULL,
  `stop_time` bigint DEFAULT NULL,
  `step_count` int unsigned DEFAULT NULL,
  `job_type` varchar(24) DEFAULT NULL,
  `job_status` varchar(24) DEFAULT NULL,
  `workflow_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `start_time_idx` (`start_time`),
  KEY `cascade_id_idx` (`cascade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `job_tracker` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `job_name` varchar(100) NOT NULL COMMENT 'name of the job run',
  `start_time` bigint unsigned NOT NULL COMMENT 'start time of the job',
  `stop_time` bigint unsigned NOT NULL COMMENT 'stop time of the job',
  `user` varchar(32) DEFAULT NULL COMMENT 'user running the cascading job',
  `cascading_flow_id` varchar(128) DEFAULT NULL COMMENT 'cascading_flow_id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `landing_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `first_event_type` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `landings_idx` (`first_event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `landing_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `first_event_type` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `listing_anchor_text` (
  `listing_id` bigint unsigned NOT NULL,
  `url` varchar(64) NOT NULL,
  `anchor_text` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`listing_id`,`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `market_research` (
  `query` text NOT NULL,
  `value` int NOT NULL DEFAULT '0',
  `listings` int NOT NULL DEFAULT '0',
  `sales` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `metrics_by_platform` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `browser` varchar(100) NOT NULL DEFAULT '',
  `version` varchar(30) NOT NULL DEFAULT '' COMMENT 'browser version',
  `major_ver` varchar(20) NOT NULL DEFAULT '',
  `platform` varchar(100) NOT NULL DEFAULT '' COMMENT 'device name or desktop operating system',
  `is_mobile_device` tinyint(1) DEFAULT NULL COMMENT 'is this a mobile device',
  `is_tablet` tinyint(1) DEFAULT NULL COMMENT 'is this a tablet',
  `is_etsy_app` tinyint(1) DEFAULT NULL COMMENT 'is this an Etsy app',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of unique visitors',
  `conversions_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `authenticated_visits` bigint NOT NULL COMMENT 'visits where the user was signed in',
  `authenticated_browsers` bigint NOT NULL COMMENT 'browsers that were authenticated at least once',
  `authenticated_active_visits` bigint NOT NULL COMMENT 'visits that did not bounce and the user was signed in',
  `authenticated_active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one visit that did not bounce and the user was signed in',
  `active_visits` bigint NOT NULL COMMENT 'visits that did not bounce - saw 2 pages or 1 page and an engagement action',
  `active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one non-bouncing visit',
  `new_browsers` bigint DEFAULT NULL,
  `total_gms` bigint DEFAULT NULL,
  `total_conversions` bigint DEFAULT NULL,
  `conversions_visits_new` bigint DEFAULT NULL COMMENT 'total new visits that converted',
  `total_gms_new` bigint DEFAULT NULL COMMENT 'total GMS generated from first visits',
  `new_visit_orders` bigint DEFAULT NULL COMMENT 'total number of purchases in first visit',
  `items_purchased` bigint DEFAULT NULL,
  `items_purchased_new` bigint DEFAULT NULL,
  PRIMARY KEY (`data_run_date`,`browser`,`version`,`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mobile_gms` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `total` float unsigned NOT NULL COMMENT 'total gms in dollars',
  `orders` bigint unsigned DEFAULT NULL COMMENT 'number of orders',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'number of items purchased',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `mobile_metrics` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `conversions_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `authenticated_visits` bigint NOT NULL COMMENT 'visits where the user was signed in',
  `authenticated_browsers` bigint NOT NULL COMMENT 'browsers that were authenticated at least once',
  `authenticated_active_visits` bigint NOT NULL COMMENT 'visits that did not bounce and the user was signed in',
  `authenticated_active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one visit that did not bounce and the user was signed in',
  `active_visits` bigint NOT NULL COMMENT 'visits that did not bounce - saw 2 pages or 1 page and an enagement action',
  `active_browsers` bigint NOT NULL COMMENT 'browsers that had at least one non-bouncing visit',
  `new_browsers` bigint DEFAULT NULL,
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `nagios_search_alerts` (
  `alert_time` bigint NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`alert_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_favorite_shops_model_ratings` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user',
  `model_name` varchar(255) NOT NULL DEFAULT 'default' COMMENT 'name of the model',
  `rating` decimal(2,0) NOT NULL COMMENT 'rating',
  `session_date` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`model_name`,`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `recommendations` text NOT NULL COMMENT 'json array of listing_ids to recommend',
  `model` text NOT NULL COMMENT 'model used to perform the ranking',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_hackernews` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_personalized` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_personalizedDepth2` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_reddit` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_scaledFavoriteCount` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_shopAndListingScore` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_trendingInCategory` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `new_items_from_favorite_shops_trendingInCategoryDepth2` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `listing_id` bigint unsigned NOT NULL COMMENT 'id of the listing being ranked',
  `weight` float NOT NULL COMMENT 'weight between to_id and from_id',
  PRIMARY KEY (`user_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `oscar_waste_entries` (
  `entry_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `office` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `waste_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight_in_lbs` float NOT NULL,
  `entry_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_aggregate_metrics` (
  `data_run_date` varchar(100) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `day` date NOT NULL DEFAULT '1000-01-01',
  `num_visits` bigint DEFAULT NULL,
  `new_visit` bigint DEFAULT NULL,
  `has_logged_in` bigint DEFAULT NULL,
  `n_user_create` bigint DEFAULT NULL,
  `visit_length` bigint DEFAULT NULL,
  `n_activity_feed_landing` bigint DEFAULT NULL,
  `purchases` bigint DEFAULT NULL,
  `items_purchased` bigint DEFAULT NULL,
  `total_gms` bigint DEFAULT NULL,
  PRIMARY KEY (`event_type`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_index_views` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `pages_slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `epoch_day` bigint unsigned NOT NULL,
  `n_impressions` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_list_views` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `pages_slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `page_collection_slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `epoch_day` bigint unsigned NOT NULL,
  `n_impressions` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_metrics` (
  `data_run_date` varchar(100) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `pages_slug` varchar(255) NOT NULL,
  `day` date NOT NULL DEFAULT '1000-01-01',
  `num_visits` bigint DEFAULT NULL,
  `new_visit` bigint DEFAULT NULL,
  `has_logged_in` bigint DEFAULT NULL,
  `n_user_create` bigint DEFAULT NULL,
  `visit_length` bigint DEFAULT NULL,
  `n_activity_feed_landing` bigint DEFAULT NULL,
  `purchases` bigint DEFAULT NULL,
  `items_purchased` bigint DEFAULT NULL,
  `total_gms` bigint DEFAULT NULL,
  PRIMARY KEY (`pages_slug`,`event_type`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_mobile_traffic` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `pages_slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `epoch_day` bigint unsigned NOT NULL,
  `is_mobile_device` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `n_mobile` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_visitors_by_curator` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `pages_slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `epoch_day` bigint unsigned NOT NULL,
  `n_impressions` bigint unsigned NOT NULL,
  `n_unique_visitors` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_visitors_by_locale` (
  `data_run_date` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `pages_slug` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `epoch_day` bigint unsigned NOT NULL,
  `detected_region` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `n_locale_count` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pages_with_default_primary_event` (
  `epoch` bigint NOT NULL,
  `htaccess_rule` varchar(200) NOT NULL COMMENT 'rule in htaccess file that matches the event url',
  `count` bigint unsigned DEFAULT NULL COMMENT 'number of events matching the rule',
  PRIMARY KEY (`epoch`,`htaccess_rule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `paypal_checkout_funnel_by_region` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `region` varchar(2) DEFAULT NULL COMMENT 'two-letter country code from IP address',
  `view_cart` bigint DEFAULT NULL COMMENT 'visits that triggered view_cart events accepting paypal; step 1 of funnel',
  `cart_review` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_review events; step 2 of funnel',
  `cart_payment` bigint unsigned DEFAULT NULL COMMENT 'visits that triggered cart_payment events; step 3 of funnel',
  KEY `data_run_date` (`region`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `personalization_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `avg_click_depth` double NOT NULL COMMENT 'the average position of clicked results',
  `avg_first_click_depth` double NOT NULL COMMENT 'the average position of the first link clicked across all searches',
  `clickthrough_rate` double NOT NULL COMMENT 'the percentage of queries that result in clicks',
  `mean_ov` double NOT NULL COMMENT 'the mean value of orders directly attributable to search',
  `median_ov` double NOT NULL COMMENT 'the median value of orders directly attributable to search',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `pinterest_crawled` (
  `pinterest_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `pinboard` varchar(255) NOT NULL,
  `pinboard_md5` varchar(32) NOT NULL,
  `pin_title` varchar(255) NOT NULL,
  `pin_description` varchar(255) NOT NULL DEFAULT '',
  `repins` int unsigned NOT NULL DEFAULT '0',
  `likes` int unsigned NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`pinterest_id`,`listing_id`,`pinboard_md5`),
  KEY `by_pinboard_md5` (`pinboard_md5`),
  KEY `by_update_date` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `popular_items_gms` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  KEY `event_type` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `popular_items_tracking` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `from_popular` bigint unsigned NOT NULL COMMENT 'based on ref tag',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  KEY `event_type` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `previous_events` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `current_event_type` varchar(100) NOT NULL,
  `previous_event_type` varchar(100) DEFAULT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `is_entrance` tinyint NOT NULL,
  `sequence_daily_volume` bigint DEFAULT NULL,
  `event_daily_volume` bigint DEFAULT NULL,
  `sequence_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_event_type_idx` (`epoch`,`current_event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `primary_events_by_region` (
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `event_type` varchar(100) NOT NULL DEFAULT '' COMMENT 'event type',
  `event_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'number of events',
  `country_code` varchar(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`data_run_date`,`event_type`,`country_code`),
  KEY `event_region` (`event_type`,`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_device_configuration` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'iPhone - iPad - iPod',
  `family` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'ios - android',
  `sdk` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `simulated` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `configuration` (`name`,`family`,`sdk`,`simulated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `qa_device_testrun` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `qa_device_configuration_id` bigint NOT NULL,
  `build_id` int NOT NULL COMMENT 'Jenkins build ID for the test run',
  `build_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `artifacts_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `tstamp` int unsigned NOT NULL,
  `app` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `builder` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `success` tinyint(1) NOT NULL DEFAULT '1',
  `features_blob` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Serialized JSON data of the features ran',
  PRIMARY KEY (`id`),
  UNIQUE KEY `qa_device_configuration_id_2` (`qa_device_configuration_id`,`build_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `query_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `query` varchar(1000) DEFAULT NULL,
  `purchased_volume` bigint DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `query_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `query` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `ref_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `ref_tag` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referred_browser_transactions` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of computation in seconds',
  `browser_id` varchar(100) NOT NULL COMMENT 'browser id, taken from utma cookie',
  `first_visit_ms` bigint unsigned NOT NULL COMMENT 'time of first visit in milliseconds',
  `conversion_ms` bigint unsigned NOT NULL COMMENT 'time of the transaction in milliseconds',
  `utm_source` varchar(100) DEFAULT NULL COMMENT 'utm source of first event in visit',
  `utm_medium` varchar(100) DEFAULT NULL COMMENT 'utm medium of first event in visit',
  `utm_campaign` varchar(100) DEFAULT NULL COMMENT 'utm campaign of first event in visit',
  `num_listings_sold` bigint unsigned DEFAULT NULL COMMENT 'the number of listings sold in the transaction',
  `gms` bigint unsigned DEFAULT NULL COMMENT 'total value of the transactions (in cents)',
  KEY `utm` (`browser_id`,`utm_source`,`utm_medium`,`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `purchased_volume` bigint DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_detected_region_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  `detected_region` varchar(100) DEFAULT NULL,
  `new_user_gms` bigint DEFAULT NULL,
  `new_user_purchase_volume` bigint DEFAULT NULL,
  `new_user_registrations` bigint DEFAULT NULL,
  `new_user_purchase_event_volume` bigint DEFAULT NULL,
  `browser_count` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `region_idx` (`region`),
  KEY `detected_region_idx` (`detected_region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_gms` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_landing_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `first_event_type` varchar(1000) DEFAULT NULL,
  `purchased_volume` bigint DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_landing_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `first_event_type` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_landing_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `first_event_type` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `ref_idx` (`referrer_type`(255)),
  KEY `landing_idx` (`first_event_type`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `refs_idx` (`referrer_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_new_visitor_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_query_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `query` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_region_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `referrer_type` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `region_idx` (`region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referrer_volume` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint DEFAULT NULL,
  `referrer_type` varchar(1000) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_campaigns` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_source` varchar(100) DEFAULT NULL COMMENT 'utm source of first event in visit',
  `utm_medium` varchar(100) DEFAULT NULL COMMENT 'utm medium of first event in visit',
  `utm_campaign` varchar(100) DEFAULT NULL COMMENT 'utm campaign of first event in visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint unsigned DEFAULT NULL,
  `registry_created_visit` bigint unsigned DEFAULT NULL,
  KEY `utm` (`utm_source`,`utm_medium`,`utm_campaign`,`data_run_date`),
  KEY `utm_campaign_idx` (`utm_campaign`),
  KEY `idx_epoch_s_utm` (`epoch_s`,`utm_campaign`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_campaigns_etl` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_source` varchar(100) DEFAULT NULL COMMENT 'utm source of first event in visit',
  `utm_medium` varchar(100) DEFAULT NULL COMMENT 'utm medium of first event in visit',
  `utm_campaign` varchar(100) DEFAULT NULL COMMENT 'utm campaign of first event in visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint unsigned DEFAULT NULL,
  `registry_created_visit` bigint unsigned DEFAULT NULL,
  KEY `utm` (`utm_source`,`utm_medium`,`utm_campaign`,`data_run_date`),
  KEY `utm_campaign_idx` (`utm_campaign`),
  KEY `idx_epoch_s_utm` (`epoch_s`,`utm_campaign`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_campaigns_new` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `utm_source` varchar(100) DEFAULT NULL COMMENT 'utm source of first event in visit',
  `utm_medium` varchar(100) DEFAULT NULL COMMENT 'utm medium of first event in visit',
  `utm_campaign` varchar(100) DEFAULT NULL COMMENT 'utm campaign of first event in visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint unsigned DEFAULT NULL,
  `registry_created_visit` bigint unsigned DEFAULT NULL,
  KEY `utm` (`utm_source`,`utm_medium`,`utm_campaign`,`data_run_date`),
  KEY `utm_campaign_idx` (`utm_campaign`),
  KEY `idx_epoch_s_utm` (`epoch_s`,`utm_campaign`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_keywords` (
  `data_run_date` varchar(100) NOT NULL DEFAULT '' COMMENT 'key for loading',
  `search_engine` varchar(255) NOT NULL DEFAULT '' COMMENT 'the search engine that referred the user',
  `query` varchar(256) NOT NULL DEFAULT '' COMMENT 'search query that referred a user to Etsy',
  `hit_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of HTTP hits',
  `user_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of distinct users',
  `browser_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of distinct browsers',
  `visit_count` bigint NOT NULL DEFAULT '0' COMMENT 'number of distinct visits',
  `new_visitors` bigint NOT NULL DEFAULT '0' COMMENT 'number of new visitors',
  `conversions_visit` bigint NOT NULL DEFAULT '0' COMMENT 'it is 0 if user does not purchase anything during a visit, 1 otherwise',
  `new_registrations` bigint NOT NULL DEFAULT '0' COMMENT 'number of new registrations',
  `email_signup` bigint NOT NULL DEFAULT '0' COMMENT 'number of email signups',
  `newsletter_signup` bigint NOT NULL DEFAULT '0' COMMENT 'number of newsletter signups',
  `total_gms` float NOT NULL DEFAULT '0' COMMENT 'total gms',
  `epoch_s` bigint DEFAULT NULL,
  KEY `epoch_s_et_al_idx` (`epoch_s`,`search_engine`,`query`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_visits` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `domain` varchar(100) DEFAULT NULL COMMENT 'domain of the referring visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint DEFAULT NULL,
  KEY `utm` (`domain`,`data_run_date`),
  KEY `idx_epoch_s_domain` (`epoch_s`,`domain`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_visits_by_region` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `region` varchar(2) DEFAULT NULL COMMENT 'two-letter country code from IP address',
  `domain` varchar(100) DEFAULT NULL COMMENT 'domain of the referring visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint DEFAULT NULL,
  KEY `utm` (`domain`,`region`,`data_run_date`),
  KEY `idx_epoch_region_domain` (`epoch_s`,`region`,`domain`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `referring_visits_new` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `domain` varchar(100) DEFAULT NULL COMMENT 'domain of the referring visit',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `conversions_visit` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `conversions_visit_new` bigint unsigned DEFAULT NULL COMMENT 'visits with > 0 conversions from first time users',
  `items_purchased` bigint unsigned DEFAULT NULL COMMENT 'total number of items purchased',
  `total_gms` bigint unsigned DEFAULT NULL COMMENT 'total number of gms (in cents)',
  `total_gms_new` bigint unsigned DEFAULT NULL COMMENT 'total gms from new visitors (in cents)',
  `new_registrations` bigint unsigned DEFAULT NULL COMMENT 'total number of new registrations',
  `pages_seen` bigint unsigned DEFAULT NULL COMMENT 'Total number of pages seen',
  `bounced` bigint unsigned DEFAULT NULL COMMENT 'Total number of bounced visits',
  `total_visit_time` bigint unsigned DEFAULT NULL COMMENT 'Total visit time on site',
  `new_visitors` bigint unsigned DEFAULT NULL COMMENT 'Total number of new visits that were made by a completely new visitor',
  `registered_seller_visit` bigint unsigned DEFAULT NULL,
  `shop_opened_visit` bigint DEFAULT NULL,
  KEY `utm` (`domain`,`data_run_date`),
  KEY `idx_epoch_s_domain` (`epoch_s`,`domain`),
  KEY `idx_data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `region_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `volume` bigint DEFAULT NULL,
  `gms` bigint DEFAULT NULL,
  `avg_visit_length` bigint DEFAULT NULL,
  `new_visitor_volume` bigint DEFAULT NULL,
  `purchase_volume` bigint DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `bounce_rate` float DEFAULT NULL,
  `avg_page_count` bigint DEFAULT NULL,
  `purchase_event_volume` bigint DEFAULT NULL,
  `aov` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_idx` (`epoch`),
  KEY `region_idx` (`region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `registered_seller_visits` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `browser_id` varchar(100) DEFAULT NULL COMMENT 'browser_id for visit',
  `user_id` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'user_id for visit',
  `utm_source` varchar(100) DEFAULT NULL COMMENT 'utm source of first event in visit',
  `utm_medium` varchar(100) DEFAULT NULL COMMENT 'utm medium of first event in visit',
  `utm_campaign` varchar(100) DEFAULT NULL COMMENT 'utm campaign of first event in visit',
  KEY `browser` (`browser_id`),
  KEY `user` (`user_id`),
  KEY `utm` (`utm_source`,`utm_medium`,`utm_campaign`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_convos_received` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_convos_replied` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_convos_time_perc50` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_convos_time_perc80` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_convos_time_perc90` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_delta_perc50` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_delta_perc80` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_delta_perc90` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_observed_perc50` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_observed_perc80` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_processing_time_observed_perc90` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_transactions_with_shipped_date_rate` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `report_card_histogram_transactions_with_tracking_rate` (
  `bin` float NOT NULL,
  `count` bigint NOT NULL,
  PRIMARY KEY (`bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scope_mobile_stats_problems` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `platform` varchar(100) NOT NULL COMMENT 'platform identifier',
  `is_mobile` bigint NOT NULL COMMENT 'whether the events were marked as mobile',
  `event_count` bigint NOT NULL COMMENT 'number of events',
  KEY `platform_data_run_date` (`platform`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout2_batch` (
  `batch_id` bigint unsigned NOT NULL,
  `max_ratings_per_listing` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout2_batch_listing` (
  `batch_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `num_ratings` int unsigned NOT NULL,
  `num_active_sessions` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`batch_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout2_batch_listing_rating` (
  `batch_listing_rating_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `taxonomy_path` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `was_skipped` tinyint(1) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `taxonomy_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_listing_rating_id`),
  UNIQUE KEY `user_id` (`user_id`,`batch_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout2_batch_listing_report_data` (
  `batch_id` bigint unsigned NOT NULL,
  `taxonomy_id` bigint unsigned NOT NULL,
  `taxonomy_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  KEY `batch_id` (`batch_id`,`taxonomy_id`,`data_type`,`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_group_listings` (
  `group_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `average_rating` float NOT NULL,
  `rating_count` float NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_group_rating_histogram` (
  `group_id` bigint unsigned NOT NULL,
  `rating_bin` int unsigned NOT NULL,
  `listing_count` int unsigned NOT NULL,
  `shop_count` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`rating_bin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_group_shops` (
  `group_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `average_rating` float NOT NULL,
  `rating_count` float NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_group_user_stats` (
  `group_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `rating_count` int unsigned NOT NULL,
  `average_rating` float NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `group_id` (`group_id`,`rating_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_groups` (
  `group_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_count` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `shop_count` int unsigned NOT NULL,
  `completed_shop_count` int unsigned NOT NULL,
  `average_rating` float NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_listings_ratings` (
  `scout_listings_rating_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `listing_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `rating` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`scout_listings_rating_id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`,`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_user_completed_groups` (
  `group_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scout_user_listing` (
  `scout_user_listing_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `shop_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `index` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`scout_user_listing_id`),
  KEY `user_id` (`user_id`,`group_id`,`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `scribble_transcriptions` (
  `name` varchar(255) DEFAULT NULL,
  `channel` varchar(255) DEFAULT NULL,
  `timestamp` mediumtext,
  `fragment` int DEFAULT NULL,
  `rank` int DEFAULT NULL,
  `text` varchar(500) DEFAULT NULL,
  `duration` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_ab_analyzer` (
  `epoch` bigint unsigned NOT NULL COMMENT 'Day in epoch seconds',
  `feature_name` varchar(64) NOT NULL COMMENT 'feature name',
  `feature_value` varchar(32) NOT NULL COMMENT 'feature value',
  `ab_test` varchar(128) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(128) NOT NULL COMMENT 'A/B variant name',
  `funnel` varchar(64) NOT NULL COMMENT 'name of funnel',
  `volume` bigint unsigned NOT NULL COMMENT 'Total search query sessions in this (test, variant, day)',
  `value` bigint unsigned NOT NULL COMMENT 'Total sessions with the given funnel in this (test, variant, day)',
  PRIMARY KEY (`feature_name`,`feature_value`,`ab_test`,`ab_variant`,`funnel`,`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_ab_analyzer_tests` (
  `epoch` bigint unsigned NOT NULL COMMENT 'Day in epoch seconds',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  PRIMARY KEY (`epoch`,`ab_test`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_click_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `clicks` bigint unsigned NOT NULL,
  `relative_position_mean` float NOT NULL,
  `relative_position_median` float NOT NULL,
  `relative_position_p95` float NOT NULL,
  `page_mean` float NOT NULL,
  `page_median` float NOT NULL,
  `page_p95` float NOT NULL,
  `absolute_position_mean` float NOT NULL,
  `absolute_position_median` float NOT NULL,
  `absolute_position_p95` float NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_click_position_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `relative_click_position` int unsigned NOT NULL,
  `clicks` bigint unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`relative_click_position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_conversions_by_query` (
  `epoch` bigint unsigned NOT NULL,
  `query` varchar(400) NOT NULL,
  `weekly_event_count` bigint unsigned NOT NULL,
  `weekly_conversion_count` bigint unsigned NOT NULL,
  `weekly_attributable_gms` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_event_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `events` bigint unsigned NOT NULL,
  `events_with_clicks` bigint unsigned NOT NULL,
  `events_with_favs` bigint unsigned NOT NULL,
  `events_with_purchases` bigint unsigned NOT NULL,
  `events_with_empty_results` bigint unsigned NOT NULL,
  `events_with_less_than_forty_results` bigint unsigned NOT NULL,
  `all_items_events` bigint unsigned NOT NULL,
  `handmade_events` bigint unsigned NOT NULL,
  `vintage_events` bigint unsigned NOT NULL,
  `supplies_events` bigint unsigned NOT NULL,
  `events_from_autosuggest` bigint unsigned NOT NULL DEFAULT '0',
  `average_result_count` bigint unsigned NOT NULL DEFAULT '0',
  `average_page` int unsigned NOT NULL DEFAULT '0',
  `events_with_shop_clicks` bigint unsigned DEFAULT '0',
  `events_with_shop_favs` bigint unsigned DEFAULT '0',
  `events_with_shop_purchases` bigint unsigned DEFAULT '0',
  `events_with_same_shop_purchases` bigint unsigned DEFAULT '0',
  `events_with_combined_purchases` bigint unsigned DEFAULT '0',
  `filter_category_events` bigint NOT NULL DEFAULT '0',
  `filter_color_events` bigint NOT NULL DEFAULT '0',
  `filter_customizable_events` bigint NOT NULL DEFAULT '0',
  `filter_favorite_events` bigint NOT NULL DEFAULT '0',
  `filter_gift_card_events` bigint NOT NULL DEFAULT '0',
  `filter_location_events` bigint NOT NULL DEFAULT '0',
  `filter_marketplace_events` bigint NOT NULL DEFAULT '0',
  `filter_price_events` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_impression_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `impressions` bigint unsigned NOT NULL,
  `unique_listings` bigint unsigned NOT NULL,
  `unique_shops` bigint unsigned NOT NULL,
  `impressions_per_shop_mean` float NOT NULL,
  `impressions_per_shop_median` float NOT NULL,
  `impressions_per_shop_p95` float NOT NULL,
  `impressions_per_listing_mean` float NOT NULL,
  `impressions_per_listing_median` float NOT NULL,
  `impressions_per_listing_p95` float NOT NULL,
  `gini` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_metrics_daily` (
  `epoch` float NOT NULL,
  `visits` bigint unsigned NOT NULL,
  `visitors` bigint unsigned NOT NULL,
  `new_visitors` bigint unsigned NOT NULL,
  `purchases` bigint unsigned NOT NULL,
  `search_events` bigint unsigned NOT NULL,
  `unique_queries` bigint unsigned NOT NULL,
  `unique_query_events` bigint unsigned NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_queries` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `query` varchar(400) NOT NULL,
  `total_results` bigint unsigned NOT NULL COMMENT 'max total results for this query for this day',
  `event_count` bigint unsigned NOT NULL COMMENT 'total number of search pages seen for this query',
  `visit_count` bigint unsigned NOT NULL COMMENT 'total number of visits with this query',
  `browser_count` bigint unsigned NOT NULL COMMENT 'total number of browsers with this query',
  `clicked` bigint unsigned NOT NULL COMMENT 'total number of clicks on this query',
  `clicked_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that clicked from this query',
  `clicked_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that clicked from this query',
  `purchased` bigint unsigned NOT NULL COMMENT 'total number of purchases from this query',
  `purchased_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that purchased from this query',
  `purchased_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that purchased from this query',
  KEY `query` (`query`(255),`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_queries_with_marketplace` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `marketplace` varchar(100) NOT NULL COMMENT 'top level marketplace',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `query` varchar(400) NOT NULL COMMENT 'search query',
  `total_results` bigint unsigned NOT NULL COMMENT 'max total results for this query for this day',
  `event_count` bigint unsigned NOT NULL COMMENT 'total number of search pages seen for this query',
  `visit_count` bigint unsigned NOT NULL COMMENT 'total number of visits with this query',
  `browser_count` bigint unsigned NOT NULL COMMENT 'total number of browsers with this query',
  `clicked` bigint unsigned NOT NULL COMMENT 'total number of clicks on this query',
  `clicked_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that clicked from this query',
  `clicked_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that clicked from this query',
  `purchased` bigint unsigned NOT NULL COMMENT 'total number of purchases from this query',
  `purchased_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that purchased from this query',
  `purchased_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that purchased from this query',
  KEY `query` (`marketplace`,`query`(255),`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_queries_with_region` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `query` varchar(400) NOT NULL COMMENT 'cleaned-up search query',
  `region` varchar(2) NOT NULL COMMENT 'two character country code',
  `total_results` bigint unsigned NOT NULL COMMENT 'max total results for this query for this day',
  `event_count` bigint unsigned NOT NULL COMMENT 'total number of search pages seen for this query',
  `visit_count` bigint unsigned NOT NULL COMMENT 'total number of visits with this query',
  `browser_count` bigint unsigned NOT NULL COMMENT 'total number of browsers with this query',
  `clicked` bigint unsigned NOT NULL COMMENT 'total number of clicks on this query',
  `clicked_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that clicked from this query',
  `clicked_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that clicked from this query',
  `purchased` bigint unsigned NOT NULL COMMENT 'total number of purchases from this query',
  `purchased_visit` bigint unsigned NOT NULL COMMENT 'total number of visits that purchased from this query',
  `purchased_browser` bigint unsigned NOT NULL COMMENT 'total number of browsers that purchased from this query',
  KEY `query` (`query`(255),`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_query_conversions` (
  `epoch` bigint unsigned NOT NULL,
  `query` varchar(400) NOT NULL,
  `event_count` bigint unsigned NOT NULL,
  `visit_conversion_count` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_query_session_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `query_sessions` bigint unsigned NOT NULL,
  `sessions_with_refinements` bigint unsigned NOT NULL,
  `sessions_with_clicks` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_favs` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_purchases` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_from_autosuggest` bigint unsigned NOT NULL DEFAULT '0',
  `page_mean` float NOT NULL DEFAULT '0',
  `page_median` float NOT NULL DEFAULT '0',
  `page_p95` float NOT NULL DEFAULT '0',
  `sessions_with_shop_clicks` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_shop_favs` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_shop_purchases` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_same_shop_purchases` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_combined_purchases` bigint unsigned NOT NULL DEFAULT '0',
  `sessions_with_refinement_category` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_color` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_customizable` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_favorites` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_gift_card` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_location` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_marketplace` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_price` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_shipping` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_view_type` bigint NOT NULL DEFAULT '0',
  `sessions_with_refinement_order` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `search_visit_metrics_daily` (
  `epoch` bigint unsigned NOT NULL,
  `visits` bigint unsigned NOT NULL,
  `visits_with_clicks` bigint unsigned NOT NULL,
  `visits_with_favs` bigint unsigned NOT NULL,
  `visits_with_purchases` bigint unsigned NOT NULL,
  `search_events` bigint unsigned NOT NULL,
  `clicks` bigint unsigned NOT NULL,
  `favs` bigint unsigned NOT NULL,
  `purchases` bigint unsigned NOT NULL,
  `visits_with_mobile_templates` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_shop_clicks` bigint unsigned DEFAULT '0',
  `visits_with_shop_favs` bigint unsigned DEFAULT '0',
  `visits_with_shop_purchases` bigint unsigned DEFAULT '0',
  `visits_with_same_shop_purchases` bigint unsigned DEFAULT '0',
  `visits_with_combined_purchases` bigint unsigned DEFAULT '0',
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shop_diversity_info` (
  `data_run_date` varchar(24) NOT NULL,
  `top_shop_impressions` bigint unsigned NOT NULL COMMENT 'search appearances of listings from the 5k most visible shops in search in this a/b pair',
  `total_impressions` bigint unsigned NOT NULL COMMENT 'num impressions of all listings in search in this a/b pair',
  `price` double DEFAULT NULL COMMENT 'total gms in usd of listings in search per this A/B value pair',
  `price_ss` double DEFAULT NULL COMMENT 'sum of square total gms in usd of listings in search per this A/B value pair',
  `percent_impressions_top5k_shops` double DEFAULT NULL COMMENT 'percent of search impressions that are from teh top 5k most visible shops in this a/b pair',
  `listing_id_count` bigint DEFAULT NULL COMMENT 'the number of listing ids seen in search for this a/b pair',
  `shop_id_count` bigint DEFAULT NULL COMMENT 'the number of shops seen in search for this a/b pair',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`ab_test`,`ab_variant`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shopping_styles` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `shopping_type` varchar(30) NOT NULL COMMENT 'shopping style: see https://jira.etsycorp.com/confluence/display/DATA/Shopping+Styles+Definitions for definitions of each style',
  `visitor_type` varchar(30) NOT NULL COMMENT 'visitor type on first page view of visit: new visitor, returning visitor, register buyer or registered seller',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'number of visits',
  `gms` float unsigned NOT NULL COMMENT 'total gms in us dollars',
  `order_count` bigint unsigned DEFAULT NULL COMMENT 'number of orders',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  PRIMARY KEY (`data_run_date`,`shopping_type`,`visitor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shopping_styles_bounces` (
  `data_run_date` varchar(30) NOT NULL COMMENT 'key for loading',
  `visit_type` varchar(30) NOT NULL COMMENT 'event type of primary event of bounce',
  `visitor_type` varchar(30) NOT NULL COMMENT 'visitor type on first page view of visit: new visitor, returning visitor, register buyer or registered seller',
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'number of visits',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  PRIMARY KEY (`data_run_date`,`visit_type`,`visitor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `shrinkray_css` (
  `data_run_date` varchar(24) NOT NULL,
  `sheet` varchar(255) NOT NULL COMMENT 'sheet name',
  `selector` varchar(255) NOT NULL COMMENT 'selector name',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'url',
  `unique_count` bigint unsigned NOT NULL COMMENT 'distinct sheet selector url',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  `found` bigint unsigned NOT NULL COMMENT 'total times this sheet selector url combination appears per day',
  `event_type` varchar(255) NOT NULL COMMENT 'event_type',
  `ignore` bigint DEFAULT '0',
  PRIMARY KEY (`sheet`,`selector`,`event_type`,`data_run_date`),
  KEY `idx_epoch_s` (`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sitterswapsy_notification` (
  `sitterswapsy_notification_id` bigint NOT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  `message` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `email_list` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`sitterswapsy_notification_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sitterswapsy_swap` (
  `sitterswapsy_swap_id` bigint NOT NULL,
  `event_date` bigint NOT NULL,
  `create_date` bigint NOT NULL,
  `update_date` bigint NOT NULL,
  `sitter_auth_username` bigint NOT NULL,
  `swapper_auth_username` bigint NOT NULL,
  `notes` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`sitterswapsy_swap_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `sitterswapsy_swapper` (
  `sitterswapsy_swapper_id` bigint NOT NULL,
  `auth_username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `use_photo` tinyint NOT NULL DEFAULT '1',
  `avatar_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone_one` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `phone_two` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `general_location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `street_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `state` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `update_date` int unsigned NOT NULL DEFAULT '0',
  `pet_info` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes_for_sitter` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`sitterswapsy_swapper_id`),
  KEY `update_date_idx` (`update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `staff_group_pairs` (
  `staff_group_pair_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `group` varchar(64) NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`staff_group_pair_id`),
  KEY `staff_id` (`staff_id`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `subsequent_events` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epoch` bigint NOT NULL,
  `current_event_type` varchar(100) NOT NULL,
  `subsequent_event_type` varchar(100) DEFAULT NULL,
  `is_exit` tinyint NOT NULL,
  `is_back_button` tinyint NOT NULL,
  `sequence_daily_volume` bigint DEFAULT NULL,
  `event_daily_volume` bigint DEFAULT NULL,
  `sequence_rate` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `epoch_event_type_idx` (`epoch`,`current_event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `supplies_top_categories` (
  `data_run_date` varchar(24) NOT NULL,
  `path` varchar(255) NOT NULL COMMENT 'categories flattened',
  `absolute_count` int unsigned NOT NULL DEFAULT '0' COMMENT 'number of transactions with this category',
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tag_recommendations` (
  `tag` varchar(255) NOT NULL,
  `recommendations` text NOT NULL,
  `model_name` varchar(255) NOT NULL,
  PRIMARY KEY (`tag`,`model_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_counts` (
  `epoch` int NOT NULL,
  `segment_id` int NOT NULL,
  `taxonomy_node_id` int unsigned NOT NULL,
  `active_count` int unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`segment_id`,`taxonomy_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_counts_b` (
  `epoch` int NOT NULL,
  `segment_id` int NOT NULL,
  `taxonomy_node_id` int unsigned NOT NULL,
  `active_count` int unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`segment_id`,`taxonomy_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_listing_counts` (
  `epoch` int NOT NULL,
  `segment_id` int NOT NULL,
  `active_count` int unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_listing_counts_b` (
  `epoch` int NOT NULL,
  `segment_id` int NOT NULL,
  `active_count` int unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_seller_counts` (
  `epoch` int NOT NULL,
  `taxonomy_seller_count` int NOT NULL,
  `total_seller_count` int NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `taxonomy_daily_seller_counts_b` (
  `epoch` int NOT NULL,
  `taxonomy_seller_count` int NOT NULL,
  `total_seller_count` int NOT NULL,
  PRIMARY KEY (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team` (
  `name` varchar(100) NOT NULL COMMENT 'name of the team',
  `shortname` varchar(10) NOT NULL COMMENT 'nickname of the team',
  `url` varchar(512) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_rec_stats` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_rec_stats2` (
  `timestamp` int NOT NULL COMMENT 'time when statistic was generated',
  `method` int NOT NULL COMMENT 'id of algorithm for recs (0 = geo recs, 1 = topical recs)',
  `recs` int NOT NULL COMMENT 'total number of recs available',
  `teams` int NOT NULL COMMENT 'total number of teams who have recs',
  `used` int NOT NULL COMMENT 'total number of recs looked at by team leaders',
  `sent` int NOT NULL COMMENT 'total number of recs sent by team leaders',
  `accepted` int NOT NULL COMMENT 'total number of recs which resulted in an accepted invitation',
  PRIMARY KEY (`timestamp`,`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `team_rec_stats3` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` int NOT NULL COMMENT 'time when statistic was generated',
  `method` int NOT NULL COMMENT 'id of algorithm for recs (0 = geo recs, 1 = topical recs)',
  `recs` int NOT NULL COMMENT 'total number of recs available',
  `teams` int NOT NULL COMMENT 'total number of teams who have recs',
  `used` int NOT NULL COMMENT 'total number of recs looked at by team leaders',
  `sent` int NOT NULL COMMENT 'total number of recs sent by team leaders',
  `accepted` int NOT NULL COMMENT 'total number of recs which resulted in an accepted invitation',
  `teams_used` int NOT NULL COMMENT 'total number of teams who have interacted with recs',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test` (
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_attribute` varchar(100) NOT NULL COMMENT 'name of the event attribute',
  `data_run_date` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_ab_click_metrics` (
  `data_run_date` varchar(24) NOT NULL,
  `test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `metric_time` bigint unsigned NOT NULL COMMENT 'Day in epoch ms',
  `event_type` varchar(255) NOT NULL COMMENT 'Event type dimension',
  `ref_tag` varchar(255) NOT NULL COMMENT 'Ref Tag dimension',
  `event_count` bigint unsigned NOT NULL COMMENT 'Total events',
  `visits_with` bigint unsigned NOT NULL COMMENT 'Total visits with this event',
  `browsers_with` bigint unsigned NOT NULL COMMENT 'Total browsers (people) with this event',
  `ab_variant` varchar(255) NOT NULL COMMENT 'A/B variant name',
  `ab_test` varchar(255) NOT NULL COMMENT 'A/B test name',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'Day in epoch s',
  PRIMARY KEY (`ab_test`,`ab_variant`,`event_type`,`ref_tag`,`epoch_s`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_index_events` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL COMMENT 'name of the event',
  `event_count` bigint NOT NULL COMMENT 'number of events seen per day',
  `primary_count` bigint NOT NULL COMMENT 'number of these events that were a primary event per day',
  `mobile_count` bigint NOT NULL COMMENT 'number of these events that were on a mobile device (includes ios)',
  `ios_count` bigint NOT NULL COMMENT 'number of these events that were on ios',
  KEY `event_type` (`event_type`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_row` (
  `test_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `test_visit_length` (
  `data_run_date` varchar(255) NOT NULL DEFAULT '',
  `length` varchar(10) NOT NULL DEFAULT '',
  `counts` varchar(10) DEFAULT NULL,
  KEY `blah` (`length`,`counts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `thread_recommendations` (
  `forum_thread_id` bigint unsigned NOT NULL,
  `recommendations` text NOT NULL,
  `model_name` varchar(255) NOT NULL,
  PRIMARY KEY (`forum_thread_id`,`model_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `three_things` (
  `three_things_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `rank` int unsigned NOT NULL,
  `text` varchar(256) DEFAULT NULL,
  `text_update_date` int unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`three_things_id`),
  KEY `create_date` (`create_date`),
  KEY `update_date` (`update_date`),
  KEY `staff_id` (`staff_id`,`rank`),
  KEY `text_update_date` (`text_update_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_analyzers` (
  `analyzer_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`analyzer_id`),
  UNIQUE KEY `tire_metric_type_group_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_input_requests` (
  `request_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_id` bigint unsigned NOT NULL,
  `visit_id` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `epoch` bigint DEFAULT NULL,
  `data_blob` longtext,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_metric_type_groups` (
  `metric_type_group_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`metric_type_group_id`),
  UNIQUE KEY `tire_metric_type_group_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_metric_types` (
  `metric_type_id` int unsigned NOT NULL AUTO_INCREMENT,
  `analyzer_id` smallint unsigned NOT NULL,
  `metric_type_group_id` smallint unsigned NOT NULL,
  `metric_units_id` tinyint unsigned NOT NULL,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`metric_type_id`),
  UNIQUE KEY `tire_metric_type_name` (`analyzer_id`,`metric_type_group_id`,`metric_units_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_metric_units` (
  `units_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`units_id`),
  UNIQUE KEY `tire_metric_units_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_request_groups` (
  `group_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_statistic_types` (
  `statistic_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `percentile_value` decimal(6,4) DEFAULT NULL,
  PRIMARY KEY (`statistic_type_id`),
  UNIQUE KEY `tire_statistic_types_name_percentile` (`name`,`percentile_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_tag_groups` (
  `tag_group_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`tag_group_id`),
  UNIQUE KEY `tire_name_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_tags` (
  `tag_id` int unsigned NOT NULL AUTO_INCREMENT,
  `tag_group_id` smallint unsigned NOT NULL,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tire_name_name` (`tag_group_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_cluster_setup_params` (
  `test_id` bigint unsigned NOT NULL,
  `namespace` varchar(63) COLLATE utf8mb4_general_ci NOT NULL,
  `param_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `param_value` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tire_cluster_setup_param_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tire_cluster_setup_param_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_cluster_setup_status` (
  `test_id` bigint unsigned NOT NULL,
  `namespace` varchar(63) COLLATE utf8mb4_general_ci NOT NULL,
  `step_status` tinyint NOT NULL,
  `step_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `job_link` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `submitter` varchar(63) COLLATE utf8mb4_general_ci NOT NULL,
  `tire_cluster_setup_status_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`tire_cluster_setup_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_histogram_bins` (
  `test_histogram_bin_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `test_id` int unsigned NOT NULL,
  `variant_one_id` tinyint unsigned NOT NULL,
  `variant_two_id` tinyint unsigned DEFAULT NULL,
  `tag_id` int unsigned NOT NULL,
  `metric_type_id` int unsigned NOT NULL,
  `min_value` double DEFAULT NULL,
  `is_min_inclusive` tinyint NOT NULL DEFAULT '0',
  `max_value` double DEFAULT NULL,
  `is_max_inclusive` tinyint NOT NULL DEFAULT '0',
  `count` bigint NOT NULL,
  `percentage` double NOT NULL,
  PRIMARY KEY (`test_histogram_bin_id`),
  UNIQUE KEY `tire_test_histogram_bin_index` (`test_id`,`tag_id`,`metric_type_id`,`variant_one_id`,`variant_two_id`,`min_value`,`is_min_inclusive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_result_stats` (
  `test_id` bigint unsigned NOT NULL,
  `stats_result_blob` longtext NOT NULL,
  `test_stats_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`test_stats_id`),
  KEY `test_id` (`test_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_results` (
  `test_id` bigint unsigned NOT NULL,
  `request_id` bigint unsigned NOT NULL,
  `result_blob` longtext NOT NULL,
  `test_result_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`test_result_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_statistics` (
  `test_statistic_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `test_id` int unsigned NOT NULL,
  `variant_one_id` tinyint unsigned NOT NULL,
  `variant_two_id` tinyint unsigned DEFAULT NULL,
  `tag_id` int unsigned NOT NULL,
  `metric_type_id` int unsigned NOT NULL,
  `statistic_type_id` tinyint unsigned NOT NULL,
  `stat_value` double DEFAULT NULL,
  PRIMARY KEY (`test_statistic_id`),
  UNIQUE KEY `tire_test_statistic_idx` (`test_id`,`variant_one_id`,`variant_two_id`,`tag_id`,`metric_type_id`,`statistic_type_id`),
  KEY `test_tag_metric` (`test_id`,`tag_id`,`metric_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_variant_comparison_data` (
  `test_id` bigint unsigned NOT NULL,
  `test_variant_comparison_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `variant_data_a` longtext NOT NULL,
  `variant_data_b` longtext NOT NULL,
  `comparison_metrics` longtext,
  `variant_a` text NOT NULL,
  `variant_b` text NOT NULL,
  PRIMARY KEY (`test_variant_comparison_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_test_variants` (
  `test_id` bigint unsigned NOT NULL,
  `variant_id` tinyint unsigned NOT NULL,
  `name` varchar(1000) NOT NULL,
  `host_string` varchar(10000) DEFAULT NULL,
  `cluster_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`test_id`,`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_tests` (
  `test_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(100) DEFAULT NULL,
  `replay_config_class` varchar(255) NOT NULL,
  `file_path` varchar(5000) DEFAULT NULL,
  `rps` int unsigned NOT NULL,
  `duration_seconds` int unsigned NOT NULL,
  `status` tinyint unsigned NOT NULL,
  `warmup_seconds` int unsigned NOT NULL DEFAULT '0',
  `rampup_seconds` int unsigned NOT NULL DEFAULT '0',
  `retries` int unsigned NOT NULL DEFAULT '0',
  `tracing_sample_rate` float unsigned NOT NULL DEFAULT '0',
  `replay_output_path` varchar(1000) DEFAULT NULL,
  `create_date` int unsigned NOT NULL DEFAULT '0',
  `creator_ldap` varchar(500) DEFAULT NULL,
  `extra_params` longtext,
  `extra_params_json` longtext,
  `title` varchar(500) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `run_by_ldap` varchar(20) DEFAULT NULL,
  `run_start_date` int unsigned DEFAULT NULL,
  `run_end_date` int unsigned DEFAULT NULL,
  `request_source_type` tinyint unsigned NOT NULL DEFAULT '0',
  `replay_service_host` varchar(255) DEFAULT NULL,
  `delete_date` int unsigned DEFAULT '0',
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`test_id`),
  KEY `tire_tests_creator_ldap` (`creator_ldap`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `tire_user_settings` (
  `tire_user_setting_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ldap` varchar(20) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` longtext,
  PRIMARY KEY (`tire_user_setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_city_populations` (
  `rank` int DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(26) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_listing_referers_domains` (
  `domain` varchar(256) NOT NULL,
  `count` int NOT NULL,
  KEY `domain` (`domain`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_listing_referers_listings_by_domain` (
  `domain` varchar(256) NOT NULL,
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  KEY `domain` (`domain`(255),`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_listing_referers_top_listings` (
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  KEY `listing_id` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `top_weekly_search_queries` (
  `epoch` bigint unsigned NOT NULL,
  `query` varchar(400) NOT NULL,
  `weekly_event_count` bigint unsigned NOT NULL,
  `weekly_conversion_count` bigint unsigned NOT NULL,
  `weekly_attributable_gms` bigint unsigned NOT NULL,
  `rank` bigint unsigned NOT NULL,
  KEY `rank` (`rank`),
  KEY `epoch` (`epoch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `topic_model_recommendations` (
  `user_id` bigint unsigned NOT NULL COMMENT 'id of the user receiving recommendations',
  `recommendations` text NOT NULL COMMENT 'json array of user_ids to recommend',
  `model_name` varchar(255) NOT NULL DEFAULT 'default' COMMENT 'name of the model',
  `user_type` varchar(1000) DEFAULT NULL,
  `perplexity` double DEFAULT NULL COMMENT 'perplexity of the topic model',
  `use_in_eval` tinyint DEFAULT NULL,
  PRIMARY KEY (`user_id`,`model_name`),
  KEY `model` (`model_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `topic_model_recommendations_ratings` (
  `user_id` bigint unsigned DEFAULT NULL,
  `suggested_user_id` bigint unsigned DEFAULT NULL,
  `model_name` varchar(255) DEFAULT NULL,
  `rating` tinyint DEFAULT NULL,
  `is_dev` tinyint DEFAULT NULL,
  `session_date` int DEFAULT NULL,
  `create_date` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `topic_model_recommendations_ratings_possible` (
  `user_id` bigint unsigned DEFAULT NULL,
  `model_distribution` text,
  `is_dev` tinyint DEFAULT NULL,
  `session_date` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `transaction_photos` (
  `transaction_id` bigint NOT NULL,
  `image_id` bigint NOT NULL,
  `caption` varchar(255) NOT NULL,
  `image_570xN` varchar(255) NOT NULL,
  `image_340x270` varchar(255) NOT NULL,
  `buyer_avatar` varchar(255) NOT NULL,
  `buyer_username` varchar(255) NOT NULL,
  `buyer_name` varchar(255) NOT NULL,
  `buyer_location` varchar(255) NOT NULL,
  `seller_avatar` varchar(255) NOT NULL,
  `seller_shop_name` varchar(255) NOT NULL,
  `seller_location` varchar(255) NOT NULL,
  `original_image_340x270` varchar(255) NOT NULL,
  `date` int DEFAULT NULL,
  PRIMARY KEY (`transaction_id`,`image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `translation_language_stats` (
  `epoch` bigint unsigned NOT NULL,
  `lang` varchar(5) NOT NULL,
  `views` bigint NOT NULL,
  `untranslated_views` bigint NOT NULL,
  `translated_views` bigint NOT NULL,
  `visits` bigint NOT NULL,
  `translated_visits` bigint NOT NULL,
  `untranslated_visits` bigint NOT NULL,
  `untranslated_view_rate` float NOT NULL,
  `untranslated_visit_rate` float NOT NULL,
  PRIMARY KEY (`epoch`,`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `treasuried_listing_refs` (
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  KEY `listing_id` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `treasuried_listings` (
  `listing_id` bigint NOT NULL,
  `count` int NOT NULL,
  KEY `listing_id` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `uk_buyer_conversion_metrics` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `is_uk` tinyint NOT NULL COMMENT 'boolean indicating whether seller is from the uk or not',
  `total_listings_viewed` bigint unsigned DEFAULT NULL COMMENT 'listing views by UK users',
  `total_items_added` bigint unsigned DEFAULT NULL COMMENT 'cart additions by UK users',
  `total_items_purchased` bigint unsigned DEFAULT NULL COMMENT 'purchases by UK users',
  `added_to_cart_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of cart additions to listing views',
  `purchase_from_view_cart_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of purchases to cart additions',
  `overall_conversion` float unsigned DEFAULT NULL COMMENT 'ratio of purchases to listing views',
  KEY `data_run_date` (`is_uk`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `untranslated_languages` (
  `epoch` bigint unsigned NOT NULL,
  `lang` varchar(5) NOT NULL,
  `views` bigint NOT NULL,
  `visits` bigint NOT NULL,
  PRIMARY KEY (`epoch`,`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_attribute_counts_daily` (
  `cohort_date` int unsigned NOT NULL,
  `attribute` varchar(64) NOT NULL,
  `value` varchar(64) NOT NULL,
  `n` bigint unsigned NOT NULL,
  `data_run_date` varchar(64) NOT NULL,
  PRIMARY KEY (`attribute`,`cohort_date`,`value`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_attribute_metrics_weekly` (
  `cohort_date` int unsigned NOT NULL,
  `attribute` varchar(64) NOT NULL,
  `value` varchar(64) NOT NULL,
  `metric` varchar(64) NOT NULL,
  `n` double NOT NULL,
  `data_run_date` varchar(64) NOT NULL,
  PRIMARY KEY (`attribute`,`cohort_date`,`value`,`metric`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `user_transactions_feedback` (
  `scout_user_listing_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `listing_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  PRIMARY KEY (`scout_user_listing_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vertica_hadoop_snapshot_metrics` (
  `table_name` char(80) DEFAULT NULL,
  `run_epoch` int DEFAULT NULL,
  `metrics_json` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_activity_feed_daily_active_users` (
  `data_run_date` varchar(30) NOT NULL,
  `count` bigint unsigned NOT NULL,
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_attributions` (
  `data_run_date` varchar(255) NOT NULL,
  `method` varchar(64) NOT NULL,
  `event_type` varchar(64) NOT NULL,
  `event_impressions` int NOT NULL DEFAULT '0',
  `item_impressions` int NOT NULL DEFAULT '0',
  `payments` int NOT NULL DEFAULT '0',
  `transactions` int NOT NULL DEFAULT '0',
  `gms` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`method`,`event_type`),
  KEY `method_event_type` (`method`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_attributions_old` (
  `data_run_date` varchar(255) NOT NULL,
  `event_type` varchar(64) NOT NULL,
  `event_impressions` int NOT NULL DEFAULT '0',
  `item_impressions` int NOT NULL DEFAULT '0',
  `payments` int NOT NULL DEFAULT '0',
  `transactions` int NOT NULL DEFAULT '0',
  `gms` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`data_run_date`,`event_type`),
  KEY `method_event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_cohort_events` (
  `data_run_date` varchar(255) NOT NULL DEFAULT '',
  `first_cohort_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date` varchar(60) NOT NULL,
  `day` tinyint NOT NULL DEFAULT '0',
  `cohort_type` varchar(128) NOT NULL DEFAULT '',
  `cohort_name` varchar(128) NOT NULL DEFAULT '',
  `key_type` varchar(64) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `cumulative` tinyint NOT NULL DEFAULT '0',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `people_count` int unsigned NOT NULL DEFAULT '0',
  `event_count` int unsigned NOT NULL DEFAULT '0',
  `event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count` int unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `people_with_event_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`first_cohort_date`,`cohort_date`,`day`,`cohort_type`,`cohort_name`,`key_type`,`variant`,`cumulative`,`event_type`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_cohort_events_seller` (
  `data_run_date` varchar(255) NOT NULL DEFAULT '',
  `first_cohort_date` varchar(60) NOT NULL DEFAULT '',
  `cohort_date` varchar(60) NOT NULL,
  `day` tinyint NOT NULL DEFAULT '0',
  `cohort_type` varchar(128) NOT NULL DEFAULT '',
  `cohort_name` varchar(128) NOT NULL DEFAULT '',
  `key_type` varchar(64) NOT NULL DEFAULT '',
  `variant` varchar(64) NOT NULL DEFAULT '',
  `is_seller` tinyint DEFAULT NULL,
  `cumulative` tinyint NOT NULL DEFAULT '0',
  `event_type` varchar(64) NOT NULL DEFAULT '',
  `people_count` int unsigned NOT NULL DEFAULT '0',
  `event_count` int unsigned NOT NULL DEFAULT '0',
  `event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count` int unsigned NOT NULL DEFAULT '0',
  `visits_with_event_count_ss` bigint unsigned NOT NULL DEFAULT '0',
  `people_with_event_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`first_cohort_date`,`cohort_date`,`day`,`cohort_type`,`cohort_name`,`key_type`,`variant`,`cumulative`,`event_type`),
  KEY `data_run_date` (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `viral_daily_active_users` (
  `data_run_date` varchar(30) NOT NULL,
  `count` bigint unsigned NOT NULL,
  PRIMARY KEY (`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `visit_level_metrics` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `event_type` varchar(100) NOT NULL,
  `visit_count` bigint unsigned DEFAULT NULL COMMENT 'total number of visits',
  `browser_count` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers',
  `conversions_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one conversion',
  `favorites_visits` bigint unsigned DEFAULT NULL COMMENT 'total number of visits with at least one favorite',
  `conversions_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one conversion',
  `favorites_browser` bigint unsigned DEFAULT NULL COMMENT 'total number of browsers with at least one favorite',
  KEY `event_name` (`event_type`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `visit_start_attributions` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned DEFAULT NULL,
  `first_event` varchar(100) NOT NULL COMMENT 'event type of the first event in the visit',
  `second_event` varchar(100) NOT NULL COMMENT 'event type of the second event in the visit',
  `user_bucket` varchar(100) NOT NULL COMMENT 'user bucket of the visitor',
  `total_visits` bigint DEFAULT NULL COMMENT 'total number of visits of this type (first_event, second_event, user_bucket)',
  `purchases` bigint DEFAULT NULL COMMENT 'number of visits of this type with at least one purchase',
  `items_purchased` bigint DEFAULT NULL COMMENT 'total number of items purchased in this type of visit',
  `total_gms` bigint DEFAULT NULL COMMENT 'total gms for for this type of visit',
  `new_registrations` bigint DEFAULT NULL COMMENT 'total number of new registrations for this type of visit',
  PRIMARY KEY (`first_event`,`second_event`,`user_bucket`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `visits_by_platform` (
  `epoch_s` int DEFAULT NULL,
  `data_run_date` varchar(24) NOT NULL,
  `percent_visits_apps` int unsigned NOT NULL DEFAULT '0' COMMENT 'percent of visits per user on mobile devices',
  `absolute_count` int unsigned NOT NULL DEFAULT '0' COMMENT 'number of users with this percent',
  `percent_users` float NOT NULL DEFAULT '0' COMMENT 'percent of users with this percent',
  PRIMARY KEY (`percent_visits_apps`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `weekly_actives` (
  `data_run_date` varchar(100) NOT NULL COMMENT 'key for loading',
  `epoch_s` bigint unsigned NOT NULL COMMENT 'time of rollup in seconds',
  `visits_by_person` bigint unsigned DEFAULT NULL COMMENT 'n return visits during 7-day window',
  `num_people` bigint unsigned DEFAULT NULL COMMENT 'number of browsers that came back n times',
  `total_visits` bigint unsigned DEFAULT NULL COMMENT 'total visits during 7-day window',
  `total_browsers` bigint unsigned DEFAULT NULL COMMENT 'total browsers seen during 7-day window',
  KEY `return_visits_by_browser` (`visits_by_person`,`data_run_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `xhprof_raw` (
  `filename` varchar(64) NOT NULL,
  `epoch` bigint NOT NULL,
  `page` varchar(32) NOT NULL,
  `function` varchar(128) NOT NULL,
  `count` int NOT NULL,
  `wall_time` int NOT NULL,
  `memory_usage` int NOT NULL,
  `peak_memory_usage` int NOT NULL,
  `exclusive_wall_time` int NOT NULL,
  `exclusive_memory_usage` int NOT NULL,
  `exclusive_peak_memory_usage` int NOT NULL,
  KEY `request_function` (`filename`,`page`,`function`),
  KEY `page_function` (`page`,`function`),
  KEY `page_date` (`epoch`,`page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `xmas_predict` (
  `xmas_predict_id` bigint NOT NULL AUTO_INCREMENT,
  `modelname` varchar(50) NOT NULL,
  `sellerid` bigint NOT NULL,
  `predicted_on` date NOT NULL,
  `num_sales` int DEFAULT NULL,
  `gms` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`xmas_predict_id`),
  KEY `predicted_on` (`predicted_on`),
  KEY `num_sales` (`num_sales`),
  KEY `gms` (`gms`),
  KEY `modelname` (`modelname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

