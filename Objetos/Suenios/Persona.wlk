class Persona {
  var property tipo
  const sueldoDeseado
  var felicidonios
  const sueniosCumplidos
  const sueniosPendientes
  const carrerasEstudiadas
  const lugaresAViajar
  const carrerasAEstudiar
  var cantidadHijosAdoptados = 0
  var cantidadHijosNoAdoptados = 0
  
  method cumplirSuenio() {
    const suenio = self.tipo().suenioACumplir(sueniosPendientes, self)
    if (not self.puedeCumplirse(suenio)) {
      throw new DomainException(message = "No puede cumplirse el suenio")
    }
    suenio.cumplirse()
    sueniosPendientes.remove(suenio)
    sueniosCumplidos.add(suenio)
  }
  
  method puedeCumplirse(suenio) = suenio.puedeCumplirse()
  
  method aumentarFelicidonios(cantidad) {
    felicidonios += cantidad
  }
  
  method quiereGanar() = sueldoDeseado
  
  method estaPendiente(suenio) = sueniosPendientes.contains(suenio)
  
  method tenerUnHijo() {
    cantidadHijosNoAdoptados += 1
  }
  
  method adoptarHijos(cantidad) {
    cantidadHijosAdoptados += cantidad
  }
  
  method tieneHijos() = cantidadHijosAdoptados > 0
  
  method quiereViajarA(lugar) = lugaresAViajar.contains(lugar)
  
  method viajarA(lugar) = lugaresAViajar.remove(lugar)
  
  method quiereEstudiar(carrera) = carrerasAEstudiar.contains(
    carrera
  ) and (not self.yaEstudio(carrera))
  
  method yaEstudio(carrera) = carrerasEstudiadas.contains(carrera)
  
  method finallizarEstudios(carrera) {
    carrerasAEstudiar.remove(carrera)
    carrerasEstudiadas.add(carrera)
  }
  
  method metaMasImportante() = sueniosPendientes.max(
    { suenio => suenio.felicidonios() }
  )
  
  method esFeliz() = felicidonios > sueniosPendientes.sum(
    { suenio => suenio.felicidonios() }
  )
  
  method esAmbiciosa() = self.sumarFelicidonios().size() > 3
  
  method sumarFelicidonios() = sueniosPendientes.filter(
    { suenio => suenio.esAmbicioso() }
  ) + sueniosCumplidos.filter({ suenio => suenio.esAmbicioso() })
}

object obsesivo {
  method suenioACumplir(suenios, _persona) = suenios.first()
}

object alocado {
  method suenioACumplir(suenios, _persona) = suenios.anyOne()
}

object realista {
  method suenioACumplir(suenios, persona) = persona.metaMasImportante()
}