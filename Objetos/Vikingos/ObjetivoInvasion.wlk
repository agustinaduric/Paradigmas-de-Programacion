class ObjetivoDeInvacion {
  method valeLaPena(expedicion)
  
  method botinConseguido(expedicion)
  
  method serInvadido(expedicion) {
    const botin = self.botinConseguido(expedicion)
    expedicion.recibirBotin(botin)
  }
}