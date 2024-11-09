import Vikingo.*

class Granjero inherits Vikingo {
  const cantidadDeHijos
  const cantidadDeHectareas
  
  override method esProductivo() = cantidadDeHectareas >= (cantidadDeHijos * 2)
}
