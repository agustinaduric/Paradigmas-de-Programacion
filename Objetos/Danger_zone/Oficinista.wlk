import Objetos.Danger_zone.Espia.*

class Oficinista {
  var estrellas = 0
  
  method saludCritica() = self.calcularSaludCritica()
  
  method calcularSaludCritica() = 40 - (5 * estrellas)
  
  method ganarEstrellas(unaCantidad) {
    estrellas += unaCantidad
  }
  
  method completarMision(mision, empleado) {
    estrellas += 1
    if (estrellas == 3) empleado.puesto(espia)
  }
}