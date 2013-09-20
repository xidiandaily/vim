#ifndef _TUX_MODULE_H
#define _TUX_MODULE_H

/*
 * TUX - Integrated HTTP layer and Object Cache
 *
 * Copyright (C) 2000, Ingo Molnar <mingo@redhat.com>
 *
 * module.h: user-space portions of the HTTP module API
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <malloc.h>
#include <fcntl.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/tcp.h>

#include <tux.h>

extern char *TUXAPI_version;
extern unsigned long TUXAPI_version_len;
extern char *TUXAPI_docroot;
extern unsigned long TUXAPI_docroot_len;
extern char *TUXAPI_servername;
extern unsigned long TUXAPI_servername_len;

extern char **TUXAPI_modulename_array;

#define CGI_SERVER_NAME(req) TUXAPI_servername
#define CGI_SERVER_NAME_LEN(req) TUXAPI_servername_len
#define CGI_GATEWAY_INTERFACE(req) "CGI/1.1"
#define CGI_SERVER_PROTOCOL(req) \
		(((req)->http_version == HTTP_1_1) ? "HTTP/1.1" : "HTTP/1.0")
#define CGI_SERVER_PORT(req) 80
#define CGI_REQUEST_METHOD(req) ({  			\
	char *__res;					\
							\
        switch ((req)->http_method) 			\
        {						\
                case METHOD_GET:			\
                        __res = "GET"; break;		\
                case METHOD_POST:			\
                        __res = "POST"; break;		\
                case METHOD_HEAD:			\
                        __res = "HEAD"; break;		\
                case METHOD_PUT:			\
                        __res = "PUT"; break;		\
                default:				\
                        __res = "NONE"; break;		\
        }						\
	__res;						\
})
#define CGI_HTTP_ACCEPT(req) ((req)->accept)
#define CGI_HTTP_USER_AGENT(req) ((req)->user_agent)
#define CGI_HTTP_REFERER(req) ((req)->referer)
#define CGI_PATH_TRANSLATED(req) (TUXAPI_docroot)
#define CGI_DOCUMENT_ROOT(req) (TUXAPI_docroot)
#define CGI_PATH_INFO(req) ((req)->query)
#define CGI_SCRIPT_NAME(req) (TUXAPI_modulename_array[(req)->module_index])
#define CGI_QUERY_STRING(req) ((req)->query)

// For the time being you'll have to use ACTION_GET_HEADERS 
// and decode the info yourself if you want to do authentication.

#define CGI_REMOTE_USER(req) ""
#define CGI_REMOTE_AUTH_TYPE(req) ""
#define CGI_ANNOTATION_SERVER(req) ""

#define CGI_CONTENT_TYPE(req) ((req)->content_type)

extern int tux (unsigned int action, user_req_t *req);

extern void * TUXAPI_malloc_shared (unsigned int len);
extern char * TUXAPI_alloc_read_objectbuf (user_req_t *req, int fd);
extern void TUXAPI_free_objectbuf (user_req_t *req, void *buf);

/* queueing functions */
#if 0
/* the queueing API is not yet mature */
void * TUXAPI_create_queue_anonymous(void);
void * TUXAPI_create_queue(char *queue_name);
int TUXAPI_remove_queue(void *queue_handle);
int TUXAPI_enqueue_request(user_req_t *req, void *queue_handle);
int TUXAPI_enqueue_request_by_name(user_req_t *req, char *queue_name);
int TUXAPI_dequeue_request(void *queue_handle);
int TUXAPI_dequeue_request_by_name(char *queue_name);
#endif

#define BUG()								\
do {									\
	printf("TUX BUG at %d:%s!\n", __LINE__, __FILE__);		\
	tux(TUX_ACTION_STOPTHREAD, NULL);				\
	tux(TUX_ACTION_SHUTDOWN, NULL);					\
	*(int*)0=0;							\
	exit(-1);							\
} while (0)

#ifdef __i386__

#define LOCK_PREFIX "lock ; "

#define barrier() __asm__ __volatile__("": : :"memory")
struct __dummy { unsigned long a[100]; };
#define ADDR (*(volatile struct __dummy *) addr)

extern __inline__ int test_and_set_bit(int nr, volatile void * addr)
{
	int oldbit;

	__asm__ __volatile__( LOCK_PREFIX
		"btsl %2,%1\n\tsbbl %0,%0"
		:"=r" (oldbit),"=m" (ADDR)
		:"Ir" (nr));
	return oldbit;
}

extern __inline__ void TUXAPI_down (int *sem)
{
	while (test_and_set_bit(0, sem))
		barrier();
}

extern __inline__ void TUXAPI_up (int *sem)
{
	*((volatile int *)sem) = 0;
}

#elif defined(__powerpc__)

extern __inline__ void TUXAPI_down (int *sem)
{
	unsigned int tmp;

	__asm__ __volatile__(
	"b		2f\n\
1:	lwzx		%0,0,%1\n\
	cmpwi		0,%0,0\n\
	bne+		1b\n\
2:	lwarx		%0,0,%1\n\
	cmpwi		0,%0,0\n\
	bne-		1b\n\
	stwcx.		%2,0,%1\n\
	bne-		2b\n\
	isync"
	: "=&r"(tmp)
	: "r"((volatile int *)sem), "r"(1)
	: "cr0", "memory");
}

extern __inline__ void TUXAPI_up (int *sem)
{
	__asm__ __volatile__("lwsync": : :"memory");
	*((volatile int *)sem) = 0;
}

#elif defined(__ia64)

#include <ia64intrin.h>

static inline void
TUXAPI_down (int *sem)
{
	while (!__sync_bool_compare_and_swap(sem, 0, 1)) {
		while (*(volatile int *)sem)
			asm volatile ("hint @pause");
	}
}

static inline void
TUXAPI_up (int *sem)
{
	*((volatile int *)sem) = 0;
}

#else

#warning Using generic TUXAPI locks - not SMP safe
#define barrier() __asm__ __volatile__("": : :"memory")

extern __inline__ int test_and_set_bit(int nr, volatile void * addr)
{
	int oldbit;
	volatile unsigned long *foo;

	foo = addr;
	oldbit = (*foo >> nr) & 1;
	*foo = *foo | (1<<nr);

	return oldbit;
}

extern __inline__ void TUXAPI_down (int *sem)
{
	while (test_and_set_bit(0, sem))
		barrier();
}

extern __inline__ void TUXAPI_up (int *sem)
{
	*((volatile int *)sem) = 0;
}

#endif

#define TUX_DEBUG 0

#if TUX_DEBUG
# define Dprintk(x...) do { printf(x); fflush(stdout); } while (0)
#else
# define Dprintk(x...) do { } while (0)
#endif

#define HTTP_TRACE(req,info) Dprintk("HTTP trace at %s:%d, request %p, info %d, event %d (meth:%d, query:%s, cookies:%s).\n", __FILE__, __LINE__, (req)->id, info, (req)->event, (req)->http_method, (req)->query, (req)->cookies_len ? (req)->cookies : "<no cookies>")

#endif
