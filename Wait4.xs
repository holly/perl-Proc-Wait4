/* --------------------- C CODE ---------------------- */
#define PERL_NO_GET_CONTEXT
#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/wait.h>
#ifdef __cplusplus
}
#endif

/*
#ifndef __linux
#error "No linux. Compile aborted."
#endif
*/

static void store_hv_for_longval (pTHX_ HV* hv, const char* key, long val) {
	hv_store(hv, key, strlen(key), newSViv(val), 0);
}

static void store_hv_for_timeval (pTHX_ HV* hv, const char* key, struct timeval* tv) {

	hv_store(hv, key, strlen(key), newSVnv(tv->tv_sec + (float)tv->tv_usec * 1e-6), 0);
}

/* --------------------- XS CODE ---------------------- */
MODULE = Proc::Wait4  PACKAGE = Proc::Wait4
PROTOTYPES: ENABLE

void
wait4(int pid, int option)
PREINIT:
	pid_t result_pid;
	int status;
	struct rusage ru;

	HV* hv = newHV();
PPCODE:
	result_pid = wait4((pid_t)pid, &status, option, &ru);
	
	EXTEND(sp, 3);
	if (result_pid > 0) {
		store_hv_for_timeval(aTHX_ hv, "ru_utime", &ru.ru_utime);
		store_hv_for_timeval(aTHX_ hv, "ru_stime", &ru.ru_stime);

		store_hv_for_longval(aTHX_ hv, "ru_maxrss", ru.ru_maxrss);
		store_hv_for_longval(aTHX_ hv, "ru_ixrss", ru.ru_ixrss);
		store_hv_for_longval(aTHX_ hv, "ru_idrss", ru.ru_idrss);
		store_hv_for_longval(aTHX_ hv, "ru_isrss", ru.ru_isrss);
		store_hv_for_longval(aTHX_ hv, "ru_minflt", ru.ru_minflt);
		store_hv_for_longval(aTHX_ hv, "ru_majflt", ru.ru_majflt);
		store_hv_for_longval(aTHX_ hv, "ru_nswap", ru.ru_nswap);
		store_hv_for_longval(aTHX_ hv, "ru_inblock", ru.ru_inblock);
		store_hv_for_longval(aTHX_ hv, "ru_oublock", ru.ru_oublock);
		store_hv_for_longval(aTHX_ hv, "ru_msgsnd", ru.ru_msgsnd);
		store_hv_for_longval(aTHX_ hv, "ru_msgrcv", ru.ru_msgrcv);
		store_hv_for_longval(aTHX_ hv, "ru_nsignals", ru.ru_nsignals);
		store_hv_for_longval(aTHX_ hv, "ru_nvcsw", ru.ru_nvcsw);
		store_hv_for_longval(aTHX_ hv, "ru_nivcsw", ru.ru_nivcsw);
	}
	PUSHs(sv_2mortal(newSViv(result_pid)));
	PUSHs(sv_2mortal(newSViv(status)));
	PUSHs(sv_2mortal(newRV_noinc((SV*)hv)));
