//
//  HeaderUtiles.h
//  FMDBSanbox
//
//  Created by Joe on 16/1/18.
//  Copyright © 2016年 Joe. All rights reserved.
//

#ifndef HeaderUtiles_h
#define HeaderUtiles_h

#endif /* HeaderUtiles_h */


#ifdef DEBUG

#define debugLog(...) NSLog(__VA_ARGS__)



#define debugMethod() NSLog(@"%s", __func__)

#else

#define debugLog(...)
#define debugMethod()

#endif


#define PATH_OF_DOCUMENT  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


