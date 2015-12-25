#!/usr/bin/php -q
<?php

    // arquivo com palavras a combinar
    $file = isset($argv[1]) ? $argv[1] : '';
    if($file=='' || !is_file($file)) die("Parametro 1 precisa ser o arquivo de palavras\n");

    // arquivo com combinacoes geradas
    $outfile = isset($argv[2]) ? $argv[2] : '';
    if($outfile=='') die("Parametro 2 deve ser o arquivo para salvar os resultados\n");

    // coletar palavras
    $list = array();
    $tmp = file($file);
    foreach($tmp as $k=>$v){
	$v = trim($v);
	if($v=='') continue;
	$list[] = $v;
    }
    unset($tmp);
    $c = count($list);
    

    $R = array();
    // Adicionar palavra caso nao exista
    function _add($w){
	global $R;
	if(!in_array($w, $R)){
	    echo " + ",$w,"\n";
	    $R[] = $w;
	}
    }
    // Adicionar combinacoes de todas as palavras
    // ja geradas com novas palavras
    function _addcomb($words){
	global $R;
	$rc = count($R);
	$ri = 0;
	for($ri = 0; $ri < $rc; $ri++){
	    $v1 = $R[$ri];
	    foreach($words as $k2=>$v2){
		_add($v1.$v2);
		//_add($v2.$v1);
		//_add($v1.$v1);
		//_add($v2.$v2);
	    }
	}
    }

    echo "- Numero de palavras: $c\n";

    // adicionar palavras simples
    foreach($list as $w) _add($w);

    echo "> Gerando combinacoes ";
    _addcomb($list);
    // combinar ate 3 palavras
    for($level = 0; $level < 2; $level++){ _addcomb($list); echo "."; $t++; }
    //for($level = 0; $level < $c; $level++){ _addcomb($list); echo "."; $t++; }
    echo "\n";
    echo "Combinacoes: ",count($R),"\n";

    echo "Gravando resultado em $outfile\n";
    $W = fopen($outfile, 'w');
    foreach($R as $x) fwrite($W, $x."\n");
    fclose($W);

    echo "Concluido\n";









?>
