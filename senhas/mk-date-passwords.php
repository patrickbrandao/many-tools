#!/usr/bin/php -q
<?php

    $year_ini = 1900;
    $year_end = 2016;

    $a1 = array();
    $a2 = array();
    $a3 = array();
    $a4 = array();
    $a5 = array();
    $a6 = array();
    $a7 = array();
    $a8 = array();
    $a9 = array();
    $a10 = array();
    $a11 = array();
    $a12 = array();
    $a13 = array();

    for($year = $year_ini; $year <= $year_end; $year++){
	    
	    for($month = 1; $month <= 12; $month++){
		    
		    for($day = 1; $day <= 31; $day++){
			    
			    $_year = substr('0'.$year, -2);
			    $_month = substr('0'.$month, -2);
			    $_day = substr('0'.$day, -2);
			    
			    echo "> ",$day,"/",$month,"/",$year,"\n";

			    // Formatos SQL e de ordenacao natural: ano mes dia

			    // yyyymmdd
			    $a1[] = $year.$_month.$_day;
			    
			    // yyyy-mm-dd
			    $a2[] = $year.'-'.$_month.'-'.$_day;

			    // yymmdd
			    $a3[] = $_year.$_month.$_day;
			    
			    // yy-mm-dd
			    $a4[] = $_year.'-'.$_month.'-'.$_day;
			    
			    // formato americano: mes dia ano
			    
			    // mmddyyyy
			    $a5[] = $_month.$_day.$year;
			    
			    // mm-dd-yyyy
			    $a6[] = $_month.'-'.$_day . '-'. $year;

			    // mmddyy
			    $a7[] = $_month.$_day.$_year;
			
			    // yy-mm-dd
			    $a8[] = $_month . '-' . $_day . '-'.$_year;

			    // formato brasileiro: dia mes ano
			    
			    // mmddyyyy
			    $a9[] = $_day.$_month.$year;
			    
			    // mm-dd-yyyy
			    $a10[] = $_day.'-'.$_month . '-'. $year;

			    // mmddyy
			    $a11[] = $_day.$_month.$_year;
			
			    // yy-mm-dd
			    $a12[] = $_day . '-'.$_month . '-' . $_year;

		    }
	    
	    }
	    
    }

    // gravar em arquivos
    function _a2f(&$a, $f){
	file_put_contents($f, implode("\n", $a)."\n");
    }

    echo "Aguarde, gravando arquivos ";
    // ordenacao SQL/natural
    _a2f($a1, 'date-passwords-yyyymmdd.txt');		// yyyymmdd
    _a2f($a2, 'date-passwords-hyphen-yyyymmdd.txt');	// yyyy-mm-dd
    _a2f($a3, 'date-passwords-yymmdd.txt');		// yymmdd
    _a2f($a4, 'date-passwords-hyphen-yymmdd.txt');	// yy-mm-dd

    echo ".";
			    
    // formato americano: mes dia ano
    _a2f($a5, 'date-passwords-eua-yyyymmdd.txt');		// mmaayyyy
    _a2f($a6, 'date-passwords-eua-hyphen-yyyymmdd.txt');	// mm-dd-yyyy
    _a2f($a7, 'date-passwords-eua-yymmdd.txt');			// mmddyy
    _a2f($a8, 'date-passwords-eua-hyphen-yymmdd.txt');		// mm-dd-yy

    echo ".";

    // formato brasileiro: dia mes ano
    _a2f($a9,  'date-passwords-brasil-yyyymmdd.txt');		// ddmmyyyy
    _a2f($a10, 'date-passwords-brasil-hyphen-yyyymmdd.txt');	// dd-mm-yyyy
    _a2f($a11, 'date-passwords-brasil-yymmdd.txt');		// ddmmyy
    _a2f($a12, 'date-passwords-brasil-hyphen-yymmdd.txt');	// dd-mm-yy

    echo "OK\n";





?>
