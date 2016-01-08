#!/bin/sh

export PREFIX="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

# lista de monitoramentos
cd /etc/lgmonitor || exit 1

LOGFILE=/var/log/lg-prefix-monitor.log

EMAILADMIN="ditec@amazontel.com.br contato@vyos.net.br"

_log(){
    logx="$(date '+%Y-%m-%d %T') - $1: $2"
    echo $logx
    echo $logx >> $LOGFILE
}
_sendmail(){
    xto="$1"		# destinatario
    xfrom="$2"		# remetente
    xsub="$3"		# titulo
    xtxt="$4"		# texto
    xtxtf="$5"		# arquivos a anexar no conteudo
    _log "sendmai" "Enviando e-mail para $xto from $xfrom, assunto '$xsub'"
    # falta o codigo
    # AQUI
}

for conf in prefix-monitor-*; do
	fc="/etc/lgmonitor/$conf"
	if [ ! -f "$fc" ]; then continue; fi
	email=""; prefix=""
	. $fc
	#email="contato@vyos.net.br"
	if [ "x$email" = "x" -o "x$prefix" = "x" ]; then continue; fi

	# processar prefixo por prefixo
	plist=$(echo $prefix | sed 's/,/ /g; s/;/ /g')
	echo "Analisando: $name"
	for p in $plist; do
	    tmp=$(echo "$p" | sed 's/\./_/g; s/\//_/g; s/:/_/g')
	    pf1="/tmp/lg-prefix-$tmp.out"
	    pf1x="/tmp/lg-prefix-$tmp.outx"
	    pf2="/tmp/lg-prefix-$tmp.new"
	    pf2x="/tmp/lg-prefix-$tmp.newx"
	    pfd="/tmp/lg-prefix-$tmp.txt"
	
	    skip=0
	    if [ ! -f "$pf1" ]; then skip=1; fi

	    echo "   Prefixo: $p ($skip)"
	    
	    # protocolo do prefixo
	    v=4
	    cmd="show ip bgp $p"
	    if [ "x$(echo $p | grep ':')" != "x" ]; then
		v=6
		cmd="show ipv6 bgp $p"
	    fi
	    vtysh -c "$cmd" > $pf2x
	    cat $pf2x | grep -v 'Last update' | grep -v 'Not advertised' > $pf2

	    diff -Naur $pf1 $pf2 | grep -v '^@@' | grep -v '^---' | grep -v '^+++' > $pfd
	    n=$(wc -l $pfd | awk '{print $1}')
	    # | egrep -v '^---' | grep -v '^\+\+\+' | grep -v '^@@' > $pfd
	    #echo "PFD: "; cat $pfd
	    #echo "Alteracoes: $n"
	    
	    # jogar atual para versao corrente
	    cat $pf2 > $pf1

	    # nao analisar nem gerar comparacao
	    if [ "$skip" = "1" ]; then continue; fi
	
	    # houve alteracoes, alertar
	    if [ "$n" -gt "0" ]; then
		# Reportar
		_log "LG-PREFIX-MONITOR" "Anuncio $p ($name) sofreu alteracao ($n): $(cat $pfd)"
		elist="$email $EMAILADMIN"
		elist=$(echo $elist | sed 's/,/\ /g')
		elist="$elist $EMAILADMIN"
		elist=$(for i in $elist; do echo $i; done | sort -u)
		for edst in $elist; do
		    /etc/lgmonitor/sendmail-text.sh "$edst" "ditec@amazontel.com.br" "BGP-LG $name prefixo $p alterado $n" "(Mensagem automatica gerada por servidor de rotas BGP - LOOKING GLASS)" "$pfd"
		done
	    fi
	done
	


done

