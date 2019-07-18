# run from project home directory
dbicdump -o dump_directory=./lib \
             -o components='["InflateColumn::DateTime"]' \
             -o debug=1 \
             Up::Schema \
             'dbi:SQLite:./db/up.db' 

