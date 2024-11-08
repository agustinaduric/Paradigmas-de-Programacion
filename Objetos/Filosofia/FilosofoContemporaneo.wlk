import Filosofo.*
import Actividad.*
class FilosofoContemporaneo inherits Filosofo {
  override method presentarse() = "Hola"
  
  override method nivelDeIluminacion() {
    if (self.esAmanteDeLaBotanica()) {
      super()
    }
    return nivelDeIluminacion * 5
  }
  
  method esAmanteDeLaBotanica() = self.actividades().contains(admirarPaisaje)
}