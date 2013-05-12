
#ifndef USERPROFILE_H_
#define USERPROFILE_H_

#include <bbmsp/bbmsp_userprofile.h>
#include <bbmsp/bbmsp_events.h>
#include <bbmsp/bbmsp_contactlist.h>
#include "aneutils.h"
#include "limits.h"
#include "global.h"


void handle_user_profile_event( bbmsp_event_t* bbmsp_event, int event_type );
FREObject getUserProfile(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject getUserProfileStatus(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setUserProfileStatus(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setUserProfileMessage(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
FREObject setUserProfilePicture(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[]);
#endif /* USERPROFILE_H_ */
