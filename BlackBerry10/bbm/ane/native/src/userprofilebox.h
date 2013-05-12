
#ifndef USERPROFILEBOX_H_
#define USERPROFILEBOX_H_

#include <bbmsp/bbmsp_user_profile_box.h>
#include <bbmsp/bbmsp_events.h>
#include "aneutils.h"
#include "global.h"


bool itemAdded;
bbmsp_user_profile_box_item_t* itemToAdd;



FREObject getProfileBoxItems(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject addProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject removeProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject removeAllProfileBoxItems(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject registerIcon(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getAddedProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getProfileBoxItemIcon(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);



void handle_user_profile_box_event( bbmsp_event_t* bbmsp_event, int event_type );


#endif /* USERPROFILEBOX_H_ */
