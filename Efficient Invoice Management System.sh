

DB_USER="root"
DB_PASSWORD="123"
DB_NAME="date"

mysql -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"


mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" << EOF
CREATE TABLE IF NOT EXISTS inv_master (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    total DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS inv_details (
    item_id INT,
    item_name VARCHAR(255),
    quantity INT,
    invid INT,
    FOREIGN KEY (invid) REFERENCES inv_master(id)
);
EOF

while IFS=':' read -r id date total; do
    mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" << EOF
    INSERT INTO inv_master (id, date, total) VALUES ('$id', '$date', '$total');
EOF
done < inv_master.txt

while IFS=':' read -r item_id item_name quantity invid; do
    mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" << EOF
    INSERT INTO inv_details (item_id, item_name, quantity, invid) VALUES ('$item_id', '$item_name', '$quantity', '$invid');
EOF
done < inv_details.txt

echo "Database setup completed successfully."
