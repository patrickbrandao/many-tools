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
) > k1.zip

# Gerar arquivo de 1 m
_have_space 1024000
for i in $(seq 1 1 1024); do
	cat k1.zip
done > M1.zip

# Gerar arquivo de 5 m
_have_space 5024000
for i in $(seq 1 1 5); do
	cat M1.zip
done > M5.zip

# Gerar arquivo de 10m
_have_space 11024000
(cat M5.zip M5.zip) > M10.zip

# Gerar arquivo de 25m
_have_space 25024000
(cat M10.zip M10.zip M5.zip) > M25.zip

# Gerar arquivo de 50m
_have_space 51024000
for i in $(seq 1 1 2); do
	cat M25.zip
done > M50.zip

# Gerar arquivo de 100m
_have_space 111024000
(cat M50.zip M50.zip) > 100M.zip

# Gerar arquivo de 250m
_have_space 250024000
(cat M100.zip M100.zip M50.zip) > M250.zip

# Gerar arquivo de 500m
_have_space 555024000
(cat M250.zip M250.zip) > M500.zip

# Gerar arquivo de 1 gigabyte
_have_space 1000222000
(cat M500.zip M500.zip) > G1.zip

# Gerar arquivo de 1.5 gigabytes
_have_space 1500222000
(cat G1.zip M500.zip) > G1_5.zip

# Gerar arquivo de 1 gigabyte
_have_space 2111333000
(cat G1.zip G1.zip) > G2.zip
















