package Bryar::Renderer::TT;
use 5.006;
use strict;
use warnings;
use Carp;
use Template;
our $VERSION = '1.0';

=head1 NAME

Bryar::Renderer::TT - Render a blog page with Template Toolkit

=head1 SYNOPSIS

	$self->generate_html(...);
	$self->generate_rss(...);

=head1 DESCRIPTION

This takes a Bryar blog, and the documents selected by the
C<Bryar::Collector>, and turns them into a page. 

You'll probably want to read a Template Toolkit tutorial before mucking
with the templates. Take a look at http://www.template-toolkit.org/

This module passes in an array called C<documents>, full of
L<Bryar::Document|Bryar::Document> objects, and a C<Bryar> object which
is most useful for calling the C<config> method on to extract things
from the L<Bryar::Config|Bryar::Config>.

=head1 METHODS

=head2 generate_html

    $self->generate_html($bryar, @documents)

Returns a HTML page from templates and documents provided by the Bryar
object.

=cut

sub _tt {
    my ($class, $bryar) = @_;
    my @path = $bryar->{config}->datadir;
    unshift @path, $bryar->{config}->datadir."/".$bryar->{arguments}->{subblog} 
        if exists $bryar->{arguments}->{subblog};
        
    @path = map { $_, $_."/templates" } @path;
    return Template->new({
        INCLUDE_PATH => \@path
    });
}

sub _tt_process {
    my ($class, $filename, $bryar, @documents) = @_;
    my $output;
    my $tt = $class->_tt($bryar);
    $tt->process($filename, {
        documents => \@documents,
        bryar     => $bryar,
    }, \$output);
    if (!$output) {
        $bryar->{config}->frontend->report_error("Template Error",
<<EOF
An error occurred while processing the templates for the blog. The
error as reported by Template Toolkit was:

<PRE>
@{[ $tt->error ]}
</PRE>
EOF
        );
    }
    return $output;
}

sub generate_html {
    my $class = shift;
    $class->_tt_process("template.html", @_);
}

=head2 generate_rss

    Bryar::Renderer::TT->generate_rss

This is a useful method, and should have a useful description.

=cut

sub generate_rss {
    my $class = shift;
    $class->_tt_process("template.rss", @_);
}




=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.


=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>


=head1 SEE ALSO





1;
