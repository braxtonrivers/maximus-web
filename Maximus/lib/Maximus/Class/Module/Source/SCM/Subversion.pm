package Maximus::Class::Module::Source::SCM::Subversion;
use Moose;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';

=head1 NAME

Maximus::Class::Module::Source::SCM::Subversion - Handles module sources inside
a Subversion repository

=head1 SYNOPSIS

	use Maximus::Class::Module::Source::SCM::Subversion;
	my $source = Maximus::Class::Module::Source::SCM::Subversion->new;

=head1 DESCRIPTION

Subversion support for retrieving the modules sources.

=head1 ATTRIBUTES

=head2 repository

Location of remote Git repository. Must be publicly readable
=cut
has 'repository' => (is => 'rw', 'isa' => 'Str', required => 1);

=head2 trunk

Path to trunk. If the repository hosts more modules then set it to the module
path, e.g. trunk/my.mod
=cut
has 'trunk' => (is => 'rw', 'isa' => 'Str', default => 'trunk');

=head2 tags

Path to tags. If the repository hosts more modules then set I<tagsFilter> to
filter the listing.
=cut
has 'tags' => (is => 'rw', 'isa' => 'Str', default => 'tags');

=head2 tagsFilter

If the repository hosts more modules then set this to filter the listing.
e.g.: C<^my\.mod-> if this module uses tags in the style of I<my.mod-0.01> or
I<my.mod-0.3.0>.
=cut
has 'tagsFilter' => (is => 'rw', 'isa' => 'Str', default => '');

=head1 METHODS

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010 Christiaan Kras

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut

__PACKAGE__->meta->make_immutable;

1;
