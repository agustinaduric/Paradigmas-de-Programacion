class Persona {
  const recuerdos
  var nivelDeFelicidad = 100
  const pensamientosCentrales
  const estadoAnimoActual                                                                   // cambiar a var
  const recuerdosALargoPlazo
  var cantidadDeRecuerdosDiarios = 0                                                        // Agregar var emocionDominante
  method vivirUnEvento(_futuroRecuerdo) {
    cantidadDeRecuerdosDiarios += 1
  }
  
  method recuerdos() = recuerdos
  
  method nivelDeFelicidad() = nivelDeFelicidad
  
  method niegaUnRecuerdo() = recuerdos.any(
    { recuerdo => recuerdo.esNegadoPor(self) }
  )
  
  method pensamientosCentrales(recuerdo) {
    if (recuerdo.noEsPensamientoCentral(recuerdo)) pensamientosCentrales.add(
        recuerdo
      )
  }
  
  method recuerdosRecientes() = recuerdos.take(5)
  
  method reducirCoeficienteFelicidad(porcentaje) {
    nivelDeFelicidad *= porcentaje
    if (self.verificarNivelMinimoFelicidad()) {
      throw new DomainException(message = "El nivel de felicidad es menor a 1")
    }
  }
  
  method verificarNivelMinimoFelicidad() = nivelDeFelicidad < 1
  
  method aumentarNivelDeFelicidad(cantidad) {
    nivelDeFelicidad += cantidad
    if (self.verificarNivelMaximoFelicidad()) {
      throw new DomainException(
        message = "El nivel de felicidad es mayor a 1000"
      )
    }
  }
  
  method verificarNivelMaximoFelicidad() = nivelDeFelicidad > 1000
  
  method pensamientosCentrales() = pensamientosCentrales
  
  method estadoAnimoActual() = estadoAnimoActual
  
  method agregarALargoPlazo(recuerdosNuevos) {
    recuerdosALargoPlazo.add(recuerdosNuevos)
  }
  
  method rememorar() {                                                                      // todo terminar
    
    // const recuerdosAntiguos 
  }
}