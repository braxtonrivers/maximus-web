use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Module::Source::SCM::Subversion' }
BEGIN { use_ok 'Maximus::Class::Module' }
BEGIN { use_ok 'Archive::Extract' }
BEGIN { use_ok 'Path::Class' }
BEGIN { use_ok 'File::Temp' }

my $zip = Path::Class::File->new('t', 'data', 'svnrepo.zip');
my $tmp_dir = File::Temp->newdir(CLEANUP => 1);
my $ae = Archive::Extract->new(archive => $zip->stringify, type => 'zip');
Maximus::Exception::Module::Archive->throw(error => $ae->error)
  unless $ae->extract(to => $tmp_dir);

my $localrepo_tmp_dir = File::Temp->newdir(CLEANUP => 1);
my $localrepo         = Path::Class::Dir->new($localrepo_tmp_dir);
my $svndir            = Path::Class::Dir->new($tmp_dir->dirname, 'svnrepo');
my $scm               = new_ok(
    'Maximus::Class::Module::Source::SCM::Subversion' => [
        (   local_repository => $localrepo->stringify,
            repository       => 'file:///'
              . $svndir->volume
              . $svndir->as_foreign('Unix'),
            trunk       => 'trunk',
            tags        => 'tags',
            tags_filter => 'mod2-(.+)',
        )
    ]
);

can_ok(
    $scm, qw/
      get_latest_revision
      get_versions
      repository
      trunk
      tags
      tags_filter
      prepare
      auto_discover
      apply_scm_settings
      /
);

my %got_versions      = $scm->get_versions();
my %expected_versions = (
    '0.01' => 'mod2-0.01/',
    '0.02' => 'mod2-0.02/',
    '0.03' => 'mod2-0.03/',
);
is_deeply(\%got_versions, \%expected_versions, 'Fetch expected versions');

is($scm->get_latest_revision(), '11', 'Latest revision check');

my $mod = Maximus::Class::Module->new(
    modscope => 'test',
    mod      => 'mod2',
    desc     => 'A test module',
    source   => $scm,
);

foreach (qw/0.01 0.02 0.03 dev/) {
    $scm->validated(0);
    $scm->version($_);
    $scm->prepare($mod);
    ok($scm->validated, sprintf('test.mod2 %s validated', $_));
}

# Auto discover modules.
my @got_auto_discover = $scm->auto_discover();
my @expected_auto_discover =
  (['test', 'mod2', undef], ['test', 'mod3', undef]);
is_deeply(\@got_auto_discover, \@expected_auto_discover,
    'Automatic discovery OK');

done_testing();
