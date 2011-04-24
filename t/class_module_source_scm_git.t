use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Module::Source::SCM::Git' }
BEGIN { use_ok 'Maximus::Class::Module' }
BEGIN { use_ok 'Archive::Zip;' }
BEGIN { use_ok 'Archive::Extract' }
BEGIN { use_ok 'Path::Class' }
BEGIN { use_ok 'File::Temp' }

my $zip = Path::Class::File->new('t', 'data', 'gitbarerepo.zip');
my $tmp_dir = File::Temp->newdir(CLEANUP => 1);
my $ae = Archive::Extract->new(archive => $zip->stringify, type => 'zip');
Maximus::Exception::Module::Archive->throw(error => $ae->error)
  unless $ae->extract(to => $tmp_dir);

my $localrepo_tmp_dir = File::Temp->newdir(CLEANUP => 1);
my $localrepo = Path::Class::Dir->new($localrepo_tmp_dir);
my $gitrepodir = Path::Class::Dir->new($tmp_dir->dirname, 'gitbarerepo');
my $scm        = new_ok(
    'Maximus::Class::Module::Source::SCM::Git' => [
        (   local_repository => $localrepo->stringify,
            repository       => $gitrepodir->stringify,
            tags_filter      => 'v?(.+)',
        )
    ]
);

can_ok(
    $scm, qw/
      get_latest_revision
      get_versions
      repository
      local_repository
      tags_filter
      prepare
      auto_discover
      /
);

my %got_versions      = $scm->get_versions();
my %expected_versions = (
    '2.0.1' => 'e4e2fd334e1af3923cbffcff55d4252bf23526bb',
    '2.0.2' => '3d9cffafaff551fe8cbf1a17f14ae15ea757e717',
    '2.0.3' => '2df5e26c2d2fffec7f24650fc15ccabb7a579ef5',
);
is_deeply(\%got_versions, \%expected_versions, 'Fetch expected versions');

is( $scm->get_latest_revision(),
    'fb79ce002ad52827c97a61614d21b028e5ad66e4',
    'Latest revision check'
);

my $mod = Maximus::Class::Module->new(
    modscope => 'test',
    mod      => 'mod1',
    desc     => 'A test module',
    source   => $scm,
);

foreach (qw/2.0.1 2.0.2 2.0.3 dev/) {

    # Make a new object so we get a new tmpDir everytime
    my $scm = Maximus::Class::Module::Source::SCM::Git->new(
        local_repository => $localrepo->stringify,
        repository       => $gitrepodir->stringify,
        tags_filter      => 'v?(.+)',
        version          => $_,
    );
    $scm->prepare($mod);
    ok($scm->validated, sprintf('test.mod1 %s validated', $_));
}

# Multi module repo tests
$zip = Path::Class::File->new('t', 'data', 'gitbaremultirepo.zip');
$tmp_dir = File::Temp->newdir(CLEANUP => 1);
$ae = Archive::Extract->new(archive => $zip->stringify, type => 'zip');
Maximus::Exception::Module::Archive->throw(error => $ae->error)
  unless $ae->extract(to => $tmp_dir);

$localrepo_tmp_dir = File::Temp->newdir(CLEANUP => 1);
$localrepo = Path::Class::Dir->new($localrepo_tmp_dir);
$gitrepodir = Path::Class::Dir->new($tmp_dir->dirname, 'gitbaremultirepo');
$scm        = new_ok(
    'Maximus::Class::Module::Source::SCM::Git' => [
        (   local_repository => $localrepo->stringify,
            repository       => $gitrepodir->stringify,
            version          => 'dev',
        )
    ]
);

is( $scm->get_latest_revision(),
    '149a351ed45a477815529805d4b31c3fe53c497e',
    'Latest revision check'
);

# Auto discover on multi module repo
my @got_auto_discover = $scm->auto_discover();
my @expected_auto_discover = (['test', 'test1'], ['test', 'test2']);
is_deeply(\@got_auto_discover, \@expected_auto_discover,
    'Automatic discovery OK');

$mod = Maximus::Class::Module->new(
    modscope => 'test',
    mod      => 'test2',
    desc     => 'A test 2 module',
    source   => $scm,
);

$scm->prepare($mod);
ok($scm->validated, 'test2.mod dev validated');

my $fh = File::Temp->new;
$scm->archive($mod, $fh);
$zip = new_ok('Archive::Zip' => [$fh->filename]);
my @gotMembers = sort($zip->memberNames());
my @expectedMembers = sort('test2.mod/', 'test2.mod/test2.bmx',
    'test2.mod/examples/', 'test2.mod/examples/example.bmx',
    'test2.mod/inc/',      'test2.mod/inc/other_imports.bmx',
    'test2.mod/inc/more_imports.bmx',);
is_deeply(\@gotMembers, \@expectedMembers,
    'Archive contains expected content');

done_testing();