use Test::More 'no_plan';
use_ok("Bryar::DataSource::FlatFile");

# Test the all_documents method exists
ok(Bryar::DataSource::FlatFile->can("all_documents"), "We can call all_documents");
# Test the search method exists
ok(Bryar::DataSource::FlatFile->can("search"), "We can call search");

use Bryar;

my $bryar = new Bryar(datadir=>"./t/");

my @documents = $bryar->{config}->source->all_documents($bryar);
is(@documents, 2, "We got two documents");
is($documents[0]->title, "First entry", "First title correct");
like($documents[0]->content, qr/flatfile format/, "First content correct");
