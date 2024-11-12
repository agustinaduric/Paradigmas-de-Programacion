import Persona.*
import ProcesoMental.*

class Riley inherits Persona {
  const procesosMentales = [
    asentamiento,
    asentamientoSelectivo,
    profundizacion,
    controlHormonal,
    restauracionCognitiva,
    liberacion
  ]
  
  override method vivirUnEvento(futuroRecuerdo) {
    super(futuroRecuerdo)
    recuerdos.add(futuroRecuerdo)
  }
  
  method pensamientosCentralesDificilDeExplicar() = pensamientosCentrales.filter(
    { pensamiento => pensamiento.esDificilDeExplicar() }
  )
  
  method irADormir(palabraClave) {
    procesosMentales.forEach(
      { proceso => proceso.aplicarseA(self, palabraClave) }
    )
    cantidadDeRecuerdosDiarios = 0
  }
  
  method borrarUltimosPensamientosCentrales(cantidad) {
    pensamientosCentrales.reverse().drop(cantidad)
  }
  
  method liberarRecuerdosDelDia() = recuerdos.drop(cantidadDeRecuerdosDiarios)
  
  method recuerdosDelDia() = recuerdos.take(cantidadDeRecuerdosDiarios)
  
  method recuerdosNoCentrales() = recuerdos.filter(
    { recuerdo => recuerdo.noEsPensamientoCentral(self) }
  )
  
  method noCentralesNoNegados() = self.recuerdosNoCentrales().filter(
    { recuerdo => recuerdo.esNegadoPor(self) }
  )
  
  method tienePensamientosnoCentralesNoNegados() = not self.noCentralesNoNegados().isEmpty()
  
  method tienePensamientoCentralEnLargoPlazo() = pensamientosCentrales.any(
    { pensamiento => recuerdosALargoPlazo.contains(pensamiento) }
  )
  
  method todosLosRecuerdosCompartenEmocion() = recuerdos.isEmpty() or recuerdos.all(
    { recuerdo => recuerdo.comparteEmocionCon(recuerdos.first()) }
  )
}