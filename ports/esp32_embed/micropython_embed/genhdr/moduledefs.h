// Automatically generated by makemoduledefs.py.

extern const struct _mp_obj_module_t mp_module_array;
#undef MODULE_DEF_ARRAY
#define MODULE_DEF_ARRAY { MP_ROM_QSTR(MP_QSTR_array), MP_ROM_PTR(&mp_module_array) },

extern const struct _mp_obj_module_t mp_module_collections;
#undef MODULE_DEF_COLLECTIONS
#define MODULE_DEF_COLLECTIONS { MP_ROM_QSTR(MP_QSTR_collections), MP_ROM_PTR(&mp_module_collections) },

extern const struct _mp_obj_module_t mp_module_errno;
#undef MODULE_DEF_ERRNO
#define MODULE_DEF_ERRNO { MP_ROM_QSTR(MP_QSTR_errno), MP_ROM_PTR(&mp_module_errno) },

extern const struct _mp_obj_module_t mp_module_io;
#undef MODULE_DEF_IO
#define MODULE_DEF_IO { MP_ROM_QSTR(MP_QSTR_io), MP_ROM_PTR(&mp_module_io) },

extern const struct _mp_obj_module_t mp_module_os;
#undef MODULE_DEF_OS
#define MODULE_DEF_OS { MP_ROM_QSTR(MP_QSTR_os), MP_ROM_PTR(&mp_module_os) },

extern const struct _mp_obj_module_t mp_module_struct;
#undef MODULE_DEF_STRUCT
#define MODULE_DEF_STRUCT { MP_ROM_QSTR(MP_QSTR_struct), MP_ROM_PTR(&mp_module_struct) },

extern const struct _mp_obj_module_t mp_module___main__;
#undef MODULE_DEF___MAIN__
#define MODULE_DEF___MAIN__ { MP_ROM_QSTR(MP_QSTR___main__), MP_ROM_PTR(&mp_module___main__) },

extern const struct _mp_obj_module_t mp_module_builtins;
#undef MODULE_DEF_BUILTINS
#define MODULE_DEF_BUILTINS { MP_ROM_QSTR(MP_QSTR_builtins), MP_ROM_PTR(&mp_module_builtins) },

extern const struct _mp_obj_module_t esp32_module;
#undef MODULE_DEF_ESP32
#define MODULE_DEF_ESP32 { MP_ROM_QSTR(MP_QSTR_esp32), MP_ROM_PTR(&esp32_module) },

extern const struct _mp_obj_module_t mp_module_gc;
#undef MODULE_DEF_GC
#define MODULE_DEF_GC { MP_ROM_QSTR(MP_QSTR_gc), MP_ROM_PTR(&mp_module_gc) },

extern const struct _mp_obj_module_t mp_module_micropython;
#undef MODULE_DEF_MICROPYTHON
#define MODULE_DEF_MICROPYTHON { MP_ROM_QSTR(MP_QSTR_micropython), MP_ROM_PTR(&mp_module_micropython) },

extern const struct _mp_obj_module_t mp_module_sys;
#undef MODULE_DEF_SYS
#define MODULE_DEF_SYS { MP_ROM_QSTR(MP_QSTR_sys), MP_ROM_PTR(&mp_module_sys) },

extern const struct _mp_obj_module_t mp_module_vfs;
#undef MODULE_DEF_VFS
#define MODULE_DEF_VFS { MP_ROM_QSTR(MP_QSTR_vfs), MP_ROM_PTR(&mp_module_vfs) },


#define MICROPY_REGISTERED_MODULES \
    MODULE_DEF_BUILTINS \
    MODULE_DEF_ESP32 \
    MODULE_DEF_GC \
    MODULE_DEF_MICROPYTHON \
    MODULE_DEF_SYS \
    MODULE_DEF_VFS \
    MODULE_DEF___MAIN__ \
// MICROPY_REGISTERED_MODULES

#define MICROPY_REGISTERED_EXTENSIBLE_MODULES \
    MODULE_DEF_ARRAY \
    MODULE_DEF_COLLECTIONS \
    MODULE_DEF_ERRNO \
    MODULE_DEF_IO \
    MODULE_DEF_OS \
    MODULE_DEF_STRUCT \
// MICROPY_REGISTERED_EXTENSIBLE_MODULES

extern void mp_module_sys_attr(mp_obj_t self_in, qstr attr, mp_obj_t *dest);
#define MICROPY_MODULE_DELEGATIONS \
    { MP_ROM_PTR(&mp_module_sys), mp_module_sys_attr }, \
// MICROPY_MODULE_DELEGATIONS
