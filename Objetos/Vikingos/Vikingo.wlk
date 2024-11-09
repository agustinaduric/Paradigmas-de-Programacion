class Vikingo {
  var casta
  var botin
  
  method puedeSubirseAunaExpedicion(expedicion) = expedicion.puedeSubir(self)
  
  method recibirBotin(monedas) {
    botin += monedas
  }
  
  method escalarSocialmenteA(nuevaCasta) {
    casta = nuevaCasta
  }
  
  method esProductivo()
  
  method esCastaApta() {
    if (not casta.validarCasta(self)) {
      throw new DomainException(message = "No puede subirse a la expedicion")
    } else {
      return true
    }
  }
}