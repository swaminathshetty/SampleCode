/*
 */
#ifndef BYTELIB_H_
#define BYTELIB_H_

#ifndef WIN32
#include "phd_types.h"
#else
#include "src/asn1/phd_types.h"
#endif

/**
 * ByteStreamReader is used to read byte array as a contiguous stream.
 *
 */
typedef struct ByteStreamReader {
	/**
	 *
	 * Number of unread bytes
	 */
	intu32 unread_bytes;
	/**
	 * The pointer to current offset in processing
	 */
	intu8 *buffer_cur;

	/**
	 * The pointer to start of buffer_cur
	 */
	intu8 *buffer;

} ByteStreamReader;

/**
 * ByteStreamWriter is used to aggregate byte array as a contiguous stream.
 */
typedef struct ByteStreamWriter {
	intu32 size;

	intu8 *buffer;
	int buffer_size;
	int open;
} ByteStreamWriter;

ByteStreamReader *byte_stream_reader_instance(intu8 *stream, intu32 size);

intu8 read_intu8(ByteStreamReader *stream, int *error);

void read_intu8_many(ByteStreamReader *stream, intu8 *buf, int len, int *error);

intu16 read_intu16(ByteStreamReader *stream, int *error);

intu32 read_intu32(ByteStreamReader *stream, int *error);

FLOAT_Type read_float(ByteStreamReader *stream, int *error);

SFLOAT_Type read_sfloat(ByteStreamReader *stream, int *error);

ByteStreamWriter *byte_stream_writer_instance(intu32 size);

ByteStreamWriter *open_stream_writer(intu32 hint);

intu32 write_intu8(ByteStreamWriter *stream, intu8 data);

intu32 write_intu8_many(ByteStreamWriter *stream, intu8 *data, int len, int *error);

intu32 write_intu16(ByteStreamWriter *stream, intu16 data);
intu32 reserve_intu16(ByteStreamWriter *stream, int *position);
void commit_intu16(ByteStreamWriter *stream, int position, intu16 data);

intu32 write_intu32(ByteStreamWriter *stream, intu32 data);

intu32 write_sfloat(ByteStreamWriter *stream, SFLOAT_Type data);

intu32 write_float(ByteStreamWriter *stream, FLOAT_Type data);

void del_byte_stream_writer(ByteStreamWriter *stream, int del_fields);
void del_byte_stream_reader(ByteStreamReader *stream, int del_fields);

/** @} */

#endif /* BYTELIB_H_ */

