#!/bin/sh

# Criar rotas estaticas que serao redistribuidas via BGP a vizinhos para testa-los:
# - testar capacidade de rotas
# - testar tempo para receber e classificar rotas
# - testar storm de anuncios (adicionar e remover em loop inifinito)

# Acao:
# start: adicionar mais rotas estaticas
# flush: limpar todas as rotas estaticas
# stop: para script em background
# random: rodar script em background adicionando e removendo rotas
ACTION="random"

# Classe ipv4 a segmentar para gerar rotas
C4=""

# Numero de rotas estaticas a adicionar
SCOUNT=25000

# Processar argumentos
for arg in $@; do
  # acao?
  if [ "$arg" = "stop" -o "$arg" = "start" -o "$arg" = "random" -o "$arg" = "flush" ]; then
    ACTION=$arg
    continue
  fi
  # numero de rotas?
  x=$(echo $arg | egrep '^[0-9]$'); if [ "x$x" != "x" ]; then SCOUNT=$arg; continue; fi

done

# FALTA...






