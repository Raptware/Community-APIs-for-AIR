/*
 * aneutils.h
 *
 *  Created on: Jan 23, 2013
 *      Author: jdolce
 */

#ifndef ANEUTILS_H_
#define ANEUTILS_H_

#include "FlashRuntimeExtensions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdarg.h>


/**
 * Simple printf wrapper
 */
void trace( const char* format, ... );

/**
 * A helper method to turn a ActionScript string into a native const char.
 */
bool getString(FREObject obj, const char **result);

#endif /* ANEUTILS_H_ */
