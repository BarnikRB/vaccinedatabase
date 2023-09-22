import psycopg2
from psycopg2 import Error
from sqlalchemy import create_engine, text
import pandas as pd
import numpy as np
from pathlib import Path
import datetime
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
                psql_conn.commit()
            # Assert in case of error
            except:
                print('Error at command:'+sql_command + ".")
                #ret_ =  False
            # Finally, clear command string
            finally:
                sql_command = ''           
                #ret_ = True
    #return ret_



def run_sql_from_file2(sql_file, psql_conn):
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
                result = psql_conn.execute(text(sql_command))
                print(result.fetchall())
                psql_conn.commit()
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
        database="postgres",  # TO BE REPLACED
        user='postgres',    # TO BE REPLACED
        password='abcdefgh', # TO BE REPLACED
        host='localhost', 
        port= '5432'
        )
        database="postgres"  # TO BE REPLACED
        user='postgres' # TO BE REPLACED
        password='abcdefgh' # TO BE REPLACED
        host='localhost' 

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
        # sql_file1  = open(DATADIR + '/code/creatingTables.sql')
        # sql_file2  = open(DATADIR + '/code/deletingTables.sql')
        psql_conn  = engine.connect()

        xls = pd.ExcelFile(DATADIR+'\\data\\vaccine-distribution-data.xlsx')

        sheet_to_df_map = {}
        for sheet_name in xls.sheet_names:
            sheet_to_df_map[sheet_name] = xls.parse(sheet_name)
            sheet_to_df_map[sheet_name].columns = sheet_to_df_map[sheet_name].columns.str.replace(" ","")
            sheet_to_df_map[sheet_name].columns = sheet_to_df_map[sheet_name].columns.str.lower()
        sheet_to_df_map["TransportationLog"] = sheet_to_df_map["Transportation log"]
        del sheet_to_df_map["Transportation log"]
        sheet_to_df_map["StaffMembers"].vaccinationstatus = sheet_to_df_map["StaffMembers"].vaccinationstatus.astype(bool)
        sheet_to_df_map["Symptoms"].criticality = sheet_to_df_map["Symptoms"].criticality.astype(bool)
        
        

        for index, row in enumerate(sheet_to_df_map["Diagnosis"]["date"]):
            try:
                sheet_to_df_map["Diagnosis"]["date"].iloc[index]=pd.to_datetime(row)
                
            except:
                s = '2021/01/01'
                d = datetime.datetime.strptime(s, '%Y/%m/%d') + datetime.timedelta(days=index)
                sheet_to_df_map["Diagnosis"]["date"].iloc[index]=(d.strftime('%Y/%m/%d'))

                
                
        orderList = ["VaccineType","Manufacturer","VaccinationStations","VaccineBatch","TransportationLog","StaffMembers","Shifts","Vaccinations","Patients","VaccinePatients","Symptoms","Diagnosis"]
        
        for name in orderList:
            
            
            sheet_to_df_map[name].to_sql(name.lower(), con=engine, if_exists='append', index=False)

        psql_conn.commit()
        # print("start1")
        # run_sql_from_file (sql_file1, psql_conn)
        # result = psql_conn.execute(text('SELECT * FROM VaccineType '))
        # print(f'After create and insert:\n{result.fetchall()}')
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