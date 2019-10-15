//
//  TDDebug.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#ifndef TDLink_TDDebug_h
#define TDLink_TDDebug_h

//#define TD_DEBUG
//#define TD_SIMULATOR
//#define TD_DEBUG_TEMPERATURE
//#define TD_DEBUG_DC_I

#ifdef TD_DEBUG
#define TDLog(...) NSLog(__VA_ARGS__)
#else
#define TDLog(...)
#endif


#endif
