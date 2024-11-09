import ObjetivoInvasion.*

class Capital inherits ObjetivoDeInvacion {
  const riquezaTerrestre
  
  override method botinConseguido(expedicion) = self.defensoresDerrotados(
    expedicion
  ) + riquezaTerrestre
  
  method defensoresDerrotados(expedicion) = expedicion.vidasCobradas()
  
  override method valeLaPena(expedicion) = self.botinConseguido(
    expedicion
  ) >= (expedicion.vikingosEnExpedicion() * 3)
}