import Objetos.Danger_zone.Empleado.*
import Oficinista.*
import Espia.*

class Jefe inherits Empleado {
  const subordinados = []
  
  override method posee(unaHabilidad) = super(
    unaHabilidad
  ) or self.algunSubordinadoTiene(unaHabilidad)
  
  method algunSubordinadoTiene(unaHabilidad) = subordinados.any(
    { subordinado => subordinado.puedeUsar(unaHabilidad) }
  )
}