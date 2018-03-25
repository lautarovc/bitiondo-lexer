package Lexer;
use Moose;
use Token;

has file => (is => 'rw');
has counter => (is => 'rw', init_arg => 0);
has tokens => (is => 'rw', init_arg => []);
has errorList => (is => 'rw', init_arg => []);

sub readFile {

	my $self = shift;

	my $file = $self->file();
	my @tokens = ();
	my @errorList = ();
	my $fileLen = @$file;
		
	my $superRegex = '\A\#.*                 							|
					  \A(\s)+                  							|
					  \Atrue\b | \Afalse\b   							|
					  \A[a-zA-Z][a-zA-Z0-9_]*  							|
					  \A0b[01]+                							|
					  \A(\d)+                  						    |
					  \A"(\\.|[^\\"\n])*"      						    |
					  \A\[	|  \A\]	   									|
					  \A\~                     							|
					  \A\$                     							|
					  \A\@                     							|
					  \A\-                     							|
					  \A\*                     							|
					  \A\/                     							|
					  \A\%                     							|
					  \A\+                     							|
					  \A\<\<  |  \A\>\>    							    |
					  \A\<\= | \A\>\= | \A\< | \A\> | \A\=\= | \A\!\=   |
					  \A\!                     							|
					  \A\=												|
					  \A\&\&                                            |
					  \A\|\|                                            |
					  \A\&                                              |
					  \A\^                                              |
					  \A\|                                              |
					  \A\;                                              |
					  \A\,                                              |
					  \A\( | \A\)';

	my $error = 0;

	for (my $i = 0; $i < $fileLen; $i = $i + 1) {

		my $prevLine = $$file[$i];
		my $tmp = Token->new(str => "", line => 1, column => 1);

		while ($prevLine ne "") {

			# CALCULO DE LA POSICION DEL NUEVO TOKEN Y COMPARACION CON SUPER REGEX
			my $prevColumn = length($tmp->str()) + $tmp->column();
			my $relPosition = $prevLine =~ /$superRegex/x;

			# VERIFICACION DE ERROR

			if ($relPosition == 0) {
				$error = 1;
				$tmp = Token->new(str => substr($prevLine, 0, 1), line => $i+1, column => $prevColumn);
				push(@errorList, $tmp);

				$prevLine = substr($prevLine, 1);
				next;
			}

			# VERIFICACION DE COMENTARIO

			if (substr($&, 0, 1) eq "#") {
				last;
			}

			# ADICION DEL TOKEN A LA LISTA DE TOKENS CON SU POSICION ACUTALIZADA

			my $j = $prevColumn + $relPosition;
			$tmp = Token->new(str => $&, line => $i+1, column => $j);
			push(@tokens, $tmp);
			$prevLine = $';

		}

	}

	# BORRA ESPACIOS
	my $tokensLen = @tokens;
	my @tokensClean = ();

	for (my $i = 0; $i < $tokensLen; $i = $i + 1) {
		my $type = $tokens[$i]->type();
	    if ($type ne "Spaces") {
	        push(@tokensClean, $tokens[$i]);
	    }
	}

	# GUARDAMOS ATRIBUTOS DEL OBJETO

	$self->tokens(\@tokensClean);
	$self->errorList(\@errorList);
}


sub nextToken {
	my $self = shift;
	my $tokens = $self->tokens();
	my $counter = $self->counter();


	my $token = $$tokens[$counter];
	$self->counter($counter+1);

	return $token;
}

sub isNext {
	my $self = shift;
	my $tokens = $self->tokens();
	my $counter = $self->counter();
	my $tokensLen = @$tokens;

	return ($counter < $tokensLen);
}

1;