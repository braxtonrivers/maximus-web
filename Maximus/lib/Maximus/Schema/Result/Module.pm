package Maximus::Schema::Result::Module;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::Module

=cut

__PACKAGE__->table("module");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 scm_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 modscope_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 desc

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "scm_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "modscope_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "desc",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("Index_3", ["modscope_id", "name"]);

=head1 RELATIONS

=head2 scm

Type: belongs_to

Related object: L<Maximus::Schema::Result::Scm>

=cut

__PACKAGE__->belongs_to(
  "scm",
  "Maximus::Schema::Result::Scm",
  { id => "scm_id" },
  { join_type => "LEFT" },
);

=head2 modscope

Type: belongs_to

Related object: L<Maximus::Schema::Result::Modscope>

=cut

__PACKAGE__->belongs_to(
  "modscope",
  "Maximus::Schema::Result::Modscope",
  { id => "modscope_id" },
  {},
);

=head2 module_versions

Type: has_many

Related object: L<Maximus::Schema::Result::ModuleVersion>

=cut

__PACKAGE__->has_many(
  "module_versions",
  "Maximus::Schema::Result::ModuleVersion",
  { "foreign.module_id" => "self.id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-07-25 09:37:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oA6eai+ptG/K8n/BsLUl6A

1;
