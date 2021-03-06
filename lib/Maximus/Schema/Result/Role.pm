package Maximus::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::Role

=cut

__PACKAGE__->table("role");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 role

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=cut

__PACKAGE__->add_columns(
    "id",
    {   data_type         => "integer",
        extra             => {unsigned => 1},
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "role",
    {data_type => "varchar", is_nullable => 0, size => 25},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("idx_role_1", ["role"]);

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<Maximus::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
    "user_roles",
    "Maximus::Schema::Result::UserRole",
    {"foreign.role_id" => "self.id"}, {},
);


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45


=head2 sqlt_deploy_hook

Force MySQL to use InnoDB and UTF-8

=cut

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8'
    );
}

__PACKAGE__->meta->make_immutable;
1;
