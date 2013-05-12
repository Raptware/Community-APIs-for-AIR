/*
 * contacts.h
 *
 *  Created on: Jan 31, 2013
 *      Author: jdolce
 */

#ifndef CONTACTS_H_
#define CONTACTS_H_

#include "FlashRuntimeExtensions.h"
#include "aneutils.h"
#include <bbmsp/bbmsp_contactlist.h>
#include "global.h"
#include "limits.h"

size_t contact_size;
bbmsp_contact_t** contact_list;

bool contactsCreated;
bool contactAdded;
bbmsp_contact_t* contactToAdd;

typedef struct _ContactUpdate ContactUpdate;

struct _ContactUpdate
{
	char *ppid;
	char *value;
	bbmsp_presence_update_types_t property;
	bbmsp_presence_status_t status;
};

ContactUpdate contact_updates[10];
int update_size;



void handle_contact_event( bbmsp_event_t* bbmsp_event, int event_type );
FREObject getContactList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getAddedContact(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getUpdatedContactProperties(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);


#endif /* CONTACTS_H_ */
