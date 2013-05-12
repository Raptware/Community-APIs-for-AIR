/*
 * global.h
 *
 *  Created on: Jan 31, 2013
 *      Author: jdolce
 */

#ifndef GLOBAL_H_
#define GLOBAL_H_

#include <pthread.h>
#include "FlashRuntimeExtensions.h"
#include <bbmsp/bbmsp_util.h>
#include "limits.h"
#include <stdlib.h>
#include "aneutils.h"

//A mutex which is used when communicating between threads.
pthread_mutex_t amutex;
//A condvar which is used when communicating between threads.
pthread_cond_t acond;
//A reference to the current context. Used for dispatching events.
FREContext context;
//Path to directory where images are written to.
const char *avatarPath;



void getAvatarPath( bbmsp_image_t* m_contact_avatar, const char *ppid, char *path );
void getIconPath( bbmsp_image_t* image, const int32_t iconId, char *path );
char *replaceChar( const char *str, const char replace, const char replaceWith );
void saveFile( const char *path, bbmsp_image_t* image );

typedef struct
{
    int channel_id;
    int domain_id;
    char output[1024];
} thread_payload_t;

enum
{
    MASTER_EXIT = 0,
    MASTER_CONNECT,
    MASTER_REGISTER,
};


int threadDomain;
int threadChannel;
int masterDomain;


#endif /* GLOBAL_H_ */
