class Casta {
  method validarCasta(_vikingo) = true
}

object jarl inherits Casta {
  override method validarCasta(vikingo) = not vikingo.tieneArmas()
}

object karl inherits Casta {
  override method validarCasta(_vikingo) = true
}

object thrall inherits Casta {
  override method validarCasta(_vikingo) = true
}