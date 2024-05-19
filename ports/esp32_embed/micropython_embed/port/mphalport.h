typedef int esp_err_t;

// Define so there's no dependency on extmod/virtpin.h
#define mp_hal_pin_obj_t



// Check the ESP-IDF error code and raise an OSError if it's not ESP_OK.
#if MICROPY_ERROR_REPORTING <= MICROPY_ERROR_REPORTING_NORMAL
#define check_esp_err(code) check_esp_err_(code)
void check_esp_err_(esp_err_t code);
#else
#define check_esp_err(code) check_esp_err_(code, __FUNCTION__, __LINE__, __FILE__)
void check_esp_err_(esp_err_t code, const char *func, const int line, const char *file);
#endif