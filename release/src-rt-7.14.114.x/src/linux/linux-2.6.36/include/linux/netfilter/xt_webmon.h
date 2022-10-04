/*  webmon --	A netfilter module to match URLs in HTTP requests 
 *  		This module can match using string match or regular expressions
 *  		Originally designed for use with Gargoyle router firmware (gargoyle-router.com)
 *
 *
 *  Copyright © 2008-2010 by Eric Bishop <eric@gargoyle-router.com>
 * 
 *  This file is free software: you may copy, redistribute and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation, either version 2 of the License, or (at your
 *  option) any later version.
 *
 *  This file is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */




#ifndef _XT_WEBMON_H
#define _XT_WEBMON_H


#define WEBMON_MAXDOMAIN           4
#define WEBMON_MAXSEARCH           8

#define WEBMON_DOMAIN             16
#define WEBMON_SEARCH             32


#define WEBMON_SET              3064

struct xt_webmon_info
{
	uint32_t max_domains;
	uint32_t max_searches;
	uint32_t* ref_count;
};

#endif /*_XT_WEBMON_H*/
