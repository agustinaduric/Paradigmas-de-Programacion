import Partido.*

class Discusion {
  const partidos
  
  method esBuena() = partidos.all({ partido => partido.esBueno() })
}