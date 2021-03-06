package Maximus::Script::Task;
use Moose;
use YAML;
use namespace::autoclean;

with 'Catalyst::ScriptRole';

has 'task' => (
    traits        => [qw(Getopt)],
    cmd_aliases   => 't',
    isa           => 'Str',
    is            => 'ro',
    documentation => 'Task to execute',
);

has 'queue' => (
    traits        => [qw(Getopt)],
    cmd_aliases   => 'q',
    isa           => 'Bool',
    is            => 'ro',
    documentation => 'Send to queue server',
    default       => sub {0},
);

has 'dump_response' => (
    traits        => [qw(Getopt)],
    isa           => 'Bool',
    is            => 'ro',
    documentation => 'Dump response to STDOUT',
    default       => sub {0},
);

sub run {
    my $self = shift;

    # Set process name
    $0 = "Maximus Task";
    $self->_run_application;
}

sub _run_application {
    my $self = shift;
    if ($self->task) {
        my $module = sprintf('Maximus::Task::%s', $self->task);
        Class::MOP::load_class($module);
        my $task = $module->new(queue => $self->queue);
        die('Failed to run task') unless $task->run($self->extra_argv);
        print Dump($task->response) if ($self->dump_response);
    }
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Script::Task - Maximus taskrunner

=head1 SYNOPSIS

    maximus_task.pl --queue --dump_response --task Other::SessionExpire

=head1 DESCRIPTION

Runs a task for Maximus

=head1 ATTRIBUTES

=head2 task

Name of task to execute, e.g. C<SCM::Update> for L<Maximus::Task::SCM::Update>

=head2 queue

Sent task (and sub-tasks) to the queue server

=head2 dump_response

Dump response to STDOUT

=head1 METHODS

=head2 run

=head2 _run_application

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2013 Christiaan Kras

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

1;
