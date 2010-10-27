use strict;
use warnings;
use Proc::Wait4 qw(:all);
use constant HAS_LEAKTRACE => eval{ require Test::LeakTrace };
use Test::More HAS_LEAKTRACE ? (tests => 1) : (skip_all => 'require Test::LeakTrace');
use Test::LeakTrace;
use POSIX qw(:sys_wait_h);


leaks_cmp_ok{

	my $pid = fork;
	if ($pid) {
		my($reaped_pid, $status, $ru) = wait4($pid, 0);
	} elsif ($pid == 0) {
		sleep 1;
		exit;
	} else {
		die "can not fork. $!";
	}

} '<', 1;
