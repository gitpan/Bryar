use Test::More 'no_plan';
use_ok("Bryar::Frontend::Mod_perl");

$class = "Bryar::Frontend::Mod_perl";
# Test the parse_args method exists
ok($class->can("parse_args"), "We can call parse_args");
# Test the output method exists
ok($class->can("output"), "We can call output");

