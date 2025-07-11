CREATE DATABASE etsy_billing_0_A;
USE etsy_billing_0_A;

CREATE TABLE `bill_charges` (
  `bill_charge_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `charge_amount` int unsigned NOT NULL DEFAULT '0',
  `charge_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `charge_type_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`bill_charge_id`),
  KEY `user_id_create_date` (`user_id`,`create_date`),
  KEY `create_date` (`create_date`),
  KEY `user_id_charge_type_id_charge_type` (`user_id`,`charge_type_id`,`charge_type`(20)),
  KEY `type_and_date_idx` (`charge_type`(64),`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bill_payments` (
  `bill_payment_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `payment_amount` int NOT NULL DEFAULT '0',
  `payment_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_type_id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  PRIMARY KEY (`bill_payment_id`),
  KEY `user_id_create_date` (`user_id`,`create_date`),
  KEY `user_id_charge_type_id` (`user_id`,`payment_type_id`),
  KEY `create_date` (`create_date`),
  KEY `user_id_payment_type` (`user_id`,`payment_type`(60))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `bill_statements` (
  `bill_statement_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `statement_year` smallint unsigned NOT NULL DEFAULT '0',
  `statement_month` tinyint unsigned NOT NULL DEFAULT '0',
  `opening_balance` int NOT NULL DEFAULT '0',
  `closing_balance` int NOT NULL DEFAULT '0',
  `total_fees` int NOT NULL DEFAULT '0',
  `total_payments` int NOT NULL DEFAULT '0',
  `listing_fees` int NOT NULL DEFAULT '0',
  `listing_private_fees` int NOT NULL DEFAULT '0',
  `transaction_fees` int NOT NULL DEFAULT '0',
  `wholesale_transaction_fees` int NOT NULL DEFAULT '0',
  `showcase_fees` int NOT NULL DEFAULT '0',
  `showcase_category_fees` int NOT NULL DEFAULT '0',
  `refunds` int NOT NULL DEFAULT '0',
  `payments` int NOT NULL DEFAULT '0',
  `edit_fees` int NOT NULL DEFAULT '0',
  `renew_fees` int NOT NULL DEFAULT '0',
  `alchemy_fees` int NOT NULL DEFAULT '0',
  `renew_expired_fees` int NOT NULL DEFAULT '0',
  `renew_sold_fees` int NOT NULL DEFAULT '0',
  `renew_sold_auto_fees` int NOT NULL DEFAULT '0',
  `renew_expired_auto_fees` int NOT NULL DEFAULT '0',
  `search_ad_fees` int NOT NULL DEFAULT '0',
  `prolist_fees` int NOT NULL DEFAULT '0',
  `shipping_label_fees` int NOT NULL DEFAULT '0',
  `shipping_label_insurance_fees` int NOT NULL DEFAULT '0',
  `shipping_label_coverage_fees` int NOT NULL DEFAULT '0',
  `shipping_label_taxes_fees` int NOT NULL DEFAULT '0',
  `vat_fees` int NOT NULL DEFAULT '0',
  `vat_seller_services_fees` int unsigned NOT NULL DEFAULT '0',
  `custom_shop_fees` int NOT NULL DEFAULT '0',
  `credits` int NOT NULL DEFAULT '0',
  `create_date` int unsigned NOT NULL,
  `listing_refunds` int unsigned NOT NULL DEFAULT '0',
  `listing_private_refunds` int unsigned NOT NULL DEFAULT '0',
  `transaction_refunds` int unsigned NOT NULL DEFAULT '0',
  `wholesale_transaction_refunds` int unsigned NOT NULL DEFAULT '0',
  `custom_shop_refunds` int unsigned NOT NULL DEFAULT '0',
  `showcase_refunds` int unsigned NOT NULL DEFAULT '0',
  `showcase_category_refunds` int unsigned NOT NULL DEFAULT '0',
  `edit_refunds` int unsigned NOT NULL DEFAULT '0',
  `renew_refunds` int unsigned NOT NULL DEFAULT '0',
  `alchemy_refunds` int unsigned NOT NULL DEFAULT '0',
  `renew_expired_refunds` int unsigned NOT NULL DEFAULT '0',
  `renew_sold_refunds` int unsigned NOT NULL DEFAULT '0',
  `renew_sold_auto_refunds` int unsigned NOT NULL DEFAULT '0',
  `renew_expired_auto_refunds` int unsigned NOT NULL DEFAULT '0',
  `search_ad_refunds` int unsigned NOT NULL DEFAULT '0',
  `prolist_refunds` int unsigned NOT NULL DEFAULT '0',
  `shipping_label_refunds` int unsigned NOT NULL DEFAULT '0',
  `shipping_label_insurance_refunds` int unsigned NOT NULL DEFAULT '0',
  `shipping_label_coverage_refunds` int unsigned NOT NULL DEFAULT '0',
  `shipping_label_taxes_refunds` int unsigned NOT NULL DEFAULT '0',
  `vat_refunds` int unsigned NOT NULL DEFAULT '0',
  `vat_seller_services_refunds` int unsigned NOT NULL DEFAULT '0',
  `googleads_fees` int unsigned NOT NULL DEFAULT '0',
  `googleads_refunds` int unsigned NOT NULL DEFAULT '0',
  `wholesale_setup_fees` int unsigned NOT NULL DEFAULT '0',
  `wholesale_setup_refunds` int unsigned NOT NULL DEFAULT '0',
  `vat_on_processing_fees` int DEFAULT '0',
  `vat_on_processing_refunds` int DEFAULT '0',
  `sales_tax_fees` int unsigned NOT NULL DEFAULT '0',
  `sales_tax_refunds` int unsigned NOT NULL DEFAULT '0',
  `tier_subscription_fees` int NOT NULL DEFAULT '0',
  `tier_subscription_refunds` int NOT NULL DEFAULT '0',
  `promoted_offer_fees` int unsigned NOT NULL DEFAULT '0',
  `promoted_offer_refunds` int unsigned NOT NULL DEFAULT '0',
  `seller_credit_payments` int unsigned NOT NULL DEFAULT '0',
  `advector_fees` int unsigned NOT NULL DEFAULT '0',
  `advector_refunds` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`bill_statement_id`),
  UNIQUE KEY `user_year_month` (`user_id`,`statement_year`,`statement_month`),
  KEY `create_date` (`create_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `cdc_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

CREATE TABLE `vitess_etet` (
  `id` bigint unsigned NOT NULL,
  `create_date` int unsigned NOT NULL,
  `update_date` int unsigned NOT NULL,
  `f_varchar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

