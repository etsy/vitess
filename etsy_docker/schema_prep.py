#!/usr/bin/env python3

import json
import sqlite3
from argparse import ArgumentParser
from pathlib import Path


parser = ArgumentParser(description="Prepare mysql_schemas repo .sql files for ingestion into etsy_docker container environment")
parser.add_argument("schema_dir", type=Path, help="Source directory for MySQL schemas (ex: ~/development/mysql_schemas/production/)")
parser.add_argument("--sqlite_filename", default="dbindex.db", help="Name for sqlite Vindex file")
args = parser.parse_args()


def cat_files(out: Path):
    empty_dir = True
    with out.open(mode="wt") as outfile:
        outfile.write(f"CREATE DATABASE {out.stem};\n")
        outfile.write(f"USE {out.stem};\n\n")
        for f in sorted(dataset_dir.iterdir()):
            if f.name.startswith("cucumber"):  # the FKEYs make these tables messy
                print("skipping", f)
                continue
            if f.suffix == ".sql":
                statement = f.read_text().rstrip("\n; ")

                # TODO: why are we doing this and the additional autoincrement INSERTs later on in the process?
                if out.stem.startswith("etsy_tickets"):
                    statement += " AUTO_INCREMENT=10001"

                statement += ";\n\n"

                outfile.write(statement)
                empty_dir = False

    if empty_dir:
        print(f"No .sql files found to cat into {out.name!r} - Removing file...")
        out.unlink(missing_ok=True)


# pre-clean any existing generated files in output dir, excluding "000" bootstrapping files for now...
for f in Path("mysql_schemas").glob("*.*"):
    if not f.name.startswith("0"):
        f.unlink()

for dataset_dir in args.schema_dir.iterdir():
    if dataset_dir.is_dir():
        # sharded datasets get two databases created
        if "shard" in dataset_dir.name:
            for i in range(1, 3):
                outfile_path = "mysql_schemas" / Path(f"{dataset_dir.name}_{i:03d}_0_A.sql")
                cat_files(outfile_path)
        else:
            outfile_path = "mysql_schemas" / Path(f"{dataset_dir.name}_0_A.sql")
            cat_files(outfile_path)


    # copy non-empty vschema.json files with names to match the keyspace
    vschema_file = dataset_dir / "vschema.json"
    if vschema_file.is_file() and vschema_file.stat().st_size:
        # Set the threshold to 0 for any hybrid vindexes for compatibility with empty sqlite tables
        vschema = json.loads(vschema_file.read_text())
        vindexes = vschema.get("vindexes", {})
        for vindex in vindexes:
            if vindexes[vindex].get("type", "") == "etsy_hybrid":
                vindexes[vindex]["params"]["threshold"] = "0"
        ("mysql_schemas" / Path(f"{dataset_dir.stem}_{vschema_file.name}")).write_text(json.dumps(vschema, indent=4))


con = sqlite3.connect(Path("mysql_schemas") / args.sqlite_filename)
cur = con.cursor()
cur.execute("""CREATE TABLE affiliate_campaigns (campaign_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (campaign_id));""")
cur.execute("""CREATE TABLE affiliate_publishers (publisher_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (publisher_id));""")
cur.execute("""CREATE TABLE api_keys_index (api_key_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (api_key_id));""")
cur.execute("""CREATE TABLE application_index (application_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (application_id));""")
cur.execute("""CREATE TABLE arbitrary_key_index (hash_bucket INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (hash_bucket));""")
cur.execute("""CREATE TABLE campaign_index (campaign_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (campaign_id));""")
cur.execute("""CREATE TABLE carts_index (cart_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (cart_id));""")
cur.execute("""CREATE TABLE checkout_audit (checkout_audit_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (checkout_audit_id));""")
cur.execute("""CREATE TABLE combined_users_index (user_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (user_id));""")
cur.execute("""CREATE TABLE contentful_index (content_type_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (content_type_id));""")
cur.execute("""CREATE TABLE craft_market (craft_market_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (craft_market_id));""")
cur.execute("""CREATE TABLE email_addresses (email_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (email_id));""")
cur.execute("""CREATE TABLE et_interaction (interaction_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (interaction_id));""")
cur.execute("""CREATE TABLE facebook_accounts_index (facebook_account_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (facebook_account_id));""")
cur.execute("""CREATE TABLE finds_page (finds_page_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (finds_page_id));""")
cur.execute("""CREATE TABLE forum_posts_by_thread (forum_thread_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (forum_thread_id));""")
cur.execute("""CREATE TABLE forum_tag (forum_tag_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (forum_tag_id));""")
cur.execute("""CREATE TABLE forums_index (forum_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (forum_id));""")
cur.execute("""CREATE TABLE groups_index (group_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (group_id));""")
cur.execute("""CREATE TABLE guest_users_index (guest_user_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (guest_user_id));""")
cur.execute("""CREATE TABLE human_tasks_index (human_task_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (human_task_id));""")
cur.execute("""CREATE TABLE images (owner_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (owner_id));""")
cur.execute("""CREATE TABLE livestream_sessions (livestream_session_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (livestream_session_id));""")
cur.execute("""CREATE TABLE local_market_index (local_market_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (local_market_id));""")
cur.execute("""CREATE TABLE mailing_lists (mailing_list_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (mailing_list_id));""")
cur.execute("""CREATE TABLE merch_collections (merch_collection_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (merch_collection_id));""")
cur.execute("""CREATE TABLE pages_index (page_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (page_id));""")
cur.execute("""CREATE TABLE shops_index (shop_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (shop_id));""")
cur.execute("""CREATE TABLE user_case_index (user_case_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (user_case_id));""")
cur.execute("""CREATE TABLE users_index (user_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (user_id));""")
cur.execute("""CREATE TABLE xylem_asset (asset_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (asset_id));""")
cur.execute("""CREATE TABLE xylem_document (document_id INTEGER NOT NULL, ksid BLOB NOT NULL, PRIMARY KEY (document_id));""")

# # 057_test_etsy_vindex.sh
# cur.execute("""create table if not exists index_tbl_sqlite (shardifier_id integer primary key, shard_num integer);""")
# cur.execute("""insert or ignore into index_tbl_sqlite (shardifier_id, shard_num) values (1, 1), (2, 2), (3, 3);""")
con.commit()

cur.close()
con.close()
