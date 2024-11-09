import Vikingo.*

class Soldado inherits Vikingo {
  const armas
  const vidasCobradas
  
  method tieneArmas() = not armas.isEmpty()
  
  override method esProductivo() = self.validarVida() and self.tieneArmas()
  
  method validarVida() = vidasCobradas > 20
}