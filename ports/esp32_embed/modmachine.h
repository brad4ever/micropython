#ifndef MICROPY_INCLUDED_ESP32_MODMACHINE_H
#define MICROPY_INCLUDED_ESP32_MODMACHINE_H

#include "py/obj.h"

extern const mp_obj_type_t machine_signal_type;
extern const mp_obj_type_t machine_pin_type;
extern const mp_obj_type_t machine_pinbase_type;

void machine_init(void);
void machine_deinit(void);
void machine_pins_init(void);
void machine_pins_deinit(void);
// void machine_pwm_deinit_all(void);
// TODO: void machine_rmt_deinit_all(void);
// void machine_timer_deinit_all(void);
void machine_i2s_init0();

#endif // MICROPY_INCLUDED_ESP32_MODMACHINE_H
