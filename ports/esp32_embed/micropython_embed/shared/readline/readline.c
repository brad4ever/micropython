/*
 * This file is part of the MicroPython project, http://micropython.org/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2013, 2014 Damien P. George
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
#include <stdint.h>
#include <string.h>

#include "py/mpstate.h"
#include "py/repl.h"
#include "py/mphal.h"
#include "shared/readline/readline.h"


void readline_init0(void) {    
}

typedef struct _readline_t {
    vstr_t *line;
    size_t orig_line_len;
    int escape_seq;
    int hist_cur;
    size_t cursor_pos;
    char escape_seq_buf[1];
    #if MICROPY_REPL_AUTO_INDENT
    uint8_t auto_indent_state;
    #endif
    const char *prompt;
} readline_t;

static readline_t rl;

int readline_process_char(int c) {
    return -1;
}

void readline_note_newline(const char *prompt) {
}
void readline_init(vstr_t *line, const char *prompt) {
}

int readline(vstr_t *line, const char *prompt) {
    return 0;
}

void readline_push_history(const char *line) {
}

MP_REGISTER_ROOT_POINTER(const char *readline_hist[MICROPY_READLINE_HISTORY_SIZE]);
