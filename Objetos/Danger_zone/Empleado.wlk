import Oficinista.*
import Espia.*

class Empleado {
  var salud
  const habilidades = []
  var property puesto
  
  method incapacitado() = salud <= self.saludCritica()
  
  method saludCritica() = puesto.saludCritica()
  
  method puedeUsar(habilidad) = (not self.incapacitado()) and self.posee(
    habilidad
  )
  
  method posee(habilidad) = habilidades.contains(habilidad)
  
  method habilidades() = habilidades
  
  method recibirDanio(cantidad) {
    salud -= cantidad
  }
  
  method estaVivo() = salud > 0
  
  method finalizarMision(mision) {
    if (self.estaVivo()) self.completarMision(mision)
  }
  
  method completarMision(mision) {
    puesto.completarMision(mision, self)
  }
  
  method aprenderHabilidad(habilidad) {
    habilidades.add(habilidad)
  }
}