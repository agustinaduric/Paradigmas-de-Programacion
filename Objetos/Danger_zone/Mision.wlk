class Mision {
  const habilidadesRequeridas
  const peligrosidad
  
  method estaCumplida(destinado) {
    self.validarHabilidades(destinado)
    destinado.recibirDanio(peligrosidad)
    destinado.finalizarMision(self)
  }
  
  method validarHabilidades(destinado) {
    if (self.cumpleRequerimientos(destinado)) {
      throw new Exception(message = "La misión ha fallado")
    }
  }
  
  method cumpleRequerimientos(destinado) = habilidadesRequeridas.all(
    { habilidad => destinado.puedeUsar(habilidad) }
  )
  
  method enseniarHabilidades(empleado) {
    self.habilidadesQueNoPosee(empleado).forEach(
      { habilidad => empleado.aprenderHabilidad(habilidad) }
    )
  }
  
  method habilidadesQueNoPosee(empleado) = habilidadesRequeridas.filter(
    { habilidad => not empleado.poseeHabilidad(habilidad) }
  )
}