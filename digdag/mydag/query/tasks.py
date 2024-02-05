import os
import yaml
import datetime
import json
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy import text
import digdag

class MyWorkflow(object):
    def my_task(self, data: object):
        print("MyWorkflow.my_task()")
        path = os.getcwd()
        print("cwd:",path)

        print(f"type: {type(data)}")
        print(f"data: {data}")


def setup( str_session_time: str ):
    print(f"::setup() {str_session_time}")

    f = open("./config.yml")
    data = yaml.load(f, Loader=yaml.SafeLoader)
    print(data)

    digdag.env.store(data)


def func1( str_session_time: str, table: object, data: object ):
    print(f"::func1() {str_session_time}")
    dt_session_time = datetime.datetime.strptime( str_session_time, '%Y-%m-%dT%H:%M:%S%z' )
    print("Parsed datetime:", dt_session_time)
    # parsed_datetime = datetime.datetime.fromisoformat( str_session_time )
    # print("パースされた日付時刻:", parsed_datetime)

    print(f"type: {type(table)}")
    print(f"table: {table}")

    objJSON = json.loads( table )
    print(f"value: {objJSON[0]['username']}, {objJSON[0]['firstname']}")

    print(f"type: {type(data)}")
    print(f"data: {data}")

    # db_url = 'postgresql+psycopg2://postgres:postgres@localhost/postgres'
    # engine = create_engine( db_url )
    # query = "SELECT username, firstname FROM public.user"
    # df = pd.read_sql( query, engine )
    # print( df )

    db_url2 = 'postgresql+psycopg2://postgres:postgres@localhost/maishiro'
    engine2 = create_engine( db_url2 )
    # df = pd.DataFrame( objJSON )
    # print( df )
    # df.to_sql( name='result', con=engine2, if_exists='append' )
    with engine2.connect() as con:
        sql = text("INSERT INTO result (username, firstname) VALUES(:username, :firstname)")
        for row in objJSON:
            con.execute( sql, **row )
