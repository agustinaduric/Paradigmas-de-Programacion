class Argumento {
  const naturaleza
  const descripcion
  
  method esEnrriquecedor() = naturaleza.enrriquece(self)
  
  method cantidadPalabras() = descripcion.words()
  
  method esPregunta() = descripcion.endsWith("?")
}

object estoica{
  method enrriquece(_argumento) = true
}

object moralista{
  method enrriquece(argumento) = argumento.cantidadPalabras() >= 10
}

object esceptica {
  method enrriquece(argumento) = argumento.esPregunta()
}

object cinica {
  method enriquece(argumento) = 1.randomUpTo(100) <= 30
}

class NaturalezaCombinada {
  const naturalezas
  
  method enriquece(argumento) = naturalezas.all(
    { naturaleza => naturaleza.enriquece(argumento) }
  )
}