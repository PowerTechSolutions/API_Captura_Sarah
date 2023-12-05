
import java.io.File
object CodigoPythonPeri {

    fun execpython(servicos:MutableList<ServicosMonitorados>) {


        val servicoCadastradorepositorio = ServicoCadastradoRepositorio()
        servicoCadastradorepositorio.iniciar()

        var componentePROCESSO = 0

        var codigoPython ="""
import psutil
import time
import platform
import datetime
from mysql.connector import connect

try:
    mydb = connect(host='localhost', user='root', password='1234.s', database='PowerTechSolutions')
    if mydb.is_connected():
        db_info = mydb.get_server_info()
        mycursor = mydb.cursor()

        lista_processos = psutil.process_iter()

        for process in lista_processos:
            process_info = process.as_dict(attrs=['pid', 'name'])
            pid = process_info['pid']
            nome = process_info['name']
            uso_cpu = round(psutil.cpu_percent(interval=1), 2)
            uso_memoria = round(psutil.virtual_memory().percent, 2)
            data = datetime.datetime.now()

            mycursor.execute('''
    INSERT INTO Processos (PID, nomeProcesso, cpu_processo, uso_ram, data_hora, fkMaquina)
    VALUES (%s, %s, %s, %s, %s, %s) 
''', (pid, nome, uso_cpu, uso_memoria, data, 1))


            mydb.commit()
            time.sleep(1)
            print(f"Uso da CPU: {uso_cpu}%")
            print(f"Uso da Memória: {uso_memoria}%\r\n")
            
finally:
    if mydb.is_connected():
        mycursor.close()
        mydb.close()


"""

        val nomeArquivoPyDefault = "CodigoPythonPeriSarah.py";

        File(nomeArquivoPyDefault).writeText(codigoPython);
        Runtime.getRuntime().exec("python3 $nomeArquivoPyDefault");

        println("Iniciando Captura de Processos!");

    }

}