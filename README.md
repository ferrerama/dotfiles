# Init.lua 
## Archivo de configuración para Linux(Ubuntu) y adaptable a Windows 10/11.
Esta configuración de nvim con lua, fue inicialmente configurada con el dotfile antiguo(de los videos de Youtube de 3rdx,
al cual se le agregaron otras funcionalidades. como:
* Cmake de celledone
* Se configuro DAP
* y se corrigieron algunos errores que ocasionaba <tab>, ademas se hicieron cambios para que se use el tema Nord, pero en forma transparente.
Notar que ya no se utiliza el actual dotfile de 3rdx, el cual tiene muchas mas funcionabilidades.
  
Para Windows, se recomienda.
* Utilizar programas sugeridos en el archivos notas
* Aplicar el init.lua con el gestor packer
* Hacer los cambios minimos que van apareciendo algunas dependencias.
Ya que normalmente en Linux no es ningun problema.

La idea es que sea funcional para C++, aunque puede utilizarse otro lenguaje sin problema.
ya que en automatico se cargan los parsers y se pueden agregar los LSP servers disponibles para Mason.

Este es un ejemplo tipico de de C++ que se podra implementar con autocompletado, sintaxis y errores (clangd).
```
#include<vector>
int main(void){
std::vector<int> v;
vector.-->
return 0;
}
```
En mi experiencia antes he utilizado flags con OmniCppComplete, CCLS con coc.q, pero nada tan completo y asyn como lo es LSP,
ademas nunca fui capaz de configurar "youcompleteme" que entiendo hace mucho tiempo era la mejor opcion.

Notar que existen ya paquetes practicos como NvChad que basicamente sin esfuerzo se pueden configurar DAP,
y que ademas provee un nivel grafico al nivel de Visual Studio Code.

Sin embargo personalmente me gusta mas los estilos sencillos, aunque eso llevo mucho tiempo de configurar, porque al parecer
Lazy tiene una mejor sincronizacion y hace que los paquetes funcionen aun con omisiones, que es lo que utiliza nvchad.



