package Bryar::DataSource::FlatFile;
use Cwd;
use Bryar::Document;
use File::Find::Rule;
use 5.006;
use strict;
use warnings;
use Carp;
use Cwd;
our $VERSION = '1.0';

=head1 NAME

Bryar::DataSource::FlatFile - Blog entries from flat files, a la blosxom

=head1 SYNOPSIS

	$self->all_documents(...);
	$self->search(...);

=head1 DESCRIPTION

Just like C<blosxom>, this data source pulls blog entries out of flat
files in the file system. 

=head1 METHODS

=head2 all_documents

    $self->all_documents

Returns all documents making up the blog.

=cut

sub all_documents {
    my ($self, $bryar) = @_;
    croak "Must pass in a Bryar object" unless UNIVERSAL::isa($bryar, "Bryar");
    my $where = cwd;
    chdir($bryar->{config}->datadir); # Damn you, F::F::R.
    my @docs = map { $self->make_document($_) }
                File::Find::Rule->file()
                                ->name("*.txt")
                                ->maxdepth($bryar->{config}->depth)
                                ->in(".");
    chdir($where);
    return @docs;
}


=head2 search

    $self->search($bryar, %params)

A more advanced search for specific documents

=cut

sub search {
    my ($self, $bryar, %params) = @_;
    croak "Must pass in a Bryar object" unless UNIVERSAL::isa($bryar, "Bryar");
    my $was = cwd;
    my $where = $bryar->{config}->datadir."/";
    if ($params{subblog}) { $where .= $params{subblog}; }
    chdir($where); # Damn you, F::F::R.
    
    my $find = File::Find::Rule->file();
    if ($params{id}) { $find->name("$params{id}.txt") }
                else { $find->name("*.txt") }
    $find->maxdepth($bryar->{config}->depth);
    if ($params{since})   { $find->mtime(">".$params{since}) }
    if ($params{before})  { $find->mtime("<".$params{before}) }
    if (!$params{limit}) {
        my @docs = map { $self->make_document($_) } $find->in(".");
        chdir($was);
        return @docs;
    }

    my @docs =  map { $self->make_document($_) } 
                (
                    map { $_->[0] }
                    sort { $b->[1] <=> $a->[1] }
                    map { [$_, ((stat$ _)[9]) ] }
                    $find->in(".")
                ) [0..$params{limit}-1];
    
    chdir($was);
    return @docs;
}

=head2 make_document

Turns a filename into a C<Bryar::Document>, by parsing the file
blosxom-style.

=cut

sub make_document {
    my ($self, $file) = @_;
    return unless $file;
    open(my($in), $file) or return;
    my $when = (stat $file)[9];
    my $who = getpwuid((stat $file)[4]);
    $file =~ s/\.txt$//;
    my $title = <$in>;
    chomp $title;
    local $/;
    my $content = <$in>;
    close $in;
    return Bryar::Document->new(
        title   => $title,
        content => $content,
        epoch   => $when,
        author  => $who,
        id      => $file,
    );
}

=head1 LICENSE

This module is free software, and may be distributed under the same
terms as Perl itself.

=head1 AUTHOR

Copyright (C) 2003, Simon Cozens C<simon@kasei.com>

=cut

1;
