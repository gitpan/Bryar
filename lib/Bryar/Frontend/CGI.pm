package Bryar::Frontend::CGI;
use base 'Bryar::Frontend::Base';
use 5.006;
use strict;
use warnings;
use Carp;
our $VERSION = '1.1';
use CGI qw/:standard :netscape/;

=head1 NAME

Bryar::Frontend::CGI - Common Gateway Interface to Bryar

=head1 DESCRIPTION

This is a frontend to Bryar which is used when Bryar is being driven as
an ordinary CGI program.

=cut

sub obtain_url { url() }
sub obtain_path_info { path_info() }
sub obtain_params { my $cgi = new CGI; map { $_ => $cgi->param($_) } $cgi->param }
sub send_data { my $self = shift; print "\n",@_ }
sub send_header { my ($self, $k, $v) = @_; print "$k: $v\n"; }

1;

=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.

=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>
