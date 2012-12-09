/*
* Copyright (c) 2012 Research In Motion Limited.
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
package qnx.images
{
	/**
	 * Return codes for <code>ImageSaver.save()</code>.
	 * @see ImageSaver#save()
	 */
	public class ImageSaverCodes
	{
		/** The operation was successful. **/
		public static const IMG_ERR_OK:int		=	0;
		
		/** Premature end of file error. **/
		public static const IMG_ERR_TRUNC:int	=	1;	
		/** Unrecoverable error in data stream **/
		public static const IMG_ERR_CORRUPT:int	=	2;	
		/** File format not recognized. **/
		public static const IMG_ERR_FORMAT:int	=	3;	
		/** No data present. **/
		public static const IMG_ERR_NODATA:int	=	4;	
		/** Requested value/format/conversion not supported. **/
		public static const IMG_ERR_NOSUPPORT:int=	5;	
		/** Memory allocation error. **/
		public static const IMG_ERR_MEM:int	=	6;	
		/** Bad or missing config file. **/
		public static const IMG_ERR_CFG:int	=	7;
		/** Error accessing the dll or entrypoint. **/
		public static const IMG_ERR_DLL:int		=	8;	
		/** File access error. **/
		public static const IMG_ERR_FILE:int	=	9;	
		/** Operation interrupted by application. **/
		public static const IMG_ERR_INTR:int	=	10;
		/** Invalid Parameter **/
		public static const IMG_ERR_PARM:int	=	11;
		/** Operation not implemented **/
		public static const IMG_ERR_NOTIMPL:int	=	12;	
	}
}
