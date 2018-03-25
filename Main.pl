
# Main.pl

# Descripcion: Main del lexer del lenguaje de programacion Bitiondo 

# Autores:
# 	Lautaro Villalon. 12-10427
# 	Yarima Luciani. 13-10770


use Lexer;

# REVISION DE ARGUMENTOS CORRECTOS
$num_args = $#ARGV + 1;

if ($num_args != 1) {
	print "\nUsage: main.pl filename";
	exit;
}

# ABRE ARCHIVO INGRESADO POR ARGUMENTOS Y GUARDA EN ARREGLO DE LINEAS

$file = $ARGV[0];

open (FH, "< $file") or die "ERROR: Can't open $file for read: $!";
my @file_lines = <FH>;

# CREA EL LEXER, LEE EL ARCHIVO Y OBTIENE LOS TOKENS
$lexer = Lexer->new(file => \@file_lines);

$lexer->readFile();

$tokens = $lexer->tokens();

# IMPRIME LOS TOKENS
foreach my $tok (@$tokens) {
	print $tok->to_str();
}

#CIERRA ARCHIVO
close FH or die "Cannot close $file: $!"; 