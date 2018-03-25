package Token;
use Moose;

has str => (is => 'rw');
has line => (is => 'rw');
has column => (is => 'rw');
has hasValue => (is => 'rw', init_arg => 0);

sub type {
	my $self = shift;

	my %regexHash = ("Spaces" => '\A(\s)+',
				  "reserved" => '\Abegin\b | \Aend\b  | \Aint\b  | \Abool\b  | \Abits\b  | \Ainput\b  | \Aoutput\b  | \Aoutputln\b  | \Aif\b  |
				                \Aelse\b  | \Afor\b  | \Aforbits\b  | \Aas\b  | \Afrom\b  | \Agoing\b  | \Ahigher\b  | \Alower\b  | \Arepeat\b  |
				                \Awhile\b | \Ado\b',
				  "boolean" => '\Atrue\b | \Afalse\b',
				  "identifier" => '\A[a-zA-Z][a-zA-Z0-9_]*',
				  "bit array" => '\A0b[01]+',
				  "integer" => '\A(\d)+',
				  "string" => '\A"(\\.|[^\\\"\n])*"',
				  "left bracket" => '\A\[',
				  "right bracket" => '\A\]',
				  "not bits" => '\A\~',
				  "dollar" => '\A\$',
				  "at" => '\A\@',
				  "minus" => '\A\-',
				  "product" => '\A\*',
				  "division" => '\A\/',
				  "module" => '\A\%',
				  "plus" => '\A\+',
				  "left displacement" => '\A\<\<',
				  "right displacement" => '\A\>\>',
				  "less or equal than" => '\A\<\=',
				  "more or equal than" => '\A\>\=',
				  "less than" => '\A\<',
				  "more than" => '\A\>',
				  "equals" => '\A\=\=',
				  "not equal" => '\A\!\=',
				  "not" => '\A\!',
				  "assign" => '\A\=',
				  "and" => '\A\&\&',
				  "or" => '\A\|\|',
				  "and bits" => '\A\&',
				  "xor bits" => '\A\^',
				  "or bits" => '\A\|',
				  "semicolon" => '\A\;',
				  "comma" => '\A\,',
				  "left parenthesis" => '\A\(',
				  "right parenthesis" => '\A\)');

	foreach my $key (keys %regexHash) {

		if ($self->str() =~ /$regexHash{$key}/x) {

			if ($key eq "identifier" or $key eq "bit array" or $key eq "integer" or $key eq "string" or $key eq "boolean") {
				$self->hasValue(1);
				return $key;

			} elsif ($key eq "reserved") {
				return $self->str();

			} 

			return $key;
		}
	}

	return "error";
}

sub to_str {

	my $self = shift;
	my $type = $self->type();
	my $str = $self->str();
	my $line = $self->line();
	my $column = $self->column();


	if ($type eq "error") {
		return "Error: Se encontró un caracter inesperado `$str` en la Línea $line, Columna $column.\n";
	} elsif ($self->hasValue()) {
		return "$type at line $line, column $column with value `$str`\n";
	} else{
		return "$type at line $line, column $column\n";
	}
}

1;