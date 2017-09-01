#include <ruby.h>
#include <stdio.h>

VALUE Base32Native = Qnil;

void Init_base32_native();
VALUE method_base32_native_encode(VALUE self, VALUE data);
VALUE method_base32_native_decode(VALUE self, VALUE data);

void Init_base32_native() {
    printf("Initialized!\n");

    Base32Native = rb_define_module("Base32Native");
    rb_define_singleton_method(Base32Native, "encode", method_base32_native_encode, 1);
    rb_define_singleton_method(Base32Native, "decode", method_base32_native_decode, 1);
}

// Adapted Google implementation from: https://raw.githubusercontent.com/heapsource/google-authenticator/master/libpam/base32.c
// Original signature: int base32_encode(const uint8_t *data, int length, uint8_t *result, int bufSize)
VALUE method_base32_native_encode(VALUE self, VALUE data) {
  char *plaintext;
  char *result;
  int length, count, index, bufSize;

  plaintext = StringValuePtr(data);
  count = 0;
  length = sizeof(plaintext);
  bufSize = ((length + 4)/5)*8 + 1;

  result = malloc(bufSize * 1024);
  // result = malloc(bufSize);

/*
144   puts("Testing base32 encoding");
145   static const uint8_t dat[] = "Hello world...";
146   uint8_t enc[((sizeof(dat) + 4)/5)*8 + 1];
147   assert(base32_encode(dat, sizeof(dat), enc, sizeof(enc)) == sizeof(enc)-1);
148   assert(!strcmp((char *)enc, "JBSWY3DPEB3W64TMMQXC4LQA"));
*/
  printf("Encoding: %s\n", plaintext);

  if (length < 0 || length > (1 << 28)) {
    return -1;
  }

  if (length > 0) {
    int buffer = plaintext[0];
    int next = 1;
    int bitsLeft = 8;
    while (count < bufSize && (bitsLeft > 0 || next < length)) {
      if (bitsLeft < 5) {
        if (next < length) {
          buffer <<= 8;
          buffer |= plaintext[next++] & 0xFF;
          bitsLeft += 8;
        } else {
          int pad = 5 - bitsLeft;
          buffer <<= pad;
          bitsLeft += pad;
        }
      }
      index = 0x1F & (buffer >> (bitsLeft - 5));
      bitsLeft -= 5;
      result[count++] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"[index];
    }
  }
  if (count < bufSize) {
    result[count] = '\000';
  }
  return (VALUE) result;
}

// Adapted Google implementation from: https://raw.githubusercontent.com/heapsource/google-authenticator/master/libpam/base32.c
// Original signature: int base32_decode(const uint8_t *encoded, uint8_t *result, int bufSize)
VALUE method_base32_native_decode(VALUE self, VALUE data) {
  char *encoded;
  char *result;
  char *ptr;

  int bufSize = 9999; // ??
  int buffer = 0;
  int bitsLeft = 0;
  int count = 0;

  encoded = StringValuePtr(data);
  result = malloc(strlen(encoded) * 4);

  printf("Decoding: %s\n", encoded);

  for (ptr = encoded; count < bufSize && *ptr; ++ptr) {
    char ch = *ptr;
    if (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n' || ch == '-') {
      continue;
    }
    buffer <<= 5;

    // Deal with commonly mistyped characters
    if (ch == '0') {
      ch = 'O';
    } else if (ch == '1') {
      ch = 'L';
    } else if (ch == '8') {
      ch = 'B';
    }

    // Look up one base32 digit
    if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z')) {
      ch = (ch & 0x1F) - 1;
    } else if (ch >= '2' && ch <= '7') {
      ch -= '2' - 26;
    } else {
      return -1;
    }

    buffer |= ch;
    bitsLeft += 5;
    if (bitsLeft >= 8) {
      result[count++] = buffer >> (bitsLeft - 8);
      bitsLeft -= 8;
    }
  }
  if (count < bufSize) {
    result[count] = '\000';
  }

  return (VALUE) result;
}
