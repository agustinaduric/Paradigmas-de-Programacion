class Suenio {
  const property cantidadFelicidonios
  
  method brindarFelicidoniosA(persona) = persona.aumentarFelicidonios(
    cantidadFelicidonios
  )
  
  method puedeCumplirse(persona)
  
  method cumplirse(persona)
}

class TenerUnHijo inherits Suenio {
  override method cumplirse(persona) {
    persona.tenerUnHijo()
  }
  
  override method puedeCumplirse(_persona) = true
}

class Adoptar inherits Suenio {
  const cantidadHijos
  
  override method cumplirse(persona) {
    persona.adoptarHijos(cantidadHijos)
  }
  
  override method puedeCumplirse(persona) = not persona.tieneHijos()
}

class Viajar inherits Suenio {
  const lugar
  
  override method cumplirse(persona) {
    persona.viajarA(lugar)
  }
  
  override method puedeCumplirse(persona) = persona.quiereViajarA(lugar)
}

class ConseguirTrabajo inherits Suenio {
  const sueldo
  
  override method puedeCumplirse(persona) = persona.quiereGanar() <= sueldo

}

class Recibirse inherits Suenio {
  const carrera
  
  override method cumplirse(persona) = carrera.realizarse(persona)
  
  override method puedeCumplirse(persona) = persona.quiereEstudiar(carrera)
}

object ingenieroEnSistemas {
  method realizarse(persona) = persona.finalizarEstudios(self)
}

object licenciadoEnPsicologia {
  method realizarse(persona) = persona.finalizarEstudios(self)
}

object odontologo {
  method realizarse(persona) = persona.finalizarEstudios(self)
}