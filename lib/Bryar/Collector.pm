package Bryar::Collector;
use 5.006;
use strict;
use warnings;
use Carp;
our $VERSION = '1.0';

=head1 NAME

Bryar::Collector - Determine which documents to show

=head1 SYNOPSIS

	$self->collect(...);
	$self->collect_current(...);

=head1 DESCRIPTION

This class is called upon to pick out the right number of the relevant
blog documents, so that they can be shipped off to the renderer.

=head1 METHODS

=head2 collect

    $self->collect

Return the right number of documents, based on the arguments passed in
by the user.

=cut


sub collect {
    my $class = shift;
    my $bryar = shift;
    croak "Must pass in a Bryar object" unless UNIVERSAL::isa($bryar, "Bryar");
    my %args = @_;
    $bryar->{arguments} = \%args;
    delete $args{xml}; # Not interesting
    if (! keys %args) { # Default operation
        return $class->collect_current($bryar);
    }
    my @docs = sort {$b->epoch <=> $a->epoch }
        $bryar->{config}->source->search($bryar, %args);
    return @docs;
}


=head2 collect_current

    $self->collect_current

Return the latest set of documents.

=cut

sub collect_current {
    my $self = shift;
    my $bryar = shift;
    croak "Must pass in a Bryar object" unless UNIVERSAL::isa($bryar, "Bryar");
    my @docs = sort {$b->epoch <=> $a->epoch }
                $bryar->{config}->source->search(
                    $bryar,
                    limit => $bryar->{config}->recent());
    return @docs;
}


=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.


=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>


=head1 SEE ALSO





1;
