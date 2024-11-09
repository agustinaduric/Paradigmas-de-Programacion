class Expedicion {
  const vikingosEnExpedicion
  const aldea
  const capital
  const objetivosAinvadir
  var botinObtenido
  
  method puedeSubir(vikingo) = vikingo.esProductivo() and vikingo.esCastaApta()
  
  method subirVikingo(vikingo) {
    if (self.puedeSubir(vikingo)) vikingosEnExpedicion.add(vikingo)
  }
  
  method realizarse() {
    if (self.validarObjetivos()) {
      objetivosAinvadir.forEach({ objetivo => objetivo.serInvadido(self) })
      self.repartirBotin()
    }
  }
  
  method recibirBotin(monedas) {
    botinObtenido += monedas
  }
  
  method repartirBotin() {
    const monedas = botinObtenido.div(vikingosEnExpedicion.size())
    vikingosEnExpedicion.forEach({ vikingo => vikingo.recibirBotin(monedas) })
  }
  
  method validarObjetivos() = objetivosAinvadir.all(
    { objetivo => objetivo.valeLaPena(self) }
  )
  
  method valeLaPena() = aldea.valeLaPena(self) and capital.valeLaPena(self)
}