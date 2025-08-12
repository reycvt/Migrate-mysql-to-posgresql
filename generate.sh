TABLES=(
affiliate_content_insight_products
affiliate_content_insights
affiliate_objectives
affiliate_platforms
affiliate_profiles
buzzer_insights
buzzers
campaigns
categories
data_changes
data_temp
data_temp_payment
failed_jobs
gmv_instagram
gmv_tiktok
import_sales_logs
internal_content_products
internal_contents
jobs
kol_briefs
kol_content_insight_products
kol_content_insights
kol_insight_weeks
kol_insights
kol_objective_histories
kol_objective_refunds
kol_objectives
kol_platforms
kol_profiles
listing_objective_histories
listing_objective_schedule_products
listing_objective_schedules
listing_objectives
listing_products
listings
migrations
objective_payments
payments
sales
settings
shipping_invoice_products
shipping_invoices
shipping_trackings
slot_analytics
temp_sales
video_performances
)

for t in "${TABLES[@]}"; do
  cat > "migrate_${t}.load" <<EOF

LOAD DATABASE
     FROM mysql://username:pass_database@host/name_database
     INTO postgresql://username:pass_database@host/name_database

 WITH include drop, create tables, create indexes, reset sequences

 CAST
    type date to date using zero-dates-to-null,
    type datetime to timestamp,
    type date to date,
    type bit to boolean drop typemod,
    type tinyint to boolean drop typemod,
    type boolean to boolean drop typemod,
    type enum to text drop default drop not null,
    type set to text drop default drop not null,
    type decimal to numeric,
    type json to text
 INCLUDING ONLY TABLE NAMES MATCHING '${t}'
;
EOF
done
