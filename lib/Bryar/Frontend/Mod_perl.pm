package Bryar::Frontend::Mod_perl;
use 5.006;
use strict;
use warnings;
use Carp;
our $VERSION = '1.0';

=head1 NAME

Bryar::Frontend::Mod_perl - 

=head1 SYNOPSIS

	$self->new(...);
	$self->parse_args(...);
	$self->output(...);

=head1 DESCRIPTION

This is an Bryar Apache handler for mod_perl.

=head1 METHODS

=head2 new

    $self->new

Creates a new Bryar::Frontend::Mod_perl instance.

=cut


sub new {
    my $class = shift;
    my %args = @_;
    my $self = bless {

    }, $class;
    return $self;
}


=head2 parse_args

    $self->parse_args

This is a useful method, and should have a useful description.

=cut

sub parse_args {
    my $self = shift;
    die "This doesn't work yet. Sorry";
    #...
}


=head2 output

    $self->output

This is a useful method, and should have a useful description.

=cut

sub output {
    my $self = shift;
    #...
}




=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.


=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>


=head1 SEE ALSO





1;
