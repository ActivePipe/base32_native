#include <ruby.h>
#include <stdio.h>

VALUE Base32Native = Qnil;

void Init_base32_native();
VALUE method_base32_native_encode(VALUE self, VALUE data);
VALUE method_base32_native_decode(VALUE self, VALUE data);

void Init_base32_native() {
    Base32Native = rb_define_module("Base32Native");
    rb_define_singleton_method(Base32Native, "encode", method_base32_native_encode, 1);
    rb_define_singleton_method(Base32Native, "decode", method_base32_native_decode, 1);
}

// Adapted Google implementation from: https://raw.githubusercontent.com/heapsource/google-authenticator/master/libpam/base32.c
// Original signature: int base32_encode(const uint8_t *data, int length, uint8_t *result, int bufSize)
VALUE method_base32_native_encode(VALUE self, VALUE data) {
  unsigned char *plaintext;
  unsigned char *result;
  int length, index, bufSize, count = 0;

  plaintext = StringValuePtr(data); // convert ruby string to unsigned char *

  length = strlen(plaintext);
  bufSize = ((length + 4)/5)*8 + 1;
  result = malloc(bufSize); // do we need to free() later?

  printf("data %s\n", data);
  printf("Encoding %s\n", plaintext);
  printf("Length: %i, Buffer: %i\n", length, bufSize);

  if (length < 0 || length > (1 << 28)) {
    return -1;
  }

  if (length > 0) {
    int buffer = plaintext[0];
    int next = 1;
    int bitsLeft = 8;
    while (count < bufSize && (bitsLeft > 0 || next < length)) {
      printf("Encoding character %i - %x\n", count, plaintext[next + 1]);
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

  return rb_str_new2(result); // convert char* to VALUE (Ruby String)
}

// Adapted Google implementation from: https://raw.githubusercontent.com/heapsource/google-authenticator/master/libpam/base32.c
// Original signature: int base32_decode(const uint8_t *encoded, uint8_t *result, int bufSize)
VALUE method_base32_native_decode(VALUE self, VALUE data) {
  unsigned char *encoded;
  unsigned char *result;
  unsigned char *ptr;

  int bufSize, buffer = 0, bitsLeft = 0, count = 0;

  encoded = StringValuePtr(data); // convert ruby string to unsigned char *
  bufSize = strlen(encoded);
  result = malloc(bufSize); // do we need to free() later?

  for (ptr = encoded; count < bufSize && *ptr; ++ptr) {
    char ch = *ptr;
    if (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n' || ch == '-' || ch == '=') {
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

  return rb_str_new2(result); // convert char* to VALUE (Ruby String)
}
