#ifndef _NET_TUX_U_H
#define _NET_TUX_U_H

#include <stdint.h>

/*
 * TUX - Integrated Application Protocols Layer and Object Cache
 *
 * Copyright (C) 2000, 2001, Ingo Molnar <mingo@redhat.com>
 *
 * tux_u.h: HTTP module API - HTTP interface to user-space
 */

/*
 * Different major versions are not compatible.
 * Different minor versions are only downward compatible.
 * Different patchlevel versions are downward and upward compatible.
 */
#define TUX_MAJOR_VERSION		3
#define TUX_MINOR_VERSION		0
#define TUX_PATCHLEVEL_VERSION		0

#define __KERNEL_SYSCALLS__

typedef enum http_versions {
        HTTP_1_0,
        HTTP_1_1
} http_version_t;

/*
 * Request methods known to HTTP:
 */
typedef enum http_methods {
        METHOD_NONE,
        METHOD_GET,
        METHOD_HEAD,
        METHOD_POST,
        METHOD_PUT,
	NR_METHODS
} http_method_t;

enum user_req {
	TUX_ACTION_STARTUP = 1,
	TUX_ACTION_SHUTDOWN = 2,
	TUX_ACTION_STARTTHREAD = 3,
	TUX_ACTION_STOPTHREAD = 4,
	TUX_ACTION_EVENTLOOP = 5,
	TUX_ACTION_GET_OBJECT = 6,
	TUX_ACTION_SEND_OBJECT = 7,
	TUX_ACTION_READ_OBJECT = 8,
	TUX_ACTION_FINISH_REQ = 9,
	TUX_ACTION_FINISH_CLOSE_REQ = 10,
	TUX_ACTION_REGISTER_MODULE = 11,
	TUX_ACTION_UNREGISTER_MODULE = 12,
	TUX_ACTION_CURRENT_DATE = 13,
	TUX_ACTION_REGISTER_MIMETYPE = 14,
	TUX_ACTION_READ_HEADERS = 15,
	TUX_ACTION_POSTPONE_REQ = 16,
	TUX_ACTION_CONTINUE_REQ = 17,
	TUX_ACTION_REDIRECT_REQ = 18,
	TUX_ACTION_READ_POST_DATA = 19,
	TUX_ACTION_SEND_BUFFER = 20,
	TUX_ACTION_WATCH_PROXY_SOCKET = 21,
	TUX_ACTION_WAIT_PROXY_SOCKET = 22,
	TUX_ACTION_QUERY_VERSION = 23,
	MAX_TUX_ACTION
};

enum tux_ret {
	TUX_ERROR = -1,
	TUX_RETURN_USERSPACE_REQUEST = 0,
	TUX_RETURN_EXIT = 1,
	TUX_RETURN_SIGNAL = 2,
	TUX_CONTINUE_EVENTLOOP = 3,
};

#define MAX_URI_LEN 256
#define MAX_COOKIE_LEN 128
#define MAX_FIELD_LEN 64
#define DATE_LEN 32

typedef struct user_req_s {
	uint32_t version_major;
	uint32_t version_minor;
	uint32_t version_patch;
	uint32_t http_version;
	uint32_t http_method;
	uint32_t http_status;

	uint32_t sock;
	uint32_t event;
	uint32_t error;
	uint32_t thread_nr;
	uint32_t bytes_sent;
	uint32_t client_host;
	uint32_t objectlen;
	uint32_t module_index;
	uint32_t keep_alive;
	uint32_t cookies_len;

	uint64_t id;
	uint64_t priv;
	uint64_t object_addr;

	uint8_t query[MAX_URI_LEN];
	uint8_t objectname[MAX_URI_LEN];
	uint8_t cookies[MAX_COOKIE_LEN];
	uint8_t content_type[MAX_FIELD_LEN];
	uint8_t user_agent[MAX_FIELD_LEN];
	uint8_t accept[MAX_FIELD_LEN];
	uint8_t accept_charset[MAX_FIELD_LEN];
	uint8_t accept_encoding[MAX_FIELD_LEN];
	uint8_t accept_language[MAX_FIELD_LEN];
	uint8_t cache_control[MAX_FIELD_LEN];
	uint8_t if_modified_since[MAX_FIELD_LEN];
	uint8_t negotiate[MAX_FIELD_LEN];
	uint8_t pragma[MAX_FIELD_LEN];
	uint8_t referer[MAX_FIELD_LEN];
	uint8_t new_date[DATE_LEN];
} user_req_t;

#define TUXAPI_declare int TUXAPI_protocol_version = 3

#endif
