class Argumento {
  const naturaleza
  const descripcion
  
  method esEnrriquecedor() = naturaleza.enrriquece(self)
  
  method cantidadPalabras() = descripcion.words()
  
  method esPregunta() = descripcion.endsWith("?")
}

class Estoica inherits Argumento {
  method enrriquece(_argumento) = true
}

class Moralista inherits Argumento {
  method enrriquece(argumento) = argumento.cantidadPalabras() >= 10
}

class Esceptica inherits Argumento {
  method enrriquece(argumento) = argumento.esPregunta()
}

class Cinica inherits Argumento {
  method enriquece(argumento) = 1.randomUpTo(100) <= 30
}

class NaturalezaCombinada {
  const naturalezas
  
  method enriquece(argumento) = naturalezas.all(
    { naturaleza => naturaleza.enriquece(argumento) }
  )
}