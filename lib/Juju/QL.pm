package Juju::QL;

# ABSTRACT: juju plugin for querying state server

use Mojo::Base -base;
use Mojo::Log;
use Getopt::Long qw[GetOptions :config pass_through];

has 'log' => sub { my $self = shift; Mojo::Log->new };
has 'description' => sub {
    print <<EOF;
usage: juju ql "select * from machines"
Making querying juju machines ez-pz

juju-ql is a simple query tool against a juju state service. Supports
SQL like syntax and a few options to format the print output (ie JSON, Ascii Table,
YAML formats).
EOF
    exit;
};

has 'usage' => sub {
    my $self = shift;
    $self->description;
    print <<EOF;
Examples:
  juju ql --query="select * from machines" --to-table
  juju ql --query="select MachineId from machines" --to-json
EOF
    exit;
};

sub query {
    my ($self, $query) = @_;
    $self->log->info(sprintf("Performing query: %s", $query));
}

sub run {
    my $self = shift;
    my ($help, $query);
    my $res = GetOptions(
        'help'     => \$help,
        'query=s' => \$query
    );

    if ($help || (!$ARGV[0] && !$query)) {
        $self->usage;
    }

    if ($query) {
        $self->query($query);
    }
}

1;
