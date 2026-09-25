import pandas as pd
from sqlalchemy import create_engine


SERVER = 'ULELAB315'
DRIVER = 'ODBC+Driver+17+for+SQL+Server'

engine_oltp = create_engine(f'mssql+pyodbc://@{SERVER}/DataSalud_Peru?driver={DRIVER}&trusted_connection=yes')
engine_dw = create_engine(f'mssql+pyodbc://@{SERVER}/DataSalud_DW?driver={DRIVER}&trusted_connection=yes')

def ejecutar_etl():
    print("Iniciando proceso ETL con Python...")
    
  
    df_atenciones = pd.read_sql("SELECT * FROM dbo.Atenciones_SIS", con=engine_oltp)
    print(f"Registros extraídos de OLTP: {len(df_atenciones)}")
    
  
    df_atenciones['REGION'] = df_atenciones['REGION'].fillna('NO ESPECIFICADO').str.upper()
    df_atenciones['PROVINCIA'] = df_atenciones['PROVINCIA'].fillna('NO ESPECIFICADO').str.upper()
    df_atenciones['DISTRITO'] = df_atenciones['DISTRITO'].fillna('NO ESPECIFICADO').str.upper()
    
   
    print("Cargando datos transformados en DataSalud_DW...")
    df_atenciones.to_sql('Staging_Atenciones', con=engine_dw, if_exists='replace', index=False)
    print("¡Proceso ETL completado exitosamente!")

if __name__ == '__main__':
    ejecutar_etl()