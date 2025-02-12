# Import libraries required for connecting to mysql
import mysql.connector
# Import libraries required for connecting to DB2 or PostgreSql
import psycopg2
# Connect to MySQL
connection = mysql.connector.connect(user='root', password='pass',host='192.168.49.2', port=30007,database='sales')
mysql_cursor = connection.cursor()
# Connect to DB2 or PostgreSql

dsn_hostname = '192.168.49.2'
dsn_user='postgres'        # e.g. "abc12345"
dsn_pwd ='securepass'      # e.g. "7dBZ3wWt9XN6$o0J"
dsn_port ="32542"                # e.g. "50000" 
dsn_database ="Test1"           # i.e. "BLUDB"
# Find out the last rowid from DB2 data warehouse or PostgreSql data warehouse
# The function get_last_rowid must return the last rowid of the table sales_data on the IBM DB2 database or PostgreSql.
conn = psycopg2.connect(
   database=dsn_database, 
   user=dsn_user,
   password=dsn_pwd,
   host=dsn_hostname, 
   port= dsn_port
)
pg_cursor = conn.cursor()

def get_last_rowid():
	SQL="""SELECT rowid FROM sales_data ORDER BY rowid DESC LIMIT 1;"""
	pg_cursor.execute(SQL)
	row = pg_cursor.fetchone()[0]
	return row



last_row_id = get_last_rowid()
print("Last row id on production datawarehouse = ", last_row_id)

# List out all records in MySQL database with rowid greater than the one on the Data warehouse
# The function get_latest_records must return a list of all records that have a rowid greater than the last_row_id in the sales_data table in the sales database on the MySQL staging data warehouse.

def get_latest_records(rowid):
	SQL = f"""SELECT * from sales_data WHERE rowid > {rowid}"""
	mysql_cursor.execute(SQL)
	all_rows= mysql_cursor.fetchall()
	print(f"Total new registers: {all_rows}")
	return all_rows	

new_records = get_latest_records(last_row_id)

print("New rows on staging datawarehouse = ", len(new_records))

# Insert the additional records from MySQL into DB2 or PostgreSql data warehouse.
# The function insert_records must insert all the records passed to it into the sales_data table in IBM DB2 database or PostgreSql.

def insert_records(records):
	if not records:
		print("Nothing to insert, datawarehouse is up to date..")
		return
	
	try:
		insert_query = """
        INSERT INTO sales_data (rowid, product_id, custumer_id, quantity)
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (rowid) DO NOTHING;
        """
		pg_cursor.executemany(insert_query, records)
		conn.commit()
		print(f"Total of {len(records)} commited into the datawarehouse..")
	except Exception as e:
		print(f"Something went wrong {e}")
	

insert_records(new_records)
print("New rows inserted into production datawarehouse = ", len(new_records)) 



# disconnect from mysql warehouse

# disconnect from DB2 or PostgreSql data warehouse 
conn.close()
pg_cursor.close()
connection.close()
mysql_cursor.close()
# End of program