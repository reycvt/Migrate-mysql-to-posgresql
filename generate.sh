TABLES=(
input table
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
