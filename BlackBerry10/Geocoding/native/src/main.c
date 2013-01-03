/*
* Copyright (c) 2013 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
#include "FlashRuntimeExtensions.h"
#include "geo_search.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdarg.h>

/**
 * Store our search reply so it can be accessed in subsequent calls.
 */
geo_search_reply_t searchReply;

/**
 * Simple printf wrapper
 */
void trace( const char* format, ... )
{
    va_list args;
    va_start( args, format );
    vfprintf( stderr, format, args );
    va_end( args );
    fprintf( stderr, "\n" );
}

/**
 * A helper method to turn a ActionScript string into a native const char.
 */
static bool
getString(FREObject obj, const char **result)
{
	FREObjectType type;
	uint32_t length;
	const uint8_t  *value;
	if ( FREGetObjectType(obj, &type) == FRE_OK && type == FRE_TYPE_STRING &&
		 FREGetObjectAsUTF8(obj, &length, &value) == FRE_OK )
	{
		*result = (const char *)value;
		return true;
	}
	return false;
}

/**
 * Parses a reply and populates the SearchLocation instance passed form ActionScript.
 */
void parse_reply( geo_search_reply_t reply, FREObject result )
{

	int n;

    if (GEO_SEARCH_OK != geo_search_reply_get_length(&reply, &n)) {
        n = 0;
    }

    trace("** %d entries in reply", n);

    int i;
    for (i=0; i < n; i++) {
        if (GEO_SEARCH_OK != geo_search_reply_set_index(&reply, i))
            break;

        if (i) {
        	trace("");
        }
        //The location variable is of type SearchLocation
        FREObject location;
        FREGetArrayElementAt( result, i, &location );

	    const char *value = NULL;
	    if (GEO_SEARCH_OK == geo_search_reply_get_name(&reply, &value)) {
	    	trace("\tname: %s", value);

	        FREObject name = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &name );
	        FRESetObjectProperty( location, (const uint8_t*)"name", name, NULL );
	    }

	    double lat;
	    if (GEO_SEARCH_OK == geo_search_reply_get_lat(&reply, &lat)) {
	    	trace("\tlat: %.6f", lat);
	        FREObject latitude = NULL;
	        FRENewObjectFromDouble( lat, &latitude );
	        FRESetObjectProperty( location, (const uint8_t*)"latitude", latitude, NULL );
	    }

	    double lon;
		if (GEO_SEARCH_OK == geo_search_reply_get_lon(&reply, &lon)) {
			trace("\tlon: %.6f", lon);
	        FREObject longitude = NULL;
	        FRENewObjectFromDouble( lon, &longitude );
	        FRESetObjectProperty( location, (const uint8_t*)"longitude", longitude, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_description(&reply, &value)) {
			trace("\tdescription: %s", value);

	        FREObject description = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &description );
	        FRESetObjectProperty( location, (const uint8_t*)"description", description, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_street(&reply, &value)) {
			trace("\tstreet: %s", value);

	        FREObject street = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &street );
	        FRESetObjectProperty( location, (const uint8_t*)"street", street, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_city(&reply, &value)) {
			trace("\tcity: %s", value);
	        FREObject city = NULL;
	       	FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &city );
	       	FRESetObjectProperty( location, (const uint8_t*)"city", city, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_region(&reply, &value)) {
			trace("\tregion: %s", value);
	        FREObject region = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &region );
	        FRESetObjectProperty( location, (const uint8_t*)"region", region, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_county(&reply, &value)) {
			trace("\tcounty: %s", value);
	        FREObject county = NULL;
	       	FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &county );
	       	FRESetObjectProperty( location, (const uint8_t*)"county", county, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_district(&reply, &value)) {
			trace("\tdistrict: %s", value);
	        FREObject district = NULL;
	       	FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &district );
	       	FRESetObjectProperty( location, (const uint8_t*)"district", district, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_country(&reply, &value)) {
			trace("\tcountry: %s", value);
	        FREObject country = NULL;
	       	FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &country );
	       	FRESetObjectProperty( location, (const uint8_t*)"country", country, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_postal_code(&reply, &value)) {
			trace("\tpostal_code: %s", value);
	        FREObject postal_code = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &postal_code );
	        FRESetObjectProperty( location, (const uint8_t*)"postalCode", postal_code, NULL );
	    }

	    int mcc;
		if (GEO_SEARCH_OK == geo_search_reply_get_mcc(&reply, &mcc)) {
			trace("\tmcc: %d", mcc);
	        FREObject mcc_value = NULL;
	        FRENewObjectFromInt32( (int32_t)mcc, &mcc_value );
	        FRESetObjectProperty( location, (const uint8_t*)"mcc", mcc_value, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_timezone(&reply, &value)) {
			trace("\ttimezone: %s", value);
	        FREObject timezone = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &timezone );
	        FRESetObjectProperty( location, (const uint8_t*)"timezone", timezone, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_iso_alpha2_country_code(&reply, &value)) {
			trace("\tiso2_country_code: %s", value);
	        FREObject countryCode2 = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &countryCode2 );
	        FRESetObjectProperty( location, (const uint8_t*)"countryCode2", countryCode2, NULL );
	    }

		if (GEO_SEARCH_OK == geo_search_reply_get_iso_alpha3_country_code(&reply, &value)) {
			trace("\tiso3_country_code: %s", value);
	        FREObject countryCode3 = NULL;
	        FRENewObjectFromUTF8( strlen( value ) + 1,  (const uint8_t*)value, &countryCode3 );
	        FRESetObjectProperty( location, (const uint8_t*)"countryCode3", countryCode3, NULL );
	    }

	    int id;
		if (GEO_SEARCH_OK == geo_search_reply_get_iso_country_id(&reply, &id)) {
			trace("\tiso_country_id: %d", id);

	        FREObject countryid = NULL;
	        FRENewObjectFromInt32( (int32_t)id, &countryid );
	        FRESetObjectProperty( location, (const uint8_t*)"countryID", countryid, NULL );


	    }
    }
}

