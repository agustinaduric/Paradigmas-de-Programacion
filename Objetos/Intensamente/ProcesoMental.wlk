class ProcesoMental {
  method aplicarseA(persona, _palabraClave)
}

object asentamiento inherits ProcesoMental {
  override method aplicarseA(persona, _palabraClave) {
    const recuerdosDelDia = persona.recuerdosDelDia()
    recuerdosDelDia.forEach({ recuerdo => recuerdo.asentarseEn(persona) })
  }
}

object asentamientoSelectivo inherits ProcesoMental {
  override method aplicarseA(persona, palabraClave) {
    const recuerdosSeleccionados = self.seleccionarRecuerdosSegun(
      persona,
      palabraClave
    )
    recuerdosSeleccionados.forEach(
      { recuerdo => recuerdo.asentarseEn(persona) }
    )
  }
  
  method seleccionarRecuerdosSegun(
    persona,
    palabraClave
  ) = persona.recuerdos().filter(
    { recuerdo => recuerdo.tieneDescripcionCon(palabraClave) }
  )
}

object profundizacion inherits ProcesoMental {
  override method aplicarseA(persona, _palabraClave) {
    if (persona.notienePensamientosCentralesNoNegados())
      persona.agregarALargoPlazo(persona.noCentralesNoNegados())
  }
}

object controlHormonal inherits ProcesoMental {
  override method aplicarseA(persona, _palabraClave) {
    if (self.verificarPensamientos(persona) || self.verificarEmocionEnRecuerdos(
      persona
    )) {
      persona.reducirCoeficienteFelicidad(15)
      persona.borrarUltimosPensamientosCentrales(3)
    }
  }
  
  method verificarPensamientos(
    persona
  ) = persona.tienePensamientoCentralEnLargoPlazo()
  
  method verificarEmocionEnRecuerdos(
    persona
  ) = persona.todosLosRecuerdosCompartenEmocion()
}

object restauracionCognitiva inherits ProcesoMental {
  override method aplicarseA(persona, _palabraClave) {
    persona.aumentarNivelDeFelicidad(100)
  }
}

object liberacion inherits ProcesoMental {
  override method aplicarseA(persona, _palabraClave) {
    persona.liberarRecuerdosDelDia()
  }
}