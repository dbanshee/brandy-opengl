package require ftp
wm iconify .
console show


set serv "dbanshee.es"
set user "u47361217-invitado"
set pass "1234567"


set ftp [ftp::Open $serv $user $pass]
if { $ftp == -1 } {
	puts "Error. No ha podido conectarse a ftp://$serv"
} else {
	puts "Conectado."
	
	set localFiles [glob -nocomplain *.tcl]
	if {[ftp::Cd $ftp VisorGL] == 1} {
		#set lF [ftp::List $ftp]
		foreach f $localFiles {
			#xq no funciona el ModTime????
			#puts "$f : [ftp::ModTime $ftp $f]"
			puts "Enviando : $f ..."
			if {[ftp::Put $ftp $f] != 1} {
				puts "Error al enviar : $f"
			}
		}
	} else {
		puts "Error al cambiar al Directorio /VisorGL"
	}
	
	
	
	#lista de archivos locales
	
	
	
	ftp::Close $ftp
}

puts "Terminado"