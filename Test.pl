use Lexer;

@file = ("begin\n", "# Soy un comentario, no un token\n", "id = 50\n", "end");

$lexer = Lexer->new(file => \@file);


$lexer->readFile();

$tokens = $lexer->tokens();

foreach my $tok (@$tokens) {
	print $tok->to_str();
}

$token = Token->new(str => 'end', line => 0, column => 0);
