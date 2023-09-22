# Source: https://pynative.com/python-postgresql-tutorial/
import psycopg2
from psycopg2 import Error
from sqlalchemy import create_engine, text
import pandas as pd
import numpy as np
from pathlib import Path

def run_sql_from_file(sql_file, psql_conn):
    '''
	read a SQL file with multiple stmts and process it
	adapted from an idea by JF Santos
	Note: not really needed when using dataframes.
    '''
    sql_command = ''
    for line in sql_file:
        #if line.startswith('VALUES'):        
     # Ignore commented lines
        if not line.startswith('--') and line.strip('\n'):        
        # Append line to the command string, prefix with space
           sql_command += line.strip('\n')
           #sql_command = ' ' + sql_command + line.strip('\n')
        # If the command string ends with ';', it is a full statement
        if sql_command.endswith(';'):
            # Try to execute statement and commit it
            try:
                #print("running " + sql_command+".") 
                psql_conn.execute(text(sql_command))
                #psql_conn.commit()
            # Assert in case of error
            except:
                print('Error at command:'+sql_command + ".")
                #ret_ =  False
            # Finally, clear command string
            finally:
                sql_command = ''           
                #ret_ = True
    #return ret_

def main():
    try:
        # Connect to an test database 
        # NOTE: 
        # 1. NEVER store credential like this in practice. This is only for testing purpose
        # 2. Replace your "database" name, "user" and "password" that we provide to test the connection to your database 
        connection = psycopg2.connect(
        database="grp06db_2023",  # TO BE REPLACED
        user='grp06_2023',    # TO BE REPLACED
        password='8gSxbXiq', # TO BE REPLACED
        host='dbcourse.cs.aalto.fi', 
        port= '5432'
        )
        database="grp06db_2023"  
        user='grp06_2023'   
        password='8gSxbXiq' 
        host='dbcourse.cs.aalto.fi' 
        
        # Create a cursor to perform database operations
        cursor = connection.cursor()
        # Print PostgreSQL details
        print("PostgreSQL server information")
        print(connection.get_dsn_parameters(), "\n")
        # Executing a SQL query
        cursor.execute("SELECT version();")
        # Fetch result
        record = cursor.fetchone()
        print("You are connected to - ", record, "\n")
        DATADIR = str(Path(__file__).parent.parent) # for relative path d:\Databases\project-vaccine-distribution-group-6
        

        
        DIALECT = 'postgresql+psycopg2://'
        
        db_uri = "%s:%s@%s/%s" % (user, password, host, database)

        engine = create_engine(DIALECT + db_uri)
        sql_file1  = open(DATADIR + '/code/creatingTables.sql')
        sql_file2  = open(DATADIR + '/code/deletingTables.sql')
        psql_conn  = engine.connect()
        


        print("deleting")
        run_sql_from_file (sql_file2, psql_conn)
        
        # print("start2")
        # run_sql_from_file (sql_file2, psql_conn)
        # #result = psql_conn.execute(text('SELECT * FROM Diagnosis '))
        # #print(f'After create and insert:\n{result.fetchall()}')
        
    except(Exception, Error) as error:
        print("Error while connecting to PostgreSQL", error)
    
    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")


main()