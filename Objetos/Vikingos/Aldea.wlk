import ObjetivoInvasion.*

class Aldea inherits ObjetivoDeInvacion {
  const iglesias
  const estaAmurallada
  const cantidadMinimaInvasores
  
  override method valeLaPena(expedicion) {
    if (self.validarMuralla(expedicion)) {
      throw new DomainException(
        message = "La invacion a la aldea no vale la pena"
      )
    }
    return self.botinConseguido(expedicion) >= 15
  }
  
  override method botinConseguido(expedicion) = iglesias.size()
  
  method validarMuralla(
    expedicion
  ) = estaAmurallada and ((not expedicion.vikingosEnExpedicion()) >= cantidadMinimaInvasores)
}