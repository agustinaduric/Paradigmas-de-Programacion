class Emocion {
  method asentarseEn(persona, recuerdo)
  
  method negar(persona, recuerdo) = false
  
  method esTristeza(_emocion) = false
  
  method esAlegria(_emocion) = false
}

object alegria inherits Emocion {
  override method asentarseEn(persona, recuerdo) {
    if (self.verificarFelicidadDe(persona)) persona.pensamientosCentrales(
        recuerdo
      )
  }
  
  method verificarFelicidadDe(persona) = persona.nivelDeFelicidad() >= 500
  
  override method negar(persona, recuerdo) = self.esAlegria(
    recuerdo.emocionDominante()
  )
  
  override method esAlegria(emocion) = self == emocion
}

object tristeza inherits Emocion {
  override method asentarseEn(persona, recuerdo) {
    persona.pensamientosCentrales(recuerdo)
    persona.recudirCoeficienteFelicidad(0.1)
  }
  
  override method negar(persona, recuerdo) = self.esTristeza(
    recuerdo.emocionDominante()
  )
  
  override method esTristeza(emocion) = self == emocion
}

object disgusto inherits Emocion {
  override method asentarseEn(persona, recuerdo) {
    
    // no hace nada
  }
}

object furioso inherits Emocion {
  override method asentarseEn(persona, recuerdo) {
    
    // no hace nada
  }
}

object temeroso inherits Emocion {
  override method asentarseEn(persona, recuerdo) {
    
    // no hace nada
  }
}