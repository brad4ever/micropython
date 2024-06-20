/*
 * This file is part of the MicroPython project, http://micropython.org/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2022-2023 Damien P. George
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

#include <string.h>
#include <stdio.h>
#include "py/mphal.h"
#include "py/objstr.h"
#include "esp_err.h"
#include "py/mperrno.h"
#include "py/nlr.h"
#include "py/runtime.h"
#include <stdarg.h>

//Context of callback
void* _m_context = NULL;

typedef void (*cb_Extern_StdOut_ptr) (void* context,const char *str, size_t len);
typedef uint8_t (*cb_Extern_PinInterface_ptr)(void* context, va_list);

//Function pointer 
void (*pyCb_StdOutWrapper) (void* context,const char *str, size_t len) = NULL;
uint8_t (*pyCb_PinWrapper)(void* context, va_list)=NULL;

uint8_t call_pyCb_PinWrapper(void* context, cb_Extern_PinInterface_ptr func, ...) {
    uint8_t value;

    va_list args;
    va_start(args, func);
    value = func(context, args);
    va_end(args);

    return value;
}

void register_cb_hal_pinWrapper(cb_Extern_PinInterface_ptr fun){
    pyCb_PinWrapper=fun;
}


void mp_hal_pin_op(uint16_t op,uint8_t index, mp_arg_val_t* args){
    enum { ARG_mode, ARG_pull, ARG_value, ARG_drive, ARG_hold };
    switch (op) {
        case MP_QSTR_init:            
            call_pyCb_PinWrapper(_m_context, pyCb_PinWrapper, op,index, args[ARG_mode].u_int, args[ARG_pull].u_int, args[ARG_value].u_int, args[ARG_drive].u_int, args[ARG_hold].u_int);
            break;
        case MP_QSTR_value:
        case MP_QSTR_off:
        case MP_QSTR_on:
            call_pyCb_PinWrapper(_m_context, pyCb_PinWrapper, op,index, args[0].u_int);
            break;
        case MP_QSTR_irq:
            break;
    }    
}

uint8_t mp_hal_pin_value(uint8_t index,uint8_t value){
    return call_pyCb_PinWrapper(_m_context, pyCb_PinWrapper, MP_QSTR_value,index, value);
}

// Send string of given length to stdout, converting \n to \r\n.
void mp_hal_stdout_tx_strn_cooked(const char *str, size_t len) {
    fflush(stdout); 
    if (pyCb_StdOutWrapper != NULL && _m_context != NULL){
        pyCb_StdOutWrapper(_m_context,str, len);
    }
    else {
        printf("%.*s", (int)len, str);
    }     
}


void register_cb_hal_stdout(cb_Extern_StdOut_ptr fun){
    pyCb_StdOutWrapper = fun;
}
 
void deregister_cb_hal_stdout(){
    pyCb_StdOutWrapper = NULL;
}

void register_cb_hal_machine_context(void* m_context){
    _m_context = m_context;
}

uint64_t mp_hal_time_ns(void) {
    //TODO: Implementing this
    return 0;

    struct timeval tv;
    gettimeofday(&tv, NULL);
    uint64_t ns = tv.tv_sec * 1000000000ULL;
    ns += (uint64_t)tv.tv_usec * 1000ULL;
    return ns;
}

// Check the ESP-IDF error code and raise an OSError if it's not ESP_OK.
#if MICROPY_ERROR_REPORTING <= MICROPY_ERROR_REPORTING_NORMAL
void check_esp_err_(esp_err_t code)
#else
void check_esp_err_(esp_err_t code, const char *func, const int line, const char *file)
#endif
{
    if (code != ESP_OK) {
        // map esp-idf error code to posix error code
        uint32_t pcode = -code;
        switch (code) {
            case ESP_ERR_NO_MEM:
                pcode = MP_ENOMEM;
                break;
            case ESP_ERR_TIMEOUT:
                pcode = MP_ETIMEDOUT;
                break;
            case ESP_ERR_NOT_SUPPORTED:
                pcode = MP_EOPNOTSUPP;
                break;
        }
        // construct string object
        mp_obj_str_t *o_str = m_new_obj_maybe(mp_obj_str_t);
        if (o_str == NULL) {
            mp_raise_OSError(pcode);
            return;
        }
        o_str->base.type = &mp_type_str;
        #if MICROPY_ERROR_REPORTING > MICROPY_ERROR_REPORTING_NORMAL
        char err_msg[64];
        esp_err_to_name_r(code, err_msg, sizeof(err_msg));
        vstr_t vstr;
        vstr_init(&vstr, 80);
        vstr_printf(&vstr, "0x%04X %s in function '%s' at line %d in file '%s'", code, err_msg, func, line, file);
        o_str->data = (const byte *)vstr_null_terminated_str(&vstr);
        #else
        o_str->data = (const byte *)esp_err_to_name(code); // esp_err_to_name ret's ptr to const str
        #endif
        o_str->len = strlen((char *)o_str->data);
        o_str->hash = qstr_compute_hash(o_str->data, o_str->len);
        // raise
        mp_obj_t args[2] = { MP_OBJ_NEW_SMALL_INT(pcode), MP_OBJ_FROM_PTR(o_str)};
        nlr_raise(mp_obj_exception_make_new(&mp_type_OSError, 2, 0, args));
    }
}