use Test::More 'no_plan';
use Cwd;
use_ok("Bryar::Renderer::TT");

# Test the generate_html method exists
ok(Bryar::Renderer::TT->can("generate_html"), "We can call generate_html");
# Test the generate_rss method exists
ok(Bryar::Renderer::TT->can("generate_rss"), "We can call generate_rss");

# Let's bust it.
use Bryar;

my $bryar = Bryar->new(datadir=> cwd()."/t/");
my @documents = $bryar->{config}->source->all_documents($bryar);
my $page = $bryar->{config}->renderer->generate_html($bryar, @documents);
like($page, qr/Boring.*first blog.*second blog/sm, "Page processed OK");
