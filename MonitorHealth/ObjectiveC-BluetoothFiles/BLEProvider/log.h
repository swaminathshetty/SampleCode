//
//  log.h
//  AllHealthChoice
//
//  Created by Apple on 07/06/18.
//  Copyright © 2018 HYLPMB00014. All rights reserved.
//

#ifndef LOG_H_
#define LOG_H_

#include <stdio.h>

/**
 * \def LOG_OUTPUT
 * Output of the log.
 */
#define LOG_OUTPUT stderr

/**
 * @brief Log to the output defined in LOG_OUTPUT.
 * @param level log level.
 * @param ... va_args like in printf.
 * @see printf
 */
#ifdef ANDROID
#include <android/log.h>
#define LOG(level, ...) \
{ \
__android_log_print(ANDROID_LOG_WARN, "antidote", level); \
__android_log_print(ANDROID_LOG_WARN, "antidote",  __VA_ARGS__); \
}
#else
#define LOG(level, ...) \
{ \
fprintf(LOG_OUTPUT, level); \
fprintf(LOG_OUTPUT, "<%s in %s:%d> ", __FUNCTION__, __FILE__, __LINE__); \
fprintf(LOG_OUTPUT, __VA_ARGS__); \
fprintf(LOG_OUTPUT, "\n"); \
fflush(LOG_OUTPUT); \
}
#endif

/**
 * @brief Logs a debug level message at the log output.
 * @param ... va_args like in printf.
 * @see printf
 */
#define DEBUG(...)   LOG("DEBUG   ", __VA_ARGS__)

/**
 * @brief Logs a error level message at the log output.
 * @param ... va_args like in printf.
 * @see printf
 */
#define ERROR(...)   LOG("ERROR   ", __VA_ARGS__)

/**
 * @brief Logs a warning level message at the log output.
 * @param ... va_args like in printf.
 * @see printf
 */
#define WARNING(...) LOG("WARNING ", __VA_ARGS__)

/**
 * @brief Logs a information level message at the log output.
 * @param ... va_args like in printf.
 * @see printf
 */
#define INFO(...)    LOG("INFO    ", __VA_ARGS__)

#endif /* LOG_H_ */
