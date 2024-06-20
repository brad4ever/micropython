/*
 * This file is part of the MicroPython project, http://micropython.org/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 "Eric Poulsen" <eric@zyxod.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <stdio.h>
#include <string.h>

#include "py/mperrno.h"
#include "py/nlr.h"
#include "py/obj.h"
#include "py/runtime.h"
#include "py/mphal.h"
#include "modmachine.h"
#include "modesp32.h"
#ifdef MICROPY_CUST_IDF
#include "esp_heap_caps.h"
#include "multi_heap.h"
#define MULTI_HEAP_FREERTOS
#include "idf/multi_heap_platform.h"
#include "idf/heap_private.h"
#endif


static mp_obj_t esp32_idf_heap_info(const mp_obj_t cap_in) {
    mp_int_t cap = mp_obj_get_int(cap_in);
    multi_heap_info_t info;
    heap_t *heap;
    mp_obj_t heap_list = mp_obj_new_list(0, 0);
    SLIST_FOREACH(heap, &registered_heaps, next) {
        if (heap_caps_match(heap, cap)) {
            multi_heap_get_info(heap->heap, &info);
            mp_obj_t data[] = {
                MP_OBJ_NEW_SMALL_INT(heap->end - heap->start), // total heap size
                MP_OBJ_NEW_SMALL_INT(info.total_free_bytes),   // total free bytes
                MP_OBJ_NEW_SMALL_INT(info.largest_free_block), // largest free contiguous
                MP_OBJ_NEW_SMALL_INT(info.minimum_free_bytes), // minimum free seen
            };
            mp_obj_t this_heap = mp_obj_new_tuple(4, data);
            mp_obj_list_append(heap_list, this_heap);
        }
    }
    return heap_list;
}
static MP_DEFINE_CONST_FUN_OBJ_1(esp32_idf_heap_info_obj, esp32_idf_heap_info);

static const mp_rom_map_elem_t esp32_module_globals_table[] = {
    { MP_ROM_QSTR(MP_QSTR___name__), MP_ROM_QSTR(MP_QSTR_esp32) },

    { MP_ROM_QSTR(MP_QSTR_Partition), MP_ROM_PTR(&esp32_partition_type) },
    { MP_ROM_QSTR(MP_QSTR_idf_heap_info), MP_ROM_PTR(&esp32_idf_heap_info_obj) },    
    { MP_ROM_QSTR(MP_QSTR_HEAP_DATA), MP_ROM_INT(MALLOC_CAP_8BIT) },    
    { MP_ROM_QSTR(MP_QSTR_HEAP_EXEC), MP_ROM_INT(MALLOC_CAP_EXEC) },
};

static MP_DEFINE_CONST_DICT(esp32_module_globals, esp32_module_globals_table);

const mp_obj_module_t esp32_module = {
    .base = { &mp_type_module },
    .globals = (mp_obj_dict_t *)&esp32_module_globals,
};

MP_REGISTER_MODULE(MP_QSTR_esp32, esp32_module);


// Registrazione del modulo
