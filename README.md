

requisitos:
[vibescript](https://github.com/OUIsolutions/VibeScript) (runtime lua para execução do script)

se estiver no linux instale com:
```bash

curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/vibescript.out -o vibescript.out && chmod +x vibescript.out && sudo mv vibescript.out /usr/local/bin/vibescript
```
se estiver no mac: 

```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.45.1/amalgamation.c -o vibescript.c && gcc vibescript.c -o vibescript && sudo mv vibescript /usr/local/bin/vibescript && rm vibescript.c
```
demais plataformas (windows/deb/rpm):
vá até a página de [releases](https://github.com/OUIsolutions/VibeScript/releases/download)

para executar: 
```bash
vibescript main.lua
```
