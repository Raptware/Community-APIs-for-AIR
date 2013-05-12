
#include "aneutils.h"
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
bool getString(FREObject obj, const char **result)
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
