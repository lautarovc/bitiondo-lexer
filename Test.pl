use Token;

$tokensito = Token->new(str => 'tata', line => 0, column => 0);

printf $tokensito->to_str()