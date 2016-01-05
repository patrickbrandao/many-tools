#!/bin/sh

DIR="/var/www/files"

# espaco livre minimo em bytes (100 megabytes)
space_offset=100333222

# funcao para verificar se ha espaco sobrando para alocar o arquivo
_have_space(){
	needspace="$1"
	freek=$(df $DIR | awk '{print $4}' | egrep '^[0-9]+$')
	if [ "x$freek" = "x" ]; then return; fi
	freeb=$(($freek*1024))
	minfree=$(($space_offset+$needspace))
	if [ "$freeb" -lt "$minfree" ]; then
		_abort "Sem espaco suficiente parar criar arquivos, requer $needspace bytes livres"
	fi
}
_abort(){ echo $@; exit 1; }


# Entrar no diretorio onde os arquivos serao criados
	mkdir -p $DIR || _abort "Erro ao criar diretorio $DIR"
	cd $DIR || _abort "Erro ao entrar no diretorio $DIR"

# Gerar arquivo de 1 k
_have_space 1024
(
	echo "Looking Glass TMSoft"
	echo "Autor: Patrick Brandao, contato@tmsoft.com.br, www.patrick.eti.br"
	for i in $(seq 1 1 12); do
		echo "TMSoft Solucoes - www.tmsoft.com.br - Excelencia em redes e telecomunicacoes."
	done
	echo
) > 1k.zip

# Gerar arquivo de 1 m
_have_space 1024000
for i in $(seq 1 1 1024); do
	cat 1k.zip
done > 1M.zip

# Gerar arquivo de 5 m
_have_space 5024000
for i in $(seq 1 1 5); do
	cat 1M.zip
done > 5M.zip

# Gerar arquivo de 10m
_have_space 11024000
(cat 5M.zip; cat 5M.zip) > 10M.zip

# Gerar arquivo de 25m
_have_space 25024000
(cat 10M.zip; cat 10M.zip; cat 5M.zip) > 25M.zip

# Gerar arquivo de 50m
_have_space 51024000
for i in $(seq 1 1 5); do
	cat 10M.zip
done > 50M.zip

# Gerar arquivo de 100m
_have_space 111024000
for i in $(seq 1 1 10); do
	cat 10M.zip
done > 100M.zip

# Gerar arquivo de 250m
_have_space 250024000
(cat 100M.zip; cat 100M.zip; cat 50M.zip) > 250M.zip

# Gerar arquivo de 500m
_have_space 555024000
for i in $(seq 1 1 5); do
	cat 100M.zip
done > 500M.zip

# Gerar arquivo de 1 gigabyte
_have_space 1000222000
(cat 500M.zip; cat 500M.zip) > G1.zip

# Gerar arquivo de 1 gigabyte
_have_space 2111333000
(cat G1.zip; cat G1.zip) > G2.zip
















