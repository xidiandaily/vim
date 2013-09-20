/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Copyright (C) IBM Corporation. 2007
 * Author: Doug Maxey <dwm@austin.ibm.com>
 *         "Prasanna Mumbai" <mumbai.prasanna@gmail.com>
 *
 */
#ifndef FWPARAM_CONTEXT_H_
#define FWPARAM_CONTEXT_H_

#include <net/if.h>

#include "iscsi_list.h"

struct boot_context {
	struct list_head list;

	/* target settings */
	int target_port;
	char targetname[256];
	char target_ipaddr[32];
	char chap_name[256];
	char chap_password[256];
	char chap_name_in[256];
	char chap_password_in[256];

	/* initiator settings */
	char isid[10];
	char initiatorname[256];

	/* network settings */
	char dhcp[18];
	char iface[IF_NAMESIZE];
	char mac[18];
	char ipaddr[18];
	char gateway[18];
	char primary_dns[18];
	char secondary_dns[18];
	char mask[18];
	char lun[17];
	char vlan[15];
};

extern int fw_get_entry(struct boot_context *context);
extern void fw_print_entry(struct boot_context *context);
extern int fw_get_targets(struct list_head *list);
extern void fw_free_targets(struct list_head *list);
extern int fwparam_ibft_sysfs(struct boot_context *context, const char *filepath);

#endif /* FWPARAM_CONTEXT_H_ */
