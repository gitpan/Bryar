package Bryar::Frontend::CGI;
use 5.006;
use strict;
use warnings;
use Carp;
our $VERSION = '1.0';
use CGI qw/:standard :netscape/;
use Time::Piece;
use Time::Local;

=head1 NAME

Bryar::Frontend::CGI - Common Gateway Interface to Bryar

=head1 SYNOPSIS

	$self->parse_args(...);
	$self->output(...);

=head1 DESCRIPTION

This is a frontend to Bryar which is used when Bryar is being driven as
an ordinary CGI program.

=head1 METHODS

=head2 parse_args

    $self->parse_args

This is a useful method, and should have a useful description.

=cut

sub parse_args {
    my $self = shift;
    my $bryar = shift;
    my $url = url();
    my %args;
    my $pi = path_info();
    my @pi = split m{/}, $pi;
    shift @pi while @pi and not$pi[0];
    return unless @pi;
    #...
    if ($pi[-1] eq "xml")     { $args{xml} = 1; pop @pi; }
    if ($pi[-1] =~ /id_(.*)/) { $args{id} = $1; pop @pi; }
    if ($pi[0] =~ /^([a-zA-Z]\w*)/) { # We have a subblog
        $args{subblog} = $1;
        shift @pi;
    }
    if (@pi) { # Time/date handling
        my ($from, $til) = _make_from_til(@pi);
        if ($from and $til) {
            $args{before} = $til;
            $args{since} = $from;
        }
    } else {
        $args{limit}   = $bryar->config->recent if $args{subblog};
    }

    return %args;
}

my $mon = 0;
my %mons = map { $_ => $mon++ }
    qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

sub _make_from_til {
    my ($y, $m, $d) = @_;
    if (!$y) { return (0,0) }
    my ($fm, $tm) = (0, 11);
    if ($m and exists $mons{$m}) { $fm = $tm = $mons{$m}; }
    my ($fd, $td);
    if ($d) { $fd = $td = $d }
    else { 
        $fd = 1;
        my $when = timelocal(0,0,0,1, $tm, $y);
        $td = Time::Piece->new($when)->month_last_day;
    }
    return (timelocal(0,0,0, $fd, $fm, $y),
            timelocal(59,59,23, $td, $tm, $y));
}


=head2 output

    $self->output

This is a useful method, and should have a useful description.

=cut

sub output {
    my ($self, $ct, $data) = @_;
    print "Content-type: $ct\n\n$data";
}

=head2 report_error

    $self->report_error($title, $message)

Used when something went horribly wrong inside Bryar. Spits out the
error in as friendly a way as possible to the browser.

=cut

sub report_error {
    my ($class, $title, $message) = @_;

    print STDOUT "Content-type: text/html\n\n";
    print STDOUT "<H1>$title</H1>\n\n$message";
    exit;
}

sub init {
    my ($self, $bryar) = @_;
    my $url = url();
    if (!$bryar->config->baseurl) {
        $bryar->config->baseurl($url) if $url =~ s/(bryar.cgi).*/$1/;
    }
}
=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.


=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>


=head1 SEE ALSO





1;
