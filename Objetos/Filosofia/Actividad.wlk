class TomarVino {
  method realizarPor(filosofo) {
    filosofo.disminuirIluminacion(10)
    filosofo.agregarHonorifico("El borracho")
  }
}

class JuntarseEnElAgora {
  const otroFilosofo
  
  method realizarPor(filosofo) {
    filosofo.aumentarIluminacion(otroFilosofo.nivelDeIluminacion() / 10)
  }
}

object admirarPaisaje {
  method realizarPor(_filosofo) {
    
    // no hace nada
  }
}

class MeditarBajoUnaCascada {
  const metros
  
  method realizarPor(filosofo) {
    filosofo.aumentarIluminacion(10 * metros)
  }
}

class PracticarDeporte {
  const deporte
  
  method realizarPor(filosofo) {
    filosofo.rejuvencer(deporte.cantidadDias())
  }
}

object futbol {
  method cantidadDias() = 1
}

object polo {
  method cantidadDias() = 2
}

object waterpolo {
  method cantidadDias() = polo.cantidadDias() * 2
}