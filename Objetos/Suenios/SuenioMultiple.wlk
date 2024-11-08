import Suenio.*

class SuenioMultiple inherits Suenio {
  const suenios

	override method cantidadFelicidonios() = suenios.sum { suenio => suenio.felicidonios() }
  
  override method puedeCumplirse(persona) = suenios.all(
    { suenio => suenio.puedeCumplirse(persona) }
  )
  
  override method cumplirse(persona) = suenios.forEach(
    { suenio => suenio.cumplirse(persona) }
  )
}