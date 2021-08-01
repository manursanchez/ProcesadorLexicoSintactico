# Procesador de Lenguaje en Java. Desarrollo del léxico y el sintáctico.

Primera parte del desarrollo de un compilador en Java. Aquí se abordan la parte del léxico y la sintaxis.

La arquitectura se monta en Eclipse y se usan las siguientes herramientas:

- JLex: es un lenguaje que se usa para especificar analizadores léxicos
- Cup: esta herramienta especifica gramáticas formales, facilitando de esta forma el análisis sintáctico para obtener un analizador ascedente de tipo LALR.
- Ant: Automatiza la compilación y ejecución de programas Java.  

Los archivos que se han modificado son:

specs/scanner.flex: donde se define el léxico del lenguaje. Aquí se exponen los tokens de los que se compone el lenguaje que vamos a crear.

specs/parser.cup: en este fichero se define y controla la sintaxis del lenguaje.
