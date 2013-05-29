#include "global.h"
#include <fcntl.h>

/**
 * Gets the path to the saved avatar on the device.
 * Avatars are saved to a avatar folder in the application storage directory with the contact id as the file name.
 */
void getAvatarPath( bbmsp_image_t* image, const char *ppid, char *path )
{
	strcpy( path, avatarPath );
	strcat( path, "avatar/" );

	char *filename = replaceChar( ppid, '/', '_' );

	strcat( path, filename );
	strcat( path, "." );

	switch( bbmsp_image_get_type( image ) )
	{
		case BBMSP_IMAGE_TYPE_JPG:
			strcat( path, "jpg" );
			break;
		case BBMSP_IMAGE_TYPE_PNG:
			strcat( path, "png" );
			break;
		case BBMSP_IMAGE_TYPE_GIF:
			strcat( path, "gif" );
			break;
		case BBMSP_IMAGE_TYPE_BMP:
			//TODO need to do some lib img stuff here to save image to a png so AIR can load it.
			trace( "BMP not supported" );
			break;
	}

	trace( "getAvatarPath %s", path );
}


/**
 * Gets the path to the saved profile box item icon on the device.
 */
void getIconPath( bbmsp_image_t* image, const int32_t iconId, char *path )
{
	strcpy( path, avatarPath );
	strcat( path, "icons/" );

	char id[12];
	sprintf( id, "%i", iconId );

	strcat( path, id );
	strcat( path, "." );

	switch( bbmsp_image_get_type( image ) )
	{
		case BBMSP_IMAGE_TYPE_JPG:
			strcat( path, "jpg" );
			break;
		case BBMSP_IMAGE_TYPE_PNG:
			strcat( path, "png" );
			break;
		case BBMSP_IMAGE_TYPE_GIF:
			strcat( path, "gif" );
			break;
		case BBMSP_IMAGE_TYPE_BMP:
			//TODO need to do some lib img stuff here to save image to a png so AIR can load it.
			trace( "BMP not supported" );
			break;
	}

	trace( "getIconPath %s", path );
}

/**
 * Replaces a given character in a string.
 */
char *replaceChar( const char *str, const char replace, const char replaceWith )
{
	 char *final = malloc(strlen(str) + 1);

	int j = 0;
	while (str[j] != 0)
	{
		if (str[j] == replace )
		{
			final[j] = replaceWith;
		}
		else
		{
			final[j] = str[j];
		}
		j++;
	}
	final[j] = 0; // end the string
	return final;
}

void saveFile( const char *path, bbmsp_image_t* image )
{
	int fd = open( path, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP );
	if( fd >= 0 )
	{
		write( fd, bbmsp_image_get_data( image ), bbmsp_image_get_data_size( image ) );
	}

	close( fd );
}
