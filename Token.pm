package Token;
use Moose;

has 'str' => (is => 'rw');
has 'line' => (is => 'rw');
has 'column' => (is => 'rw');
has 'type' => (reader => 'get_type', builder =>'_build_type');
has 'hasValue' => (is => 'rw', init_arg => 0);

sub _build_type {
	%regexHash = ("Spaces" => /\A(\s)+/,
					  "reserved" => /\Abegin\b | \Aend\b  | \Aint\b  | \Abool\b  | \Abits\b  | \Ainput\b  | \Aoutput\b  | \Aoutputln\b  | \Aif\b  |
					               \Aelse\b  | \Afor\b  | \Aforbits\b  | \Aas\b  | \Afrom\b  | \Agoing\b  | \Ahigher\b  | \Alower\b  | \Arepeat\b  |
					               \Awhile\b | \Ado\b/x,
					  "boolean" => /\Atrue\b | \Afalse\b/x,
					  "identifier" => /\A[a-zA-Z][a-zA-Z0-9_]*/,
					  "bit array" => /\A0b[01]+/,
					  "integer" => /\A(\d)+/,
					  "string" => /\A"(\\.|[^\\\"\n])*"/,
					  "left bracket" => /\A\[/,
					  "right bracket" => /\A\]/,
					  "not bits" => /\A\~/,
					  "dollar" => /\A\$/,
					  "at" => /\A\@/,
					  "minus" => /\A\-/,
					  "product" => /\A\*/,
					  "division" => /\A\//,
					  "module" => /\A\%/,
					  "plus" => /\A\+/,
					  "left displacement" => /\A\<\</,
					  "right displacement" => /\A\>\>/,
					  "less or equal than" => /\A\<\=/,
					  "more or equal than" => /\A\>\=/,
					  "less than" => /\A\</,
					  "more than" => /\A\>/,
					  "equals" => /\A\=\=/,
					  "not equal" => /\A\!\=/,
					  "not" => /\A\!/,
					  "assign" => /\A\=/,
					  "and" => /\A\&\&/,
					  "or" => /\A\|\|/,
					  "and bits" => /\A\&/,
					  "xor bits" => /\A\^/,
					  "or bits" => /\A\|/,
					  "semicolon" => /\A\;/,
					  "comma" => /\A\,/,
					  "left parenthesis" => /\A\(/,
					  "right parenthesis" => /\A\)/)

	foreach $key (keys %regexHash) {
		$regex = $regexHash{$key};
		$self = shift;

		if ($self->str() =~ $regex) {

			if ($key == "identifier" or keyStr == "bit array" or keyStr == "integer" or keyStr == "string" or keyStr == "boolean") {
				$self->hasValue(1);
				return $key;

			} elsif ($key =="reserved") {
				return $self->str();

			} 

			return $key;
		}
	}

	return "error"
}

sub to_str {

	$self = shift;
	$type = $self->get_type()
	$str = $self->str()
	$line = $self->line()
	$column = $self->column()


	if ($type == "error")
		puts "Error: Se encontró un caracter inesperado `$str` en la Línea $line, Columna $column."


	elsif ($self->hasValue())
		puts "$type at line $line, column $column with value `$str`"

	else
		puts "$type at line $line, column $column"

}

1;