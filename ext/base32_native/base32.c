#include <ruby.h>
#include <stdio.h>

VALUE Base32Native = Qnil;

void Init_base32_native();
VALUE method_base32_native_encode(VALUE self, VALUE data);

void Init_base32_native() {
    printf("Initialized!\n");

    Base32Native = rb_define_module("Base32Native");
    rb_define_singleton_method(Base32Native, "encode", method_base32_native_encode, 1);
}

VALUE method_base32_native_encode(VALUE self, VALUE data) {
    printf("Encode a string!\n");
    return 0;
}