/**
 * Outputs any an error to a human readable string.
 */
static void show_error(const char *string, geo_search_error_t error) {
	trace("    error: %s", string);
	trace("    [%d] - %s", error, geo_search_strerror(error));
}

/**
 * Does a geo-code search based on the supplied search string.
 * Returns error codes back to ActionScript.
 */
FREObject
search_geocode(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;

	const char *search;
	//First argument is the search string.
	getString( argv[0], &search );

	geo_search_handle_t handle = NULL;
	geo_search_error_t error;

	if (GEO_SEARCH_OK != (error = geo_search_open(&handle)))
	{
		show_error( "geo_search_open", error );
	}
	else
	{
		error = geo_search_geocode(&handle, &searchReply, search);
	}
	geo_search_close( &handle );

	FRENewObjectFromInt32( (int32_t)error, &result );
	return result;
}

/**
 * Does a geo-code serach based on the supplied search string, with a lat/long hint.
 * Retunrs error codes back to ActionScript.
 */
FREObject
search_geocode_latlon(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;

	const char *search;
	//First argument is the search string.
	getString( argv[0], &search );
	geo_search_handle_t handle = NULL;
	geo_search_error_t error;

	if (GEO_SEARCH_OK != (error = geo_search_open(&handle)))
	{
		show_error( "geo_search_open", error );
	}
	else
	{
		double lat;
		//Second argument is the latitude hint
		FREGetObjectAsDouble( argv[ 1 ], &lat );
		double lon;
		//Third argument is the longitude hint
		FREGetObjectAsDouble( argv[ 2 ], &lon );

		error = geo_search_geocode_latlon(&handle, &searchReply, search, lat, lon );
	}

	geo_search_close( &handle );

	FRENewObjectFromInt32( (int32_t)error, &result );
	return result;
}

/**
 * Gets the number of locations returned by the last search.
 */
FREObject
get_replylen( FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;

	int n;
	if (GEO_SEARCH_OK != geo_search_reply_get_length(&searchReply, &n))
	{
		n = 0;
	}

	FRENewObjectFromInt32( (int32_t)n, &result );

	return( result );
}

/**
 * Returns a human readable string based on a error code.
 */
FREObject
get_error_string( FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;
	int32_t error;
	//First argument is the error code.
	FREGetObjectAsInt32( argv[ 0 ], &error );

	const char *str = geo_search_strerror((geo_search_error_t)error);

	 FRENewObjectFromUTF8( strlen( str ) + 1,  (const uint8_t*)str, &result );

	return( result );
}

/**
 * Gets the result of the search.
 * The first argument should be a Vector.<SearchLocation> instance pre-filled with the correct number of items.
 *
 */
FREObject
get_reply( FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	parse_reply( searchReply, argv[ 0 ] );
	geo_search_free_reply( &searchReply );
	searchReply = NULL;
	return( NULL );
}

void
contextInitializer(void* extData, const uint8_t* ctxType,
				   FREContext ctx, uint32_t* numFunctionsToSet,
				   const FRENamedFunction** functionsToSet)
{

	static FRENamedFunction s_classMethods[] = {
	    {(const uint8_t*)"search_geocode", NULL, search_geocode},
	    {(const uint8_t*)"search_geocode_latlon", NULL, search_geocode_latlon},
	    {(const uint8_t*)"get_replylen", NULL, get_replylen},
	    {(const uint8_t*)"get_error_string", NULL, get_error_string},
	    {(const uint8_t*)"get_reply", NULL, get_reply},

	};
	const int c_methodCount = sizeof(s_classMethods) / sizeof(FRENamedFunction);

	*functionsToSet = s_classMethods;
	*numFunctionsToSet = c_methodCount;
}

void
contextFinalizer(FREContext ctx)
{
}


void
extensionInitializer(void** extDataToSet,
					 FREContextInitializer* ctxInitializerToSet,
					 FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &contextInitializer;
	*ctxFinalizerToSet = &contextFinalizer;
}


void
extensionFinalizer()
{
	return;
}
