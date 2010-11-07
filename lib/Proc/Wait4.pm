package Proc::Wait4;

use strict;
use warnings;
use base qw(Exporter);
our $VERSION = '0.1';
our(@ISA, @EXPORT_OK, %EXPORT_TAGS);

eval {
    require XSLoader;
    XSLoader::load(__PACKAGE__, $VERSION);
    1;
} or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    __PACKAGE__->bootstrap($VERSION);
};

@EXPORT_OK = qw(wait4);
%EXPORT_TAGS = (all => \@EXPORT_OK);

1;
__END__

=head1 NAME

Proc::Wait4 - wait4 interface xs module

=head1 VERSION

0.1

=head1 SYNOPSIS

  use strict;
  use warnings;
  use Proc::Wait4 qw(wait4);
  use POSIX qw(:sys_wait_h);

  my $pid = fork;
  if ($pid) {
    print "parent process[$pid] fork success\n";
  } elsif ($pid == 0) {
    print "child process[$pid] execute start\n";
	# anything to heavy execute...
    print "child process[$pid] execute end\n";
	exit;
  } else {
    die "fork faild. $!";
  }
  
  my($waitpid, $status, $rusage) = wait4($pid, 0);
  my $exit_value = WEXITSTATUS($status);
  my $signal_num = WTERMSIG($status);
  print "child process[$waitpid] reap!. exit_value:$exit_value signal_num:$signal_num\n";

=head1 DESCRIPTION

Proc::Wait4 is wait4 interface xs module. However, this module is still experimental

=head1 METHOD

=head2 wait4

wait4 system call. see SYNOPSIS

=head1 NOTES

This module is a version while developing at the time of test only with CentOS.

=head1 SEE ALSO

wait4(2) man page

=head1 AUTHOR

Akira Horimoto

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
