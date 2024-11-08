import Argumento.*

class Partido {
  const filosofo
  const argumentos
  
  method esBueno() = filosofo.estaEnLoCorrecto() and self.argumentosBuenos()
  
  method argumentosBuenos() = self.cantidadArgumentosEnriquecedores() > (self.cantidadArgumentos() / 2)
  
  method cantidadArgumentos() = argumentos.size()
  
  method cantidadArgumentosEnriquecedores() = argumentos.count(
    { argumento => argumento.esEnriquecedor() }
  )
}