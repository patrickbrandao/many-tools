#!/bin/sh

DIR="/var/www/files"
FORCE=0
SIM=0

# processar parametros
for p in $@; do
	if [ "$p" = "-f" -o "$p" = "force" ]; then FORCE=1; fi
	if [ "$p" = "-s" -o "$p" = "simulate" -o "$p" = "test" ]; then SIM=1; fi
done

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
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36"

OIURL="http://arquivos.oi.com.br"
OILIST="
	1024000:M1.zip
	5024000:M5.zip
	11024000:M10.zip
	51024000:M50.zip
	555024000:M500.zip
	1000222000:G1.zip
	1500222000:G1_5.zip
	2111333000:G2.zip
"

for it in $OILIST; do
	fbytes=$(echo $it | cut -f1 -d:)
	fname=$(echo $it | cut -f2 -d:)
	dname="$fname"
	URL="$OIURL/$fname"

	echo "$fname ($fbytes bytes) => $URL"

	if [ "$FORCE" = "0" -a -f "$fname" ]; then
		echo "-------> $fname ja existe, pulando..."
		sleep 1
		continue
	fi

	# nao salvar em disco, apenas gastar banda
	if [ "$SIM" = "1" ]; then
		dname="/dev/null"
	else
		# verificar se ha espaco para baixar o arquivo
		_have_space "$fbytes"		
	fi

	# fazer download
	rm "$fname" 2>/dev/null
	wget \
		--tries=3000 \
		--read-timeout=5 \
		--user-agent="$UA" \
		--header="Referer: $OIURL/" \
		-O "$dname" \
		"$URL"

done




