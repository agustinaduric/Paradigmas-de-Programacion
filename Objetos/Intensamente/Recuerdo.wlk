class Recuerdo {
  const emocionDominante
  const descripcion
  const fecha
  
  method asentarseEn(persona) = emocionDominante.asentarseEn(persona, self)
  
  method esDificilDeExplicar() = descripcion.words() > 10
  
  method emocionDominante() = emocionDominante
  
  method esNegadoPor(persona) = emocionDominante.negar(persona, self)
  
  method tieneDescripcionCon(palabra) = descripcion.contains(palabra)
  
  method noEsPensamientoCentral(
    persona
  ) = not persona.pensamientosCentrales().contains(self)
  
  method fecha() = fecha
  
  method comparteEmocionCon(
    otroRecuerdo
  ) = self.emocionDominante() == otroRecuerdo.emocionDominante()
}