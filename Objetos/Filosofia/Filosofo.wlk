class Filosofo {
  const nombre
  var edad
  const honorificos
  var nivelDeIluminacion
  var diasVividosEnUnAnio = 0
  const property actividades
  
  method presentarse() = (self.nombre() + ", ") + self.contarHonorificos()
  
  method nombre() = nombre
  
  method contarHonorificos() = honorificos.join(",")
  
  method estaEnLoCorrecto() = nivelDeIluminacion > 1000
  
  method vivirUnDia() {
    self.realizarActividades()
    self.envejecer()
  }
  
  method realizarActividades() {
    actividades.forEach({ actividad => actividad.realizarPor(self) })
  }
  
  method nivelDeIluminacion() = nivelDeIluminacion
  
  method disminuirIluminacion(cantidad) {
    nivelDeIluminacion -= cantidad
  }
  
  method aumentarIluminacion(cantidad) {
    nivelDeIluminacion += cantidad
  }
  
  method agregarHonorifico(honorificoNuevo) {
    self.verificarHonorifico(honorificoNuevo)
    honorificos.add(honorificoNuevo)
  }
  
  method verificarHonorifico(honorifico) {
    if (self.estaRepetido(honorifico)) {
      throw new DomainException(message = "Honorifico repetido")
    }
  }
  
  method estaRepetido(honorifico) = honorificos.contains(honorifico)
  
  method rejuvenecer(dias) {
    diasVividosEnUnAnio -= dias
  }
  
  method envejecer() {
    diasVividosEnUnAnio += 1
    self.verificarCumpleanio()
  }
  
  method verificarCumpleanio() {
    if (diasVividosEnUnAnio == 365) {
      diasVividosEnUnAnio = 0
      self.cumplirAnios()
    }
  }
  
  method cumplirAnios() {
    self.envejecer(1)
    self.aumentarIluminacion(10)
  }
  
  method envejecer(anios) {
    edad += anios
    self.verificarEdad()
  }
  
  method verificarEdad() {
    if (edad == 60) self.agregarHonorifico("El sabio")
  }
}