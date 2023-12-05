package app

import CodigoPythonPeri
import MaquinasRepositorio
import Monitoramento_RAWRepositorio
//import Processos_Repositorio
import ServicoCadastradoRepositorio
import ServicoMonitoradoRepositorio
import ServicosMonitorados
import Usuario
import UsuarioRepositorio
import java.time.LocalDateTime
import java.time.LocalTime
import java.util.*

open class Main {
    companion object {
        @JvmStatic fun main(args: Array<String>) {

            var dataAtual = LocalDateTime.now()

            val usuario_repositorio = UsuarioRepositorio()
            val maquina_repositorio = MaquinasRepositorio()
            val servicoMonitoradorepositorio = ServicoMonitoradoRepositorio()
            val servicoCadastradorepositorio = ServicoCadastradoRepositorio()

            servicoCadastradorepositorio.iniciar()
            servicoMonitoradorepositorio.iniciar()
            maquina_repositorio.iniciar()
            usuario_repositorio.iniciar()

            val sn = Scanner(System.`in`)

            println("Bem vindo a PowerTech! Por favor, realize o login para utilizar nosso sistema")

            println("Informe seu Email: ")
            var Email:String = sn.next()

                if (usuario_repositorio.autenticar(Email)){

                var funcionario:Usuario = usuario_repositorio.resgatarinfo(Email)

                var maquinas:String = maquina_repositorio.pegarMaquinas(funcionario.IDUsuario)
                    println("Qual a numeração da maquina em que você deseja iniciar a captura? $maquinas")

                    var maquinaEscolhida = sn.next().toInt()

                var servicos:MutableList<ServicosMonitorados> = servicoMonitoradorepositorio.buscarComponentes(maquinaEscolhida)

                var funcoes:MutableList<String> = mutableListOf()

//                for (servico in servicos){
//
//                    var apelido:String = servicoCadastradorepositorio.buscarComponente(servico.FKComponente_cadastrado)
//
//                    when(apelido){
//                        "PROCESSO" -> funcoes.add("P")
//                        else -> {
//                            funcoes.add("CR")
//                        }
//
//                    }
//
//                }

                Captura(funcoes,servicos,maquinaEscolhida,dataAtual)
//                    processo()

            }

        }

        fun Captura(funcoes:MutableList<String>,servicos: MutableList<ServicosMonitorados>, maquinaEscolhida: Int, dataAtual: LocalDateTime) {

//            var capturaPROCESSO = 0
//
//            for (servico in funcoes) {
//                when (servico) {
//                    "P" -> capturaPROCESSO = 1
//                }
//            }

//            var capturaPROCESSO = 0
//
//            for (servico in funcoes){
//                when(servico){
//                    "P" -> capturaPROCESSO = 1
//                }
//            }
//
//            var repositorio = Monitoramento_RAWRepositorio()
//            repositorio.iniciar()
//
//            println("Captura Iniciada, para para o processo use [ctrl+c]")
//
//                while (true) {
//                    if (capturaPROCESSO == 1) {
//                        CodigoPythonPeri.execpython(servicos)
//                    }
//
//                    Thread.sleep(1000)
//                }

            CodigoPythonPeri.execpython(servicos)

            }
//        fun processo(){
//            var repositorio = Processos_Repositorio()
//            repositorio.iniciar()
//            while(true){
//                repositorio.apagarEAtualizarListaProcesso()
//            }
//        }
        }

}
