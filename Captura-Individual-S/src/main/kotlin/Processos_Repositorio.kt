//import org.springframework.jdbc.core.BeanPropertyRowMapper
//import org.springframework.jdbc.core.JdbcTemplate
//import java.io.IOException
//
//class Processos_Repositorio {
//
//    lateinit var jdbcTemplate: JdbcTemplate
//
//    fun iniciar() {
//        jdbcTemplate = Conexao.jdbcTemplate!!
//    }
//
//    fun buscarProcessosNaoApagados():List<Processos> {
//        var process:List<Processos> = jdbcTemplate.query("""
//            SELECT * FROM Processos_Encerrados WHERE situacao = 0 and fkMaquina = 1
//        """, BeanPropertyRowMapper(Processos::class.java))
//
//        return process
//    }
//
//    fun apagarProcesso(processo: Processos) {
//
//        try {
//            val processoID = processo.PID
//
//            val comandoTaskkill = "taskkill /F /PID $processoID"
//            val processoTaskkill = Runtime.getRuntime().exec(comandoTaskkill)
//            processoTaskkill.waitFor()
//
//        } catch (e: IOException) {
//            // se o comando taskkill não for encontrado
//            e.printStackTrace()
//        } catch (e: InterruptedException) {
//            // exceções de interrupção
//            e.printStackTrace()
//        }
//
//    }
//    fun atualizarListaProcesso(processo: Processos) {
//
//        var atualizacao = jdbcTemplate.queryForObject(
//            "UPDATE Processos_Encerrados SET situacao = 1 WHERE IDProcessos_Encerrados = ${processo.IDProcessos_Encerrados};",
//            BeanPropertyRowMapper(Usuario::class.java)
//        )
//    }
//
//    fun apagarEAtualizarListaProcesso() {
//        val processosParaApagar = buscarProcessosNaoApagados()
//
//        processosParaApagar.forEach {
//            apagarProcesso(it)
//            atualizarListaProcesso(it)
//        }
//    }
//}
