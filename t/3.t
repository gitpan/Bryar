use Test::More 'no_plan';
use_ok("Bryar::Frontend::Mod_perl");

# Test constructor
my $object = Bryar::Frontend::Mod_perl->new();
isa_ok($object, "Bryar::Frontend::Mod_perl");
# Do all data members have the right value?


# Test the parse_args method exists
ok($object->can("parse_args"), "We can call parse_args");
# Test the output method exists
ok($object->can("output"), "We can call output");

